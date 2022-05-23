import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stephanie_nutri/exceptions/app_exception.dart';
import 'package:stephanie_nutri/services/users_services.dart';

import '../models/app_user.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService = UserService();

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<AppUser?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return await _userService.getUserByUid(userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } on FirebaseException catch (e){
      throw AppException.fromFirebase(e);
    } //TODO tratar exceções no geral
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } on FirebaseException catch (e){
      throw AppException.fromFirebase(e);
    } //TODO tratar exceções no geral
  }


//TODO: displayName não está sendo gravado 
  Future<AppUser?> signUp(
      {required String email, required String password,
        String? displayName,
        String? fullName,
        String? phoneNumber,
        String? photoURL,
        String? cpf,
        String? birthDate,
        String? gender}) async {
    try {
      UserCredential _userCredential =  await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      await _userService.saveUser(email: email,
          uid: _userCredential.user!.uid,
        displayName: displayName,
        fullName: fullName,
        emailVerified: _userCredential.user!.emailVerified,
        phoneNumber: phoneNumber,
        photoURL: photoURL,
        cpf: cpf,
        birthDate: birthDate,
        gender: gender
      );

      return AppUser(
            email: _userCredential.user!.email,
            uid: _userCredential.user!.uid,
            displayName: _userCredential.user!.displayName,
            fullName: _userCredential.user!.displayName,
            emailVerified: _userCredential.user!.emailVerified,
            phoneNumber: _userCredential.user!.phoneNumber,
            photoURL: _userCredential.user!.photoURL,
          );

    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } on FirebaseException catch (e){
      throw AppException.fromFirebase(e);
    } //TODO tratar exceções no geral
  }

  Future<AppUser?> signInWithGoogle() async {
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

      //Salva o usuário caso não exista na base
      return await saveUser(userCredential);

    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } on FirebaseException catch (e){
      throw AppException.fromFirebase(e);
    } //TODO tratar exceções no geral
  }

  Future<AppUser?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if(loginResult.status == LoginStatus.success) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);

        //Salva o usuário caso não exista na base
        return await saveUser(userCredential);
      } else if(loginResult.status == LoginStatus.failed){
        print('passou');
        throw AppException(message: 'Não foi possível realizar o login');
      }

    } on FirebaseAuthException catch (e) {
      //If Account exists with different credential send the correct message
      if(e.code == 'account-exists-with-different-credential'){
        List<String> signInMethods =  await _firebaseAuth.fetchSignInMethodsForEmail(e.email!);
        throw AppException(message: 'Você já possui uma conta, favor acessar usando ${signInMethods.join(', ')}');
      }
      throw AppException.fromFirebaseAuth(e);
    } on FirebaseException catch (e){
      throw AppException.fromFirebase(e);
    } //TODO tratar exceções no geral
  }


  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AppException.fromFirebaseAuth(e);
    } on FirebaseException catch (e){
      throw AppException.fromFirebase(e);
    } //TODO tratar exceções no geral
  }

  Future<AppUser?> saveUser(UserCredential userCredential) async {
    //Verifica se usuário existe no banco de dados e salvar caso ainda não exista
    AppUser? appUser;
    if (userCredential != null && userCredential.user != null) {
      appUser = await _userService.getUserByUid(userCredential.user!.uid);

      if (appUser == null) {
        _userService.saveUser(
            email: userCredential.user!.email,
            uid: userCredential.user!.uid,
            displayName: userCredential.user!.displayName,
            fullName: userCredential.user!.displayName,
            emailVerified: userCredential.user!.emailVerified,
            phoneNumber: userCredential.user!.phoneNumber,
            photoURL: userCredential.user!.photoURL,
          );
        return AppUser(
            email: userCredential.user!.email,
            uid: userCredential.user!.uid,
            displayName: userCredential.user!.displayName,
            fullName: userCredential.user!.displayName,
            emailVerified: userCredential.user!.emailVerified,
            phoneNumber: userCredential.user!.phoneNumber,
            photoURL: userCredential.user!.photoURL,
          );          
      }else{
        return appUser;
      }
    }
  }
}
