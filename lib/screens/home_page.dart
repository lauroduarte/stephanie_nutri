import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/authentication_services.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // _logout() async {
  //   SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  //   await sharedPreference.remove('token');
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text('Home Page'),
            ElevatedButton(
                onPressed: () {
                  // await _logout();
                  context.read<AuthenticationService>().signOut();
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => LoginScreen()),
                  // );
                },
                child: Text('Voltar')),
          ],
        ),
      ),
    );
  }
}
