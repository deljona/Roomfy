import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:logger/logger.dart';

// Logs
var logger = Logger(printer: PrettyPrinter());

class Client {
  static void connectToSocket({required String ip, required String port}) {
    var uri = "http://$ip:$port" as Uri;
    io.Socket socket = io.io(uri);
    socket.onConnect((_) {
      logger.i("Conectado al Socket!");
      socket.emit('mensaje', 'Hola server!');
    });
  }
}
