import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/models/checkout_model.dart';
import 'package:stephanie_nutri/utils/utils.dart';

class Payment extends StatelessWidget {
  Payment({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _cardValidityMonthController = TextEditingController();
  final _cardValidityYearController = TextEditingController();
  final _cardCvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _cardNumberController.text =
        context.watch<CheckoutModel>().cardNumber ?? "";
    _cardNameController.text = context.watch<CheckoutModel>().cardName ?? "";
    _cardValidityMonthController.text =
        (context.watch<CheckoutModel>().validityMonth ?? "").toString();
    _cardValidityYearController.text =
        (context.watch<CheckoutModel>().validityYear ?? "").toString();
    _cardCvvController.text = context.watch<CheckoutModel>().cvv ?? "";

    return SafeArea(
        child: Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          DropdownButtonFormField(
              hint: Text("Quantidade de parcelas"),
              onSaved: (value) {
                context.read<CheckoutModel>().installments = value;
              },
              items: CheckoutModel.installmentsOptions.map((int val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text(
                    (val == 1) ? "à vista" : val.toString() + "x",
                  ),
                );
              }).toList(),
              validator: (int? value) {
                if (value == null) {
                  return "Favor escolher a quantidade de parcelas";
                } else {
                  return null;
                }
              },
              onChanged: (value) {}),
          TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(hintText: 'Número do Cartão'),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                context.read<CheckoutModel>().cardNumber = value;
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Número do cartão inválido';
                } else {
                  return null;
                }
              }),
          DropdownButtonFormField(
              hint: Text("Bandeira"),
              onSaved: (value) {
                context.read<CheckoutModel>().cardNetwork = value;
              },
              items: CheckoutModel.cardNetworks.map((String val) {
                return DropdownMenuItem(
                  value: val,
                  child: Text(
                    val,
                  ),
                );
              }).toList(),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Favor escolher a bandeira do cartão";
                } else {
                  return null;
                }
              },
              onChanged: (value) {}),
          TextFormField(
              controller: _cardNameController,
              decoration:
                  const InputDecoration(hintText: 'Nome como está no cartão'),
              keyboardType: TextInputType.name,
              onSaved: (value) {
                context.read<CheckoutModel>().cardName = value;
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Nome como está no cartão inválido';
                } else {
                  return null;
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Validade:"),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: TextFormField(
                    controller: _cardValidityMonthController,
                    decoration: const InputDecoration(hintText: 'MM'),
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      context.read<CheckoutModel>().validityMonth =
                          int.tryParse(value!);
                    },
                    validator: (text) {
                      if (text == null ||
                          text.isEmpty ||
                          !Utils.isNumeric(text)) {
                        return 'Validade inválida';
                      } else {
                        return null;
                      }
                    }),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 6,
                child: TextFormField(
                    controller: _cardValidityYearController,
                    decoration: const InputDecoration(hintText: 'YY'),
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      context.read<CheckoutModel>().validityYear =
                          int.tryParse(value!);
                    },
                    validator: (text) {
                      if (text == null ||
                          text.isEmpty ||
                          !Utils.isNumeric(text)) {
                        return 'Validade inválida';
                      } else {
                        return null;
                      }
                    }),
              ),
            ],
          ),
          TextFormField(
              controller: _cardCvvController,
              decoration:
                  const InputDecoration(hintText: 'Código de segurança CVV'),
              maxLength: 3,
              keyboardType: TextInputType.number,
              onSaved: (value) {
                context.read<CheckoutModel>().cvv = value;
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Código de segurança CVV inválido';
                } else {
                  return null;
                }
              }),
        ],
      ),
    ));
  }
}
