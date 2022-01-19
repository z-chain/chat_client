import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

import '../../index.dart';

class AccountGeneratorCubit extends Cubit<AccountGeneratorState> {
  final AccountRepository repository;

  AccountGeneratorCubit({required this.repository})
      : super(AccountGeneratorState.initial());

  Future<void> generate() {
    emit(state.clone(status: FormzStatus.submissionInProgress));
    return repository
        .generate()
        .then((value) => emit(
            state.clone(status: FormzStatus.submissionSuccess, account: value)))
        .onError((error, stackTrace) => FormzStatus.submissionFailure);
  }
}
