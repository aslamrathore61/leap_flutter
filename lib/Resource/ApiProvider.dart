import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:leap_flutter/db/SharePrefObj.dart';
import 'package:leap_flutter/models/BusinessCardTemplateResponse.dart';
import 'package:leap_flutter/models/CreateUpdateCardRequestResponse.dart';
import 'package:leap_flutter/models/FlyersCardTemplateResponse.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';

import '../../models/LoginResponse.dart';
import '../constants.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://leap.savemax.com/api/';

  /***  Call Login API ***/
  Future<LoginResponse> fetchLoginData(String username, String password) async {
    try {
      Response response = await _dio.post(
        '${_baseUrl}getloginresponse',
        data: {
          'emailId': username,
          'password': password,
        },
      );
      return LoginResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print('Exception occurred: $error stackTrace: $stacktrace');
      return LoginResponse.withError('Data not found / connection issue');
    }
  }

  /***  Call Home ServiceCount API ***/
  Future<ServiceCountResponse> fetcheServiceCount() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await _dio.get(
        '${_baseUrl}getuserservicesrequestcount',
      );
      return ServiceCountResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return ServiceCountResponse.withError(
          'Data not found / connection issue');
    }
  }

  /***  Fetch Business Card tempalte API ***/
  Future<BusinessCardTemplateResponse> fetcheBusinessCardTempalte() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await _dio.get('${_baseUrl}getcardstemplatelist',);
      return BusinessCardTemplateResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return BusinessCardTemplateResponse.withError(
          'Data not found / connection issue');
    }
  }

  /*** BusinessCard Submit Vis API  ***/
  Future<CreateUpdateCardResponse> submitBusinessCardDetails(
      CreateUpdateCardRequest cardRequest) async {
    print('cardRequest ${cardRequest.toJson()}');
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      String requestBody = json.encode(cardRequest.toJson());
      Response response = await _dio.post('${_baseUrl}createupdatecardrequest', data: requestBody,);
      return CreateUpdateCardResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print('Exception occurred: $error stackTrace: $stacktrace');
      return CreateUpdateCardResponse.withError(
          'Data not found / connection issue');
    }
  }


  /*** Flyers Card Submit Vis API  ***/
  Future<CreateUpdateCardResponse> submitFlyersCardDetails(
      CreateUpdateCardRequest cardRequest) async {
    print('flyerCardRequest ${cardRequest.toJson()}');
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      String requestBody = json.encode(cardRequest.toJson());
      Response response = await _dio.post('${_baseUrl}createupdateflyerrequest', data: requestBody,);
      final flyersCardTemplateResponses = CreateUpdateCardResponse.fromJson(response.data);
      print('SubmitFlyersResponse ${flyersCardTemplateResponses.code} ${flyersCardTemplateResponses.message}');
      return CreateUpdateCardResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print('Exception occurred: $error stackTrace: $stacktrace');
      return CreateUpdateCardResponse.withError(
          'Data not found / connection issue');
    }
  }


  /***  Fetching Flyers Card Template API ***/
  Future<FlyersCardTemplateResponse> fetcheFlyersCardTemplate() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await _dio.get('${_baseUrl}getflyerstemplatelist',);
      return FlyersCardTemplateResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print('Exception occured: $error stackTrace: $stacktrace');
      return FlyersCardTemplateResponse.withError(
          'Data not found / connection issue');
    }
  }


}
