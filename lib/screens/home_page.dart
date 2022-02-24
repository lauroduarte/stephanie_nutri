import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/screens/appointments.dart';
import 'package:stephanie_nutri/screens/welcome.dart';

import '../services/authentication_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _pageOptions = [
    Welcome(),
    Appointments(),
    Welcome(),
    Welcome(),
  ];

  int selectedPage = 0;

  // _logout() async {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPage,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: "Agenda"),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
          ],
          onTap: (index){
            setState(() {
              selectedPage = index;
            });
          },

        ),
        body:
        IndexedStack(
          index: selectedPage,
          children: _pageOptions,
        ),
      ),
    );
  }
}
