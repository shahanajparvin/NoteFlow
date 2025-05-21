import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import '../../repository/authentication_repository.dart';

@Injectable()
class LogOutUseCase {
  final AuthenticationRepository repository;

  LogOutUseCase(this.repository);

  Future<Response<void>> call() async {
    return await repository.logOut();
  }
}
