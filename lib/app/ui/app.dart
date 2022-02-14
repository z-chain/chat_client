import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:styled_widget/styled_widget.dart';

import '../index.dart';
import 'app_theme.dart';

class App extends StatefulWidget {
  final SharedPreferences preferences;

  final Database database;

  const App({Key? key, required this.preferences, required this.database})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  late AccountRepository accountRepository;

  late MQTTRepository mqttRepository;

  late ChatRepository inboxRepository;

  late NotificationRepository notificationRepository;

  @override
  void initState() {
    super.initState();
    accountRepository = AccountRepository(preferences: widget.preferences);
    mqttRepository = MQTTRepository(server: 'broker-cn.emqx.io');
    notificationRepository = NotificationRepository()..init();
    inboxRepository = ChatRepository(
        database: widget.database,
        mqttRepository: mqttRepository,
        notificationRepository: notificationRepository);
  }

  @override
  void dispose() {
    accountRepository.close();
    mqttRepository.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountBloc, AccountState>(builder: (context, state) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        theme: AppTheme().light,
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
        .parent(({required child}) => MultiBlocProvider(providers: [
              BlocProvider(
                  create: (context) => AccountBloc(repository: context.read())),
              BlocProvider(
                  create: (context) => ConnectorBloc(
                      mqttRepository: mqttRepository,
                      accountRepository: accountRepository)),
              BlocProvider(
                  create: (context) =>
                      OnlineUserBloc(repository: mqttRepository)),
              BlocProvider(
                  create: (context) =>
                      NotificationBloc(repository: notificationRepository)
                        ..add(NotificationLoaded()))
            ], child: child))
        .parent(({required child}) => MultiRepositoryProvider(providers: [
              RepositoryProvider.value(value: accountRepository),
              RepositoryProvider.value(value: mqttRepository),
              RepositoryProvider.value(value: inboxRepository),
              RepositoryProvider.value(value: notificationRepository)
            ], child: child));
  }
}
