import 'package:flutter/cupertino.dart';
import 'package:leap_flutter/models/MyRequestResponse.dart';

import '../../models/CreateUpdateCardRequestResponse.dart';

@immutable
abstract class MyRequestState {}

class MyRequestInitial extends MyRequestState {}

class MyRequestLoading extends MyRequestState {}

class MyRequestFetchingSuccessState extends MyRequestState {
  final MyRequestResponse myRequestResponse;
  MyRequestFetchingSuccessState(this.myRequestResponse);
}
class MyRequestFetchingError extends MyRequestState {
  final String error;
  MyRequestFetchingError(this.error);
}