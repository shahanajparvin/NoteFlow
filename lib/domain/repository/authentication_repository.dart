import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/auth/sign_in_entity.dart';
import 'package:noteflow/domain/entities/auth/sign_up_entity.dart';
import '../entities/auth/first_page_entity.dart';


abstract class AuthenticationRepository {
  Future<Response<UserCredential>> signIn(SignInEntity signIn);
  Future<Response<UserCredential>> signUp(SignUpEntity signUp);
  Response<FirstPageEntity> firstPage(); // unchanged if not wrapped
  Future<Response<void>> verifyEmail();
  Future<Response<void>> checkEmailVerification(Completer completer);
  Future<Response<void>> logOut();



}
