import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stephanie_nutri/exceptions/app_exception.dart';
import 'package:stephanie_nutri/models/booking_model.dart';
import 'package:stephanie_nutri/models/time_slot.dart';
import 'package:http/http.dart';

class BookingService {
  final CollectionReference _availableTimeSlots =
      FirebaseFirestore.instance.collection('available_time_slots');

  final String baseURL =
      "http://192.168.0.113:5001/stephanie-nutri/us-central1/app/";

  Stream<List<TimeSlot>> get availableTimeSlots {
    DateTime day = DateTime.now();
    return _availableTimeSlots
        .where('date',
            isGreaterThanOrEqualTo: DateTime(day.year, day.month, day.day))
        .where('status', isEqualTo: TimeSlot.available)
        .snapshots()
        .map((e) => e.docs.map((doc) => TimeSlot.fromDocument(doc)).toList());
  }

  Future<DocumentSnapshot<Object?>> createOrder({
    required String customerName,
    required String customerEmail,
    required BookingModel bookingModel,
  }) async {

    //1. Make selected timeslot unavailable to other users

    // TODO: Refactor bookingModel to save userid and make timeslot available for current user
    //await updateTimeSlotAvailability(bookingModel, true);


    //2. Create order in pagarme
    
    const String endpoint = "processPayment";
    Response res = await post(Uri.parse(baseURL + endpoint), body: {
      "customerName": customerName,
      "customerEmail": customerEmail,
      "itemDescription": bookingModel.getBookingDescription(),
    });
    if (res.statusCode != 200) {
      throw AppException(
          message: "Erro ao processar o pagamento, volte e tente novamente");
    }
    var pagarmeResult = json.decode(res.body);

    //3. Create order in firebase for that user
    DocumentReference docRef = await FirebaseFirestore.instance
    .collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('appointments').add(
      {
        "paymentStatus" : "pending",
        "paymentIdPagarme" : pagarmeResult["id"],
        "amount" : pagarmeResult["amount"],
        "paymentUrl" : pagarmeResult["checkouts"][0]["payment_url"],
        "appointmentDate" : bookingModel.selectedDate,
        "appointmentHour" : bookingModel.hour,
        "appointmentMinute" : bookingModel.minute,
      }
    );
    return await docRef.get();    
  }

  Future<void> updateTimeSlotAvailability(BookingModel bookingModel, bool available) async {
    var timeSlotsToUpdate = await _availableTimeSlots.where('date', isGreaterThanOrEqualTo:  DateTime(bookingModel.selectedDate.year, bookingModel.selectedDate.month, bookingModel.selectedDate.day))
    .where('date', isLessThan: DateTime(bookingModel.selectedDate.year, bookingModel.selectedDate.month, bookingModel.selectedDate.day + 1))
    .where('hour', isEqualTo: bookingModel.hour)
    .where('minute', isEqualTo: bookingModel.minute).get();
    
    timeSlotsToUpdate.docs.forEach((document) {
      document.reference.update({"status": TimeSlot.available});
    });
  }

  Future<void> cancelOrder({
    required String customerName,
    required String customerEmail,
    required BookingModel bookingModel,
  })async {
    //1. Verify if exists open order in pagarme and cancel it
    
    //2. Make timeslot avaible for other users
    await updateTimeSlotAvailability(bookingModel, false);

    //3. Set status of appointment in firebase
  }  
}
