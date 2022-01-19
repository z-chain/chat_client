import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:styled_widget/styled_widget.dart';

import '../index.dart';

class App extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final SharedPreferences preferences;

  const App({Key? key, required this.preferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(builder: (context, state) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        onGenerateRoute: (settings) {
          if (state.authorized) {
            return HomePage.route();
          } else {
            return AccountCreatorPage.route();
          }
        },
      );
    }, listener: (context, state) {
      if (state.authorized) {
        navigatorKey.currentState
            ?.pushAndRemoveUntil(HomePage.route(), (route) => false);
      } else {
        navigatorKey.currentState
            ?.pushAndRemoveUntil(AccountCreatorPage.route(), (route) => false);
      }
    })
        .parent(({required child}) => BlocProvider(
              create: (context) => AccountBloc(repository: context.read()),
              child: child,
            ))
        .parent(({required child}) => RepositoryProvider(
              create: (context) => AccountRepository(preferences: preferences),
              child: child,
            ));
  }
}
