import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/domain/entities/note/note.dart';
import 'package:noteflow/presentation/note/bloc/note_bloc.dart';
import 'package:noteflow/presentation/note/ui/widgets/note_list_item.dart';



class NoteList extends StatefulWidget {
  final List<Note> notes;
  final ModalController modalController;
  final NoteBloc noteBloc;

  const NoteList({
    super.key,
    required this.notes,
    required this.modalController,
    required this.noteBloc,
  });

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant NoteList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.notes.length > oldWidget.notes.length) {
      // Scroll to the end of the list when a new item is added
      Future.delayed(Duration(milliseconds: 300), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  final user = FirebaseAuth.instance.currentUser;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) {
        return SizedBox(
          height: AppHeight.s15,
        );
      },
      padding: EdgeInsets.symmetric(
        horizontal: AppWidth.s20,
        vertical: AppHeight.s10,
      ),
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        final task = widget.notes[index];
        return NoteListItem(
          user: user!,
          index: index,
          noteBloc: widget.noteBloc,
          note: task,
          modalController: widget.modalController,
        );
      },
    );
  }
}

