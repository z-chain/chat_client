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

  late StreamSubscription _receivedSubscription;

  late StreamSubscription _publishedSubscription;

  ChatRepository({required this.database, required this.mqttRepository}) {
    _receivedSubscription =
        mqttRepository.receivedMessageStream.listen((event) async {
      final topic = event.topic;
      if (topic.contains('message')) {
        final message = event.payload as MqttPublishMessage;
        await _processMessage(message);
      }
    });

    _publishedSubscription =
        mqttRepository.publishedMessageStream.listen((event) async {
      final topic = event.variableHeader?.topicName ?? '';
      if (topic.contains('message')) {
        await _processMessage(event);
      }
    });
  }

  Future<void> _processMessage(MqttPublishMessage message) async {
    final bytes = message.payload.message.toList();

    final payload = utf8.decode(bytes);
    final json = jsonDecode(payload);
    final chatMessage = types.Message.fromJson(json);
    final source = chatMessage.author.id;
    final target = chatMessage.remoteId;
    await database
        .insert('Inbox', {'source': source, 'target': target, 'msg': payload});
    _messageController.add(chatMessage);
  }

  void send(String source, String target, types.Message message) {
    return mqttRepository.publish(
        'z-chain/chat/$target/message/$source', jsonEncode(message.toJson()));
  }

  Future<List<types.Message>> messages(String source, String target) async {
    final List<Map> messages = await database.query('Inbox',
        columns: ['id', 'msg'],
        where: 'source = ? or target = ? or source = ? or target = ?',
        whereArgs: [source, source, target, target],
        orderBy: "id desc");
    return messages
        .map((e) => jsonDecode(e['msg']))
        .map((e) => types.Message.fromJson(e))
        .toList();
  }

  void close() {
    _messageController.close();
    _receivedSubscription.cancel();
    _publishedSubscription.cancel();
  }
}
