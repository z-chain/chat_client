import '../../index.dart';

class AccountState {
  final Account account;

  bool get authorized => !account.isEmpty;

  AccountState._({required this.account});

  factory AccountState.initial({required Account account}) =>
      AccountState._(account: account);

  AccountState clone({Account? account}) {
    return AccountState._(account: account ?? this.account);
  }
}
