import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../index.dart';

class AccountQrcode extends StatelessWidget {
  const AccountQrcode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
      return QrImage(data: state.account.public ?? state.account.address);
    });
  }
}
