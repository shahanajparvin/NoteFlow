import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/datasources/transformer/remote_to_domain_transformer.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/domain/repository/note_repository.dart';

import '../../domain/entities/note/note.dart';

@LazySingleton(as: NoteRepository)
class RemoteDataSourceImpl extends NoteRepository {
  final FirebaseFirestore fireStore;

  RemoteDataSourceImpl(this.fireStore);

  @override
  Future<Response<List<Note>>> getNotes() async {
    try {
      final QuerySnapshot snapshot = await fireStore.collection('notes').get();
      if (snapshot.docs.isNotEmpty) {
        return SuccessResponse<List<Note>>(data: transformToNote(snapshot));
      } else {
        return ErrorResponse<List<Note>>(errorMessage: 'No Notes found');
      }
    } catch (e) {
      if (e is FirebaseException) {
        return ErrorResponse<List<Note>>(
          errorMessage: e.message ?? 'An error occurred while fetching Notes',
          exception: e,
        );
      } else {
        return ErrorResponse<List<Note>>(
          errorMessage: 'An unexpected error occurred',
          exception: e as Exception,
        );
      }
    }
  }

  @override
  Future<Response<Note>> addNote(Note note) async {
    try {
      DocumentReference docRef = await fireStore.collection('notes').add(note.toMap());
      // Get the ID of the newly added document
      String newNoteId = docRef.id;
      final updatedNote = note.copyWith(id: newNoteId);
      return SuccessResponse<Note>(data: updatedNote);
    } catch (e) {
      return ErrorResponse<Note>(errorMessage: 'No Notes found');
    }
  }

  @override
  Future<Response<Note>> updateNote(Map<String, dynamic> map) async {
    try {
      Note note = map['note'];
      String id = map['id'];
      DocumentReference docRef = fireStore.collection('notes').doc(id);
      await docRef.update(note.toMap());
      String newNoteId = docRef.id;
      final updatedNote = note.copyWith(id: newNoteId);
      return SuccessResponse<Note>(data: updatedNote);
    } catch (e) {
      return ErrorResponse<Note>(errorMessage: 'No Notes found');
    }
  }



  @override
  Future<Response<String>> deleteNote(String documentId) async {
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('notes').doc(documentId);
      await docRef.delete();
      return SuccessResponse<String>(data: documentId);
    } catch (e) {
      return ErrorResponse<String>(errorMessage: 'Error deleting Note');
    }
  }





}
