part of 'card_bloc.dart';

@immutable
abstract class CardState {}

class CardInitialState extends CardState {}

/***  Flyers Card Template State ***/

class CardTemplateLoadingState extends CardState {}

class CardTemplateErrorState extends CardState {
  final String error;
  CardTemplateErrorState(this.error);
}

/*  Flyers Card template Success State  */
class FlyersCardTemplateFetchingSuccessState extends CardState {
  final FlyersCardTemplateResponse flyersCardTemplateResponse;
  FlyersCardTemplateFetchingSuccessState(this.flyersCardTemplateResponse);
}

/*  Business Card template Success State  */
class BusinessCardTemplateFetchingSuccessState extends CardState {
  final BusinessCardTemplateResponse businessCardTemplateResponse;
  BusinessCardTemplateFetchingSuccessState(this.businessCardTemplateResponse);
}

/*   Submit  Card Loading State   */
class SubmissionCardLoadingState extends CardState {}

/*   Submit Business Card Success State   */
class SubmissionBusinessCardReqSuccessState extends CardState {
  final CreateUpdateCardResponse createUpdateCardResponse;
  SubmissionBusinessCardReqSuccessState(this.createUpdateCardResponse);
}

/*   Submit Business Card Error State   */
class SubmissionBusinessCardReqErrorState extends CardState {
  final String error;
  SubmissionBusinessCardReqErrorState(this.error);
}


