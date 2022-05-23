import 'package:cloud_firestore/cloud_firestore.dart';

class TimeSlot{
  String? uid;
  DateTime? date;
  int? hour;
  int? minute;
  String? status;
  String? clientUid;

  static const available = 'available';
  static const reserved = 'reserved';
  static const confirmed = 'confirmed';
  static const unavailable = 'unavailable';

  String get asString {
    return hour.toString().padLeft(2, '0') +
        ':' +
        minute.toString().padLeft(2, '0');
  }

  TimeSlot({this.uid, this.clientUid, this.date, this.hour, this.minute, this.status});

  factory TimeSlot.fromDocument(DocumentSnapshot document){
    return TimeSlot(
      uid: document.id,
      clientUid: document['clientUid'],
      date: DateTime.parse(document['date'].toDate().toString()),
      hour: document['hour'],
      minute: document['minute'],
      status: document['status'],
    );
  }


}