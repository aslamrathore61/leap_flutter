import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:leap_flutter/Resource/ApiProvider.dart';
import 'package:leap_flutter/models/MentorList.dart';
import 'package:leap_flutter/models/TrainingProgram.dart';
import 'package:meta/meta.dart';
import '../../models/MyRequestDeleteModel.dart';
import '../../models/OneToOneMentorshipPostGet.dart';

part 'training_event.dart';

part 'training_state.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final ApiProvider apiProvider = ApiProvider();

  TrainingBloc() : super(TrainingInitialState()) {
    on<GetMentorListEvent>(getMentorList);
    on<SubmitOneToOneMentorshipEvent>(setSubmitOneToOneMentorship);
    on<SubmitCorporateTrainingpEvent>(setSubmitCorporateTraining);
    on<GetTrainingProgramListEvent>(getTrainingProgramList);
  }

  FutureOr<void> getMentorList(
      GetMentorListEvent event, Emitter<TrainingState> emit) async {
    try {
      final mentorList = await apiProvider.fetchingMentorListing();
      if (mentorList.mentors != null && mentorList.mentors!.isNotEmpty) {
        emit(MentorListFetchingSuccessState(mentorList));
      } else {
        emit(MentorAndTrainingListFetchingError(
            "Failed to fetch mentor details."));
      }
    } catch (e) {
      emit(MentorAndTrainingListFetchingError(e.toString()));
    }
  }

  FutureOr<void> setSubmitOneToOneMentorship(
      SubmitOneToOneMentorshipEvent event, Emitter<TrainingState> emit) async {
    emit(SubmissionTrainingLoadingState());

    try {
      final businessCardSubmitResponse = await apiProvider
          .submitOneToOneMentorshipDetails(event.oneToOneMentorshipPostGet!, event.isPost!);

      final statusCode = businessCardSubmitResponse.code;
      print('statusCodeaslam $statusCode');
      if (statusCode == 200) {
        emit(SubmissionTrainingSuccessState(businessCardSubmitResponse));
      } else {
        print('errormessage ${businessCardSubmitResponse.error}');
        emit(SubmissionTrainingErrorState(businessCardSubmitResponse.message ??
            "Something went wrong, please try again later."));
      }
    } catch (error) {
      emit(SubmissionTrainingErrorState(error.toString()));
    }
  }

  FutureOr<void> getTrainingProgramList(
      GetTrainingProgramListEvent event, Emitter<TrainingState> emit) async {
    try {
      final trainingProgramList =
          await apiProvider.fetchingTrainingProgramListing();
      if (trainingProgramList != null &&
          trainingProgramList.trainings != null) {
        emit(TrainingProgramListFetchingSuccessState(trainingProgramList));
      } else {
        emit(MentorAndTrainingListFetchingError(
            "Failed to fetch mentor details."));
      }
    } catch (e) {
      emit(MentorAndTrainingListFetchingError(e.toString()));
    }
  }

  FutureOr<void> setSubmitCorporateTraining(
      SubmitCorporateTrainingpEvent event, Emitter<TrainingState> emit) async {
    emit(SubmissionTrainingLoadingState());

    try {
      final corporateTraining =
          await apiProvider.submitCorporateTrainingDetails(
              event.corporateTrainingPostPut!, event.isPost!);

      final statusCode = corporateTraining.code;
      print('corporateTrainingStatusCode $statusCode');
      if (statusCode == 200) {
        emit(SubmissionTrainingSuccessState(corporateTraining));
      } else {
        print('corporateTrainingStatusErrorMessage ${corporateTraining.error}');
        emit(SubmissionTrainingErrorState(corporateTraining.message ??
            "Something went wrong, please try again later."));
      }
    } catch (error) {
      emit(SubmissionTrainingErrorState(error.toString()));
    }
  }
}
