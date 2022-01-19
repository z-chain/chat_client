import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../index.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  late StreamSubscription _subscription;

  AccountBloc({required this.repository})
      : super(AccountState.initial(account: repository.account)) {
    on<AccountChanged>(_changed);
    on<AccountSignedIn>(_signedIn);
    on<AccountSignedOut>(_signedOut);
    _subscription = repository.stream.listen((event) {
      add(AccountChanged(account: event));
    });
  }

  void _changed(AccountChanged event, Emitter<AccountState> emit) async {
    emit(state.clone(account: event.account));
  }

  void _signedIn(AccountSignedIn event, Emitter<AccountState> emit) async {
    repository.signIn(event.account);
  }

  void _signedOut(AccountSignedOut event, Emitter<AccountState> emit) async {
    repository.signOut();
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
