import 'package:chat/screens/chat.dart';
import 'package:chat/screens/users.dart';
import 'package:flutter/material.dart';

class Principal extends StatefulWidget {
  final String username;
  const Principal({required this.username, super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  // Lista de páginas
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      Chat(
        username: widget.username,
      ),
      const Users(),
    ];
  }

  // Indice actual de la página
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ENCABEZADO
      appBar: AppBar(
        title: Text(widget.username),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'Opciones',
            itemBuilder: (context) => <PopupMenuEntry<MenuItem>>[
              const PopupMenuItem<MenuItem>(
                height: 8,
                value: MenuItem.cerrarSesion,
                onTap: null,
                child: Text('Cerrar sesión'),
              )
            ],
          ),
        ],
      ),
      // CUERPO
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        destinations: const <NavigationDestination>[
          NavigationDestination(
              icon: Icon(Icons.chat_outlined, color: Color(0xffFF70B4)),
              selectedIcon: Icon(Icons.chat, color: Color(0xffFF70B4)),
              label: 'Grupo'),
          NavigationDestination(
              icon: Icon(Icons.workspaces_outlined, color: Color(0xff85CEFF)),
              selectedIcon: Icon(Icons.workspaces, color: Color(0xff85CEFF)),
              label: 'Conversaciones'),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemTapped,
      ),
    );
  }
}
