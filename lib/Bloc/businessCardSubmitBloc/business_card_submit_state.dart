import 'package:equatable/equatable.dart';
import 'package:leap_flutter/models/BusinessCardTemplateResponse.dart';
import '../../models/CreateUpdateCardRequestResponse.dart';
import '../loginBloc/form_submission_status.dart';

class BusinessCardSubmitState extends Equatable {
  final FormSubmissionStatus formStatus;

  final CreateUpdateCardResponse?
      createUpdateCardResponse; // Property to hold the login response data

  const BusinessCardSubmitState({
    this.formStatus = const InitialFormStatus(),
    this.createUpdateCardResponse, // Initialize loginResponse to null
  });

  BusinessCardSubmitState copyWith({
    FormSubmissionStatus? formStatus,
    CreateUpdateCardResponse?
    createUpdateCardResponse, // Include loginResponse in copyWith method
  }) {
    return BusinessCardSubmitState(
      formStatus: formStatus ?? this.formStatus,
      createUpdateCardResponse: createUpdateCardResponse ??
          this.createUpdateCardResponse, // Update loginResponse in copyWith
    );
  }

  @override
  List<Object?> get props => [formStatus, createUpdateCardResponse];
}
