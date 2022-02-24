import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stephanie_nutri/models/app_user.dart';



class UserService {

  final CollectionReference _users =
  FirebaseFirestore.instance.collection('users');


  Future<String?> saveUser(
      {displayName,
        fullName,
      required email,
      emailVerified,
      phoneNumber,
      photoURL,
      required uid,
      cpf,
      birthDate,
      gender}) async {
    Map<String, dynamic> data = <String, dynamic>{
      'displayName': displayName,
      'fullName' : fullName,
      'email': email,
      'emailVerified': emailVerified,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'uid': uid,
      'cpf': cpf,
      'birthDate': birthDate,
      'gender': gender,
    };

    DocumentReference userRef = _users.doc(uid);

    await userRef.set(data);

    return 'User saved';
  }

  Future<AppUser?> getUserByUid(String uid) async {
    DocumentReference userRef = _users.doc(uid);
    DocumentSnapshot userSnap = await userRef.get();
    if (userSnap.exists) {
      return AppUser.fromDocument(userSnap);
    } else {
      return null;
    }
  }
}
