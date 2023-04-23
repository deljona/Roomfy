import 'dart:convert';

import 'package:chat/main.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  String username;
  Chat({required this.username, super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageInputController = TextEditingController();

  _responseMessage() {
    socket.on('responseMessage', (data) => logger.d(data));
  }

  _sendMessage() {
    String jsonMessage = jsonEncode('Test de prueba');
    socket.emit('message', jsonMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.username),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.person),
              tooltip: 'Perfil',
              onPressed: () {},
            ),
          ],
        ),
        body: Column(children: [
          Expanded(child: ListView()),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageInputController,
                      decoration: const InputDecoration(
                        hintText: 'Mensaje',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_messageInputController.text.trim().isNotEmpty) {
                        _sendMessage();
                      }
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          )
        ]));
  }
}
