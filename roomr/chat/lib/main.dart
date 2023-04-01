import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';

// Logs
var logger = Logger(printer: PrettyPrinter());

main() {
  // Dart client
  IO.Socket socket = IO.io('http://10.0.2.2:5000',
      IO.OptionBuilder().setTransports(['websocket']).build());
  socket.onConnect((_) {
    logger.i("Conectado al Socket!");
    socket.emit('mensaje', 'Hola server!');
  });
  logger.i("Building App...");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
        ),
        body: const Center(
          child: Text("Esto es una prueba."),
        ),
      ),
    );
  }
}
