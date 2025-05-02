import 'package:auth_service/src/entity/api_token.dart';
import 'package:auth_service/src/entity/credentials_data.dart';

abstract interface class Credentials {
  Future<void> saveCredentials(CredentialsData tokenData);

  Future<JwtToken?> getCredentials([bool validate = true]);

  Future<void> clearCredentials();
}
