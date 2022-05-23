import 'package:cloud_firestore/cloud_firestore.dart';
class AppUser {
  String? displayName;
  String? fullName;
  String? email;
  bool? emailVerified;
  String? phoneNumber;
  String? photoURL;
  String? uid;
  String? cpf;
  String? birthDate;
  String? gender;

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

  void updateFromDocument(DocumentSnapshot document) {
    displayName = document['displayName'];
    fullName = document['fullName'];
    email = document['email'];
    emailVerified = document['emailVerified'];
    phoneNumber = document['phoneNumber'];
    uid = document['uid'];
    cpf = document['cpf'];
    birthDate = document['birthDate'];
    gender = document['gender'];    
  }

  void copy(AppUser? appUserToCopy) {
    if(appUserToCopy != null){
      displayName = appUserToCopy.displayName;
      fullName = appUserToCopy.fullName;
      email = appUserToCopy.email;
      emailVerified = appUserToCopy.emailVerified;
      phoneNumber = appUserToCopy.phoneNumber;
      uid = appUserToCopy.uid;
      cpf = appUserToCopy.cpf;
      birthDate = appUserToCopy.birthDate;
      gender = appUserToCopy.gender;    
    }
  }  
}
