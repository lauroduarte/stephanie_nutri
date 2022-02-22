import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String? displayName;
  final String? fullName;
  final String? email;
  final bool? emailVerified;
  final String? phoneNumber;
  final String? photoURL;
  final String? uid;
  final String? cpf;
  final String? birthDate;
  final String? gender;

  AppUser(
      {this.displayName,
      this.fullName,
      this.email,
      this.emailVerified,
      this.phoneNumber,
      this.photoURL,
      this.uid,
      this.cpf,
      this.birthDate,
      this.gender});

  factory AppUser.fromDocument(DocumentSnapshot document) {
    return AppUser(
        displayName: document['displayName'],
        fullName: document['fullName'],
        email: document['email'],
        emailVerified: document['emailVerified'],
        phoneNumber: document['phoneNumber'],
        uid: document['uid'],
        cpf: document['cpf'],
        birthDate: document['birthDate'],
        gender: document['gender']);
  }
}
