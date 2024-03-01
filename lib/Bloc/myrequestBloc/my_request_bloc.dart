import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../Resource/ApiProvider.dart';
import 'my_request_event.dart';
import 'my_request_state.dart';

class MyRequestBloc extends Bloc<MyRequestEvent, MyRequestState> {
  final ApiProvider _apiRepo = ApiProvider();

  MyRequestBloc() : super(MyRequestInitial()) {
    on<GetMyRequestListEvent>(getMyRequestList);
    on<DeleteMyRequestItemEvent>(deleteMyRequestItem);
  }

  FutureOr<void> getMyRequestList(
      MyRequestEvent event, Emitter<MyRequestState> emit) async {
    emit(MyRequestLoading());

    final mMyRequestList = await _apiRepo.fetchingMyRequestlist();
    if (mMyRequestList.oneToOneMentorship == null &&
        mMyRequestList.corporateTraining == null &&
        mMyRequestList.flyers == null &&
        mMyRequestList.corporateTraining == null) {
      emit(MyRequestFetchingError(
          'Failed to fetch my request. Is your device online?'));
    } else {
      emit(MyRequestFetchingSuccessState(mMyRequestList));
    }
  }

  /***  Delete card request response method  ***/
  FutureOr<void> deleteMyRequestItem(
      DeleteMyRequestItemEvent event, Emitter<MyRequestState> emit) async {
    try {
      final deleteCardResponse = await _apiRepo.deleteMyRequestItemDetails(
          event.cardDelete, event.endPoint);
      final statusCode = deleteCardResponse.code;
      if (statusCode == 200) {
        print('Success Deleted Items');
      } else {
        print('Failed to Delete');
      }
    } catch (error) {
      print('Failed to Delete $error');
    }
  }
}
