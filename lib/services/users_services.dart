import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _users =
    FirebaseFirestore.instance.collection('users');

class UserService {

  Future<String?> saveUser (
      {displayName,
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

      await userRef
          .set(data)
          .whenComplete(() => print("Notes item added to the database"))
          .catchError((e) => print(e));
      return 'User saved';

  }
}
