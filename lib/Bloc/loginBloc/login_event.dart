import 'package:flutter/cupertino.dart';

@immutable
abstract class LoginEvent {}

class LoginSubmittedEvent extends LoginEvent {
  final String userName;
  final String password;

  LoginSubmittedEvent(this.userName, this.password) {}
}
