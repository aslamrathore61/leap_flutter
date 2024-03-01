part of 'training_bloc.dart';

@immutable
abstract class TrainingState {}

class TrainingInitialState extends TrainingState {}

class MentorAndTrainingListFetchingError extends TrainingState {
  final String? str;

  MentorAndTrainingListFetchingError(this.str);
}

class MentorListFetchingSuccessState extends TrainingState {
  final MentorList? mentorList;

  MentorListFetchingSuccessState(this.mentorList);
}

class SubmissionTrainingLoadingState extends TrainingState {}

class SubmissionTrainingErrorState extends TrainingState {
  final String error;

  SubmissionTrainingErrorState(this.error);
}

class SubmissionTrainingSuccessState extends TrainingState {
  final CommonSimilarResponse commonSimilarResponse;

  SubmissionTrainingSuccessState(this.commonSimilarResponse);
}

class TrainingProgramListFetchingSuccessState extends TrainingState {
  final TrainingProgram? trainingProgram;

  TrainingProgramListFetchingSuccessState(this.trainingProgram);
}
