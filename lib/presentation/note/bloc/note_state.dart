import 'package:equatable/equatable.dart';
import 'package:noteflow/domain/entities/note/note.dart';


abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object?> get props => [];
}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<Note> notes;
  final String? message;  // Make nullable
  final bool isError;

  const NoteLoaded({
    this.notes = const [],  // Default value
    this.message,          // Optional
    this.isError = false   // Default value
  });

  // Implement copyWith
  NoteLoaded copyWith({
    List<Note>? Notes,
    String? message,
    bool? isError,
  }) {
    return NoteLoaded(
      notes: Notes ?? this.notes,
      message: message ?? this.message,
      isError: isError ?? this.isError,
    );
  }

  @override
  List<Object?> get props => [notes, message, isError];  // Include all properties
}

class NoteError extends NoteState {
  final String message;

  const NoteError(this.message);

  @override
  List<Object?> get props => [message];
}
