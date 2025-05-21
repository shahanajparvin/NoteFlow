

import 'package:flutter/material.dart';
import 'package:noteflow/core/utils/modal_controller.dart';

class AppCloseIcon extends StatelessWidget {

  final ModalController modalController;

  const AppCloseIcon({super.key, required this.modalController});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Material(
        shape: CircleBorder(),
        color: Colors.grey.shade300,
        child: InkWell(
          splashColor: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(100),
          onTap: (){
             modalController.closeModal(context);
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}
