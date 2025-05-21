import 'package:flutter/material.dart';
import 'package:noteflow/core/constant/app_color.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/utils/date_time_utility.dart';
import 'package:noteflow/core/utils/core_utils.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/presentation/note/bloc/note_bloc.dart';
import 'package:noteflow/presentation/note/ui/widgets/add_note_widget.dart';

class HeaderSection extends StatelessWidget {

  final ModalController modalController;
  final NoteBloc noteBloc;

  const HeaderSection({super.key, required this.modalController, required this.noteBloc,});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding:  EdgeInsets.only(top: AppHeight.s25,bottom: AppHeight.s10, left: AppWidth.s20,right: AppWidth.s20),
      child: SizedBox(
        child: Row(
          mainAxisAlignment : MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize : MainAxisSize.min,
              crossAxisAlignment :CrossAxisAlignment.start,
              children: [
                Text( context.text.your_task,style: TextStyle(height:1,color: AppColor.textColorBlack,fontWeight: FontWeight.w500,fontSize: AppTextSize.s20),),
                DateWidget()
              ],
            ),
            Spacer(),
            SizedBox(
              height: AppHeight.s36,
              child: ElevatedButton.icon(
                icon:  Icon(
                  Icons.add,
                  size: AppWidth.s18,
                  color: AppColor.whiteColor,
                ),
                label:  Text(context.text.new_task,style: TextStyle(color: AppColor.whiteColor),),
                onPressed: () {
                  modalController.showModal(
                    context,
                    AddNoteWidget(modalController: modalController, noteBloc: noteBloc,),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        5), // Makes the button rectangular
                  ),
                ),
              ),)

          ],
        ),
      ),
    );
  }
}



class DateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: DateTimeUtility.getCurrentDate(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return Text(
          snapshot.hasData&&snapshot.data!=null?snapshot.data!:'',
          style: TextStyle(
            color: AppColor.caseDividerColor,
            fontWeight: FontWeight.w500,
            fontSize: AppTextSize.s13,
          ),
        );
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the result
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any errors
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          // Display the formatted date
          return Text(
            snapshot.data!,
            style: TextStyle(
              color: AppColor.caseDividerColor,
              fontWeight: FontWeight.w500,
              fontSize: AppTextSize.s13,
            ),
          );
        } else {
          // Handle the case where there's no data
          return Text('No date available');
        }
      },
    );
  }
}

