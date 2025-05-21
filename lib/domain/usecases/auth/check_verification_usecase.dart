import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import '../../repository/authentication_repository.dart';

@Injectable()
class CheckVerificationUseCase {
  final AuthenticationRepository repository;
  CheckVerificationUseCase(this.repository);

  Future<Response<void>> call(Completer completer){
    return  repository.checkEmailVerification(completer);
  }
}
