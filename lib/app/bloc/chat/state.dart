import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatState {
  final String source;

  final String target;

  final List<types.Message> messages;

  ChatState(
      {required this.source, required this.target, required this.messages});

  factory ChatState.initial({required String source, required String target}) =>
      ChatState(source: source, target: target, messages: []);

  ChatState clone({List<types.Message>? messages}) {
    return ChatState(
        messages: messages ?? this.messages, source: source, target: target);
  }
}
