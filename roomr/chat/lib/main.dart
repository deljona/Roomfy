import 'package:chat/services/client.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';

// Logs
var logger = Logger(printer: PrettyPrinter());

main() {
  Client.connectToSocket(ip: "10.0.2.2", port: "5000");
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
