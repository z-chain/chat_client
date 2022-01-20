import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

import '../../../index.dart';

class ChatMessageContainer extends StatelessWidget {
  const ChatMessageContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      final user = types.User(id: state.author);
      final chat = context.read<ChatBloc>();
      return Chat(
          messages: state.messages,
          onSendPressed: (message) => chat.add(ChatSent(
              message: types.TextMessage(
                  author: user,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  id: const Uuid().v4(),
                  text: message.text))),
          user: user);
    });
  }
}
