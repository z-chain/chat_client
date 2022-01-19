import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class HomePage extends StatelessWidget {
  static Route route() =>
      MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('HomePage').center(),
    );
  }
}
