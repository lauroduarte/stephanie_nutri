import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService{
  final CollectionReference _availableTimeSlots = FirebaseFirestore.instance.collection('available_time_slots');

  Future<List<List<int>>> getAvailableTimeSlots(DateTime day) async {
    List<List<int>> availableTimeSlots = [];
    QuerySnapshot qSnap = await _availableTimeSlots
        .where('date', isGreaterThanOrEqualTo: DateTime(day.year, day.month, day.day))
        .where('date', isLessThan: DateTime(day.year, day.month, day.day + 1))
        .where('booked', isEqualTo: false)
        .get();
    for (var element in qSnap.docs) {
      availableTimeSlots.add([element['hour'], element['minute']]);
    }

    print(availableTimeSlots);
    return availableTimeSlots;
  }

  Stream<QuerySnapshot> get availableDays {
    DateTime day = DateTime.now();
    return _availableTimeSlots
        .where('date', isGreaterThanOrEqualTo: DateTime(day.year, day.month, day.day))
        .where('booked', isEqualTo: false)
        .snapshots();
  }

}