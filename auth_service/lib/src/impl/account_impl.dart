import 'package:auth_service/src/entity/account_data.dart';
import 'package:flutter_tools/json.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final class AccountImpl extends AccountData {
  @override
  final String sub;

  const AccountImpl({
    required this.sub,
  });

  factory AccountImpl.fromJwt(String token) {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return AccountImpl(
      sub: decodedToken.getAsType('sub'),
    );
  }

  @override
  List<Object?> get props => [sub];
}