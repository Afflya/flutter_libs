import 'package:equatable/equatable.dart';
import 'package:flutter_tools/enum_ext.dart';
import 'package:flutter_tools/json.dart';
import 'package:flutter_tools/scope_functions.dart';

enum TokenType { bearer }

class CredentialsData with EquatableMixin {
  // 'access_token'
  final String accessToken;

  // 'token_type'
  final TokenType tokenType;

  // 'expires_in'
  final int? expiresIn;

  // 'refresh_token'
  final String? refreshToken;

  // 'refresh_expires_in'
  final int? refreshExpiresIn;

  const CredentialsData({
    required this.accessToken,
    this.tokenType = TokenType.bearer,
    this.expiresIn,
    this.refreshToken,
    this.refreshExpiresIn,
  });

  @override
  List<Object?> get props => [
        accessToken,
        tokenType,
        expiresIn,
        refreshToken,
        refreshExpiresIn,
      ];

  @override
  bool? get stringify => true;

  factory CredentialsData.fromJson(JsonObject json) {
    return CredentialsData(
      accessToken: json.getAsType('access_token'),
      tokenType: json.getAsTypeOrNull<String>('token_type')?.let(TokenType.values.byNameOrNull) ?? TokenType.bearer,
      expiresIn: json.getAsTypeOrNull('expires_in'),
      refreshToken: json.getAsTypeOrNull('refresh_token'),
      refreshExpiresIn: json.getAsTypeOrNull('refresh_expires_in'),
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType.name,
        if (expiresIn != null) 'expires_in': expiresIn,
        if (refreshToken != null) 'refresh_token': refreshToken,
        if (refreshExpiresIn != null) 'refresh_expires_in': refreshExpiresIn,
      };
}
