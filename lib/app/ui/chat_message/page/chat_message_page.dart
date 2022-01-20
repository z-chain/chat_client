import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../index.dart';

class ChatMessagePage extends StatelessWidget {
  static Route route(User user) =>
      MaterialPageRoute(builder: (context) => ChatMessagePage(user: user));

  final User user;

  const ChatMessagePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
        return const ChatMessageContainer()
            .parent(({required child}) => BlocProvider(
                  create: (context) => ChatBloc(
                      address: user.address,
                      author: state.account.address,
                      repository: context.read()),
                  child: child,
                ));
      }),
    );
  }
}
