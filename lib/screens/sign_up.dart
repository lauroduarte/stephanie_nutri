import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/services/authentication_services.dart';

import '../exceptions/app_exception.dart';
import '../utils/cpf_validator.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);

  final List<String> _genders = ['Masculino', 'Feminino', 'Outros'];

  final _displayNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _cpfController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _selectedGender;

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
            TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'Senha'),
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Senha inválida';
                  } else if (text.length < 8) {
                    return 'A senha precisa conter no mínimo 8 caracteres';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(hintText: 'Nome completo'),
                keyboardType: TextInputType.name,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Nome inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(hintText: 'Apelido'),
                keyboardType: TextInputType.name,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Apelido inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(hintText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validator: (text) {
                  if (text == null || text.isEmpty || text.length < 6) {
                    return 'Telefone inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(hintText: 'CPF'),
                keyboardType: TextInputType.phone,
                validator: (text) {
                  if (text == null ||
                      text.isEmpty ||
                      !CPFValidator.isValid(text)) {
                    return 'CPF inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                readOnly: true,
                onTap: () async {
                  DateTime? birthDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1940),
                    lastDate: DateTime.now(),
                  );

                  if (birthDate != null) {
                    _birthDateController.text =
                        '${birthDate.day.toString().padLeft(2, '0')}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.year}';
                  }
                },
                controller: _birthDateController,
                decoration:
                    const InputDecoration(hintText: 'Data de Nascimento'),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Data de nascimento inválida';
                  } else {
                    return null;
                  }
                }),
            Text('Sexo:'),
            GroupButton(
              isRadio: true,
              buttons: _genders,
              onSelected: (int index, bool isSelected) {
                if (isSelected) {
                  _selectedGender = _genders[index];
                }
              },
            ),
            SizedBox(
              height: 40,
              child: ElevatedButton(
                child: Text('Cadastrar'),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    try {
                      await context.read<AuthenticationService>().signUp(
                        email: _emailController.text,
                        password: _passwordController.text,
                        birthDate: _birthDateController.text,
                        photoURL: '',
                        phoneNumber: _phoneNumberController.text,
                        fullName: _fullNameController.text,
                        displayName: _displayNameController.text,
                        cpf: _cpfController.text,
                        gender: _selectedGender,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                            'Cadastro efetuado com sucesso',
                            textAlign: TextAlign.center,
                          )));
                      Navigator.of(context).pop();
                    } on AppException catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            e.message!,
                            textAlign: TextAlign.center,
                          )));
                    }
                  }
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
