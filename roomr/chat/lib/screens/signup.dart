import 'dart:convert';

import 'package:chat/main.dart';
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());
int estaRegistrado = -2;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKeySignUp = GlobalKey<FormState>();

  final nombreController = TextEditingController();
  final usuarioController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  String? _validarCampo(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Este campo es obligatorio';
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
          title: const Text(
            "Registro",
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: Column(children: [
              const SizedBox(height: 40),
              const Text(
                'Los usuarios te conocerán como: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 40),
              Text(
                "${_nameController.text}@${_userController.text}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 70),
              Form(
                key: _formKeySignUp,
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
                          _formKeySignUp.currentState!.validate();
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
                          _formKeySignUp.currentState!.validate();
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

                        if (_formKeySignUp.currentState!.validate()) {
                          await register(jsonString);
                          await isRegister();
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

  Future<void> register(String json) async {
    socket.emit('registro', json);
  }

  Future<void> isRegister() async {
    socket.once('registrado', (data) {
      estaRegistrado = data;
      if (estaRegistrado == 0) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("¡Bien!"),
              content: const Text("Te has registrado con éxito!"),
              actions: [
                TextButton(
                  child: const Text("Iniciar sesión"),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      } else if (estaRegistrado == 1) {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Vaya..."),
              content: const Text("Parece que este usuario ya existe."),
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
      logger.d(estaRegistrado);
    });
  }
}
