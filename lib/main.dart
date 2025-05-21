import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:noteflow/core/base/app_settings.dart';
import 'package:noteflow/core/constant/app_color.dart';
import 'package:noteflow/core/di/dependencies.dart';
import 'package:noteflow/core/utils/sharedpreferences_helper.dart';
import 'package:noteflow/domain/entities/other/language.dart';
import 'package:noteflow/presentation/lanuage/bloc/language_bloc.dart';
import 'package:noteflow/presentation/lanuage/bloc/language_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/di/injector.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as screenutil;

import 'presentation/auth/bloc/authentication/auth_bloc.dart';

late AppLocalizations localizations;


void main() async {
  await init();
  runApp(const MyApp());
}



void updateLocalization(Language language) async {
  localizations = await AppLocalizations.delegate.load(language.locale);
}


Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  await DependencyManager.inject();
  SharedPreferencesHelper preferencesHelper = injector();
  await preferencesHelper.init();
}



Future<void> initFirebase() async {
  await Firebase.initializeApp( options: const FirebaseOptions(
    apiKey: "AIzaSyCYcscfqh_LoVjK8M8JqBIyLJtF10pq-rU",
    appId: "1:167763629226:android:ae74a7c64f78a17abbacd3",
    messagingSenderId: "167763629226",
    projectId: "todoapp-e06fa", // <-- You need to replace this with actual projectId from Firebase Console
  ),);
  FlutterError.onError = (errorDetails) {
   // FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
   // FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppSettings appSettings = injector();
      updateLocalization(appSettings.getSelectedLanguage());
    });
  }




  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _getProviders(),
      child:_buildAppWithLanguage(),

    );
  }

  List<BlocProvider> _getProviders() {
    AppSettings appSettings = injector();
    return [
      BlocProvider<LanguageBloc>(
        create: (context) => LanguageBloc(appSettings.getSelectedLanguage()),
      ),
      BlocProvider<AuthBloc>(
        create: (context) => injector<AuthBloc>()..add(CheckLoggingInEvent()),
      ),

    ];
  }



    Widget _buildAppWithLanguage() {

      return BlocProvider(
        create: (context) =>
            LanguageBloc(injector<AppSettings>().getSelectedLanguage()),
        child: BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) => _buildScreenUtilInit(state),
        ),
      );
    }

  Widget _buildScreenUtilInit(LanguageState state) {
    return screenutil.ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) => _buildMaterialApp(state),
    );
  }

  Widget _buildMaterialApp(LanguageState state) {
    GoRouter router = injector();
    return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: state.selectedLanguage.locale,
      builder: (BuildContext context,  child) {
        EasyLoading.instance
          ..maskType = EasyLoadingMaskType.custom
          ..displayDuration = const Duration(milliseconds: 1)
          ..indicatorType = EasyLoadingIndicatorType.fadingCircle
          ..loadingStyle = EasyLoadingStyle.custom
          ..indicatorSize = 45.0
          ..radius = 5.0
          ..progressColor = Colors.yellow
          ..backgroundColor = AppColor.whiteColor
          ..indicatorColor =  AppColor.themeColor
          ..textColor = AppColor.themeColor
          ..maskColor = Colors.black.withOpacity(0.7)
          ..userInteractions = false;

        return FlutterEasyLoading(child: child);
      },
        );
  }
}
