import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/utils/core_utils.dart';




class UserAccountView extends StatefulWidget {
  const UserAccountView({super.key});

  @override
  State<UserAccountView> createState() => _UserAccountViewState();
}

class _UserAccountViewState extends State<UserAccountView> {
  final userCredential = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(AppHeight.s10),
        alignment: Alignment.center,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppWidth.s5),
            child: Row(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.text.hi,

                      style: TextStyle(
                          fontSize: AppTextSize.s14, color: Colors.grey.shade600)),
                  Row(
                    children: [
                      Text(userCredential!=null?userCredential!.email ?? '': 'Beautiful',
                          style: TextStyle(
                              fontSize: AppTextSize.s16, color: Colors.black)),
                    ],
                  )
                ],
              )
            ])));
  }
}
