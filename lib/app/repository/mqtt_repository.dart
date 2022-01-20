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

  Stream<String?> get connectStatusStream =>
      _connectedController.stream.map((event) => _address = event);

  final StreamController<MqttReceivedMessage<MqttMessage>>
      _receivedMessageController = StreamController.broadcast();

  Stream<MqttReceivedMessage<MqttMessage>> get receivedMessageStream =>
      _receivedMessageController.stream;

  String? get address => _address;

  MqttServerClient? _client;

  MQTTRepository({required this.server});

  void connect(String address, {MqttConnectMessage? message}) async {
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
    _client?.connectionMessage = message;
    await _client?.connect();
    _subscription = _client?.updates?.listen((event) {
      for (var element in event) {
        log('received message from ${element.topic}');
        _receivedMessageController.add(element);
      }
    });
  }

  void _onConnected() {
    _connectedController.add(_client?.clientIdentifier);
  }

  void _onDisconnected() {
    _connectedController.add(null);
  }

  void _onSubscribed(String topic) {
    log('subscribed topic succeed : [$topic]');
  }

  void _onSubscribeFailure(String topic) {
    log('subscribed topic failure : [$topic]');
  }

  void _onUnsubscribed(String? topic) {
    log('unsubscribed topic : [$topic]');
  }

  void _onPong() {
    log('mqtt client on pong');
  }

  void subscribe(String topic) {
    _client?.subscribe(topic, MqttQos.exactlyOnce);
  }

  void publish(String topic, String message, {bool retain = false}) {
    final builder = MqttClientPayloadBuilder();
    builder.addUTF8String(message);
    _client?.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!,
        retain: retain);
  }

  void close() {
    _connectedController.close();
    _receivedMessageController.close();
  }
}
