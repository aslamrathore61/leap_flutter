import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:leap_flutter/models/LoginResponse.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginFetchingErrorState extends LoginState {
  final String? error;

  LoginFetchingErrorState(this.error);
}

class LoginFetchingSuccessState extends LoginState {
  final LoginResponse? loginResponse;

  LoginFetchingSuccessState({this.loginResponse});
}
