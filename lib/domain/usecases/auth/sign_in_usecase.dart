
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/auth/sign_in_entity.dart';
import '../../repository/authentication_repository.dart';


@Injectable()
class SignInUseCase {
  final AuthenticationRepository repository;

  SignInUseCase(this.repository);

  Future<Response<UserCredential>> call(SignInEntity signIn) async {
    return await repository.signIn(signIn);
  }
}
