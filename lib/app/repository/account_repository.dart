import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../index.dart';

class AccountRepository {
  final SharedPreferences preferences;

  final StreamController<Account> _controller = StreamController.broadcast();

  Stream<Account> get stream =>
      _controller.stream.map((event) => _cache(event));

  Account get account => _cached();

  AccountRepository({required this.preferences});

  static const String _cacheAccountKey = 'account-key';

  Account _cache(Account account) {
    preferences.setString(_cacheAccountKey, account.private);
    return account;
  }

  Account _cached() {
    final private = preferences.getString(_cacheAccountKey);
    if (private == null || private.isEmpty) return Account.empty;
    return Account.fromPrivateKey(private);
  }

  void signIn(Account account) {
    _controller.add(account);
  }

  Future<Account> generate() async {
    await Future.delayed(const Duration(seconds: 2));
    return Account.fromPrivateKey("自动生成账号 ${DateTime.now()}");
  }

  Future<Account> import(String path) async {
    await Future.delayed(const Duration(seconds: 2));
    return Account.fromPrivateKey("导入生成账号 ${DateTime.now()}");
  }

  void close() {
    _controller.close();
  }
}
