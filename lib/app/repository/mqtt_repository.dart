import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:sqflite/utils/utils.dart';

class MQTTRepository {
  final String server;

  StreamSubscription? _updateSubscription;

  StreamSubscription? _publishSubscription;

  final StreamController<String?> _connectedController =
      StreamController.broadcast();

  String? _address;

  Stream<String?> get connectStatusStream =>
      _connectedController.stream.map((event) => _address = event);

  final StreamController<MqttReceivedMessage<MqttMessage>>
      _receivedMessageController = StreamController.broadcast();

  final StreamController<MqttPublishMessage> _publishedMessageController =
      StreamController.broadcast();

  Stream<MqttReceivedMessage<MqttMessage>> get receivedMessageStream =>
      _receivedMessageController.stream;

  Stream<MqttPublishMessage> get publishedMessageStream =>
      _publishedMessageController.stream;

  String? get address => _address;

  MqttServerClient? _client;

  MQTTRepository({required this.server});

  void connect(String address, {MqttConnectMessage? message}) async {
    _client?.disconnect();
    _updateSubscription?.cancel();
    _publishSubscription?.cancel();
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
    // _client?.publishingManager =
    await _client?.connect();
    _updateSubscription = _client?.updates?.listen((event) {
      for (var element in event) {
        log('received message from ${element.topic}');
        _receivedMessageController.add(element);
      }
    });
    _publishSubscription = _client?.published?.listen((event) {
      _publishedMessageController.add(event);
    });
  }

  void _onConnected() {
    log("mqtt has been connected.");
    _connectedController.add(_client?.clientIdentifier);
  }

  void _onDisconnected() {
    _connectedController.add(null);
    log("mqtt has been disconnected.");
    Timer(const Duration(seconds: 5), () {
      _client?.connect();
    });
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
    _updateSubscription?.cancel();
    _publishSubscription?.cancel();
    _connectedController.close();
    _receivedMessageController.close();
    _publishedMessageController.close();
  }
}
