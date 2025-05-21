import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/constant/app_text.dart';

import 'package:noteflow/core/utils/app_alert_manager.dart';
import 'package:noteflow/core/utils/app_easy_loading.dart';
import 'package:noteflow/core/utils/core_utils.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/presentation/auth/bloc/authentication/auth_bloc.dart' show AuthBloc, LogOutEvent;
import 'package:noteflow/presentation/common/widgets/logout_icon.dart';


import 'package:noteflow/presentation/common/widgets/user_accout_view.dart';
import 'package:noteflow/presentation/note/bloc/note_bloc.dart';
import 'package:noteflow/presentation/note/bloc/note_event.dart';
import 'package:noteflow/presentation/note/bloc/note_state.dart';
import 'package:noteflow/presentation/note/ui/widgets/add_note_widget.dart';
import 'package:noteflow/presentation/note/ui/widgets/delete_confirmation_widget.dart';
import 'package:noteflow/presentation/note/ui/widgets/header_section.dart';
import 'package:noteflow/presentation/note/ui/widgets/localization_icon.dart';
import 'package:noteflow/presentation/note/ui/widgets/no_note_widget.dart';
import 'package:noteflow/presentation/note/ui/widgets/note_list.dart';
import 'package:noteflow/presentation/note/ui/widgets/note_shimmer_list.dart';

class NoteListPage extends StatefulWidget {
  final NoteBloc noteBloc;

  const NoteListPage({super.key, required this.noteBloc});

  @override
  State<NoteListPage> createState() => _NoteListState();
}

class _NoteListState extends State<NoteListPage> {
  late ModalController modalController;
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    widget.noteBloc.add(FetchNotes());
    modalController = ModalController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF3F3F3),
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: AppHeight.s80,
          title: UserAccountView(),
          actions: [
            TranslateIcon(
              modalController: modalController,
            ),
            LogoutIcon( modalController: modalController,),

            Gap(15)

          ],
        ),
        body: Column(
          children: [
            HeaderSection(
              modalController: modalController,
              noteBloc: widget.noteBloc,
            ),
            Flexible(
                child: BlocListener<NoteBloc, NoteState>(
                    listener: (context, state) {
                      if (state is NoteLoading) {
                        showLoadingIndicator(); // Show loading indicator
                      }
                      else if (state is NoteLoaded) {
                        dismissLoadingIndicator();
                        if (state.message != null) {
                          dismissWithMessage(message: state.message!, isError: state.isError);
                        }
                      }else{
                        dismissLoadingIndicator();
                        if(state is NoteError)
                        dismissWithMessage(message: state.message);
                      }
                    },
                    child: BlocBuilder<NoteBloc, NoteState>(
                      builder: (context, state) {
                        if (state is NoteLoading) {
                          return const ShimmerNoteList();
                        } else if (state is NoteLoaded &&
                            state.notes.isNotEmpty) {
                          final sortedNotes = List<Note>.from(state.notes)
                            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
                          return NoteList(
                              notes: sortedNotes,
                              modalController: modalController,
                              noteBloc: widget.noteBloc,);
                        }
                        return NoResultsScreen(onPressCallBack: () {
                          modalController.showModal(
                            context,
                            AddNoteWidget(
                                modalController: modalController,
                                noteBloc: widget.noteBloc),
                          );
                        });
                      }
                    )))
          ]
        ));
  }

  dismissWithMessage({required String message, bool isError = true}) {
    dismissLoadingIndicator();
    showAlert(
        message: _messageTranslated(message),
        isError: isError
    );
  }

  String _messageTranslated(String message) {
    switch (message) {
      case AppConst.addSuccess:
        return context.text.success_add;
      case AppConst.addFail:
        return context.text.fail_add;

      case AppConst.updateSuccess:
        return context.text.success_update;
      case AppConst.updateFail:
        return context.text.fail_update;

      case AppConst.deleteSuccess:
        return context.text.success_delete;
      case AppConst.deleteFail:
        return context.text.fail_delete;

      case AppConst.statusSuccess:
        return context.text.success_status;
      case AppConst.statusFail:
        return context.text.fail_status;
      default:
        return message;
    }
    }
}
