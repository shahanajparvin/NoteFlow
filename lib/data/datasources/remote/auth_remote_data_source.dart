import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/models/sign_in_model.dart';
import 'package:noteflow/data/models/sign_up_model.dart';
import '../../../core/error/exceptions.dart';


abstract class AuthRemoteDataSource {
  Future<UserCredential> signUp(SignUpModel signUp);
  Future<UserCredential> signIn(SignInModel signIn);
  Future<void> verifyEmail();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserCredential> signIn(SignInModel signIn) async {
    try {
      FirebaseAuth firebaseInstance = FirebaseAuth.instance;
     await  firebaseInstance.currentUser?.reload();
     return  await firebaseInstance.signInWithEmailAndPassword(
        email: signIn.email,
        password: signIn.password,
      );
    }  on FirebaseAuthException catch (e) {
      print('error ' + e.code);
      if (e.code == 'invalid-credential') {
        throw InValidCredential();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }else if (e.code == 'invalid-email') {
        throw InValidEmail();
      }else{
        throw WrongPasswordException();
      }
    }
  }

  @override
  Future<UserCredential> signUp(SignUpModel signUp) async {
    try {
      FirebaseAuth firebaseInstance = FirebaseAuth.instance;
      await  firebaseInstance.currentUser?.reload();
      return await firebaseInstance.createUserWithEmailAndPassword(
        email: signUp.email,
        password: signUp.password,
      );
    } on FirebaseAuthException catch (e) {
      print('error ' + e.code);
      if (e.code == 'weak-password') {
        throw WeekPassException();
      } else if (e.code == 'email-already-in-use') {
        throw ExistedAccountException();
      }else if (e.code == 'invalid-email') {
        throw InValidEmail();
      }else{
        throw ServerException();
      }
    }
  }

  @override
  Future<void> verifyEmail() async {

    final user = FirebaseAuth.instance.currentUser;


    if(user != null){
      try{
        await user.reload();
        await user.sendEmailVerification();
      }on FirebaseAuthException catch (e) {
        if (e.code == 'too-many-requests') {
          throw TooManyRequestsException();
        }else {
          throw ServerException();
        }
      }catch(e){
        throw ServerException();
      }
    }else{
      throw NoUserException();
    }
    return Future.value();
  }



}
