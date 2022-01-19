import 'dart:io';

import 'package:flutter/material.dart';

class AppTheme {
  ThemeData get light =>
      ThemeData.light().copyWith(platform: TargetPlatform.iOS);
}
