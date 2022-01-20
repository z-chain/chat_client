import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../../index.dart';

class ConnectorBloc extends Bloc<ConnectorEvent, ConnectorState> {
  final MQTTRepository mqttRepository;

  final AccountRepository accountRepository;

  late StreamSubscription _mqttSubscription;

  late StreamSubscription _accountSubscription;

  ConnectorBloc({required this.mqttRepository, required this.accountRepository})
      : super(ConnectorState.initial(address: mqttRepository.address)) {
    on<ConnectorChanged>(_changed);
    _mqttSubscription = mqttRepository.connectStatusStream.listen((event) {
      add(ConnectorChanged(address: event));
    });
    _accountSubscription = accountRepository.stream.listen((event) {
      _connect(event);
    });
    _connect(accountRepository.account);
  }

  void _connect(Account account) {
    if (account.isEmpty) return;
    // 连接消息
    final message = MqttConnectMessage()
        .withWillTopic('z-chain/chat/online-user/${account.address}')
        .withClientIdentifier(account.address)
        .withWillMessage('')
        .withWillRetain()
        .withWillQos(MqttQos.exactlyOnce);
    mqttRepository.connect(account.address, message: message);
  }

  void _changed(ConnectorChanged event, Emitter<ConnectorState> emit) async {
    emit(state.clone(address: event.address));
    if (event.address != null) {
      // 消息
      mqttRepository.subscribe('z-chain/chat/${event.address}/message/#');
      // 联系人
      mqttRepository.subscribe('z-chain/chat/${event.address}/contact/#');
      // 在线用户
      mqttRepository.subscribe('z-chain/chat/online-user/#');
      // 发送在线消息
      mqttRepository.publish(
          'z-chain/chat/online-user/${event.address}',
          jsonEncode(User(
                  address: accountRepository.account.address,
                  public: accountRepository.account.public)
              .toJson()),
          retain: true);
    }
  }

  @override
  Future<void> close() {
    _mqttSubscription.cancel();
    _accountSubscription.cancel();
    return super.close();
  }
}
