import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';

import '../../index.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final String author;

  final String address;

  final ChatRepository repository;

  late StreamSubscription _subscription;

  ChatBloc(
      {required this.address, required this.author, required this.repository})
      : super(ChatState.initial(author: author, address: address)) {
    on<ChatReceived>(_received);
    on<ChatSent>(_sent);
    _subscription = repository.stream.listen((event) {
      add(ChatReceived(message: event));
    });
  }

  void _received(ChatReceived event, Emitter<ChatState> emit) async {
    emit(state.clone(messages: [...state.messages..insert(0, event.message)]));
  }

  void _sent(ChatSent event, Emitter<ChatState> emit) async {
    repository.send(state.author, state.target, event.message);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
