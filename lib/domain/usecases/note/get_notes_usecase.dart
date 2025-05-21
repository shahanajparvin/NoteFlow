
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/domain/usecases/note/note_usecase.dart' show NoteUseCase;



@Injectable()
class GetNotesUseCase
    extends NoteUseCase<String, Response<List<Note>>> {
  GetNotesUseCase({required super.repository});

  @override
  Future<Response<List<Note>>> execute() async {
    return repository.getNotes();
  }
}