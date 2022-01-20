import 'dart:async';

import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/credentials.dart';

import '../index.dart';

// Account _generate(String passphrase) {
//   final mnemonic = bip39.generateMnemonic();
//   final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase);
//   final root = BIP32.fromSeed(seed);
//   final bip32 = root.derivePath("m/44'/12580'/0/0/0");
//   final private = hex.encode(bip32.privateKey!);
//   final public = hex.encode(bip32.publicKey);
//   final address = EthPrivateKey.fromHex(private).address.hexEip55;
//   return Account(private: private, public: public, address: address);
// }

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

  void signOut() {
    _controller.add(Account.empty);
  }

  Future<Account> generate(String passphrase) async {
    return await compute(Account.generate, passphrase);
  }

  Future<Account> import(String path) async {
    await Future.delayed(const Duration(seconds: 2));
    throw AppException(message: '哈哈哈，作者还没有完成这个功能，赶紧催一催他吧');
  }

  void close() {
    _controller.close();
  }
}
