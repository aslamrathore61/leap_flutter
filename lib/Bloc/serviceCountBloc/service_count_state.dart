import 'package:equatable/equatable.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';

abstract class ServiceCountState extends Equatable {
  const ServiceCountState();

  @override
  List<Object?> get props => [];
}

class ServiceCountInitial extends ServiceCountState {}

class ServiceCountLoading extends ServiceCountState {}

class ServiceCountFetchingSuccessState extends ServiceCountState {
  final ServiceCountResponse serviceCountResponse;

  const ServiceCountFetchingSuccessState(this.serviceCountResponse);
}

class ServiceCountError extends ServiceCountState {
  final String? message;

  const ServiceCountError(this.message);
}
