import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';

import '../../entities/auth/first_page_entity.dart';
import '../../repository/authentication_repository.dart';

@Injectable()
class FirstPageUseCase {
  final AuthenticationRepository repository;

  FirstPageUseCase(this.repository);

  Response<FirstPageEntity> call(){
    return  repository.firstPage();
  }
}
