import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentModel {
  String? id;
  int? amount;
  DateTime? appointmentDate;
  int? appointmentHour;
  int? appointmentMinute;
  String? paymentIdPagarme;
  String? paymentStatus;
  String? paymentUrl;


  AppointmentModel({  
    required String id,
    int? amount,
    DateTime? appointmentDate,
    int? appointmentHour,
    int? appointmentMinute,
    String? paymentIdPagarme,
    String? paymentStatus,
    String? paymentUrl,
  });

  factory AppointmentModel.fromDocument(DocumentSnapshot document){
    return AppointmentModel(
      id: document['id'],
      amount: document['amount'],
      appointmentDate: document['appointmentDate'], 
      appointmentHour: document['appointmentHour'],
      appointmentMinute: document['appointmentMinute'],
      paymentIdPagarme: document['paymentIdPagarme'],
      paymentStatus: document['paymentStatus'],
      paymentUrl: document['paymentUrl'],
    );
  }
}
