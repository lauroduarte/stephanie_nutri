import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authetication_services.dart';
import 'home_page.dart';

class SignInPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final snackBar = SnackBar(content: Text('E-mail ou senha são inválidos', textAlign: TextAlign.center,));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body:
      // if (model.isLoading) {
      //   return Center(
      //     child: CircularProgressIndicator(),
      //   );
      // }
      SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              Image.asset("assets/images/logo.png",
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width / 4,
              ),
              TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text == null ||
                        text.isEmpty ||
                        !text.contains('@')) {
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
                  onPressed: null,
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(
                      fontFamily: 'Merriweather',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text(
                    'Entrar',
                  ),
                  onPressed: () async  {

                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if(_formKey.currentState!.validate()){
                      await context.read<AuthenticationService>().signIn(
                        email: _emailController.text,
                        password: _passController.text,
                      );

                      if(!currentFocus.hasPrimaryFocus){
                        currentFocus.unfocus();
                      }

                      //final firebaseUser = context.watch<User?>();

                      if(FirebaseAuth.instance.currentUser == null){
                        _passController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}