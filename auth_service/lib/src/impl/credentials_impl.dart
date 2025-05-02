import 'dart:async';
import 'dart:convert';

import 'package:app_prefs/app_prefs.dart';
import 'package:auth_service/src/credentials.dart';
import 'package:auth_service/src/entity/api_token.dart';
import 'package:auth_service/src/entity/credentials_data.dart';
import 'package:auth_service/src/errors.dart';
import 'package:flutter_tools/json.dart';
import 'package:flutter_tools/scope_functions.dart';
import 'package:http/http.dart' as http;

final class CredentialsImpl implements Credentials {
  ///
  /// config
  ///

  final String _scope;

  final String? _refreshUrl;

  // extra data to pass during refresh
  final Map<String, dynamic> Function()? _refreshData;

  final http.Client _client;

  ///
  ///
  ///

  String get _accessStoragePath => '$_scope/auth/access_token';

  String get _refreshStoragePath => '$_scope/auth/refresh_token';

  JwtToken? _accessToken;

  Future<JwtToken?>? _lock;

  ///
  ///
  ///

  CredentialsImpl({
    String? scope,
    String? refreshUrl,
    JsonObject Function()? refreshData,
    http.Client? client,
  })  : _scope = scope ?? 'app',
        _refreshUrl = refreshUrl,
        _refreshData = refreshData,
        _client = client ?? http.Client();

  @override
  Future<JwtToken?> getCredentials([bool validate = true]) async {
    final lock = _lock;
    if (lock != null) {
      return lock;
    }
    final completer = Completer<JwtToken>();
    _lock = completer.future;
    try {
      final token = await _currentAccessToken();
      if (token == null) {
        throw NotAuthenticatedException();
      }
      if (validate && token.isExpired) {
        await _refreshCredentials();
      }
      completer.complete(_accessToken);
    } on NotAuthenticatedException catch (e) {
      completer.completeError(e);
      rethrow;
    } catch (e) {
      completer.completeError(e);
    } finally {
      _lock = null;
    }

    return _accessToken;
  }

  @override
  Future<void> saveCredentials(CredentialsData tokenData) async {
    final accessToken = JwtToken(
      token: tokenData.accessToken,
      expireIn: tokenData.expiresIn ?? 0,
    );
    _accessToken = accessToken;

    final refreshToken = tokenData.refreshToken?.let((it) => JwtToken(token: it));


    await SecuredPrefs.instance.writeString(key: _accessStoragePath, value: accessToken.token);
    await SecuredPrefs.instance.writeString(key: _refreshStoragePath, value: refreshToken?.token);
  }

  @override
  Future<void> clearCredentials() async {
    _accessToken = null;
    await SecuredPrefs.instance.remove(_accessStoragePath);
    await SecuredPrefs.instance.remove(_refreshStoragePath);
  }

  ///
  /// private
  ///

  Future<void> _refreshCredentials([int retry = 2]) async {
    final refreshUrl = _refreshUrl;
    if (refreshUrl == null) {
      throw NotAuthenticatedException();
    }

    final refreshToken = await SecuredPrefs.instance.readString(_refreshStoragePath);

    if (refreshToken == null) {
      throw NotAuthenticatedException();
    }

    if (JwtToken.fromJwt(refreshToken).isExpired) {
      throw NotAuthenticatedException();
    }

    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $refreshToken',
    };

    final JsonObject body = {};
    _refreshData?.call().let(body.addAll);

    final http.Response response = await _client.post(
      Uri.parse(refreshUrl),
      headers: headers,
      body: json.encode(body),
    );

    final utf8Body = utf8.decode(response.bodyBytes);

    final jsonBody = json.decode(utf8Body) as Map<String, dynamic>?;

    switch (response.statusCode) {
      case 200:
        final tokenData = CredentialsData.fromJson(jsonBody!);
        await saveCredentials(tokenData);
        return;
      case 401:
      case 404:
        await clearCredentials();
        throw NotAuthenticatedException(jsonBody);
      case 500:
        if (retry > 0) {
          await Future.delayed(Duration(seconds: 1));
          return _refreshCredentials(retry - 1);
        }
        throw InternalError(jsonBody);
      default:
        throw InternalError(jsonBody);
    }
  }

  Future<JwtToken?> _currentAccessToken() async {
    final token = _accessToken;
    if (token != null) return token;
    final savedToken = await SecuredPrefs.instance.readString(_accessStoragePath);
    print('_currentAccessToken _accessStoragePath=$_accessStoragePath savedToken=$savedToken');
    if (savedToken == null) return null;
    try {
      _accessToken = JwtToken.fromJwt(savedToken);
      return _accessToken;
    } catch (_) {
      return null;
    }
  }
}
