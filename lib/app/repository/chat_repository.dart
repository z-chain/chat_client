import 'dart:async';
import 'dart:convert';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:mqtt_client/mqtt_client.dart';
import 'package:sqflite/sqflite.dart';

import 'mqtt_repository.dart';

class ChatRepository {
  final Database database;

  final MQTTRepository mqttRepository;

  final StreamController<types.Message> _messageController =
      StreamController.broadcast();

  Stream<types.Message> get stream => _messageController.stream;

  late StreamSubscription _subscription;

  ChatRepository({required this.database, required this.mqttRepository}) {
    _subscription = mqttRepository.receivedMessageStream.listen((event) async {
      final topic = event.topic;
      if (topic.contains('message')) {
        final message = event.payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        final json = jsonDecode(payload);
        final chatMessage = types.Message.fromJson(json);
        final from = chatMessage.author.id;
        const to = 'me';
        await database
            .insert('Inbox', {'source': from, 'target': to, 'msg': payload});
        _messageController.add(chatMessage);
      }
    });
  }

  void send(String source, String target, types.Message message) {
    return mqttRepository.publish(
        'z-chain/chat/$target/message/$source', jsonEncode(message.toJson()));
  }

  void close() {
    _messageController.close();
    _subscription.cancel();
  }
}
