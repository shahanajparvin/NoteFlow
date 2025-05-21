import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:noteflow/core/strings/failures.dart';
import 'package:noteflow/data/models/sign_in_model.dart';
import 'package:noteflow/data/models/sign_up_model.dart';
import 'package:noteflow/data/responses/firebase_response.dart';
import 'package:noteflow/domain/entities/auth/sign_in_entity.dart';
import 'package:noteflow/domain/entities/auth/sign_up_entity.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/repository/authentication_repository.dart';
import '../datasources/remote/auth_remote_data_source.dart';
import '../models/first_page_model.dart' show FirstPageModel;



@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImp implements AuthenticationRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final NetworkInfo networkInfo;

  AuthenticationRepositoryImp({
    required this.networkInfo,
    required this.authRemoteDataSource,
  });

  @override
  Future<Response<UserCredential>> signIn(SignInEntity signIn) async {
    if (await networkInfo.isConnected) {
      try {
        final signInModel = SignInModel(
          email: signIn.email,
          password: signIn.password,
        );
        final userCredential = await authRemoteDataSource.signIn(signInModel);
        return SuccessResponse(data: userCredential);
      } on ExistedAccountException catch (e) {
        return ErrorResponse(errorMessage: EXISTED_ACCOUNT_FAILURE_MESSAGE, exception: e);
      } on WrongPasswordException catch (e) {
        return ErrorResponse(errorMessage: WRONG_PASSWORD_FAILURE_MESSAGE, exception: e);
      } on ServerException catch (e) {
        return ErrorResponse(errorMessage: 'Server error occurred', exception: e);
      } on InValidEmail catch (e) {
        return ErrorResponse(errorMessage: 'Invalid Email', exception: e);
      }
      on InValidCredential catch (e) {
        return ErrorResponse(errorMessage: 'Invalid Credential', exception: e);
      }
      on NoUserException catch (e) {
        return ErrorResponse(errorMessage: NO_USER_FAILURE_MESSAGE, exception: e);
      }
      catch (e) {
        return ErrorResponse(errorMessage: OFFLINE_FAILURE_MESSAGE, exception: e as Exception);
      }
    } else {
      return const ErrorResponse(errorMessage: 'No internet connection');
    }
  }




  @override
  Future<Response<UserCredential>> signUp(SignUpEntity signUp) async {
    if (!await networkInfo.isConnected) {
      return const ErrorResponse(errorMessage: OFFLINE_FAILURE_MESSAGE);
    } else if (signUp.password != signUp.repeatedPassword) {
      return const ErrorResponse(errorMessage: UNMATCHED_PASSWORD_FAILURE_MESSAGE);
    } else {
      try {
        final signUpModel = SignUpModel(
          name: signUp.name,
          email: signUp.email,
          password: signUp.password,
          repeatedPassword: signUp.repeatedPassword,
        );
        final userCredential = await authRemoteDataSource.signUp(signUpModel);
        return SuccessResponse(data: userCredential);
      } on WeekPassException catch (e) {
        return ErrorResponse(errorMessage: WEEK_PASS_FAILURE_MESSAGE, exception: e);
      } on ExistedAccountException catch (e) {
        return ErrorResponse(errorMessage: EXISTED_ACCOUNT_FAILURE_MESSAGE, exception: e);
      }  on InValidEmail catch (e) {
        return ErrorResponse(errorMessage: 'Invalid Email', exception: e);
      }on ServerException catch (e) {
        return ErrorResponse(errorMessage: 'Server error', exception: e);
      } catch (e) {
        return ErrorResponse(errorMessage: 'Unexpected error', exception: e as Exception);
      }
    }
  }

  @override
  Future<Response<void>> verifyEmail() async {
    if (await networkInfo.isConnected) {
      try {
        await authRemoteDataSource.verifyEmail();
        return const SuccessResponse(data: null);
      } on TooManyRequestsException catch (e) {
        return ErrorResponse(errorMessage: TOO_MANY_REQUESTS_FAILURE_MESSAGE, exception: e);
      } on ServerException catch (e) {
        return ErrorResponse(errorMessage: 'Server error', exception: e);
      } on NoUserException catch (e) {
        return ErrorResponse(errorMessage: NO_USER_FAILURE_MESSAGE, exception: e);
      } catch (e) {
        return ErrorResponse(errorMessage: 'Unexpected error', exception: e as Exception);
      }
    } else {
      return const ErrorResponse(errorMessage: OFFLINE_FAILURE_MESSAGE);
    }
  }

  @override
  Future<Response<void>> logOut() async {
    if (await networkInfo.isConnected) {
      try {
        await FirebaseAuth.instance.signOut();
        return const SuccessResponse(data: null);
      } catch (e) {
        return ErrorResponse(errorMessage: 'Logout failed', exception: e as Exception);
      }
    } else {
      return const ErrorResponse(errorMessage: OFFLINE_FAILURE_MESSAGE);
    }
  }

  @override
  Response<FirstPageModel> firstPage() {
    final user = FirebaseAuth.instance.currentUser;
    print('user ' + user.toString());
    if (user != null && user.emailVerified) {
      return const SuccessResponse(
          data: FirstPageModel(isVerifyingEmail: false, isLoggedIn: true));
    } else if (user != null) {
      return const SuccessResponse(
          data: FirstPageModel(isVerifyingEmail: true, isLoggedIn: false));
    } else {
      return const SuccessResponse(
          data: FirstPageModel(isVerifyingEmail: false, isLoggedIn: false));
    }
  }

  @override
  Future<Response<void>> checkEmailVerification(Completer completer) async {
    try {
      await waitForVerifiedUser(completer).timeout(const Duration(days: 30));
      return const SuccessResponse(data: null);
    } catch (e) {
      return ErrorResponse(errorMessage: 'Verification timeout or error', exception: e as Exception);
    }
  }

  Future<void> waitForVerifiedUser(Completer completer) async {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        completer.complete();
        timer.cancel();
      }
    });
    await completer.future;
  }
}
