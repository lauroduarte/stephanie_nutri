import 'package:flutter/material.dart';

class BookingModel with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  String? _selectedTimeSlot;

  String? get selectedTimeSlot => _selectedTimeSlot;

  set selectedTimeSlot(String? value) {
    _selectedTimeSlot = value;
    notifyListeners();
  }

  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  DateTime _focusedDate = DateTime.now();

  DateTime get focusedDate => _focusedDate;

  set focusedDate(DateTime value) {
    _focusedDate = value;
    notifyListeners();
  }
}