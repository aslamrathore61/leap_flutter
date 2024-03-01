import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/loginBloc/login_state.dart';
import '../../Resource/ApiProvider.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiProvider _apiRepo = ApiProvider();

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmittedEvent>(loginSubmitted);
  }

  Future<void> loginSubmitted(LoginSubmittedEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());

    try {
      final loginResponse =
          await _apiRepo.fetchLoginDetails(event.userName, event.password);

      final statusCode = loginResponse.code;
      if (statusCode == 200) {
        emit(LoginFetchingSuccessState(loginResponse: loginResponse));
      } else if (statusCode == 400) {
        emit(LoginFetchingErrorState('Please enter correct Email/Password'));
      } else if (statusCode == 401) {
        emit(LoginFetchingErrorState('Please enter correct password'));
      } else {
        emit(LoginFetchingErrorState('Something went wrong, please try again'));
      }
    } catch (error) {
      emit(LoginFetchingErrorState(error.toString()));
    }
  }
}
