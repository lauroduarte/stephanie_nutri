import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/models/app_user.dart';
import 'package:stephanie_nutri/models/checkout_model.dart';
import 'package:stephanie_nutri/screens/checkout/checkout.dart';
import 'package:stephanie_nutri/services/booking_services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/booking_model.dart';
import '../models/booking_stepper_model.dart';
import '../models/time_slot.dart';

class BookingStepper extends StatelessWidget {
  int _currentStep = 0;

  BookingStepper({Key? key}) : super(key: key);

  _steps() => [
        Step(
          title: Text(''),
          content: _ChooseTimeSlot(),
          isActive: _currentStep == 0,
        ),
        Step(
          title: Text(''),
          content: _CardForm(),
          isActive: _currentStep == 1,
        ),
        Step(
          title: Text(''),
          content: _Overview(),
          isActive: _currentStep == 2,
        )
      ];

  @override
  Widget build(BuildContext context) {
    _currentStep = context.watch<BookingStepperModel>().currentStep;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento'),
      ),
      body: Stepper(
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: controls.onStepContinue,
                  child: const Text('Próximo'),
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
        type: StepperType.horizontal,
        steps: _steps(),
        currentStep: context.watch<BookingStepperModel>().currentStep,
        onStepTapped: (step) {
          context.read<BookingStepperModel>().currentStep = step;
        },
        onStepContinue: () {
          if (context.read<BookingStepperModel>().currentStep <
              _steps().length - 1) {
            context.read<BookingStepperModel>().currentStep += 1;
          }
        },
        onStepCancel: () {
          context.read<BookingStepperModel>().currentStep = 0;

          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _ChooseTimeSlot extends StatelessWidget {
  _ChooseTimeSlot({Key? key}) : super(key: key);

  List<TimeSlot> _availableSlots = [];

  @override
  Widget build(BuildContext context) {
    List<TimeSlot> _availableSlots = context.watch<List<TimeSlot>>();
    var aTime = _availableSlots
        .where((e1) =>
            isSameDay(e1.date, context.read<BookingModel>().selectedDate))
        .map((e2) => e2.asString)
        .toList();
    aTime.sort();
    //_availableSlots = aTime;

    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.7,
      child: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: context.watch<BookingModel>().focusedDate,
            selectedDayPredicate: (day) {
              return isSameDay(context.watch<BookingModel>().selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              context.read<BookingModel>().selectedDate = selectedDay;
              context.read<BookingModel>().focusedDate = focusedDay;
            },
            calendarFormat: CalendarFormat.week,
            availableCalendarFormats: {CalendarFormat.week: ''},
            onPageChanged: (focusedDay) {
              context.read<BookingModel>().focusedDate = focusedDay;
            },
            eventLoader: (day) {
              var available = _availableSlots
                  .map((element) {
                    DateTime eDate = element.date!;
                    if (DateTime(eDate.year, eDate.month, eDate.day) ==
                        DateTime(day.year, day.month, day.day))
                      return 'Disponível';
                  })
                  .where((e) => e != null)
                  .toList();
              return available;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
              child: ListView(
            children: [
              _availableSlots
                          .where((e1) => isSameDay(e1.date,
                              context.read<BookingModel>().selectedDate))
                          .length >
                      0
                  ? Text('Selecione um dos horários disponíveis')
                  : Text('Tente outra data'),
              GroupButton(
                isRadio: true,
                buttons: _availableSlots
                    .where((e1) => isSameDay(
                        e1.date, context.read<BookingModel>().selectedDate))
                    .map((e) => e.asString)
                    .toList()
                  ..sort(),
                onSelected: (int index, bool isSelected) {
                  if (isSelected) {
                    context.read<BookingModel>().selectedTimeSlot =
                        _availableSlots[index].asString;
                  }
                },
              )
            ],
          )),
        ],
      ),
    );
  }
}

class _CardForm extends StatelessWidget {
  const _CardForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 1.7,
        child: Column(
          children: [
            TextButton(
              child: Text("Clique para acessar a página de pagamento"),
              onPressed: () async {
                _launchURL(context);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                _launchURL(context);
              },
              child: Text("Ir para página de pagamento"),
            ),
          ],
        ));
  }

  void _launchURL(BuildContext context) async {
    context.read<CheckoutModel>().itemQuantity = 1;
    context.read<CheckoutModel>().itemDescription = "Consulta";
    context.read<CheckoutModel>().itemAmount = 25000;
    context.read<CheckoutModel>().itemCode = "c0001";

    //If not in release mode fills data to make tests easier
    if (!kReleaseMode) {
      context.read<CheckoutModel>().addressNumber = "310";
      context.read<CheckoutModel>().cardName = "Orual D Omar";
      context.read<CheckoutModel>().cardNetwork = "Visa";
      context.read<CheckoutModel>().cardNumber = "4000000000000010";
      context.read<CheckoutModel>().cep = "47205606";
      context.read<CheckoutModel>().city = "Lavras";
      context.read<CheckoutModel>().complement = "Casa";
      context.read<CheckoutModel>().cpfCnpj = "60464848040";
      context.read<CheckoutModel>().cvv = "999";
      context.read<CheckoutModel>().email = "orual.omar@gmail.com";
      context.read<CheckoutModel>().fullName = "Orual Darte Omar";
      context.read<CheckoutModel>().installments = 1;
      context.read<CheckoutModel>().mobileNumber = "980893066";
      context.read<CheckoutModel>().mobileNumberCodeArea = "35";
      context.read<CheckoutModel>().neighbourhood = "Elcharco";
      context.read<CheckoutModel>().phoneNumber = "980893066";
      context.read<CheckoutModel>().phoneNumberCodeArea = "35";
      context.read<CheckoutModel>().state = "Minas Gerais";
      context.read<CheckoutModel>().street = "Rua Dogeral Bertioga";
      context.read<CheckoutModel>().validityMonth = 12;
      context.read<CheckoutModel>().validityYear = 28;
    }

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Checkout()));
    // DocumentSnapshot<Object?> order =
    //     await context.read<BookingService>().createOrder(
    //           customerName: context.read<AppUser>().fullName ?? "",
    //           customerEmail: FirebaseAuth.instance.currentUser!.email ?? "",
    //           bookingModel: context.read<BookingModel>(),
    //         );

    // //TODO Tratar erros
    // if (order.exists && order['paymentUrl'] != null) {
    //   if (!await launch(
    //     order['paymentUrl'],
    //     forceSafariVC: true,
    //     forceWebView: true,
    //     enableJavaScript: true,
    //   )) throw 'Could not launch';
    // }
  }
}

class _Overview extends StatelessWidget {
  const _Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Center(child: Text('Thank you for your order!')),
      ],
    );
  }
}
