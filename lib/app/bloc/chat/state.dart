import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatState {
  final String author;

  final String target;

  final List<types.Message> messages;

  ChatState(
      {required this.author, required this.target, required this.messages});

  factory ChatState.initial(
          {required String author, required String address}) =>
      ChatState(author: author, target: address, messages: []);

  ChatState clone({List<types.Message>? messages}) {
    return ChatState(
        messages: messages ?? this.messages, author: author, target: target);
  }
}
