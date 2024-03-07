import 'package:flutter/cupertino.dart';
import 'package:leap_flutter/models/Profile.dart';

@immutable
abstract class ServiceCountEvent {}

class GetServiceCountListEvents extends ServiceCountEvent {}

class GetProfileDataEvents extends ServiceCountEvent {}

class UpdateProfileDetailsEvent extends ServiceCountEvent {
  final ProfileUpdate profileUpdate;

  UpdateProfileDetailsEvent({required this.profileUpdate});
}


class ChangesPasswordEvent extends ServiceCountEvent {
  final ChangesPassword changesPassword;

  ChangesPasswordEvent({required this.changesPassword});
}
