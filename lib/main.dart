import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:window_manager/window_manager.dart';

import 'app/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    await windowManager.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setAsFrameless();
      await windowManager.setSize(const Size(300, 500));
      windowManager.show();
    });
  }

  final preferences = await SharedPreferences.getInstance();

  final databasePath = await getDatabasesPath();
  String path = join(databasePath, 'chat.db');

  // await deleteDatabase(path);
  final Database database =
      await openDatabase(path, version: 2, onCreate: (db, version) async {
    await db.execute(
        'CREATE TABLE Inbox (id INTEGER PRIMARY KEY, source TEXT, target TEXT, msg TEXT)');
  });

  runApp(App(
    preferences: preferences,
    database: database,
  ));
}
