part of 'training_bloc.dart';

@immutable
abstract class TrainingEvent {}

class GetMentorListEvent extends TrainingEvent {}

class SubmitOneToOneMentorshipEvent extends TrainingEvent {
  final OneToOneMentorshipPostPut? oneToOneMentorshipPostGet;
  final bool? isPost;
  SubmitOneToOneMentorshipEvent({this.oneToOneMentorshipPostGet, this.isPost});
}

class GetTrainingProgramListEvent extends TrainingEvent {}

class SubmitCorporateTrainingpEvent extends TrainingEvent {
  final CorporateTrainingPostPut? corporateTrainingPostPut;
  final bool? isPost;

  SubmitCorporateTrainingpEvent({this.corporateTrainingPostPut, this.isPost});
}
