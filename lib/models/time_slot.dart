import 'package:cloud_firestore/cloud_firestore.dart';

class TimeSlot{
  String? uid;
  bool? booked;
  DateTime? date;
  int? hour;
  int? minute;

  String get asString {
    return this.hour.toString().padLeft(2, '0') +
        ':' +
        this.minute.toString().padLeft(2, '0');
  }

  TimeSlot({this.uid, this.booked, this.date, this.hour, this.minute});

  factory TimeSlot.fromDocument(DocumentSnapshot document){
    return TimeSlot(
      uid: document.id,
      booked: document['booked'],
      date: DateTime.parse(document['date'].toDate().toString()),
      hour: document['hour'],
      minute: document['minute']
    );
  }


}