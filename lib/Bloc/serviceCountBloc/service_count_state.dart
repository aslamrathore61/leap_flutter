import 'package:equatable/equatable.dart';
import 'package:leap_flutter/models/MyRequestDeleteArchivedModel.dart';
import 'package:leap_flutter/models/Profile.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';

abstract class ServiceCountState extends Equatable {
  const ServiceCountState();

  @override
  List<Object?> get props => [];
}

class ServiceCountInitial extends ServiceCountState {}

class ServiceCountLoading extends ServiceCountState {}

class ServiceCountFetchingSuccessState extends ServiceCountState {
  final ServiceCountResponse serviceCountResponse;

  const ServiceCountFetchingSuccessState(this.serviceCountResponse);
}

class ServiceCountError extends ServiceCountState {
  final String? message;

  const ServiceCountError(this.message);
}

class ProfileUpdateAndFetchingLoading extends ServiceCountState {}

class ProfileDetailsFetchingSuccessState extends ServiceCountState {
  final Profile profileDetails;
  const ProfileDetailsFetchingSuccessState(this.profileDetails);
}

class ProfileUpdateAndFetchingErrorState extends ServiceCountState {
  final String? error;
  const ProfileUpdateAndFetchingErrorState(this.error);
}


class ProfileUpdateSuccessState extends ServiceCountState {
  final CommonSimilarResponse commonSimilarResponse;
  const ProfileUpdateSuccessState(this.commonSimilarResponse);
}

class ChangesPasswordLoading extends ServiceCountState {}

class ChangesPasswordSuccessState extends ServiceCountState {
  final CommonSimilarResponse commonSimilarResponse;
  const ChangesPasswordSuccessState(this.commonSimilarResponse);
}

class ChangesPasswordErrorState extends ServiceCountState {
  final String? error;
  const ChangesPasswordErrorState(this.error);
}