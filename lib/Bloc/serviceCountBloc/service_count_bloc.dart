import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_event.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_state.dart';
import '../../Resource/ApiRepository.dart';

class ServiceCountBloc extends Bloc<ServiceCountEvent, ServiceCountState> {
  final ApiRepository _apiRepository = ApiRepository();

  ServiceCountBloc() : super(ServiceCountInitial()) {
    on<GetServiceCountListEvents>(getServiceCountList);
  }

  Future<FutureOr<void>> getServiceCountList(GetServiceCountListEvents event, Emitter<ServiceCountState> emit) async {
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
}
