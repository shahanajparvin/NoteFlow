import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:noteflow/core/constant/app_text.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/domain/usecases/note/add_note_usecase.dart';
import 'package:noteflow/domain/usecases/note/delete_note_usecase.dart';
import 'package:noteflow/domain/usecases/note/get_notes_usecase.dart';
import 'package:noteflow/domain/usecases/note/update_note_usecase.dart';

import 'note_event.dart';
import 'note_state.dart';

@Injectable()
class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNotesUseCase getNotesUseCase;
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;


  NoteBloc(this.getNotesUseCase, this.addNoteUseCase, this.updateNoteUseCase,
      this.deleteNoteUseCase) : super(NoteInitial()) {
    on<FetchNotes>(_onFetchNotes);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }


  Future<void> _onFetchNotes(FetchNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      Response<List<Note>> response = await getNotesUseCase.execute();
      if (response is SuccessResponse<List<Note>>) {
        List<Note> NoteList = response
            .data; // `.data` should be accessible here
        emit(NoteLoaded(notes: NoteList));
      } else {
        emit(NoteLoaded(notes: []));
      }
    } catch (e) {

    }
  }



  Future<void> _onAddNote(AddNote event, Emitter<NoteState> emit) async {
    print('add Note'.toString());
    try {
      List<Note> updatedNoteList = [];
      if (state is NoteLoaded) {
        updatedNoteList = List.from((state as NoteLoaded).notes);
      }
      emit(NoteLoading());
      addNoteUseCase.setParam(event.note);
      Response<Note> response = await addNoteUseCase.execute();
      if (response is SuccessResponse<Note>) {
        Note newNote = response.data;
        if (updatedNoteList.isNotEmpty) {
          updatedNoteList.insert(0,newNote); // Add the new Note to the list
          emit(NoteLoaded(notes: updatedNoteList,
              message: AppConst.addSuccess
          ));
        } else {
          updatedNoteList.add(newNote); // Add the new Note to the list
          emit(NoteLoaded(
            notes: updatedNoteList,
            message: AppConst.addSuccess
          ));
        }
      } else {
        _triggerMessage(AppConst.addFail,emit);
        emit(NoteLoaded(notes: updatedNoteList,
            message:''
        ));
      }
    } catch (e) {
      print(e.toString());
      _triggerMessage(e.toString(),emit);
    }
  }


  _triggerMessage(message,Emitter<NoteState> emit){
    if(state is NoteLoaded){
      emit((state as NoteLoaded).copyWith(
        message: message,
      ));
    }else{
      emit(NoteError(message));
    }
  }




  Future<void> _onUpdateNote(UpdateNote event, Emitter<NoteState> emit) async {
    try {
      List<Note> updatedNoteList = [];
      if (state is NoteLoaded) {
        updatedNoteList = List.from((state as NoteLoaded).notes);
      }
      emit(NoteLoading());
      updateNoteUseCase.setParam({'id': event.noteId, 'note': event.note});
      Response<Note> response = await updateNoteUseCase.execute();
      if (response is SuccessResponse<Note>) {
        Note updatedNote = response.data;
        if (updatedNoteList.isNotEmpty) {
          final index = updatedNoteList.indexWhere((Note) =>
          Note.id == event.noteId);
          if (index != -1) {
            updatedNoteList[index] =
                updatedNote; // Replace the old Note with the updated Note
          }
          emit(NoteLoaded(
              notes: updatedNoteList, message: AppConst.updateSuccess));
        }
      } else {
        _triggerMessage(AppConst.updateFail,emit);
      }
    } catch (e) {
      _triggerMessage(AppConst.updateFail,emit);
    }
  }


  Future<void> _onDeleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    try {
      List<Note> updatedNoteList = [];
      if (state is NoteLoaded) {
        updatedNoteList = List.from((state as NoteLoaded).notes);
      }
      emit(NoteLoading());
      deleteNoteUseCase.setParam(event.noteId);
      Response<String> response = await deleteNoteUseCase.execute();
      if (response is SuccessResponse<String>) {
        final deletedNoteId = response.data;
        if (updatedNoteList.isNotEmpty) {
          updatedNoteList.removeWhere((Note) =>
          Note.id == deletedNoteId);
          emit(NoteLoaded(notes: updatedNoteList,message: AppConst.deleteSuccess));
        }
      } else {
        _triggerMessage(AppConst.deleteFail,emit);
      }
    } catch (e) {
      _triggerMessage(AppConst.deleteFail,emit);
    }
  }



  Future<void> NoteLoadedInList(List<Note> NoteList) async {
    emit(NoteLoaded(notes: NoteList));
  }


}
