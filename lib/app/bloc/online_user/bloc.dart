import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../index.dart';

class OnlineUserBloc extends Bloc<OnlineUserEvent, OnlineUserState> {
  final MQTTRepository repository;

  late StreamSubscription _subscription;

  OnlineUserBloc({required this.repository})
      : super(OnlineUserState.initial()) {
    on<OnlineUserOnline>(_online);
    on<OnlineUserOffline>(_offline);
    _subscription = repository.receivedMessageStream.listen((event) {
      const prefix = 'z-chain/chat/online-user/';
      final topic = event.topic;
      if (topic.indexOf(prefix) == 0) {
        final address = topic.replaceAll(prefix, '');
        final message = event.payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        if (payload.isEmpty) {
          add(OnlineUserOffline(address: address));
        } else {
          add(OnlineUserOnline(user: User.fromJson(jsonDecode(payload))));
        }
      }
      // log('online-user ${event.topic}');
    });
  }

  void _online(OnlineUserOnline event, Emitter<OnlineUserState> emit) async {
    emit(state.clone(users: HashSet.from(state.users..add(event.user))));
  }

  void _offline(OnlineUserOffline event, Emitter<OnlineUserState> emit) async {
    emit(state.clone(
        users: HashSet.from(state.users
          ..removeWhere((element) => element.address == event.address))));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
