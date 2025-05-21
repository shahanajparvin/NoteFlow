import 'package:equatable/equatable.dart';
import 'package:noteflow/domain/entities/note/note.dart';



abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotes extends NoteEvent {}

class AddNote extends NoteEvent {
  final Note note;

  const AddNote(this.note);

  @override
  List<Object?> get props => [note];
}

class UpdateNote extends NoteEvent {
  final String noteId;
  final Note note;

  const UpdateNote(this.noteId,this.note);

  @override
  List<Object?> get props => [Note];
}

class DeleteNote extends NoteEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object?> get props => [noteId];
}



