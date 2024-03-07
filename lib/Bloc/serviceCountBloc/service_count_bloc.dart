import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_event.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_state.dart';
import '../../Resource/ApiProvider.dart';

class ServiceCountBloc extends Bloc<ServiceCountEvent, ServiceCountState> {
  final ApiProvider _apiRepository = ApiProvider();

  ServiceCountBloc() : super(ServiceCountInitial()) {
    on<GetServiceCountListEvents>(getServiceCountList);
    on<GetProfileDataEvents>(getProfileDetails);
    on<UpdateProfileDetailsEvent>(setUpdateProfileDetails);
    on<ChangesPasswordEvent>(setChangesPassword);
  }

  Future<FutureOr<void>> getServiceCountList(
      GetServiceCountListEvents event, Emitter<ServiceCountState> emit) async {
    emit(ServiceCountLoading());

    try {
      final mList = await _apiRepository.fetchServiceCount();

      if (mList != null) {
        //  print('aslamp ${mList.requestList!.length}');
        emit(ServiceCountFetchingSuccessState(mList));
      } else {
        emit(ServiceCountError('Failed to fetch data. Is your device online?'));
      }
    } catch (error) {
      emit(ServiceCountError(error.toString()));
    }
  }

  FutureOr<void> getProfileDetails(
      GetProfileDataEvents event, Emitter<ServiceCountState> emit) async {
    emit(ProfileUpdateAndFetchingLoading());
    try {
      final mProfileDetails = await _apiRepository.fetchingMyProfileData();

      if (mProfileDetails.result != null) {
        //  print('aslamp ${mList.requestList!.length}');
        emit(ProfileDetailsFetchingSuccessState(mProfileDetails));
      } else if (mProfileDetails.code == 401) {
        emit(ProfileUpdateAndFetchingErrorState('SessionOut'));
      } else {
        emit(ProfileUpdateAndFetchingErrorState(
            'Failed to fetch data. Is your device online?'));
      }
    } catch (error) {
      emit(ServiceCountError(error.toString()));
    }
  }

  FutureOr<void> setUpdateProfileDetails(
      UpdateProfileDetailsEvent event, Emitter<ServiceCountState> emit) async {
    emit(ProfileUpdateAndFetchingLoading());

    try {
      final profileUpdateResponse =
          await _apiRepository.updateProfileDetails(event.profileUpdate);

      final statusCode = profileUpdateResponse.code;
      print('statusCodeaslam $statusCode');
      if (statusCode == 200) {
        emit(ProfileUpdateSuccessState(profileUpdateResponse));
      } else {
        print('errormessage ${profileUpdateResponse.error}');
        emit(ProfileUpdateAndFetchingErrorState(profileUpdateResponse.message ??
            "Something went wrong, please try again later."));
      }
    } catch (error) {
      emit(ProfileUpdateAndFetchingErrorState(error.toString()));
    }
  }

  FutureOr<void> setChangesPassword(
      ChangesPasswordEvent event, Emitter<ServiceCountState> emit) async {
    emit(ChangesPasswordLoading());

    try {
      final changesPasswordResponse =
          await _apiRepository.changesPasswordUpdate(event.changesPassword);

      final statusCode = changesPasswordResponse.code;
      print('changesPasswordStatusCode $statusCode');
      if (statusCode == 200) {
        emit(ChangesPasswordSuccessState(changesPasswordResponse));
      } else {
        print('errormessage ${changesPasswordResponse.error}');
        emit(ChangesPasswordErrorState(changesPasswordResponse.message ?? "Failed to change password."));
      }
    } catch (error) {
      emit(ChangesPasswordErrorState('Failed to change password.'));
    }
  }
}
