import 'package:chat/main.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  String username;
  Chat({required this.username, super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Usuario: ${widget.username}\n${socket.id}'),
      ),
    );
  }
}
