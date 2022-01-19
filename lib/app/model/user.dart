class User {
  final String address;

  final String? public;

  /// 头像
  String get avatar => 'https://api.multiavatar.com/$address.png';

  const User({required this.address, this.public});
}
