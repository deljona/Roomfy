import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:logger/logger.dart';

// Logs
var logger = Logger(printer: PrettyPrinter());

class Client {
  static void connectToSocket({required String ip, required String port}) {
    var uri = "http://$ip:$port";
    io.Socket socket =
        io.io(uri, io.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((_) {
      logger.i("Conectado al Socket!");
      socket.emit('mensaje', 'Usuario conectado.');
    });
  }
}
