library;

import 'package:auth_service/src/auth_service.dart';
import 'package:auth_service/src/impl/auth_service_impl.dart';
import 'package:http/http.dart' as http;

export 'src/auth_service.dart';
export 'src/entity/account_data.dart';
export 'src/entity/api_token.dart';
export 'src/entity/auth_state.dart';
export 'src/entity/credentials_data.dart';

Future<AuthService> newAuthService({
  http.Client? client,
  Map<String, dynamic> Function()? refreshData,
  String? refreshUrl,
}) {
  return AuthServiceImpl.newInstance(
    client: client,
    refreshData: refreshData,
    refreshUrl: refreshUrl,
  );
}
