import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/presentation/auth/bloc/authentication/auth_bloc.dart';
import 'package:noteflow/presentation/changelanguage/ui/change_language_view.dart';
import 'package:noteflow/presentation/note/ui/widgets/delete_confirmation_widget.dart';

class LogoutIcon extends StatelessWidget {

  final ModalController modalController;
  final Color? color;

  const LogoutIcon({super.key, required this.modalController, this.color});

  @override
  Widget build(BuildContext context) {
    return   Row(children: [
      IconButton(onPressed: () async {
        modalController.showModal(context, AlertConfirmView(
            message: 'Are you sure want to logout?',
            modalController: modalController, onDelete: (){
          BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
        }));
      }, icon: Icon(Icons.logout,color: Colors.red))
    ]);
  }
}