import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/core/utils/app_context.dart';
import 'package:noteflow/presentation/auth/pages/auth/sign_in_page.dart';
import 'package:noteflow/presentation/auth/pages/auth/sign_up_page.dart';
import 'package:noteflow/presentation/auth/pages/auth/verify_email.dart';
import 'package:noteflow/presentation/home/home_page.dart';
import 'package:noteflow/presentation/splash/splash_page.dart';
import 'package:noteflow/presentation/note/bloc/note_bloc.dart';
import 'package:noteflow/presentation/note/ui/pages/note_details_page.dart';

import 'package:noteflow/domain/entities/note/note.dart';



enum AppRoutes {
  splash,
  signup,
  signin,
  verifyEmail,
  home,
  noteDetail
}

GoRouter provideGoRoute() {
  return GoRouter(
      navigatorKey: AppContext.navigatorKey,
      initialLocation: "/",
      debugLogDiagnostics: kDebugMode,
      routes: [
        GoRoute(
          path: "/",
          name: AppRoutes.splash.name,
          builder: (context, state) => const SplashPage(),
        ),

        GoRoute(
          path: "/signup",
          name: AppRoutes.signup.name,
          builder: (context, state) => const SignUp(),
        ),

        GoRoute(
          path: "/signin",
          name: AppRoutes.signin.name,
          builder: (context, state) => const SignIn(),
        ),
        GoRoute(
          path: "/verifyEmail",
          name: AppRoutes.verifyEmail.name,
          builder: (context, state) => const VerifyEmail(),
        ),

        GoRoute(
          path: "/home",
          name: AppRoutes.home.name,
          builder: (context, state) =>  HomePage(),
        ),

        GoRoute(
          path: "/noteDetail",
          name: AppRoutes.noteDetail.name,
          builder: (context, state) {
            print('state extra '+ state.extra.toString());
            if(state.extra is Map<String, dynamic>){
              final extra = state.extra as Map<String, dynamic>;
              final note = extra['note'] as Note;
              final noteBloc = extra['noteBloc'] as NoteBloc;

              return NoteDetailsPage(note: note, noteBloc: noteBloc);
            }
           return SizedBox();
          },
        ),




      ]);
}
