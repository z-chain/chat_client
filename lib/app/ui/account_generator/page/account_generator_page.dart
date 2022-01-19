import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../index.dart';

class AccountGeneratorPage extends StatelessWidget {
  static Route<Account?> route() =>
      MaterialPageRoute(builder: (context) => const AccountGeneratorPage());

  const AccountGeneratorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AccountGeneratorContainer(
        onGenerated: (account) => Navigator.of(context).pop(account),
      ).center(),
    ).parent(({required child}) => BlocProvider(
          create: (context) =>
              AccountGeneratorCubit(repository: context.read()),
          child: child,
        ));
  }
}
