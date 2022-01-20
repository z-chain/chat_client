class User {
  final String address;

  final String? public;

  /// 头像
  String get avatar => 'https://api.multiavatar.com/$address.png';

  const User({required this.address, this.public});

  Map<String, dynamic> toJson() {
    return {'address': address, 'public': public};
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(address: json['address'], public: json['public']);
  }

  @override
  int get hashCode => address.hashCode;

  @override
  bool operator ==(Object other) {
    return hashCode == other.hashCode;
  }
}
