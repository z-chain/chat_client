import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../index.dart';

class ConnectorBloc extends Bloc<ConnectorEvent, ConnectorState> {
  final MQTTRepository mqttRepository;

  final AccountRepository accountRepository;

  late StreamSubscription _mqttSubscription;

  late StreamSubscription _accountSubscription;

  ConnectorBloc({required this.mqttRepository, required this.accountRepository})
      : super(ConnectorState.initial(address: mqttRepository.address)) {
    on<ConnectorChanged>(_changed);
    _mqttSubscription = mqttRepository.connectStatus.listen((event) {
      add(ConnectorChanged(address: event));
    });
    _accountSubscription = accountRepository.stream.listen((event) {
      _connect(event);
    });
    _connect(accountRepository.account);
  }

  void _connect(Account account) {
    if (account.isEmpty) return;
    mqttRepository.connect(account.address);
  }

  void _changed(ConnectorChanged event, Emitter<ConnectorState> emit) async {
    emit(state.clone(address: event.address));
    if (event.address != null) {
      mqttRepository.subscribe('z-chain/chat/123/message/#');
    }
  }

  @override
  Future<void> close() {
    _mqttSubscription.cancel();
    _accountSubscription.cancel();
    return super.close();
  }
}
