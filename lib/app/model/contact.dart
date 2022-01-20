import 'user.dart';

class Contact extends User {
  final String remark;

  Contact(
      {required String address, required String public, required this.remark})
      : super(address: address, public: public);

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
        address: json['address'],
        public: json['public'],
        remark: json['remark']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'address': address, 'public': public, 'remark': remark};
  }
}
