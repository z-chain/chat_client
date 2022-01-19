import 'package:formz/formz.dart';

import '../../index.dart';

class AccountImporterState {
  final FormzStatus status;

  final Account account;

  final AppException? exception;

  AccountImporterState._(
      {required this.status, required this.account, this.exception});

  factory AccountImporterState.initial() =>
      AccountImporterState._(status: FormzStatus.pure, account: Account.empty);

  AccountImporterState clone(
      {FormzStatus? status, Account? account, AppException? exception}) {
    return AccountImporterState._(
        status: status ?? this.status,
        account: account ?? this.account,
        exception: exception);
  }
}
