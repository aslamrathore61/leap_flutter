import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Resource/ApiRepository.dart';
import '../loginBloc/form_submission_status.dart';
import 'business_card_submit_event.dart';
import 'business_card_submit_state.dart';


class BusinessCardSubmitBloc
    extends Bloc<BusinessCardSubmitEvent, BusinessCardSubmitState> {
  final ApiRepository? authRepo;

  BusinessCardSubmitBloc({this.authRepo}) : super(const BusinessCardSubmitState()) {
    on<BusinessCardSubmitEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  Future<void> mapEventToState(
      BusinessCardSubmitEvent event, Emitter<BusinessCardSubmitState> emit) async {
    // Form submitted
    if (event is BusinesCardSubmitted) {

      emit(state.copyWith(formStatus: FormSubmitting()));

      final createUpdateCardResponse = await authRepo?.submitBusinessCardDetails(event.createUpdateCardRequest!);
      if(createUpdateCardResponse!.code == 200) {
        emit(state.copyWith(formStatus: SubmissionBusinessCardSuccess(createUpdateCardResponse!)));
      }else {
        emit(state.copyWith(formStatus: SubmissionFailed(createUpdateCardResponse.message!)));
      }

    }
  }
}
