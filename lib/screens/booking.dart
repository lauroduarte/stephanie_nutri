import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stephanie_nutri/models/time_slot.dart';
import 'package:table_calendar/table_calendar.dart';

class Booking extends StatefulWidget {
  const Booking({Key? key}) : super(key: key);

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  List<String> _availableSlots = [];

  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    _selectedDay = DateTime.now();
    _focusedDay = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TimeSlot> availableDays = context.watch<List<TimeSlot>>();
    var aTime = availableDays
        .where((e1) => isSameDay(e1.date, _selectedDay))
        .map((e2) => e2.asString)
        .toList();
    aTime.sort();
    _availableSlots = aTime;

    return Scaffold(
      appBar: AppBar(
        title: Text('Escolha uma data'),
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'pt_BR',
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay ?? DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) async {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
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
                shrinkWrap: true,
                children: [
                  Text('Selecione um dos horários disponíveis'),
                  ..._availableSlots.map((e) {
                    return ElevatedButton(
                      child: Text(e),
                      onPressed: () {},
                );
              }),
            ],
          )),
        ],
      ),
    );
  }
}
