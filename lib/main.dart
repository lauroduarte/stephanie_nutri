import 'package:flutter/material.dart';
import 'package:stephanie_nutri/screens/login_screen.dart';
import 'package:stephanie_nutri/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stephanie Nutri',
      theme: lightThemeData(context),
      home: LoginScreen(),
    );
  }
}
