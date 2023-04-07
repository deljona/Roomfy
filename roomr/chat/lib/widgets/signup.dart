import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late IO.Socket _socket;

  final _formKey = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final usuarioController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  TextEditingController _userController = TextEditingController();

  String? _validarCampo(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Este campo es requerido';
    }
    final RegExp regExp = RegExp(r'^[a-zA-Z0-9]{1,10}$');
    if (!regExp.hasMatch(valor)) {
      return 'Ingrese sólo números, letras y máximo 10 carácteres.';
    }
    return null;
  }

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
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const Text('Los usuarios te conocerán como: '),
              Text("${_nameController.text}@${_userController.text}"),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      validator: _validarCampo,
                      controller: nombreController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          labelText: 'Nombre'),
                      onChanged: (text) {
                        setState(() {
                          _formKey.currentState!.validate();
                          _nameController.text = text;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: _validarCampo,
                      controller: usuarioController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          border: OutlineInputBorder(),
                          labelText: 'Usuario'),
                      onChanged: (text) {
                        setState(() {
                          _formKey.currentState!.validate();
                          _userController.text = text;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _socket.emit(
                              'registro',
                              User(
                                      name: nombreController.text,
                                      username: usuarioController.text)
                                  .toJson());
                        }
                      },
                      child: const Text('Registrarme'),
                    ),
                  ],
                ),
              )
            ]),
          )),
        ));
  }
}
