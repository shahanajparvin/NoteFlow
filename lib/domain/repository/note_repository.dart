import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/note/note.dart';

abstract class NoteRepository {
  Future<Response<List<Note>>> getNotes();
  Future<Response<Note>> addNote(Note task);
  Future<Response<Note>> updateNote(Map<String, dynamic> map);
  Future<Response<String>> deleteNote(String id);
}
