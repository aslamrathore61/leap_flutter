import 'package:flutter/cupertino.dart';

import '../../models/BusinessCardTemplateResponse.dart';
import '../../models/CreateUpdateCardRequestResponse.dart';
import '../../models/FlyersCardTemplateResponse.dart';
import '../../models/MyRequestDeleteModel.dart';

@immutable
abstract class CardState {}

class CardInitialState extends CardState {}

/***  Flyers Card Template State ***/

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

/*   Submit  Card Error State   */
class SubmissionCardReqErrorState extends CardState {
  final String error;

  SubmissionCardReqErrorState(this.error);
}

/*   Submit  Card Success State   */
class SubmissionCardReqSuccessState extends CardState {
  final CommonSimilarResponse createUpdateCardResponse;

  SubmissionCardReqSuccessState(this.createUpdateCardResponse);
}
