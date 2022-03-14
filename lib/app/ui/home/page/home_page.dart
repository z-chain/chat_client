import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../index.dart';

class HomePage extends StatefulWidget {
  static Route route() => MaterialPageRoute(builder: (context) => HomePage());

  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final GlobalKey<InnerDrawerState> _drawerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      context.read<NotificationBloc>().add(NotificationLoaded());
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: const AccountAvatar()
          .padding(all: 8)
          .gestures(onTap: () => _drawerKey.currentState?.toggle()),
      actions: [
        BlocListener<NotificationBloc, NotificationState>(
          listener: (context, state) {
            if (state.granted) {
              context.read<NotificationBloc>().add(NotificationEnabled());
            }
          },
          listenWhen: (prev, state) => prev.granted != state.granted,
          child: IconButton(
              onPressed: () => AppSettings.openNotificationSettings(),
              icon: const Icon(Icons.notifications)),
        ),
        IconButton(
            onPressed: () => context
                .read<NotificationRepository>()
                .show("title", "${DateTime.now()}"),
            icon: const Icon(Icons.message)),
        const OnlineUserCount().center(),
        const AccountConnector(),
        const AccountQrcode().backgroundColor(Colors.white).padding(all: 4)
      ],
    );

    return InnerDrawer(
      key: _drawerKey,
      scale: const IDOffset.horizontal(0.88),
      borderRadius: 12,
      backgroundDecoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.srcATop),
            image: const CachedNetworkImageProvider(
                'https://c-ssl.duitang.com/uploads/item/201509/17/20150917151413_2jEtG.thumb.1000_0.jpeg')),
      ),
      scaffold: Scaffold(
        appBar: appBar,
        body: const OnlineUsers(),
      ),
      leftChild: const HomeLeftDrawer(),
    ).parent(({required child}) => WillPopScope(
        child: child,
        onWillPop: () async {
          await MoveToBackground.moveTaskToBack();
          return Future.value(false);
        }));
  }
}
