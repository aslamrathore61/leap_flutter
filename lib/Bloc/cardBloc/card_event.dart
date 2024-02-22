part of 'card_bloc.dart';

@immutable
abstract class CardEvent {}

class GetFlyersCardListEvent extends CardEvent {}

class GetBusinessCardListEvent extends CardEvent {}

class SubmitBusinesCardEvent extends CardEvent {
  final CreateUpdateCardRequest? createUpdateCardRequest;
  SubmitBusinesCardEvent({this.createUpdateCardRequest});
}

class SubmitFlyersCardEvent extends CardEvent {
  final CreateUpdateCardRequest? createUpdateCardRequest;
  SubmitFlyersCardEvent({this.createUpdateCardRequest});
}