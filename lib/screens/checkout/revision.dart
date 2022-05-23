import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/models/checkout_model.dart';

class Revision extends StatelessWidget {
  const Revision({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Card(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Item: " +
                      (context
                          .read<CheckoutModel>()
                          .itemDescription
                          .toString())),
                  Text("Quantidade: " +
                      context.read<CheckoutModel>().itemQuantity.toString()),
                  Text("Valor: " +
                      context.read<CheckoutModel>().itemAmount.toString()),
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nome: " +
                      (context.read<CheckoutModel>().fullName.toString())),
                  Text("E-mail: " +
                      context.read<CheckoutModel>().email.toString()),
                  Text("Documento: " +
                      context.read<CheckoutModel>().cpfCnpj.toString()),
                  Text("Telefone: (" +
                      context
                          .read<CheckoutModel>()
                          .phoneNumberCodeArea
                          .toString() +
                      ") " +
                      context.read<CheckoutModel>().phoneNumber.toString()),
                  Text("Celular: (" +
                      context
                          .read<CheckoutModel>()
                          .mobileNumberCodeArea
                          .toString() +
                      ") " +
                      context.read<CheckoutModel>().phoneNumber.toString()),
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Logradouro: " +
                      context.read<CheckoutModel>().street.toString()),
                  Text("Número: " +
                      context.read<CheckoutModel>().addressNumber.toString() +
                      " Complemento: " +
                      context.read<CheckoutModel>().complement.toString()),
                  Text("Bairro: " +
                      context.read<CheckoutModel>().neighbourhood.toString()),
                  Text("Cidade: " +
                      context.read<CheckoutModel>().city.toString() +
                      " Estado: " +
                      context.read<CheckoutModel>().state.toString()),
                  Text("CEP: " + context.read<CheckoutModel>().cep.toString()),
                ],
              ),
            ],
          ),
        ),
        Card(
          margin: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Quantidade de Parcelas: " +
                        context.read<CheckoutModel>().installments.toString()),
                    Text(
                        "Número do Cartão: " +
                            context.read<CheckoutModel>().cardNumber.toString(),
                        softWrap: false,
                        overflow: TextOverflow.fade),
                    Text("Bandeira: " +
                        context.read<CheckoutModel>().cardNetwork.toString()),
                    Text("Nome no Cartão: " +
                        context.read<CheckoutModel>().cardName.toString()),
                    Text("Validade: " +
                        context.read<CheckoutModel>().validityMonth.toString() +
                        "/" +
                        context.read<CheckoutModel>().validityYear.toString()),
                    Text(
                        "CVV: " + context.read<CheckoutModel>().cvv.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
