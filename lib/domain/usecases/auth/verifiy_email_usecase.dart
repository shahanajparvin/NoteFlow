
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import '../../repository/authentication_repository.dart';

@Injectable()
class VerifyEmailUseCase {
  final AuthenticationRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Response<void>> call() async {
    return await repository.verifyEmail();
  }
}
