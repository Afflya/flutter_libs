import 'package:equatable/equatable.dart';

abstract class AccountData with EquatableMixin {
  const AccountData();

  String get sub;
}
