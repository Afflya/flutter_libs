import 'dart:async';

import 'package:auth_service/src/auth_service.dart';
import 'package:auth_service/src/entity/api_token.dart';
import 'package:auth_service/src/entity/auth_state.dart';
import 'package:auth_service/src/entity/credentials_data.dart';
import 'package:auth_service/src/errors.dart';
import 'package:auth_service/src/impl/account_impl.dart';
import 'package:auth_service/src/impl/credentials_impl.dart';
import 'package:flutter_tools/cast.dart';
import 'package:http/http.dart' as http;

final class AuthServiceImpl implements AuthService {
  final CredentialsImpl _credentials;

  AuthServiceImpl._(this._credentials, this._state);

  static Future<AuthServiceImpl> newInstance({
    http.Client? client,
    Map<String, dynamic> Function()? refreshData,
    String? refreshUrl,
  }) async {
    final credentials = CredentialsImpl(
      client: client,
      refreshData: refreshData,
      refreshUrl: refreshUrl,
    );

    AuthServiceState initialState;

    try {
      final creds = await credentials.getCredentials();
      if (creds == null) throw NotAuthenticatedException();
      final account = AccountImpl.fromJwt(creds.token);
      initialState = Authorized(account: account);
    } catch (e) {
      initialState = Unauthorized();
    }

    return AuthServiceImpl._(credentials, initialState);
  }

  ///
  /// private
  ///

  AuthServiceState _state;
  final _stateController = StreamController<AuthServiceState>.broadcast();

  void _updateAccount(AccountImpl? account) {
    if (account == null) {
      _state = Unauthorized();
    } else {
      _state = Authorized(account: account);
    }
    _stateController.add(_state);
  }

  ///
  /// public
  ///

  @override
  Future<void> handleAuth(CredentialsData tokenData) async {
    final account = AccountImpl.fromJwt(tokenData.accessToken);
    _updateAccount(account);
    await _credentials.saveCredentials(tokenData);
  }

  @override
  Future<void> signOut() async {
    await _credentials.clearCredentials();
    _updateAccount(null);
  }

  @override
  Future<http.Request> signRequest(http.Request request) async {
    try {
      final creds = await _credentials.getCredentials();
      if (creds == null) throw NotAuthenticatedException();

      // update account if changed
      final account = AccountImpl.fromJwt(creds.token);
      if (state.castOrNull<Authorized>()?.account != account) {
        _updateAccount(account);
      }

      request.headers['Authorization'] = 'Bearer ${creds.bearerToken}';
      return request;
    } on NotAuthenticatedException catch (_) {
      _updateAccount(null);
      rethrow;
    }
  }

  @override
  AuthServiceState get state => _state;

  @override
  Stream<AuthServiceState> watchStateChanges() => _stateController.stream;

  @override
  void dispose() {
    _stateController.close();
  }
}
