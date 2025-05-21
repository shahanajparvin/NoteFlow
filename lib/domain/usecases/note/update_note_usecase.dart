
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/domain/usecases/note/note_usecase.dart';



@Injectable()
class UpdateNoteUseCase
    extends NoteUseCase<Map<String, dynamic>, Response<Note>> {
  UpdateNoteUseCase({required super.repository});

  @override
  Future<Response<Note>> execute() async {
    return repository.updateNote(getParam()!);
  }
}