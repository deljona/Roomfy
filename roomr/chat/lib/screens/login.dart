import 'dart:convert';

import 'package:chat/main.dart';
import 'package:chat/models/user.dart';
import 'package:chat/providers/chat.dart';
import 'package:chat/screens/chat.dart';
import 'package:chat/screens/principal.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:provider/provider.dart';

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
              const SizedBox(height: 80),
              const Text(
                "Inicia sesión",
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0)),
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
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xff3A00E5), width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Nombre'),
                      onChanged: (text) {
                        setState(() {
                          _formKeyLogin.currentState!.validate();
                          _nameController.text = text;
                        });
                      },
                    ),
                    const SizedBox(height: 35),
                    TextFormField(
                      maxLength: 10,
                      validator: _validarCampo,
                      controller: usuarioController,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color(0xff3A00E5), width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.red, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                          prefixIcon: const Icon(Icons.alternate_email),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Usuario'),
                      onChanged: (text) {
                        setState(() {
                          _formKeyLogin.currentState!.validate();
                          _userController.text = text;
                        });
                      },
                    ),
                    const SizedBox(height: 80),
                    ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              const Color(0xffffffff)),
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff3A00E5)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)))),
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
              const SizedBox(height: 125),
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
        String username = '${nombreController.text}@${usuarioController.text}';

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider(
                  create: (context) => ChatProvider(),
                  child: Principal(username: username))),
        );
      } else if (estaLogin == 1) {
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
