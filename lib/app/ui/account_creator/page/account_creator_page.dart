import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../index.dart';

class AccountCreatorPage extends StatelessWidget {
  static Route<Account?> route() =>
      MaterialPageRoute(builder: (context) => const AccountCreatorPage());

  const AccountCreatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountBloc>();
    return Scaffold(
      body: Wrap(
        children: [
          ElevatedButton(
                  onPressed: () => Navigator.of(context)
                          .push(AccountGeneratorPage.route())
                          .then((value) {
                        if (value != null) {
                          account.add(AccountSignedIn(account: value));
                        }
                      }),
                  child: const Text('创建账户'))
              .center(),
          ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).push(AccountImporterPage.route()),
                  child: const Text('导入账号'))
              .center()
        ],
      ).center(),
    );
  }
}
