

import 'package:noteflow/domain/entities/auth/sign_in_entity.dart';

class SignInModel extends SignInEntity {
  const SignInModel({required String email,required String password})
      : super(  email: email, password: password);
}
