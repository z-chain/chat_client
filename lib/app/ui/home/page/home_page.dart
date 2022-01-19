import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../../index.dart';

class HomePage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => HomePage());

  final GlobalKey<InnerDrawerState> _drawerKey = GlobalKey();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: const AccountAvatar()
          .padding(all: 8)
          .gestures(onTap: () => _drawerKey.currentState?.toggle()),
      actions: [
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
        body: const Text("home").center(),
      ),
      leftChild: const HomeLeftDrawer(),
    );
  }
}
