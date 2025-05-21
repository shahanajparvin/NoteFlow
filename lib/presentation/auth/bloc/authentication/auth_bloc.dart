import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:bloc/bloc.dart';
import 'package:noteflow/domain/entities/auth/first_page_entity.dart';
import 'package:noteflow/domain/entities/auth/sign_in_entity.dart';
import 'package:noteflow/domain/entities/auth/sign_up_entity.dart';
import 'package:noteflow/domain/usecases/auth/check_verification_usecase.dart';
import 'package:noteflow/domain/usecases/auth/first_page_usecase.dart';
import 'package:noteflow/domain/usecases/auth/logout_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:noteflow/domain/usecases/auth/sign_in_usecase.dart';
import 'package:noteflow/domain/usecases/auth/sign_up_usecase.dart';
import '../../../../domain/usecases/auth/verifiy_email_usecase.dart';


part 'auth_event.dart';
part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final FirstPageUseCase firstPage;
  final CheckVerificationUseCase checkVerificationUseCase;
  final LogOutUseCase logOutUseCase;


  Completer<void> completer = Completer<void>();

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.firstPage,
    required this.verifyEmailUseCase,
    required this.checkVerificationUseCase,
    required this.logOutUseCase,
  }) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      print('check '+ event.toString());
      if (event is CheckLoggingInEvent) {

        final Response<FirstPageEntity> response = firstPage();
        print('response '+ response.toString());
        if (response is SuccessResponse<FirstPageEntity>) {
          final data = response.data;
          print('data '+ data.toString());
          if (data.isLoggedIn) {
            emit(SignedInPageState());
          } else if (data.isVerifyingEmail) {
            emit(VerifyEmailPageState());
          }else{
            emit(AuthInitial());
          }
        } else if (response is ErrorResponse<FirstPageEntity>) {
          emit(ErrorAuthState(message: response.errorMessage));
        }

      } else if (event is SignInEvent) {
        emit(LoadingState());
        final Response<UserCredential>  response = await signInUseCase(event.signInEntity);
        if (response is SuccessResponse<UserCredential>) {
          emit(SignedInState());
        } else if (response is ErrorResponse<UserCredential>) {
          emit(ErrorAuthState(message: response.errorMessage));
        }

      } else if (event is SignUpEvent) {
        emit(LoadingState());
        final Response<UserCredential> response = await signUpUseCase(event.signUpEntity);
        if (response is SuccessResponse<UserCredential>) {
          emit(SignedUpState());
        } else if (response is ErrorResponse<UserCredential>) {
          emit(ErrorAuthState(message: response.errorMessage));
        }

      } else if (event is SendEmailVerificationEvent) {
        final response = await verifyEmailUseCase();
        if (response is SuccessResponse) {
          emit(EmailIsSentState());
        } else if (response is ErrorResponse) {
          emit(ErrorAuthState(message: response.errorMessage));
        }

      } else if (event is CheckEmailVerificationEvent) {
        if (!completer.isCompleted) {
          completer.complete();
          completer = Completer<void>();
        }
        final response = await checkVerificationUseCase(completer);
        if (response is SuccessResponse) {
          emit(EmailIsVerifiedState());
        } else if (response is ErrorResponse) {
          emit(ErrorAuthState(message: response.errorMessage));
        }

      } else if (event is LogOutEvent) {
        final response = await logOutUseCase();
        if (response is SuccessResponse) {
          emit(LoggedOutState());
        } else if (response is ErrorResponse) {
          emit(ErrorAuthState(message: response.errorMessage));
        }
      }
    });
  }
}

