import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Resource/ApiProvider.dart';
import 'card_event.dart';
import 'card_state.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final ApiProvider _apiRepo = ApiProvider();

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
      final mBusinessCardTemplateList =
          await _apiRepo.fetchBusinessCardTemplate();
      if (mBusinessCardTemplateList != null) {
        emit(BusinessCardTemplateFetchingSuccessState(
            mBusinessCardTemplateList));
      } else {
        emit(CardTemplateErrorState(
            'Failed to fetch data. Is your device online?'));
      }
    } catch (error) {
      emit(CardTemplateErrorState(error.toString()));
    }
  }

  /***  Post and Put Business card submit request response method  ***/
  FutureOr<void> setBusinessCardRequest(
      SubmitBusinesCardEvent event, Emitter<CardState> emit) async {
    emit(SubmissionCardLoadingState());

    try {
      final businessCardSubmitResponse =
          await _apiRepo.submitBusinessCardDetails(
              event.createUpdateCardRequest!, event.isPost!);

      final statusCode = businessCardSubmitResponse.code;
      print('statusCodeaslam $statusCode');
      if (statusCode == 200) {
        emit(SubmissionCardReqSuccessState(businessCardSubmitResponse));
      } else {
        print('errormessage ${businessCardSubmitResponse.error}');
        emit(SubmissionCardReqErrorState(businessCardSubmitResponse.message ??
            "Something went wrong, please try again later."));
      }
    } catch (error) {
      emit(SubmissionCardReqErrorState(error.toString()));
    }
  }

  /***  Post and Put Flyers card submit request response method  ***/
  FutureOr<void> setFlyersCardRequest(
      SubmitFlyersCardEvent event, Emitter<CardState> emit) async {
    emit(SubmissionCardLoadingState());
    try {
      final businessCardSubmitResponse = await _apiRepo.submitFlyersCardDetails(
          event.createUpdateCardRequest!, event.isPost!);
      final statusCode = businessCardSubmitResponse.code;
      if (statusCode == 200) {
        emit(SubmissionCardReqSuccessState(businessCardSubmitResponse));
      } else {
        emit(SubmissionCardReqErrorState(businessCardSubmitResponse.message ??
            "Something went wrong, please try again later."));
      }
    } catch (error) {
      emit(SubmissionCardReqErrorState(error.toString()));
    }
  }
}
