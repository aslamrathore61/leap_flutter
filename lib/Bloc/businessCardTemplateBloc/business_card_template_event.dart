import 'package:equatable/equatable.dart';

abstract class BusinessCardTemplateEvent extends Equatable {
  const BusinessCardTemplateEvent();

  List<Object> get props => [];
}

class GetBusinessCardTemplateList extends BusinessCardTemplateEvent {}

