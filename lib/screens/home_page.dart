import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  _logout() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.remove('token');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text('Home Page'),
            ElevatedButton(
                onPressed: () async {
                  await _logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text('Voltar')),
          ],
        ),
      ),
    );
  }
}
