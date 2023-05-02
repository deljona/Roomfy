import 'package:chat/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _messages = [];

  List<Message> get messages => _messages;

  addNewMessage(Message message) async {
    _messages.add(message);
    notifyListeners();
  }
}
