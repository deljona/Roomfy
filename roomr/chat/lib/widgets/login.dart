import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late IO.Socket _socket;

  _connectSocket() {
    _socket.onConnect((data) => logger.i('Conexión establecida.'));
    _socket.onConnectError((data) => logger.e('Error de conexión: $data'));
    _socket.onDisconnect((data) => logger.w('Socket.IO desconectado.'));
  }

  @override
  void initState() {
    super.initState();
    _socket = IO.io("http://10.0.2.2:5000",
        IO.OptionBuilder().setTransports(['websocket']).build());
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registro"),
        ),
        body: const Center(
            child: Text(
          'Diseño',
        )));
  }
}
