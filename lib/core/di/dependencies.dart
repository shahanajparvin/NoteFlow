import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:noteflow/core/base/app_routes.dart';
import 'package:noteflow/core/base/app_settings.dart';
import 'package:noteflow/core/di/injector.dart';
import 'package:noteflow/core/utils/sharedpreferences_helper.dart';



class DependencyManager {
  static Future<void> inject() async {
    SharedPreferencesHelper helper = SharedPreferencesHelper();
    AppSettings appSettings = AppSettings(helper);
    GoRouter routes = provideGoRoute();
    injector.registerLazySingleton<SharedPreferencesHelper>(() => helper);
    injector.registerSingleton(appSettings);
    injector.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
    injector.registerLazySingleton<GoRouter>(() => routes);
    injector.registerLazySingleton<InternetConnection>(() => InternetConnection());
    await configureDependencies();
  }
}
