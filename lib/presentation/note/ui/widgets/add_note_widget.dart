import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/constant/pref_keys.dart';
import 'package:noteflow/core/utils/core_utils.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/presentation/common/widgets/app_close_icon.dart';
import 'package:noteflow/presentation/note/bloc/note_bloc.dart';
import 'package:noteflow/presentation/note/bloc/note_event.dart';
import 'package:noteflow/presentation/note/ui/widgets/add_note_button_section.dart';
import 'package:noteflow/presentation/note/ui/widgets/text_input_field.dart';



class AddNoteWidget extends StatefulWidget {
  final ModalController modalController;
  final NoteBloc noteBloc;
  final Note? task;
  final BuildContext? buildContext;

  const AddNoteWidget({super.key, required this.modalController, required this.noteBloc,  this.task,this.buildContext});

  @override
  State<AddNoteWidget> createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends State<AddNoteWidget> {

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();



  final _titleKey = GlobalKey<FormFieldState<String>>();

  final _formKey = GlobalKey<FormState>();

  final _descriptionKey = GlobalKey<FormFieldState<String>>();



  @override
  void initState() {
    super.initState();

    if(widget.task!=null){
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
    }
  }

  String localizeCategory(BuildContext context, String category){
    if(category==AppKey.working){
      return context.text.working;
    }else if(category==AppKey.general){
      return context.text.general;
    }else if(category==AppKey.learning){
      return context.text.learning;
    }
    return category;
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom, // Adjust padding for keyboard
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Padding(
               padding: EdgeInsets.symmetric(
                  horizontal: AppWidth.s30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment : CrossAxisAlignment.start,
                // This will force the Column to take up all available vertical space
                children: [
                  Gap(AppHeight.s25),
                  AppCloseIcon(modalController: widget.modalController),
                  Gap(AppHeight.s20),
                  TextInputField(
                    maxLength: 50,
                    textFieldKey: _titleKey,
                    label: context.text.title_task,
                    inputController: _titleController,
                    hintText: context.text.title_hint,
                    errorText: context.text.title_error,
                  ),
                  Gap(AppHeight.s20),
                  TextInputField(
                    maxLength: 150,
                    textFieldKey: _descriptionKey,
                    label: context.text.description,
                    inputController: _descriptionController,
                    hintText:context.text.description,
                    maxLine: 4,
                  ),
                  Gap(AppHeight.s20),

                  Gap(AppHeight.s20),

                  AddTaskButtonSection(
                    buttonLabel: widget.task!=null?context.text.update:context.text.create,
                    onCancelCallback: (){
                      widget.modalController.closeModal(context);
                    },
                    onCreateCallBack: (){
                      if(_formKey.currentState!.validate()){
                        final userCredential = FirebaseAuth.instance.currentUser;
                        DateTime now = DateTime.now();
                        Timestamp timestamp = Timestamp.fromDate(now);
                        if(widget.task!=null){
                          final task = Note(
                              userId: userCredential!.uid,
                              id: widget.task!.id,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              createdAt: timestamp,
                              updatedAt: timestamp,
                            );
                          _updateTask(task);
                        }else{
                          final task = Note(
                            userId: userCredential!.uid,
                            title: _titleController.text,
                            description: _descriptionController.text,
                            createdAt: timestamp,
                            updatedAt: timestamp,
                          );
                          _addTask(task);
                        }
                      }

                    },
                  ),
                  Gap(AppHeight.s30),
                ],
              ),
            )),
          )),
    );
  }
  _addTask(Note newTask){
    widget.noteBloc.add(AddNote(newTask));
    widget.modalController.closeModal(context);
  }
  _updateTask(Note task){
    widget.noteBloc.add(
        UpdateNote(
            task.id!, task));
    widget.modalController.closeModal(context);
  }




}
