import 'dart:async';
import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTRepository {
  final String server;

  StreamSubscription? _subscription;

  final StreamController<String?> _connectedController =
      StreamController.broadcast();

  String? _address;

  Stream<String?> get connectStatus =>
      _connectedController.stream.map((event) => _address = event);

  String? get address => _address;

  MqttServerClient? _client;

  MQTTRepository({required this.server});

  void connect(String address) {
    _client?.disconnect();
    _subscription?.cancel();
    _client = MqttServerClient(server, address);
    _client?.onConnected = _onConnected;
    _client?.onDisconnected = _onDisconnected;
    _client?.onSubscribed = _onSubscribed;
    _client?.onSubscribeFail = _onSubscribeFailure;
    _client?.onUnsubscribed = _onUnsubscribed;
    _client?.pongCallback = _onPong;
    _client?.logging(on: false);
    _client?.keepAlivePeriod = 20;
    _subscription = _client?.updates?.listen((event) {
      log('$event');
    });
    _client?.connect();
  }

  void _onConnected() {
    _connectedController.add(_client?.clientIdentifier);
  }

  void _onDisconnected() {
    _connectedController.add(null);
  }

  void _onSubscribed(String topic) {}

  void _onSubscribeFailure(String topic) {}

  void _onUnsubscribed(String? topic) {}

  void _onPong() {
    log('mqtt client on pong');
  }

  void subscribe(String topic) {
    _client?.subscribe(topic, MqttQos.exactlyOnce);
  }

  void close() {
    _connectedController.close();
  }
}
