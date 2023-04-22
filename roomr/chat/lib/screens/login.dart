import 'dart:convert';

import 'package:chat/main.dart';
import 'package:chat/models/user.dart';
import 'package:chat/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());
int estaLogin = -2;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKeyLogin = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final usuarioController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  String? _validarCampo(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Este campo es obligatorio.';
    }
    final RegExp regExp = RegExp(r'^[a-z0-9]{1,10}$');
    if (!regExp.hasMatch(valor)) {
      return 'Ingrese sólo números, letras y minúsculas.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Image.asset(
              "assets/images/logo.png",
              scale: 1.7,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              const Text(
                "Inicia sesión",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff252525)),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKeyLogin,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      maxLength: 10,
                      validator: _validarCampo,
                      controller: nombreController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                          labelText: 'Nombre'),
                      onChanged: (text) {
                        setState(() {
                          _formKeyLogin.currentState!.validate();
                          _nameController.text = text;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      maxLength: 10,
                      validator: _validarCampo,
                      controller: usuarioController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          border: OutlineInputBorder(),
                          labelText: 'Usuario'),
                      onChanged: (text) {
                        setState(() {
                          _formKeyLogin.currentState!.validate();
                          _userController.text = text;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        User nuevoUsuario = User(
                            name: nombreController.text,
                            username: usuarioController.text);

                        String jsonString = jsonEncode(nuevoUsuario);

                        if (_formKeyLogin.currentState!.validate()) {
                          await login(jsonString);
                          await isLogin();
                        }
                        logger.w(socket.id);
                      },
                      child: const Text('Iniciar sesión'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 200),
              TextButton(
                onPressed: () {
                  nombreController.clear();
                  usuarioController.clear();
                  Navigator.pushNamed(context, '/registro');
                },
                child: const Text('Crear nueva cuenta'),
              )
            ]),
          )),
        ));
  }

  Future<void> login(String json) async {
    socket.emit('login', json);
  }

  Future<void> isLogin() async {
    socket.once('logeado', (data) {
      estaLogin = data;
      if (estaLogin == 0) {
        String username = '${nombreController.text}@${nombreController.text}';
        logger.w(estaLogin);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Chat(username: username)),
        );
      } else if (estaLogin == 1) {
        logger.w(estaLogin);
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Vaya..."),
              content: const Text("Este usuario no existe."),
              actions: [
                TextButton(
                  child: const Text("Probar de nuevo"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      logger.d(estaLogin);
    });
  }
}
