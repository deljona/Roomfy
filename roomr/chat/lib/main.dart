import 'package:chat/widgets/signup.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

main() {
  logger.i("Building App...");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const SignUp());
  }
}
