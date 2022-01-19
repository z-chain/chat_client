import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

import '../../index.dart';

class AccountImporterCubit extends Cubit<AccountImporterState> {
  final AccountRepository repository;

  AccountImporterCubit({required this.repository})
      : super(AccountImporterState.initial());

  Future<void> import(String path) {
    emit(state.clone(status: FormzStatus.submissionInProgress));
    return repository
        .import(path)
        .then((value) => emit(
            state.clone(status: FormzStatus.submissionSuccess, account: value)))
        .onError((AppException error, stackTrace) => emit(state.clone(
            status: FormzStatus.submissionFailure, exception: error)));
  }
}
