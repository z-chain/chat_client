import 'package:bloc/bloc.dart';

import '../../index.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({required this.repository})
      : super(NotificationState.initial()) {
    on<NotificationLoaded>(_loaded);
    on<NotificationEnabled>(_enabled);
  }

  void _loaded(
      NotificationLoaded event, Emitter<NotificationState> emit) async {
    final granted = await repository.isGranted();
    emit(state.clone(granted: granted));
  }

  void _enabled(
      NotificationEnabled event, Emitter<NotificationState> emit) async {
    await repository
        .enable()
        .then((value) => emit(state.clone(enabled: true)))
        .onError(
          (AppException error, stackTrace) => emit(
            state.clone(exception: error),
          ),
        );
  }
}
