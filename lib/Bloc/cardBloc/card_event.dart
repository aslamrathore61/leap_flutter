part of 'card_bloc.dart';

@immutable
abstract class CardEvent {}

class GetFlyersCardListEvent extends CardEvent {}

class GetBusinessCardListEvent extends CardEvent {}

class SubmitBusinesCardEvent extends CardEvent {
  final CreateUpdateCardRequest? createUpdateCardRequest;
  SubmitBusinesCardEvent({this.createUpdateCardRequest});
}
