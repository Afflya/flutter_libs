import 'package:auth_service/src/entity/account_data.dart';
import 'package:equatable/equatable.dart';

sealed class AuthServiceState with EquatableMixin {
  const AuthServiceState();

  @override
  List<Object?> get props => [];
}

final class Authorized extends AuthServiceState {
  final AccountData account;

  const Authorized({required this.account});

  @override
  List<Object?> get props => [account];
}

final class Unauthorized extends AuthServiceState {}
