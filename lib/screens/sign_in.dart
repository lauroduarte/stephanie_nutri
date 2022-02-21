import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/screens/forgot_password.dart';
import 'package:stephanie_nutri/screens/sign_up.dart';
import 'package:stephanie_nutri/services/users_services.dart';

import '../services/authentication_services.dart';

class SignIn extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final snackBar = const SnackBar(
      content: Text(
    'E-mail ou senha são inválidos',
    textAlign: TextAlign.center,
  ));

  SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 4,
              ),
              TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text == null || text.isEmpty || !text.contains('@')) {
                      return 'E-mail inválido';
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'Senha'),
                  validator: (text) {
                    if (text == null || text.isEmpty || text.length < 8) {
                      return 'A senha deve ter pelo menos 8 caracteres';
                    } else {
                      return null;
                    }
                  }),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                  },
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  child: const Text(
                    'Entrar',
                  ),
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (_formKey.currentState!.validate()) {
                      await context.read<AuthenticationService>().signIn(
                            email: _emailController.text,
                            password: _passController.text,
                          );

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      if (FirebaseAuth.instance.currentUser == null) {
                        _passController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                ),
              ),
              Center(
                child: Text('ou entre com'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await context
                          .read<AuthenticationService>()
                          .signInWithGoogle();
                      if (FirebaseAuth.instance.currentUser == null) {
                        _passController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: Icon(Icons.g_mobiledata_outlined),
                  ),
                  IconButton(
                    onPressed: () async {
                      await context
                          .read<AuthenticationService>()
                          .signInWithGoogle();
                      if (FirebaseAuth.instance.currentUser == null) {
                        _passController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    icon: const Icon(Icons.facebook),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Ainda não é cadastrado? '),
                  TextButton(
                    child: Text('Cadastre-se.'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUp()),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}