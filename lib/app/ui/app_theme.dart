import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get light {
    const backgroundColor = Color(0xffededed);
    return ThemeData.light().copyWith(
        platform: TargetPlatform.iOS,
        backgroundColor: backgroundColor,
        canvasColor: backgroundColor,
        scaffoldBackgroundColor: backgroundColor);
  }
}
