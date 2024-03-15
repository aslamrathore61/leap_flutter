import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/loginBloc/login_state.dart';
import '../../Resource/ApiProvider.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiProvider _apiRepo = ApiProvider();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmittedEvent>(loginSubmitted);
    on<ResetPWDSubmitEvent>(resetPWDSubmit);
    on<OTPValidateEvent>(OTPValidateSubmit);
    on<ChooseNewPWDSubmitEvent>(SaveNewPasswordSubmit);
  }

  Future<void> loginSubmitted(
      LoginSubmittedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());

    try {
      final loginResponse =
          await _apiRepo.fetchLoginDetails(event.userName, event.password);

      final statusCode = loginResponse.code;
      if (statusCode == 200) {
        emit(LoginFetchingSuccessState(loginResponse: loginResponse));
      } else if (statusCode == 400) {
        emit(FetchingErrorState('Please enter correct Email/Password'));
      } else if (statusCode == 401) {
        emit(FetchingErrorState('Please enter correct password'));
      } else {
        emit(FetchingErrorState('Something went wrong, please try again'));
      }
    } catch (error) {
      emit(FetchingErrorState(error.toString()));
    }
  }

  Future<FutureOr<void>> resetPWDSubmit(
      ResetPWDSubmitEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());

    try {
      final commonSimilarResponse =
          await _apiRepo.resetPassword(event.resetPasswordReq, event.endPoint);

      final statusCode = commonSimilarResponse.code;
      if (statusCode == 200) {
        emit(
            ResetPWDSuccessState(commonSimilarResponse: commonSimilarResponse));
      } else {
        emit(FetchingErrorState(commonSimilarResponse.message));
      }
    } catch (error) {
      emit(FetchingErrorState(error.toString()));
    }
  }

  Future<FutureOr<void>> OTPValidateSubmit(
      OTPValidateEvent event, Emitter<LoginState> emit) async {
    emit(OTPValidateLoadingState());

    try {
      final commonSimilarResponse = await _apiRepo.otpValidateResponse(
          event.resetPasswordReq, event.endPoint);

      final statusCode = commonSimilarResponse.code;
      if (statusCode == 200) {
        emit(OTPValidateSuccessState(
            commonSimilarResponse: commonSimilarResponse));
      } else {
        emit(OTPValidateErrorState(commonSimilarResponse.message));
      }
    } catch (error) {
      emit(OTPValidateErrorState(error.toString()));
    }
  }

  Future<FutureOr<void>> SaveNewPasswordSubmit(
      ChooseNewPWDSubmitEvent event, Emitter<LoginState> emit) async {
    emit(ChooseNewPWDSubmitLoadingState());

    try {
      final commonSimilarResponse = await _apiRepo.choosenewPWDSubmitResponse(
          event.resetPasswordReq, event.endPoint);

      final statusCode = commonSimilarResponse.code;
      if (statusCode == 200) {
        print('statusCodeMsg111 $statusCode ${commonSimilarResponse.message}');
        emit(ChooseNewPWDSubmitSuccessState(
            commonSimilarResponse: commonSimilarResponse));
      } else {
        print('statusCodeMsg2222 $statusCode ${commonSimilarResponse.message}');
        emit(ChooseNewPWDSubmitErrorState(commonSimilarResponse.message));
      }
    } catch (error) {
      emit(ChooseNewPWDSubmitErrorState(error.toString()));
    }
  }
}
