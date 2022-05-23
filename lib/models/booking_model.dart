import 'package:flutter/material.dart';

import '../utils/utils.dart';

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

  int? get hour {
    
    if(_selectedTimeSlot !=null){
      List<String> splited = _selectedTimeSlot!.split(":");
      if(splited.length == 2){
        return int.parse(splited[0]);
      }
    }
    return null;
  } 

  int? get minute {
    
    if(_selectedTimeSlot !=null){
      List<String> splited = _selectedTimeSlot!.split(":");
      if(splited.length == 2){
        return int.parse(splited[1]);
      }
    }
    return null;
  }

  DateTime _focusedDate = DateTime.now();

  DateTime get focusedDate => _focusedDate;

  set focusedDate(DateTime value) {
    _focusedDate = value;
    notifyListeners();
  }

  String getBookingDescription(){
    if(_selectedTimeSlot !=null){
      return "Consulta agendada para " + Utils.formatDate(_selectedDate) + " " + _selectedTimeSlot!;
    }
    return "Favor selecionar uma data e horário para a consulta";
  }
}