import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:leap_flutter/models/LoginResponse.dart';
import 'package:leap_flutter/models/MyRequestDeleteArchivedModel.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class FetchingErrorState extends LoginState {
  final String? error;

  FetchingErrorState(this.error);
}

class LoginFetchingSuccessState extends LoginState {
  final LoginResponse? loginResponse;

  LoginFetchingSuccessState({this.loginResponse});
}


class ResetPWDSuccessState extends LoginState {
  final CommonSimilarResponse? commonSimilarResponse;

  ResetPWDSuccessState({this.commonSimilarResponse});
}


class OTPValidateLoadingState extends LoginState {}

class OTPValidateSuccessState extends LoginState {
  final CommonSimilarResponse? commonSimilarResponse;

  OTPValidateSuccessState({this.commonSimilarResponse});
}

class OTPValidateErrorState extends LoginState {
  final String? error;

  OTPValidateErrorState(this.error);
}



class ChooseNewPWDSubmitLoadingState extends LoginState {}

class ChooseNewPWDSubmitSuccessState extends LoginState {
  final CommonSimilarResponse? commonSimilarResponse;

  ChooseNewPWDSubmitSuccessState({this.commonSimilarResponse});
}

class ChooseNewPWDSubmitErrorState extends LoginState {
  final String? error;

  ChooseNewPWDSubmitErrorState(this.error);
}


