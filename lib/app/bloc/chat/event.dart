import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

abstract class ChatEvent {}

class ChatReceived extends ChatEvent {
  final types.Message message;

  ChatReceived({required this.message});
}

class ChatSent extends ChatEvent {
  final types.Message message;

  ChatSent({required this.message});
}
