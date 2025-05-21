

import 'package:flutter/material.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/presentation/changelanguage/ui/change_language_view.dart';

class TranslateIcon extends StatelessWidget {

  final ModalController modalController;
  final Color? color;

  const TranslateIcon({super.key, required this.modalController, this.color});

  @override
  Widget build(BuildContext context) {
    return  Row(children: [
      IconButton(onPressed: () async {
        modalController.showModal(context, ChangeLanguageView(modalController: modalController,));
      }, icon: Icon(Icons.translate,color: color!=null?color:null,))
    ]);
  }
}
