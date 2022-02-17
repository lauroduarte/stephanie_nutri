import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/authentication_services.dart';

class ForgotPassword extends StatelessWidget {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final snackBar = const SnackBar(
      content: Text(
        'E-mail enviado com sucesso',
        textAlign: TextAlign.center,
      ));

  ForgotPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Informe o seu endereço de e-mail:'),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'E-mail'),
                  validator: (text) {
                    if (text == null || text.isEmpty || !text.contains('@')) {
                      return 'E-mail inválido';
                    } else {
                      return null;
                    }
                  }),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  child: const Text(
                    'Redefinir senha',
                  ),
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (_formKey.currentState!.validate()) {
                      await context.read<AuthenticationService>().sendPasswordResetEmail(_emailController.text);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
