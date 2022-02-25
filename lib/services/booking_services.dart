import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stephanie_nutri/models/time_slot.dart';

class BookingService{
  final CollectionReference _availableTimeSlots = FirebaseFirestore.instance.collection('available_time_slots');


  Stream<List<TimeSlot>> get availableTimeSlots {
    DateTime day = DateTime.now();
    return _availableTimeSlots
        .where('date', isGreaterThanOrEqualTo: DateTime(day.year, day.month, day.day))
        .where('booked', isEqualTo: false)
        .snapshots().map(
            (e) => e.docs.map((doc) => TimeSlot.fromDocument(doc)).toList());
  }

}