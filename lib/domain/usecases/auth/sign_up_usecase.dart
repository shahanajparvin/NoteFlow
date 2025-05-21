import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/auth/sign_up_entity.dart';
import 'package:noteflow/domain/repository/authentication_repository.dart';


@Injectable()
class SignUpUseCase {
  final AuthenticationRepository repository;

  SignUpUseCase(this.repository);

  Future<Response<UserCredential>> call(SignUpEntity signup) async {
    return await repository.signUp(signup);
  }
}
