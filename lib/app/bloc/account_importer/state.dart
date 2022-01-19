import 'package:formz/formz.dart';

import '../../index.dart';

class AccountImporterState {
  final FormzStatus status;

  final Account account;

  AccountImporterState._({required this.status, required this.account});

  factory AccountImporterState.initial() =>
      AccountImporterState._(status: FormzStatus.pure, account: Account.empty);

  AccountImporterState clone({FormzStatus? status, Account? account}) {
    return AccountImporterState._(
        status: status ?? this.status, account: account ?? this.account);
  }
}
