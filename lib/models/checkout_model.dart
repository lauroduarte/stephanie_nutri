import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckoutModel with ChangeNotifier {
  static const cardNetworks = [
    'Visa',
    'Mastercard',
    'Elo',
    'Hipercard',
    'Discover',
    'Diners',
    'JCB',
    'Cabal',
    'UnionPay'
  ];

  CheckoutModel() {
    loadStateAndCities();
  }

  //State and City
  final Map _statesAndCities = LinkedHashMap();

  Map get statesAndCities => _statesAndCities;

  // Fetch content from the json file
  Future<Map> loadStateAndCities() async {
    if (_statesAndCities.isEmpty) {
      final String response =
          await rootBundle.loadString('assets/estados_cidades.json');
      _statesAndCities.addAll(json.decode(response));
    }
    return _statesAndCities;
  }

  Iterable<String> getStates() {
    return (statesAndCities["estados"] as List)
        .map((e) => e["nome"].toString());
  }

  String? getStateISOByName(String stateName) {
    var estados = (statesAndCities["estados"] as List)
        .firstWhere((st) => st["nome"] == state, orElse: () {
      return null;
    });
    if (estados != null) {
      return estados["sigla"];
    } else {
      return null;
    }
  }

  Iterable<String> getCities(String state) {
    List<String> result = [];
    (statesAndCities["estados"] as List)
        .where((st) => st["nome"] == state)
        .toList()
        .forEach((element) {
      element["cidades"].forEach((cid) => result.add(cid));
    });
    return result;
  }

  //Stepper
  int _currentStep = 0;

  int get currentStep => _currentStep;

  set currentStep(int value) {
    _currentStep = value;
    //on step two creates an order on Pagar.me
    if (_currentStep == 2) {}
    notifyListeners();
  }

  //Item Data
  int _itemAmount = 0;
  int _itemQuantity = 1;
  String? _itemDescription;
  String? _itemCode;

  get itemCode => _itemCode;

  set itemCode(itemCode) {
    _itemCode = itemCode;
    notifyListeners();
  }

  get itemAmount => _itemAmount;

  set itemAmount(itemAmount) {
    _itemAmount = itemAmount;
    notifyListeners();
  }

  get itemQuantity => _itemQuantity;

  set itemQuantity(itemQuantity) {
    _itemQuantity = itemQuantity;
    notifyListeners();
  }

  get itemDescription => _itemDescription;

  set itemDescription(itemDescription) {
    _itemDescription = itemDescription;
    notifyListeners();
  }

  //Buyers Data
  String? _fullName;
  String? _email;
  String? _cpfCnpj;
  String? _phoneNumber;
  String? _phoneNumberCodeArea;
  String? _mobileNumber;
  String? _mobileNumberCodeArea;

  void updateBuyer(
      {required String fullName,
      required String email,
      required String cpfCNPJ,
      required String phoneNumber,
      required String mobileNumber}) {
    _fullName = fullName;
    _email = email;
    _cpfCnpj = cpfCNPJ;
    _phoneNumber = phoneNumber;
    _mobileNumber = mobileNumber;
    notifyListeners();
  }

  //Order Adress Data
  String? _cep;
  String? _street;
  String? _addressNumber;
  String? _neighbourhood;
  String? _city;
  String? _state;
  String? _complement;

  //Payment Data

  static const List<int> installmentsOptions = [1, 2, 3, 4, 5, 6];

  int? _installments;
  String? _cardNumber;
  String? _cardNetwork;
  String? _cardName;
  int? _validityMonth;
  int? _validityYear;
  String? _cvv;

  get fullName => _fullName;

  set fullName(fullName) {
    _fullName = fullName;
    notifyListeners();
  }

  get complement => _complement;

  set complement(complement) {
    _complement = complement;
    notifyListeners();
  }

  get email => _email;

  set email(email) {
    _email = email;
    notifyListeners();
  }

  get cpfCnpj => _cpfCnpj;

  set cpfCnpj(cpfCnpj) {
    _cpfCnpj = cpfCnpj;
    notifyListeners();
  }

  get phoneNumber => _phoneNumber;

  set phoneNumber(phoneNumber) {
    _phoneNumber = phoneNumber;
    notifyListeners();
  }

  get phoneNumberCodeArea => _phoneNumberCodeArea;

  set phoneNumberCodeArea(value) {
    _phoneNumberCodeArea = value;
    notifyListeners();
  }

  get mobileNumber => _mobileNumber;

  set mobileNumber(mobileNumber) {
    _mobileNumber = mobileNumber;
    notifyListeners();
  }

  get mobileNumberCodeArea => _mobileNumberCodeArea;

  set mobileNumberCodeArea(value) {
    _mobileNumberCodeArea = value;
    notifyListeners();
  }

  get cep => _cep;

  set cep(cep) {
    _cep = cep;
    notifyListeners();
  }

  get street => _street;

  set street(street) {
    _street = street;
    notifyListeners();
  }

  get addressNumber => _addressNumber;

  set addressNumber(adreesNumber) {
    _addressNumber = adreesNumber;
    notifyListeners();
  }

  get neighbourhood => _neighbourhood;

  set neighbourhood(neighbourhood) {
    _neighbourhood = neighbourhood;
    notifyListeners();
  }

  get city => _city;

  set city(city) {
    _city = city;
    notifyListeners();
  }

  get state => _state;

  set state(state) {
    _state = state;
    notifyListeners();
  }

  get installments => _installments;

  set installments(installments) {
    _installments = installments;
    notifyListeners();
  }

  get cardNumber => _cardNumber;

  set cardNumber(cardNumber) {
    _cardNumber = cardNumber;
    notifyListeners();
  }

  get cardNetwork => _cardNetwork;

  set cardNetwork(cardNetwork) {
    _cardNetwork = cardNetwork;
    notifyListeners();
  }

  get cardName => _cardName;

  set cardName(cardName) {
    _cardName = cardName;
    notifyListeners();
  }

  get validityMonth => _validityMonth;

  set validityMonth(validityMonth) {
    _validityMonth = validityMonth;
    notifyListeners();
  }

  get validityYear => _validityYear;

  set validityYear(validityYear) {
    _validityYear = validityYear;
    notifyListeners();
  }

  get cvv => _cvv;

  set cvv(cvv) {
    _cvv = cvv;
    notifyListeners();
  }
}
