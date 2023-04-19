import 'dart:convert';

import 'package:chat/main.dart';
import 'package:chat/models/user.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

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

  int reg = -1;

  String? _validarCampo(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Este campo es requerido';
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
                color: Color(0xff252525)),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: Column(children: [
              const Text(
                'Los usuarios te conocerán como: ',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                "${_nameController.text}@${_userController.text}",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKeySignUp,
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
                          _formKeySignUp.currentState!.validate();
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
                          _formKeySignUp.currentState!.validate();
                          _userController.text = text;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        // Instancia un nuevo usuario
                        User nuevoUsuario = User(
                            name: nombreController.text,
                            username: usuarioController.text);
                        String jsonString = jsonEncode(nuevoUsuario);
                        if (_formKeySignUp.currentState!.validate()) {
                          await procesoRegistro(jsonString);
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

  Future<void> procesoRegistro(String json) async {
    socket.emit('registro', json);
    Future.delayed(const Duration(milliseconds: 5), () {
      socket.on('registrado', (data) {
        reg = data;
        if (reg == 0) {
          logger.w(reg);
        } else if (reg == 1) {
          logger.w(reg);
        }
      });
    });
  }
}
