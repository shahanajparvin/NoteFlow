import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noteflow/core/constant/app_color.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/constant/app_text.dart';
import 'package:noteflow/core/utils/core_utils.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/presentation/note/ui/widgets/app_button.dart';

class AlertConfirmView extends StatelessWidget {

  final String message;
  final ModalController modalController;
  final String? confirmationButtonLevel;
  final VoidCallback onDelete;

  AlertConfirmView(
      {super.key, required this.modalController, required this.onDelete, required this.message,  this.confirmationButtonLevel});

  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: AppWidth.s20, vertical: AppHeight.s25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // This will force the Column to take up all available vertical space
        children: [
          Gap(AppHeight.s10),

          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColor.deleteBgColor,
              shape: BoxShape.circle
            ),
            child: Icon(
              Icons.clear,
              size: AppHeight.s32,
              color: AppColor.errorColor),
          ),

          Gap(AppHeight.s25),

          Text(message,
              textAlign: TextAlign.center,
              style: context.textTheme.displaySmall!.copyWith(
                  fontSize: AppTextSize.s18,
                  fontWeight: FontWeight.w400,
                  color: AppColor.subtitleColor
              )),

          Gap(AppHeight.s25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      isBorder: true,
                      borderColor: AppColor.errorColor,
                      onPressed: (){
                        modalController.closeModal(context);
                      },
                      backGroundColor: AppColor.windowBackgroundColor,
                      height: AppHeight.s48, label: context.text.no,labelColor: AppColor.errorColor,)),
              ),
              Gap(AppWidth.s20),
              Expanded(
                child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: (){
                        modalController.closeModal(context);
                        onDelete();
                        },
                      backGroundColor: AppColor.errorColor,
                      height: AppHeight.s48, label: confirmationButtonLevel ?? 'Yes',labelColor: AppColor.windowBackgroundColor,)),
              )

            ],
          ),
          Gap(AppHeight.s20),
        ],
      ),
    );
  }
}