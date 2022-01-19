import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import '../../../index.dart';

class AccountImporterPage extends StatelessWidget {
  static Route<Account?> route() =>
      MaterialPageRoute(builder: (context) => const AccountImporterPage());

  const AccountImporterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Account Importer Page").center(),
    );
  }
}
