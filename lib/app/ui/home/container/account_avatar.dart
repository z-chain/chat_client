import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../index.dart';

class AccountAvatar extends StatelessWidget {
  const AccountAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
      if (state.account.isEmpty) return const SizedBox();
      return Avatar(
        avatar: state.account.avatar,
      );
    });
  }
}
