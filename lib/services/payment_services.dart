import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:stephanie_nutri/exceptions/app_exception.dart';
import 'package:stephanie_nutri/models/checkout_model.dart';

class PaymentService {
  final String baseURL =
      "http://192.168.0.113:5001/stephanie-nutri/us-central1/app/";

  Future<DocumentSnapshot<Object?>> createOrder({
    required CheckoutModel checkoutModel,
  }) async {
    // Create order
    const String endpoint = "processPayment";
    Response res = await post(Uri.parse(baseURL + endpoint), body: {
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "customerName": checkoutModel.fullName,
      "customerEmail": checkoutModel.email,
      "customerDocument": checkoutModel.cpfCnpj,
      "customerType": "individual",
      "homeAreaCode": checkoutModel.phoneNumberCodeArea,
      "homePhoneNumber": checkoutModel.phoneNumber,
      "mobileAreaCode": checkoutModel.mobileNumberCodeArea,
      "mobilePhoneNumber": checkoutModel.mobileNumber,
      "itemDescription": checkoutModel.itemDescription,
      "itemQuantity": checkoutModel.itemQuantity.toString(),
      "amount": checkoutModel.itemAmount.toString(),
      "itemCode": checkoutModel.itemCode,
      "installments": checkoutModel.installments.toString(),
      "statementDescriptor": "Stephanie Nutri",
      "cardNumber": checkoutModel.cardNumber,
      "cardHolderName": checkoutModel.cardName,
      "cardExpMonth": checkoutModel.validityMonth.toString(),
      "cardExpYear": checkoutModel.validityYear.toString(),
      "cardCvv": checkoutModel.cvv,
      "billingAddressLine1": checkoutModel.street,
      "billingAddressZipCode": checkoutModel.cep,
      "billingAddressCity": checkoutModel.city,
      "billingAddressState":
          checkoutModel.getStateISOByName(checkoutModel.state),
      "billingAddressCountry": "BR"
    });
    if (res.statusCode != 200) {
      throw AppException(
          message: "Erro ao processar o pagamento, volte e tente novamente");
    }
    var pagarmeResult = json.decode(res.body);

    // Get payment created
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('payments')
        .doc(pagarmeResult["id"]);
    return await docRef.get();
  }
}
