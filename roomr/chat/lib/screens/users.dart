import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Conversando con: '),
        ),
        body: ListView(
          children: const <Widget>[
            Card(
              child: ListTile(
                  leading: CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                  title: Text('Usuario 1'),
                  subtitle: Text('Último mensaje')),
            ),
            Card(
              child: ListTile(
                  leading: CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                  title: Text('Usuario 2'),
                  subtitle: Text('Último mensaje')),
            ),
            Card(
              child: ListTile(
                  leading: CircleAvatar(
                    radius: 15,
                    backgroundImage: AssetImage("assets/images/avatar.png"),
                  ),
                  title: Text('Usuario 3'),
                  subtitle: Text('Último mensaje')),
            ),
          ],
        ));
  }
}
