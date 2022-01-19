import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../index.dart';

class AccountImporterPage extends StatelessWidget {
  static Route<Account?> route() =>
      MaterialPageRoute(builder: (context) => const AccountImporterPage());

  const AccountImporterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AccountImporterContainer(
        onImported: (account) => Navigator.of(context).pop(account),
      ).center(),
    ).parent(({required child}) => BlocProvider(
          create: (context) => AccountImporterCubit(repository: context.read()),
          child: child,
        ));
  }
}
