
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteflow/domain/entities/note/note.dart';


List<Note> transformToNote(QuerySnapshot snapshot) {
  final tasks = snapshot.docs.map((doc) => Note.fromDocument(doc)).toList();
  return tasks;
}


