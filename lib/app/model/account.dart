import 'dart:convert';

import 'package:bip32/bip32.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:web3dart/credentials.dart';

import 'user.dart';
import 'package:convert/convert.dart';

class Account extends User {
  final String private;

  const Account(
      {required this.private, required String address, String? public})
      : super(address: address, public: public);

  bool get isEmpty => this == empty;

  static const Account empty = Account(private: '', address: '');

  factory Account.fromPrivateKey(String private) {
    final eth = EthPrivateKey.fromHex(private);
    final address = eth.address.hexEip55;
    final public = hex.encode(eth.publicKey.getEncoded());
    return Account(private: private, address: address, public: public);
  }

  factory Account.generate(String passphrase) {
    final mnemonic = bip39.generateMnemonic();
    final seed = bip39.mnemonicToSeed(mnemonic, passphrase: passphrase);
    final root = BIP32.fromSeed(seed);
    final bip32 = root.derivePath("m/44'/12580'/0/0/0");
    final private = hex.encode(bip32.privateKey!);
    final public = hex.encode(bip32.publicKey);
    final address = EthPrivateKey.fromHex(private).address.hexEip55;
    return Account(private: private, public: public, address: address);
  }
}
