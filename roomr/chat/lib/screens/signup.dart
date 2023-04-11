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
                      onPressed: () {
                        User nuevoUsuario = User(
                            name: nombreController.text,
                            username: usuarioController.text);
                        if (_formKeySignUp.currentState!.validate()) {
                          socket.emit('registro', nuevoUsuario.toJson());
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
