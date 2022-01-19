import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

import '../index.dart';

class HomeLeftDrawer extends StatelessWidget {
  const HomeLeftDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const AccountAvatar(),
        IconButton(
            onPressed: () => log('qrcode'), icon: const Icon(Icons.qr_code))
      ],
    ).parent(({required child}) => Material(
          child: child,
          color: Colors.transparent,
        ));
  }
}
