import 'user.dart';

class Account extends User {
  final String private;

  const Account(
      {required this.private, required String address, String? public})
      : super(address: address, public: public);

  bool get isEmpty => this == empty;

  static const Account empty = Account(private: '', address: '');

  factory Account.fromPrivateKey(String private) {
    return Account(private: private, address: '$private address', public: '$private public');
  }
}
