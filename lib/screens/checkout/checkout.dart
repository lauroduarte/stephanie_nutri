import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/models/checkout_model.dart';
import 'package:stephanie_nutri/screens/checkout/buyer.dart';
import 'package:stephanie_nutri/screens/checkout/order_adress.dart';
import 'package:stephanie_nutri/screens/checkout/payment.dart';
import 'package:stephanie_nutri/screens/checkout/revision.dart';
import 'package:stephanie_nutri/services/payment_services.dart';

class Checkout extends StatelessWidget {
  Checkout({Key? key}) : super(key: key);

  int _currentStep = 0;

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  _steps() => [
        Step(
          title: Text('Identificação'),
          content: Buyer(formKey: _formKeys[0]),
          isActive: _currentStep == 0,
        ),
        Step(
          title: Text('Endereço de cobrança'),
          content: OrderAdress(formKey: _formKeys[1]),
          isActive: _currentStep == 1,
        ),
        Step(
          title: Text('Dados do pagamento'),
          content: Payment(
            formKey: _formKeys[2],
          ),
          isActive: _currentStep == 2,
        ),
        Step(
          title: Text('Revisão'),
          content: Revision(),
          isActive: _currentStep == 3,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    _currentStep = context.watch<CheckoutModel>().currentStep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagamento'),
      ),
      body: Stepper(
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                (_currentStep < 3)
                    ? ElevatedButton(
                        onPressed: controls.onStepContinue,
                        child: const Text('Próximo'),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          context.read<PaymentService>().createOrder(
                              checkoutModel: context.read<CheckoutModel>());
                        },
                        child: const Text('Pagar'),
                      ),
                TextButton(
                  onPressed: controls.onStepCancel,
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
        type: StepperType.vertical,
        steps: _steps(),
        currentStep: context.watch<CheckoutModel>().currentStep,
        onStepTapped: (step) {
          if (step < _currentStep) {
            context.read<CheckoutModel>().currentStep = step;
          }
        },
        onStepContinue: () {
          if (_currentStep < _steps().length - 1) {
            if (_formKeys[_currentStep].currentState!.validate()) {
              _formKeys[_currentStep].currentState!.save();
              context.read<CheckoutModel>().currentStep += 1;
            }
          }
        },
        onStepCancel: () {
          context.read<CheckoutModel>().currentStep = 0;

          Navigator.of(context).pop();
        },
      ),
    );
  }
}
