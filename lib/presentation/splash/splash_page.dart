import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/core/base/app_routes.dart';
import 'package:noteflow/core/base/app_settings.dart';
import 'package:noteflow/core/constant/app_color.dart';
import 'package:noteflow/core/constant/app_size.dart';
import 'package:noteflow/core/di/injector.dart';
import 'package:noteflow/core/utils/core_utils.dart';
import 'package:noteflow/core/utils/modal_controller.dart';
import 'package:noteflow/presentation/auth/bloc/authentication/auth_bloc.dart';



import '../../../../core/utils/app_analytics_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  ModalController modalController = ModalController();
  AppSettings appSettings = injector();

  @override
  void initState() {
    super.initState();
    logSplashOpen();
  }

  @override
  Widget build(BuildContext context) {
    return  BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignedInPageState) {
            context.goNamed(AppRoutes.home.name);
          } else {
            context.goNamed(AppRoutes.signup.name);
          }
        },
        child: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(color: AppColor.themeColor),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Gap(MediaQuery.of(context).viewPadding.top),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50.0,
                            child: Icon(
                              Icons.task_alt,
                              color: Colors.black,
                              size: AppHeight.s50,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: AppHeight.s20)),
                          Text(
                            context.text.welcome_todo_app,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppTextSize.s20,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )));
  }


}
