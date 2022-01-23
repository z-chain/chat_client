import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';

import '../../index.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String source;

  final String target;

  final ChatRepository repository;

  late StreamSubscription _subscription;

  ChatBloc(
      {required this.target, required this.source, required this.repository})
      : super(ChatState.initial(source: source, target: target)) {
    on<ChatLoaded>(_loaded);
    on<ChatReceived>(_received);
    on<ChatSent>(_sent);
    final participants = [source, target];
    _subscription = repository.stream.listen((event) {
      if (participants.contains(event.remoteId) ||
          participants.contains(event.author.id)) {
        add(ChatReceived(message: event));
      }
    });
  }

  void _loaded(ChatLoaded event, Emitter<ChatState> emit) async {
    await repository
        .messages(source, target)
        .then((value) => emit(state.clone(messages: value)));
  }

  void _received(ChatReceived event, Emitter<ChatState> emit) async {
    emit(state.clone(messages: [...state.messages..insert(0, event.message)]));
  }

  void _sent(ChatSent event, Emitter<ChatState> emit) async {
    repository.send(state.source, state.target, event.message);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
