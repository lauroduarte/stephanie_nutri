import 'package:firebase_auth/firebase_auth.dart';

class AppException implements Exception {
  String? message;
  String? errorCode;

  AppException({required this.message, this.errorCode});

  AppException.fromFirebaseAuth(FirebaseAuthException firebaseAuthException){
    errorCode = firebaseAuthException.code;

    if(errorCode == 'auth/invalid-email'){
      message = 'O e-mail informado é inválido';
    } else if (errorCode == 'auth/user-disabled'){
      message = 'Usuário bloqueado';
    } else if (errorCode == 'auth/user-not-found' || errorCode == 'auth/wrong-password') {
      message = 'Usuário inexistente';
    } else if (errorCode == 'email-already-in-use'){
      message = 'E-mail já registrado';
    } else {
      message = 'Erro ao tentar autenticar o usuário';
    }

  }

  AppException.fromFirebase(FirebaseException firebaseException){
    errorCode = firebaseException.code;

    if(errorCode == 'not-found'){
      message = 'Registro não encontrado';
    } else if (errorCode == 'already-exists'){
      message = 'Registro já cadastrado';
    } else if (errorCode == 'permission-denied') {
      message = 'Acesso negado';
    } else {
      message = 'Erro ao acessar os dados do servidor';
    }
  }

}
