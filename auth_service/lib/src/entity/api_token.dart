import 'package:equatable/equatable.dart';
import 'package:flutter_tools/json.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtToken extends Equatable {
  final String token;
  final int expireIn; // in seconds

  // 0 for infinite token
  const JwtToken({
    required this.token,
    this.expireIn = 0,
  });

  factory JwtToken.fromJwt(String token) {
    final exp = JwtDecoder.decode(token).getAsTypeOrNull<int>("exp");
    return JwtToken(token: token, expireIn: exp ?? 0);
  }

  @override
  List<Object?> get props => [
        token,
        expireIn,
      ];
}

extension JwtTokenX on JwtToken {
  Map<String, dynamic> get data => JwtDecoder.decode(token);

  String get bearerToken => "Bearer $token";

  bool get isExpired => expireIn > 0 && DateTime.now().millisecondsSinceEpoch / 1000 > expireIn - 60;
}
