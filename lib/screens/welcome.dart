import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stephanie_nutri/screens/booking_stepper.dart';

import '../services/authentication_services.dart';
import 'booking.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Seja bem vindo!'),
      ),
      body: Container(
          child: Column(
        children: [
          Text('Olá ${FirebaseAuth.instance.currentUser!.displayName}'),
          Text("Vamos agendar uma consulta",
              style: GoogleFonts.lato(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              )),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BookingStepper())
              );
            },
            child: Text('Agendar'),
          ),
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
      )),
    );
  }
}
