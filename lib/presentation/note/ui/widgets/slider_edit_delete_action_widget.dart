import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:noteflow/core/constant/app_color.dart';

import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/utils/core_utils.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/presentation/note/ui/widgets/delete_confirmation_widget.dart';


class SlidableListItem extends StatefulWidget  {
  final Widget child;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  SlidableListItem({
    Key? key,
    required this.child,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  State<SlidableListItem> createState() => _SlidableListItemState();
}

class _SlidableListItemState extends State<SlidableListItem> with TickerProviderStateMixin  {

  late SlidableController slidableController;

  @override
  void initState() {
    super.initState();
    slidableController = SlidableController(this);
  }


  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: slidableController,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4, // This limits the swipe length to 25% of the item's width
        children: [
          Gap(AppWidth.s10),
          SizedBox(
            width: AppHeight.s48,
            height: AppHeight.s48,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: AppColor.deleteBgColor,
              shape: const CircleBorder(), // Ensure circular shape (though it's default)
              child: Icon(Icons.close,color: AppColor.errorColor,size: AppHeight.s24,),
              onPressed: () {
                final ModalController modalController = ModalController();
                modalController.showModal(context, AlertConfirmView(
                  modalController: modalController, onDelete: (){
                  widget.onDelete();
                  slidableController.close(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                  confirmationButtonLevel: context.text.delete,
                  message: context.text.delete_task,));
              },
            ),
          ),
          Gap(AppWidth.s20),
          SizedBox(
            width: AppHeight.s48,
            height: AppHeight.s48,
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor:  Colors.green.withOpacity(0.3),
              shape: const CircleBorder(), // Ensure circular shape (though it's default)
              child: Icon(Icons.edit,color:Colors.green,size: AppHeight.s24,),
              onPressed: () {
                widget.onUpdate();
                slidableController.close(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          )  ,
         ],
      ),
      child: widget.child,
    );
  }
}