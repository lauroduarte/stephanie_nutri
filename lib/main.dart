import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:stephanie_nutri/services/authentication_services.dart';
import 'package:stephanie_nutri/screens/home_page.dart';
import 'package:stephanie_nutri/screens/sign_in.dart';
import 'package:stephanie_nutri/services/booking_services.dart';
import 'package:stephanie_nutri/services/users_services.dart';
import 'package:stephanie_nutri/themes/theme.dart';

import 'models/booking_model.dart';
import 'models/booking_stepper_model.dart';
import 'models/time_slot.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('pt_BR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        Provider<UserService>(
          create: (_) => UserService(),
        ),
        Provider<BookingService>(
          create: (_) => BookingService(),
        ),
        ChangeNotifierProvider<BookingModel>(
          create: (_) => BookingModel(),
        ),
        ChangeNotifierProvider<BookingStepperModel>(
          create: (_) => BookingStepperModel(),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
        StreamProvider<List<TimeSlot>>(
          create: (context) => context.read<BookingService>().availableTimeSlots,
          initialData: [],
        ),
      ],
      child: MaterialApp(
        title: 'Stephanie Nutri',
        theme: lightThemeData(context),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return HomePage();
    }
    return SignIn();
  }
}
