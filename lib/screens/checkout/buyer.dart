import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/models/checkout_model.dart';

import '../../utils/cpf_validator.dart';

class Buyer extends StatelessWidget {
  Buyer({Key? key, required Key this.formKey}) : super(key: key);

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _phoneNumberCodeAreaController = TextEditingController();
  final _mobileNumberCodeAreaController = TextEditingController();

  final Key formKey;

  @override
  Widget build(BuildContext context) {
    _fullNameController.text = context.watch<CheckoutModel>().fullName ?? "";
    _emailController.text = context.watch<CheckoutModel>().email ?? "";
    _cpfCnpjController.text = context.watch<CheckoutModel>().cpfCnpj ?? "";
    _phoneNumberController.text =
        context.watch<CheckoutModel>().phoneNumber ?? "";
    _mobileNumberController.text =
        context.watch<CheckoutModel>().mobileNumber ?? "";
    _phoneNumberCodeAreaController.text =
        context.watch<CheckoutModel>().phoneNumberCodeArea ?? "";
    _mobileNumberCodeAreaController.text =
        context.watch<CheckoutModel>().mobileNumberCodeArea ?? "";

    return SafeArea(
        child: Form(
      key: formKey,
      child: ListView(
          padding: const EdgeInsets.all(24),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(hintText: 'Nome completo'),
                keyboardType: TextInputType.name,
                onSaved: (value) {
                  context.read<CheckoutModel>().fullName = value;
                },
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Nome inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  context.read<CheckoutModel>().email = value;
                },
                validator: (text) {
                  if (text == null || text.isEmpty || !text.contains('@')) {
                    return 'E-mail inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                controller: _cpfCnpjController,
                decoration: const InputDecoration(hintText: 'CPF / CNPJ'),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                onSaved: (value) {
                  context.read<CheckoutModel>().cpfCnpj = value;
                },
                validator: (text) {
                  if (text == null ||
                      text.isEmpty ||
                      !CPFValidator.isValid(text)) {
                    return 'CPF / CNPJ inválido';
                  } else {
                    return null;
                  }
                }),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 8,
                  child: TextFormField(
                      controller: _phoneNumberCodeAreaController,
                      decoration: const InputDecoration(hintText: 'DDD'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        context.read<CheckoutModel>().phoneNumberCodeArea =
                            value;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'DDD inválido';
                        } else {
                          return null;
                        }
                      }),
                ),
                Expanded(
                  child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(hintText: 'Telefone'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        context.read<CheckoutModel>().phoneNumber = value;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Telefone inválido';
                        } else {
                          return null;
                        }
                      }),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 8,
                  child: TextFormField(
                      controller: _mobileNumberCodeAreaController,
                      decoration: const InputDecoration(hintText: 'DDD'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        context.read<CheckoutModel>().mobileNumberCodeArea =
                            value;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'DDD inválido';
                        } else {
                          return null;
                        }
                      }),
                ),
                Expanded(
                  child: TextFormField(
                      controller: _mobileNumberController,
                      decoration: const InputDecoration(hintText: 'Celular'),
                      keyboardType: TextInputType.phone,
                      onSaved: (value) {
                        context.read<CheckoutModel>().mobileNumber = value;
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Telefone inválido';
                        } else {
                          return null;
                        }
                      }),
                ),
              ],
            ),
          ]),
    ));
  }
}
