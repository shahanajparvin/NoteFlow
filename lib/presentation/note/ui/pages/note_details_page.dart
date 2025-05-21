import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:noteflow/core/constant/app_color.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/utils/core_utils.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/presentation/note/bloc/note_bloc.dart';
import 'package:noteflow/presentation/note/bloc/note_event.dart';
import 'package:noteflow/presentation/note/ui/widgets/add_note_widget.dart';
import 'package:noteflow/presentation/note/ui/widgets/app_button.dart';
import 'package:noteflow/presentation/note/ui/widgets/delete_confirmation_widget.dart';

class NoteDetailsPage extends StatelessWidget {

  final Note note;
  final NoteBloc noteBloc;

  const NoteDetailsPage({
    super.key, required this.note, required this.noteBloc,

  });

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;
    final currentUserId = user!.uid;
    final noteOwnerId = note.userId; // assuming this is available
    final bool isOwner = currentUserId == noteOwnerId;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Note Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              note.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const Spacer(),

            if(isOwner)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          isBorder: true,
                          borderColor: AppColor.themeColor,
                          onPressed: (){
                            ModalController modalController = ModalController();
                            modalController.showModal(
                              context,
                              AddNoteWidget(modalController: modalController, noteBloc: noteBloc,task: note,buildContext: context,),
                            );
                          },
                          backGroundColor: AppColor.windowBackgroundColor,
                          height: AppHeight.s48, label: 'Edit',labelColor: AppColor.themeColor,)),
                  ),
                  Gap(AppWidth.s20),
                  Expanded(
                    child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          onPressed: (){
                            final ModalController modalController = ModalController();
                            modalController.showModal(context, AlertConfirmView(
                              modalController: modalController, onDelete: (){
                              noteBloc.add(DeleteNote(note.id!));
                              context.pop();
                            },
                              confirmationButtonLevel: context.text.delete,
                              message: context.text.delete_task,));

                          },
                          backGroundColor: AppColor.errorColor,
                          height: AppHeight.s48, label: 'Delete',labelColor: AppColor.windowBackgroundColor,)),
                  )

                ],
              ),

            Gap(30)
          ],
        ),
      ),
    );
  }
}
