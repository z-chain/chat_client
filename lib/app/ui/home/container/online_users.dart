import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../index.dart';

class OnlineUsers extends StatelessWidget {
  const OnlineUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<OnlineUserBloc, OnlineUserState>(
        builder: (context, state) {
      return ListView.separated(
          itemBuilder: (context, index) {
            final user = state.users.toList()[index];
            return Flex(
              direction: Axis.horizontal,
              children: [
                Avatar(avatar: user.avatar).constrained(width: 56, height: 56),
                Text(
                  user.address,
                  overflow: TextOverflow.ellipsis,
                ).expanded(),
              ],
            ).padding(all: 12).ripple().gestures(
                onTap: () =>
                    Navigator.of(context).push(ChatMessagePage.route(user)));
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 1,
                width: double.maxFinite,
              ).backgroundColor(theme.disabledColor).padding(all: 12),
          itemCount: state.users.length);
    });
  }
}
