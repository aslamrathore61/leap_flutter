import 'package:flutter/cupertino.dart';

import '../../models/LoginResponse.dart';

@immutable
abstract class LoginEvent {}

class LoginSubmittedEvent extends LoginEvent {
  final String userName;
  final String password;

  LoginSubmittedEvent(this.userName, this.password) {}
}

class ResetPWDSubmitEvent extends LoginEvent {
  final ResetPasswordReq resetPasswordReq;
  final String endPoint;

  ResetPWDSubmitEvent(this.resetPasswordReq, this.endPoint) {}

}

class OTPValidateEvent extends LoginEvent {
  final ResetPasswordReq resetPasswordReq;
  final String endPoint;

  OTPValidateEvent(this.resetPasswordReq, this.endPoint) {}

}


class ChooseNewPWDSubmitEvent extends LoginEvent {
  final ResetPasswordReq resetPasswordReq;
  final String endPoint;

  ChooseNewPWDSubmitEvent(this.resetPasswordReq, this.endPoint) {}

}
