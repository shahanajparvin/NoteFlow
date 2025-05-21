// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;

import '../../data/datasources/remote/auth_remote_data_source.dart' as _i624;
import '../../data/repositories/auth_repository_impl.dart' as _i895;
import '../../data/repositories/note_repository_impl.dart' as _i385;
import '../../domain/repository/authentication_repository.dart' as _i856;
import '../../domain/repository/note_repository.dart' as _i45;
import '../../domain/usecases/auth/check_verification_usecase.dart' as _i781;
import '../../domain/usecases/auth/first_page_usecase.dart' as _i864;
import '../../domain/usecases/auth/logout_usecase.dart' as _i320;
import '../../domain/usecases/auth/sign_in_usecase.dart' as _i549;
import '../../domain/usecases/auth/sign_up_usecase.dart' as _i270;
import '../../domain/usecases/auth/verifiy_email_usecase.dart' as _i1046;
import '../../domain/usecases/note/add_note_usecase.dart' as _i780;
import '../../domain/usecases/note/delete_note_usecase.dart' as _i900;
import '../../domain/usecases/note/get_notes_usecase.dart' as _i98;
import '../../domain/usecases/note/update_note_usecase.dart' as _i989;
import '../../presentation/auth/bloc/authentication/auth_bloc.dart' as _i57;
import '../../presentation/note/bloc/note_bloc.dart' as _i294;
import '../network/network_info.dart' as _i932;
import '../utils/app_alert_manager.dart' as _i839;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i839.AppCustomAlertManager>(
        () => _i839.AppCustomAlertManager());
    gh.lazySingleton<_i624.AuthRemoteDataSource>(
        () => _i624.AuthRemoteDataSourceImpl());
    gh.lazySingleton<_i45.NoteRepository>(
        () => _i385.RemoteDataSourceImpl(gh<_i974.FirebaseFirestore>()));
    gh.lazySingleton<_i932.NetworkInfo>(
        () => _i932.NetworkInfoImpl(gh<_i161.InternetConnection>()));
    gh.factory<_i780.AddNoteUseCase>(
        () => _i780.AddNoteUseCase(repository: gh<_i45.NoteRepository>()));
    gh.factory<_i900.DeleteNoteUseCase>(
        () => _i900.DeleteNoteUseCase(repository: gh<_i45.NoteRepository>()));
    gh.factory<_i98.GetNotesUseCase>(
        () => _i98.GetNotesUseCase(repository: gh<_i45.NoteRepository>()));
    gh.factory<_i989.UpdateNoteUseCase>(
        () => _i989.UpdateNoteUseCase(repository: gh<_i45.NoteRepository>()));
    gh.factory<_i294.NoteBloc>(() => _i294.NoteBloc(
          gh<_i98.GetNotesUseCase>(),
          gh<_i780.AddNoteUseCase>(),
          gh<_i989.UpdateNoteUseCase>(),
          gh<_i900.DeleteNoteUseCase>(),
        ));
    gh.lazySingleton<_i856.AuthenticationRepository>(
        () => _i895.AuthenticationRepositoryImp(
              networkInfo: gh<_i932.NetworkInfo>(),
              authRemoteDataSource: gh<_i624.AuthRemoteDataSource>(),
            ));
    gh.factory<_i781.CheckVerificationUseCase>(() =>
        _i781.CheckVerificationUseCase(gh<_i856.AuthenticationRepository>()));
    gh.factory<_i864.FirstPageUseCase>(
        () => _i864.FirstPageUseCase(gh<_i856.AuthenticationRepository>()));
    gh.factory<_i320.LogOutUseCase>(
        () => _i320.LogOutUseCase(gh<_i856.AuthenticationRepository>()));
    gh.factory<_i549.SignInUseCase>(
        () => _i549.SignInUseCase(gh<_i856.AuthenticationRepository>()));
    gh.factory<_i270.SignUpUseCase>(
        () => _i270.SignUpUseCase(gh<_i856.AuthenticationRepository>()));
    gh.factory<_i1046.VerifyEmailUseCase>(
        () => _i1046.VerifyEmailUseCase(gh<_i856.AuthenticationRepository>()));
    gh.factory<_i57.AuthBloc>(() => _i57.AuthBloc(
          signInUseCase: gh<_i549.SignInUseCase>(),
          signUpUseCase: gh<_i270.SignUpUseCase>(),
          firstPage: gh<_i864.FirstPageUseCase>(),
          verifyEmailUseCase: gh<_i1046.VerifyEmailUseCase>(),
          checkVerificationUseCase: gh<_i781.CheckVerificationUseCase>(),
          logOutUseCase: gh<_i320.LogOutUseCase>(),
        ));
    return this;
  }
}
