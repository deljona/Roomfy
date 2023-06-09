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

  _getMessagesFromDb() {
    socket.emit('getMsgFromDb');
    socket.once('getMsgs', (data) {
      List<dynamic> oldData = data;
      for (var msg in oldData) {
        Provider.of<ChatProvider>(context, listen: false)
            .addNewMessage(Message.fromJson(msg));
        logger.i(msg['message']);
      }
    });
  }

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
        jsonEncode(
            {'message': jsonMessage, 'senderUsername': widget.username}));
    _messageInputController.clear();
  }

  @override
  void initState() {
    super.initState();
    _getMessagesFromDb();
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
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment:
                                message.senderUsername == widget.username
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    message.senderUsername == widget.username
                                        ? CrossAxisAlignment.center
                                        : CrossAxisAlignment.center,
                                children: [
                                  const CircleAvatar(
                                    radius: 15,
                                    backgroundImage:
                                        AssetImage("assets/images/avatar.png"),
                                  ),
                                  SizedBox(
                                      width: message.senderUsername ==
                                              widget.username
                                          ? 0
                                          : 10),
                                  if (message.senderUsername != widget.username)
                                    Text(
                                      message.senderUsername,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  if (message.senderUsername != widget.username)
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.reply),
                                      iconSize: 20,
                                    ),
                                  SizedBox(
                                      width: message.senderUsername ==
                                              widget.username
                                          ? 0
                                          : 0)
                                ],
                              ),
                              Bubble(
                                margin: const BubbleEdges.only(top: 10),
                                radius: const Radius.circular(20.0),
                                nip: message.senderUsername == widget.username
                                    ? BubbleNip.rightTop
                                    : BubbleNip.leftTop,
                                color: const Color.fromRGBO(225, 255, 199, 1.0),
                                child: Text(message.message,
                                    textAlign: TextAlign.right),
                              )
                            ]))
                  ]);
            },
            separatorBuilder: (_, index) => const SizedBox(
              height: 5,
            ),
            itemCount: provider.messages.length,
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
                    icon: const Icon(Icons.send_rounded),
                  )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}
