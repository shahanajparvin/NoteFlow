import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:noteflow/core/base/app_routes.dart';
import 'package:noteflow/core/di/injector.dart';
import 'package:noteflow/presentation/auth/bloc/authentication/auth_bloc.dart';
import 'package:noteflow/presentation/note/bloc/note_bloc.dart';
import 'package:noteflow/presentation/note/ui/pages/note_list_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late NoteBloc _taskBloc;


  @override
  void initState() {
    super.initState();
    _taskBloc = injector();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
      if (state is LoggedOutState) {
         context.goNamed(AppRoutes.signin.name);
      }
    },
    child: BlocProvider(
        create: (context) => _taskBloc,
    child:NoteListPage(noteBloc: _taskBloc)));
  }
}


