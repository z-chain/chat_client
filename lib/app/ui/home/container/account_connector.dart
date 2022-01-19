import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../index.dart';

class AccountConnector extends StatelessWidget {
  const AccountConnector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConnectorBloc, ConnectorState>(
        builder: (context, state) {
      return Icon(state.connected ? Icons.power : Icons.power_off);
    });
  }
}
