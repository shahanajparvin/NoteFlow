
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/usecases/note/note_usecase.dart';



@Injectable()
class DeleteNoteUseCase
    extends NoteUseCase<String, Response<String>> {
  DeleteNoteUseCase({required super.repository});

  @override
  Future<Response<String>> execute() async {
    return repository.deleteNote(getParam()!);
  }
}