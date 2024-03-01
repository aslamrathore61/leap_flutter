
import 'package:flutter/cupertino.dart';

import '../../models/CreateUpdateCardRequestResponse.dart';
import '../../models/MyRequestDeleteModel.dart';

@immutable
abstract class MyRequestEvent {}

class GetMyRequestListEvent extends MyRequestEvent {}

class DeleteMyRequestItemEvent extends MyRequestEvent {
  final MyRequestDeleteModel cardDelete;
  final String endPoint;
  DeleteMyRequestItemEvent({required this.cardDelete,required this.endPoint});
}
