import 'package:equatable/equatable.dart';
import 'package:leap_flutter/models/BusinessCardTemplateResponse.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';

abstract class BusinessCardTemplateState extends Equatable {
  const BusinessCardTemplateState();

  @override
  List<Object?> get props => [];
}

class BusinessCardTemplateInitial extends BusinessCardTemplateState {}

class BusinessCardTemplateLoading extends BusinessCardTemplateState {}

class BusinessCardTemplateLoaded extends BusinessCardTemplateState {
  final BusinessCardTemplateResponse businessCardResponse;

  const BusinessCardTemplateLoaded(this.businessCardResponse);
}

class BusinessCardTemplateError extends BusinessCardTemplateState {
  final String? message;

  const BusinessCardTemplateError(this.message);
}


