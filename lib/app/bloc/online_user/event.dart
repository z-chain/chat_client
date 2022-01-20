import '../../index.dart';

abstract class OnlineUserEvent {}

class OnlineUserOnline extends OnlineUserEvent {
  final User user;

  OnlineUserOnline({required this.user});
}

class OnlineUserOffline extends OnlineUserEvent {
  final String address;

  OnlineUserOffline({required this.address});
}
