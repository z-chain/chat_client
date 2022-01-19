import 'package:formz/formz.dart';

import '../../index.dart';

class AccountGeneratorState {
  final FormzStatus status;

  final Account account;

  AccountGeneratorState._({required this.status, required this.account});

  factory AccountGeneratorState.initial() =>
      AccountGeneratorState._(status: FormzStatus.pure, account: Account.empty);

  AccountGeneratorState clone({FormzStatus? status, Account? account}) {
    return AccountGeneratorState._(
        status: status ?? this.status, account: account ?? this.account);
  }
}
