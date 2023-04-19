import 'package:chat/screens/login.dart';
import 'package:chat/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

var logger = Logger(printer: PrettyPrinter());
late io.Socket socket;

main() {
  connectSocket() {
    socket.onConnect((data) => logger.i('Conexión establecida.'));
    socket.onConnectError((data) => logger.e('Error de conexión: $data'));
    socket.onDisconnect((data) => logger.w('Socket.IO desconectado.'));
  }

  socket = io.io(
      "http://10.0.2.2:5000",
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({'foo': 'bar'})
          .build());
  socket.connect();
  connectSocket();

  logger.i("Building App...");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const Login(),
          '/registro': (context) => const SignUp()
        },
        initialRoute: '/');
  }
}
