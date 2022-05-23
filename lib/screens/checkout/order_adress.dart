import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/checkout_model.dart';

class OrderAdress extends StatelessWidget {
  OrderAdress({Key? key, required this.formKey}) : super(key: key);

  final GlobalKey<FormState> formKey;

  final _cepController = TextEditingController();
  final _streetController = TextEditingController();
  final _adressNumberController = TextEditingController();
  final _neighbourhoodController = TextEditingController();
  final _complementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _cepController.text = context.watch<CheckoutModel>().cep ?? "";
    _streetController.text = context.watch<CheckoutModel>().street ?? "";
    _adressNumberController.text =
        context.watch<CheckoutModel>().addressNumber ?? "";
    _neighbourhoodController.text =
        context.watch<CheckoutModel>().neighbourhood ?? "";
    _complementController.text =
        context.watch<CheckoutModel>().complement ?? "";

    return SafeArea(
      child: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(hintText: 'CEP'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  context.read<CheckoutModel>().cep = value;
                },
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'CEP inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(hintText: 'Logradouro'),
                keyboardType: TextInputType.streetAddress,
                onSaved: (value) {
                  context.read<CheckoutModel>().street = value;
                },
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Logradouro inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
                controller: _adressNumberController,
                decoration: const InputDecoration(hintText: 'Número'),
                keyboardType: TextInputType.text,
                onSaved: (value) {
                  context.read<CheckoutModel>().addressNumber = value;
                },
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Número inválido';
                  } else {
                    return null;
                  }
                }),
            TextFormField(
              controller: _complementController,
              decoration: const InputDecoration(hintText: 'Complemento'),
              keyboardType: TextInputType.text,
              onSaved: (value) {
                context.read<CheckoutModel>().complement = value;
              },
            ),
            TextFormField(
                controller: _neighbourhoodController,
                decoration: const InputDecoration(hintText: 'Bairro'),
                keyboardType: TextInputType.text,
                onSaved: (value) {
                  context.read<CheckoutModel>().neighbourhood = value;
                },
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Bairro inválido';
                  } else {
                    return null;
                  }
                }),
            Focus(
              onFocusChange: (hasFocus) {
                formKey.currentState!.save();
              },
              child: Autocomplete<String>(
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Estado',
                    ),
                    focusNode: focusNode,
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    onSaved: (value) {
                      context.read<CheckoutModel>().state = value;
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Estado inválido';
                      }
                      return null;
                    },
                  );
                },
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return const Iterable<String>.empty();
                  }
                  List<String> result = [];
                  result =
                      context.read<CheckoutModel>().getStates().where((estado) {
                    return estado
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  }).toList();
                  return result;
                },
                initialValue: TextEditingValue(
                    text: context.watch<CheckoutModel>().state ?? ""),
                onSelected: (String selection) {
                  context.read<CheckoutModel>().state = selection;
                },
              ),
            ),
            Autocomplete<String>(
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Cidade',
                  ),
                  focusNode: focusNode,
                  onFieldSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                  onSaved: (value) {
                    context.read<CheckoutModel>().city = value;
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Cidade inválida';
                    }
                    return null;
                  },
                );
              },
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                List<String> result = [];
                result.addAll(context
                    .read<CheckoutModel>()
                    .getCities(context.read<CheckoutModel>().state));
                return result.where((cidade) {
                  return cidade
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                }).toList();
              },
              initialValue: TextEditingValue(
                  text: context.watch<CheckoutModel>().city ?? ""),
              onSelected: (String selection) {
                context.read<CheckoutModel>().city = selection;
              },
            )
          ],
        ),
      ),
    );
  }
}
