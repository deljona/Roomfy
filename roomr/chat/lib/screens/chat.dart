import 'dart:convert';

import 'package:chat/main.dart';
import 'package:chat/models/message.dart';
import 'package:chat/providers/chat.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';
import 'package:provider/provider.dart';

enum MenuItem { cerrarSesion }

class Chat extends StatefulWidget {
  final String username;
  const Chat({required this.username, super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _messageInputController = TextEditingController();

  _responseMessage() {
    socket.on(
        'responseMessage',
        (data) => Provider.of<ChatProvider>(context, listen: false)
            .addNewMessage(Message.fromJson((data))));
  }

  _sendMessage() {
    String jsonMessage = _messageInputController.text.trim();
    socket.emit(
        'message',
        jsonEncode({
          'message': jsonMessage,
          'senderUsername': widget.username,
          'sentAt': DateTime.now().minute
        }));
    _messageInputController.clear();
  }

  @override
  void initState() {
    super.initState();
    _responseMessage();
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.username),
          actions: <Widget>[
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Opciones',
              itemBuilder: (context) => <PopupMenuEntry<MenuItem>>[
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.cerrarSesion,
                  onTap: null,
                  child: Text('Cerrar sesión'),
                )
              ],
            ),
          ],
        ),
        body: Column(children: [
          Expanded(
              child: Consumer<ChatProvider>(
            builder: (_, provider, __) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final message = provider.messages[index];
                return Wrap(
                  alignment: message.senderUsername == widget.username
                      ? WrapAlignment.end
                      : WrapAlignment.start,
                  children: [
                    Bubble(
                      margin: const BubbleEdges.only(top: 10),
                      radius: const Radius.circular(20.0),
                      alignment: Alignment.topRight,
                      nip: BubbleNip.rightTop,
                      color: const Color.fromRGBO(225, 255, 199, 1.0),
                      child: Text(message.message, textAlign: TextAlign.right),
                    )
                  ],
                );
              },
              separatorBuilder: (_, index) => const SizedBox(
                height: 5,
              ),
              itemCount: provider.messages.length,
            ),
          )),
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
