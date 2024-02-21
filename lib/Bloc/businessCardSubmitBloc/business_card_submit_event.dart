import 'package:equatable/equatable.dart';
import '../../models/CreateUpdateCardRequestResponse.dart';

abstract class BusinessCardSubmitEvent extends Equatable {}

class BusinesCardSubmitted extends BusinessCardSubmitEvent {
  final CreateUpdateCardRequest? createUpdateCardRequest;

  BusinesCardSubmitted({this.createUpdateCardRequest});

  @override
  List<Object?> get props => [];
}
