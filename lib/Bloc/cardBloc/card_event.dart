
import 'package:flutter/cupertino.dart';

import '../../models/CreateUpdateCardRequestResponse.dart';

@immutable
abstract class CardEvent {}

class GetFlyersCardListEvent extends CardEvent {}

class GetBusinessCardListEvent extends CardEvent {}

class SubmitBusinesCardEvent extends CardEvent {
  final CreateUpdateCardRequest? createUpdateCardRequest;
  final bool? isPost;
  SubmitBusinesCardEvent({this.createUpdateCardRequest, this.isPost});
}

class SubmitFlyersCardEvent extends CardEvent {
  final CreateUpdateCardRequest? createUpdateCardRequest;
  final bool? isPost;
  SubmitFlyersCardEvent({this.createUpdateCardRequest,this.isPost});
}

