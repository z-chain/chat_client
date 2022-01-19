import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../index.dart';

class HomePage extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: const AccountAvatar().padding(all: 8).gestures(
          onTap: () => context.read<AccountBloc>().add(AccountSignedOut())),
    );

    return Scaffold(
      appBar: appBar,
      body: const Text('HomePage').center(),
    );
  }
}
