import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../index.dart';
import '../index.dart';

class HomeLeftDrawer extends StatelessWidget {
  const HomeLeftDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountBloc>();
    return Wrap(
      children: [
        const AccountAvatar(),
        IconButton(
            onPressed: () => log('qrcode'), icon: const Icon(Icons.qr_code)),
        IconButton(
            onPressed: () => account.add(AccountSignedOut()),
            icon: const Icon(Icons.power_settings_new))
      ],
    ).parent(({required child}) => Material(
          child: child,
          color: Colors.transparent,
        ));
  }
}
