
import 'package:flutter/cupertino.dart';

import '../../models/CreateUpdateCardRequestResponse.dart';
import '../../models/MyRequestDeleteArchivedModel.dart';
import '../../models/ProofReadRequest.dart';

@immutable
abstract class MyRequestEvent {}

class GetMyRequestListEvent extends MyRequestEvent {}

class DeleteMyRequestItemEvent extends MyRequestEvent {
  final MyRequestDeleteModel cardDelete;
  final String endPoint;
  DeleteMyRequestItemEvent({required this.cardDelete,required this.endPoint});
}

class ArchivedMyRequestItemEvent extends MyRequestEvent {
  final MyRequestArchivedModel myRequestArchivedModel;
  final String endPoint;
  ArchivedMyRequestItemEvent({required this.myRequestArchivedModel,required this.endPoint});
}

class ProofReadRequestEvent extends MyRequestEvent {
  final ProofReadRequest proofReadRequest;
  ProofReadRequestEvent({required this.proofReadRequest});
}