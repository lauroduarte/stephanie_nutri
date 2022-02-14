import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final snackBar = SnackBar(content: Text('E-mail ou senha são inválidos', textAlign: TextAlign.center,));

  @override
  initState(){
    super.initState();
    _verifyToken().then((value){
      if(value){
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => HomePage()),);
      }
    });
  }


  Future<bool> _verifyToken() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    return sharedPreference.getString('token') != null;
  }

  Future<bool> _login() async{
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    var url = Uri.parse('https://620a9e5792946600171c5bc8.mockapi.io/api/v1/login');
    var resp = await http.post(url,
    body: {
      'username': _emailController.text,
      'password': _passController.text
    });

    if(resp.statusCode == 200 || resp.statusCode == 201){
      await sharedPreference.setString('token', jsonDecode(resp.body)['token']);
      return true;
    } else {
      return false;
    }

  }

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
                  onPressed: _login,
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
                  onPressed: () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if(_formKey.currentState!.validate()){
                      bool isLoggedIn = await _login();
                      if(!currentFocus.hasPrimaryFocus){
                        currentFocus.unfocus();
                      }
                      if(isLoggedIn){
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomePage()),);
                      } else {
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
