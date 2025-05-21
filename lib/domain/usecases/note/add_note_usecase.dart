
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/domain/usecases/note/note_usecase.dart';



@Injectable()
class AddNoteUseCase
    extends NoteUseCase<Note, Response<Note>> {
  AddNoteUseCase({required super.repository});

  @override
  Future<Response<Note>> execute() async {
    return repository.addNote(getParam()!);
  }
}