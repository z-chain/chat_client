import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class Avatar extends StatelessWidget {
  final String avatar;

  const Avatar({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: avatar,
      progressIndicatorBuilder:
          (BuildContext context, String url, DownloadProgress progress) =>
              CircularProgressIndicator(
        value: progress.progress,
      ).padding(all: 8),
    );
  }
}
