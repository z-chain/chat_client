import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/index.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  runApp(App(
    preferences: preferences,
  ));
}
