import 'package:chat/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

var logger = Logger(printer: PrettyPrinter());
late IO.Socket socket;

main() {
  logger.i("Building App...");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _connectSocket() {
    socket.onConnect((data) => logger.i('Conexión establecida.'));
    socket.onConnectError((data) => logger.e('Error de conexión: $data'));
    socket.onDisconnect((data) => logger.w('Socket.IO desconectado.'));
  }

  @override
  void initState() {
    super.initState();
    socket = IO.io("http://10.0.2.2:5000",
        IO.OptionBuilder().setTransports(['websocket']).build());
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const Login());
  }
}
