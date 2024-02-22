import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:leap_flutter/models/FlyersCardTemplateResponse.dart';
import 'package:meta/meta.dart';

import '../../Resource/ApiRepository.dart';
import '../../models/BusinessCardTemplateResponse.dart';
import '../../models/CreateUpdateCardRequestResponse.dart';

part 'card_event.dart';

part 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final ApiRepository _apiRepo = ApiRepository();

  CardBloc() : super(CardInitialState()) {
    on<GetFlyersCardListEvent>(getFlyersCardTemplate);
    on<GetBusinessCardListEvent>(getBusinessCardTemplate);
    on<SubmitBusinesCardEvent>(setBusinessCardRequest);
    on<SubmitFlyersCardEvent>(setFlyersCardRequest);
  }

  /***  Get Flyers Card Template   ***/
  FutureOr<void> getFlyersCardTemplate(
      GetFlyersCardListEvent event, Emitter<CardState> emit) async {
    try {
      final mFlyersCardTemplateList =
          await _apiRepo.fetchingFlyersCardTemplate();
      if (mFlyersCardTemplateList != null) {
        emit(FlyersCardTemplateFetchingSuccessState(mFlyersCardTemplateList));
      } else {
        emit(CardTemplateErrorState(
            'Failed to fetch data. Is your device online?'));
      }
    } catch (error) {
      emit(CardTemplateErrorState(error.toString()));
    }
  }


  /***  Get Business Card Tmeplate   ***/
  FutureOr<void> getBusinessCardTemplate(
      GetBusinessCardListEvent event, Emitter<CardState> emit) async {
    try {
      final mBusinessCardTemplateList = await _apiRepo.fetchBusinessCardTemplate();
      if (mBusinessCardTemplateList != null) {
        emit(BusinessCardTemplateFetchingSuccessState(mBusinessCardTemplateList));
      } else {
        emit(CardTemplateErrorState(
            'Failed to fetch data. Is your device online?'));
      }
    } catch (error) {
      emit(CardTemplateErrorState(error.toString()));
    }
  }


  /***  Post Business card submit request response method  ***/
  FutureOr<void> setBusinessCardRequest(SubmitBusinesCardEvent event, Emitter<CardState> emit) async {
    print('businesCardRequest ${event.createUpdateCardRequest}');
    emit(SubmissionCardLoadingState());

    try {
      final businessCardSubmitResponse = await _apiRepo.submitBusinessCardDetails(event.createUpdateCardRequest!);

      final statusCode = businessCardSubmitResponse.code;
      print('statusCode $statusCode');
      if (statusCode == 200) {
        emit(SubmissionCardReqSuccessState(businessCardSubmitResponse));
      } else {
        emit(SubmissionCardReqErrorState(businessCardSubmitResponse.message ?? "Something went wrong, please try again later."));
      }
    } catch (error) {
      emit(SubmissionCardReqErrorState(error.toString()));
    }
  }


  /***  Post Flyers card submit request response method  ***/
  FutureOr<void> setFlyersCardRequest(SubmitFlyersCardEvent event, Emitter<CardState> emit) async {
    emit(SubmissionCardLoadingState());
    try {
      final businessCardSubmitResponse = await _apiRepo.submitFlyersCardDetails(event.createUpdateCardRequest!);
      final statusCode = businessCardSubmitResponse.code;
      print('statusCode $statusCode');
      if (statusCode == 200) {
        emit(SubmissionCardReqSuccessState(businessCardSubmitResponse));
      } else {
        emit(SubmissionCardReqErrorState(businessCardSubmitResponse.message ?? "Something went wrong, please try again later."));
      }
    } catch (error) {
      emit(SubmissionCardReqErrorState(error.toString()));
    }
  }

}
