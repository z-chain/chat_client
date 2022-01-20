import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../index.dart';

class OnlineUserCount extends StatelessWidget {
  const OnlineUserCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnlineUserBloc, OnlineUserState>(
        builder: (context, state) {
      return Text('在线人数:${state.users.length}');
    });
  }
}
