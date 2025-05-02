import 'package:auth_service/src/entity/auth_state.dart';
import 'package:auth_service/src/entity/credentials_data.dart';
import 'package:http/http.dart' as http;

abstract interface class AuthService {
  Stream<AuthServiceState> watchStateChanges();

  AuthServiceState get state;

  Future<void> handleAuth(CredentialsData tokenData);

  Future<http.Request> signRequest(http.Request request);

  Future<void> signOut();

  void dispose();
}
