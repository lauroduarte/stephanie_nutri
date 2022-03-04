import 'package:flutter/cupertino.dart';

class BookingStepperModel with ChangeNotifier{
  int _currentStep = 0;

  int get currentStep => _currentStep;

  set currentStep(int value) {
    _currentStep = value;
    notifyListeners();
  }
}