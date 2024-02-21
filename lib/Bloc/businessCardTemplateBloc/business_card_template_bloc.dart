import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/businessCardTemplateBloc/business_card_template_state.dart';
import '../../Resource/ApiRepository.dart';
import 'business_card_template_event.dart';

class BusinessCardTemplateBloc extends Bloc<BusinessCardTemplateEvent, BusinessCardTemplateState> {
  BusinessCardTemplateBloc() : super(BusinessCardTemplateInitial()) {
    final ApiRepository _apiRepository = ApiRepository();

    on<GetBusinessCardTemplateList>((event, emit) async {
      try {
        emit(BusinessCardTemplateLoading());
        final mList = await _apiRepository.fetchBusinessCardTemplate();
        if (mList != null) {
          //  print('aslamp ${mList.requestList!.length}');
          emit(BusinessCardTemplateLoaded(mList));
        } else {
          emit(BusinessCardTemplateError('Failed to fetch data. Is your device online?'));
        }
      } on NetworkError {
        emit(BusinessCardTemplateError('Failed to fetch data. Is your device online?'));
      }
    });

    on<BusinessCardTemplateEvent>((event, emit) {});
  }
}
