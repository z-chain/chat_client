import '../../index.dart';

abstract class AccountEvent {}

class AccountSignedIn extends AccountEvent {
  final Account account;

  AccountSignedIn({required this.account});
}

class AccountSignedOut extends AccountEvent {}

class AccountChanged extends AccountEvent {
  final Account account;

  AccountChanged({required this.account});
}
