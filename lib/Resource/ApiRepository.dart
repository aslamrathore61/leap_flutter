import 'package:leap_flutter/models/BusinessCardTemplateResponse.dart';
import 'package:leap_flutter/models/FlyersCardTemplateResponse.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';

import '../models/CreateUpdateCardRequestResponse.dart';
import '../models/LoginResponse.dart';
import 'ApiProvider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<LoginResponse> fetchLoginDetails(
      String username, String password) async {
    try {
      return _provider.fetchLoginData(username, password);
    } catch (error) {
      throw NetworkError();
    }
  }


  /***   Fetching Service Count Home Page   ***/
  Future<ServiceCountResponse> fetchServiceCount() async {
    try {
      return _provider.fetcheServiceCount();
    } catch (error) {
      throw NetworkError();
    }
  }

  Future<BusinessCardTemplateResponse> fetchBusinessCardTemplate() async {
    try {
      return _provider.fetcheBusinessCardTempalte();
    } catch (error) {
      throw NetworkError();
    }
  }

  Future<CreateUpdateCardResponse> submitBusinessCardDetails(
      CreateUpdateCardRequest cardRequest) async {
    try {
      return _provider.submitBusinessCardDetails(cardRequest);
    } catch (error) {
      throw NetworkError();
    }
  }


  /***   Fetching Flyers Card Template   ***/
  Future<FlyersCardTemplateResponse> fetchingFlyersCardTemplate() async {
    try {
      return _provider.fetcheFlyersCardTemplate();
    } catch (error) {
      throw NetworkError();
    }
  }


}

class NetworkError extends Error {}
