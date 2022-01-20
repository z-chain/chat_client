import 'dart:collection';

import '../../index.dart';

class OnlineUserState {
  final HashSet<User> users;

  OnlineUserState({required this.users});

  factory OnlineUserState.initial() => OnlineUserState(users: HashSet());

  OnlineUserState clone({HashSet<User>? users}) {
    return OnlineUserState(users: users ?? this.users);
  }
}
