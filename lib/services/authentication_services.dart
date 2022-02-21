import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stephanie_nutri/services/users_services.dart';

import '../models/app_user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService = UserService();

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return 'Signed Out';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      //TODO: Verificar se usuário existe no banco de dados e salvar caso ainda não exista
      AppUser? appUser;
      if(userCredential != null && userCredential.user != null) {
        appUser = await _userService.getUserByUid(userCredential.user!.uid);

        if (appUser == null){
          _userService.saveUser(
              email: userCredential.user!.email,
              uid: userCredential.user!.uid,
              displayName: userCredential.user!.displayName,
              fullName: userCredential.user!.displayName,
              emailVerified: userCredential.user!.emailVerified,
              phoneNumber:userCredential.user!.phoneNumber,
              photoURL: userCredential.user!.photoURL
          );
        }
      }



      return 'Signed Up Wiht Google';
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      return 'Signed In With Facebook';
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return 'Password Reset E-mail sent';
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
