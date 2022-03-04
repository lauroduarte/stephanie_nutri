import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/booking_model.dart';
import '../models/booking_stepper_model.dart';
import '../models/time_slot.dart';

class BookingStepper extends StatelessWidget {
  int _currentStep = 0;

  BookingStepper({Key? key}) : super(key: key);

  _steps () => [
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
        onStepContinue: (){
          if(context.read<BookingStepperModel>().currentStep < _steps().length - 1){
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

  List<String> _availableSlots = [];

  @override
  Widget build(BuildContext context) {

    List<TimeSlot> availableDays = context.watch<List<TimeSlot>>();
    var aTime = availableDays
        .where((e1) => isSameDay(e1.date, context.read<BookingModel>().selectedDate ))
        .map((e2) => e2.asString)
        .toList();
    aTime.sort();
    _availableSlots = aTime;

    return SizedBox(
      height: MediaQuery.of(context).size.height/1.6,
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
            availableCalendarFormats: {CalendarFormat.week : ''},
            onPageChanged: (focusedDay) {
              context.read<BookingModel>().focusedDate = focusedDay;
            },
            eventLoader: (day) {
              var available = availableDays
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
                  _availableSlots.length > 0 ? Text('Selecione um dos horários disponíveis') : Text('Tente outra data'),
                  GroupButton(
                    isRadio: true,
                    buttons: _availableSlots,
                    onSelected: (int index, bool isSelected) {
                      if (isSelected) {
                        context.read<BookingModel>().selectedTimeSlot = _availableSlots[index];
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
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Card number',
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Expiry date',
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'CVV',
          ),
        ),
      ],
    );
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
