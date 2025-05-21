import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:noteflow/core/base/app_routes.dart';
import 'package:noteflow/core/constant/app_color.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/constant/pref_keys.dart';
import 'package:noteflow/core/utils/date_time_utility.dart';
import 'package:noteflow/core/utils/core_utils.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/presentation/note/bloc/note_bloc.dart';
import 'package:noteflow/presentation/note/bloc/note_event.dart';
import 'package:noteflow/presentation/note/ui/widgets/add_note_widget.dart';
import 'package:noteflow/presentation/note/ui/widgets/slider_edit_delete_action_widget.dart';

class NoteListItem extends StatefulWidget {
  final ModalController modalController;
  final NoteBloc noteBloc;
  final Note note;
  final int index;
  final User user;


  NoteListItem({super.key, required this.modalController, required this.noteBloc, required this.note, required this.index, required this.user});

  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  double screenHeight = 0;

  double screenWidth = 0;

  bool startAnimation = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        startAnimation = true;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    TextDirection direction = Directionality.of(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final currentUserId = widget.user.uid;

    final noteOwnerId = widget.note.userId; // assuming this is available

    final bool isOwner = currentUserId == noteOwnerId;
    return isOwner?SlidableListItem(
        onDelete:(){
         widget.noteBloc.add(DeleteNote(widget.note.id!));
        },
        onUpdate: () {
          widget.modalController.showModal(
            context,
            AddNoteWidget(modalController: widget.modalController, noteBloc: widget.noteBloc,task: widget.note,buildContext: context,),
          );
        },
        child:itemWidget(direction)):itemWidget(direction);
  }

  Widget itemWidget(TextDirection direction ){
    final timestamp = widget.note.createdAt; // Timestamp
    final dateTime = timestamp.toDate(); // Convert to DateTime
    final formattedDate = DateFormat('MM/dd/yyyy').format(dateTime); // String like "08/20/2025
    final formattedTime = DateFormat('h:mm a').format(dateTime); // e.g., 9:45 AM
    return AnimatedContainer(
      decoration: BoxDecoration(
        color: Colors.white,
        border: direction==TextDirection.ltr?Border(
          left: BorderSide(
            color: AppColor.themeColor,
            width: AppWidth.s6, // Border width
          ),
        ):Border(
          right: BorderSide(
            color: AppColor.themeColor,
            width: AppWidth.s6, // Border width
          ),
        ),
        borderRadius: BorderRadius.circular(
            10.0), // Radius applied to all corners
      ),
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: (300 + (widget.index * 200)).toInt()),
      transform: Matrix4.translationValues(startAnimation ? 0 : screenWidth, 0, 0),
      child: InkWell(
        onTap: (){
          context.pushNamed(
            AppRoutes.noteDetail.name,
            extra: {
              'note': widget.note,
              'noteBloc': widget.noteBloc,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Use spaceBetween to separate the items
                      children: [
                        Flexible(
                          child: Text(
                            widget.note.title,
                            style: TextStyle(
                              fontSize: AppTextSize.s16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Gap(AppWidth.s10),
                      ],
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      widget.note.description,
                      style: TextStyle(
                        fontSize: AppTextSize.s14,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Gap(AppHeight.s10),
                    Divider(color: Colors.grey.shade200,height:0.5),
                    Gap(AppHeight.s10),
                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                            size: AppWidth.s16),
                        SizedBox(width: 4.0),
                        Text(DateTimeUtility.stringConvertToDateLocalization(dateString: formattedDate,parseCode: 'en'),style: TextStyle(fontSize: AppTextSize.s14, color: Colors.grey.shade600,fontWeight: FontWeight.w400)),

                        SizedBox(width: AppWidth.s16),
                        Icon(Icons.access_time, size: AppWidth.s16),
                        SizedBox(width: AppWidth.s4),
                        Text(DateTimeUtility.stringConvertToATimeLocalization(timeString: formattedTime,parseCode: 'en'), style: TextStyle(fontSize: AppTextSize.s14, color: Colors.grey.shade600,fontWeight: FontWeight.w400)),
                        Spacer(),

                      ],
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



}





