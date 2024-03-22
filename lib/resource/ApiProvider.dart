import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:leap_flutter/models/MentorList.dart';
import 'package:leap_flutter/models/Profile.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';
import '../Utils/constants.dart';
import '../db/SharedPrefObj.dart';
import '../models/BusinessCardTemplateResponse.dart';
import '../models/CreateUpdateCardRequestResponse.dart';
import '../models/FlyersCardTemplateResponse.dart';
import '../models/LoginResponse.dart';
import '../models/MyRequestDeleteArchivedModel.dart';
import '../models/MyRequestResponse.dart';
import '../models/OneToOneMentorshipPostGet.dart';
import '../models/TrainingProgram.dart';

class ApiProvider {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://leap.savemax.com/api/';

  ApiProvider() {
    // Add interceptors for logging and error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log request details only in debug mode
        assert(() {
          print('Request: ${options.method} ${options.path}');
          print('Request headers: ${options.headers}');
          print('Request data: ${options.data}');
          return true;
        }());
        return handler.next(options); // continue the request
      },
      onResponse: (response, handler) {
        // Log response details only in debug mode
        assert(() {
          print('Response: ${response.statusCode}');
          print('Response data: ${response.data}');
          return true;
        }());
        return handler.next(response); // continue the response
      },
      onError: (DioError e, handler) {
        // Log error details only in debug mode
        assert(() {
          print('Error: ${e.response?.statusCode}');
          print('Error message: ${e.message}');
          return true;
        }());
        return handler.next(e); // continue the error
      },
    ));
  }

  /***  Call Login API ***/
  Future<LoginResponse> fetchLoginDetails(
      String username, String password) async {
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
      return LoginResponse.withError('Data not found / connection issue');
    }
  }

  /***  Call Home ServiceCount API ***/
  Future<ServiceCountResponse> fetchServiceCount() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await _dio.get(
        '${_baseUrl}getuserservicesrequestcount',
      );
      ServiceCountResponse serviceCountResponse =
          ServiceCountResponse.fromJson(response.data);
      await SharedPrefObj.setServiceCountSharedPreValue(
          serviceCount, serviceCountResponse);
      return serviceCountResponse;
    } catch (error, stacktrace) {
      return ServiceCountResponse.withError(
          'Data not found / connection issue');
    }
  }

  /***  Fetch Business Card tempalte API ***/
  Future<BusinessCardTemplateResponse> fetchBusinessCardTemplate() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await _dio.get(
        '${_baseUrl}getcardstemplatelist',
      );
      final bTemplateList =
          BusinessCardTemplateResponse.fromJson(response.data);
      return BusinessCardTemplateResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return BusinessCardTemplateResponse.withError(
          'Data not found / connection issue');
    }
  }

  /*** BusinessCard Submit Vis API  ***/

  Future<CommonSimilarResponse> submitBusinessCardDetails(
    CreateUpdateCardRequest cardRequest,
    bool isPost,
  ) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      String requestBody = json.encode(cardRequest.toJson());

      Response response;
      if (isPost) {
        response = await _dio.post('${_baseUrl}createupdatecardrequest',
            data: requestBody);
      } else {
        response = await _dio.put('${_baseUrl}createupdatecardrequest',
            data: requestBody);
      }
      final respose = CommonSimilarResponse.fromJson(response.data);
      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError(
          'Data not found / connection issue');
    }
  }

  /*** Flyers Card Submit Vis API  ***/

  Future<CommonSimilarResponse> submitFlyersCardDetails(
      CreateUpdateCardRequest cardRequest, bool isPost) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(cardRequest.toJson());

      Response response;
      if (isPost) {
        response = await _dio.post(
          '${_baseUrl}createupdateflyerrequest',
          data: requestBody,
        );
      } else {
        response = await _dio.put(
          '${_baseUrl}createupdateflyerrequest',
          data: requestBody,
        );
      }
      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError(
          'Data not found / connection issue');
    }
  }

  /***  Delete My Request Row API Vis API  ***/

  Future<CommonSimilarResponse> deleteMyRequestItemDetails(
      MyRequestDeleteModel cardDelete, String endPoint) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(cardDelete.toJson());

      Response response = await _dio.post(
        '${_baseUrl}${endPoint}',
        data: requestBody,
      );

      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError('connection issue');
    }
  }

  /***  Fetching Flyers Card Template API ***/
  Future<FlyersCardTemplateResponse> fetchingFlyersCardTemplate() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await _dio.get(
        '${_baseUrl}getflyerstemplatelist',
      );
      return FlyersCardTemplateResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return FlyersCardTemplateResponse.withError(
          'Data not found / connection issue');
    }
  }

  /*** Fetching My Request listing ***/

  Future<MyRequestResponse> fetchingMyRequestlist() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response =
          await _dio.get('${_baseUrl}getuserservicesraisedlist');
      return MyRequestResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return MyRequestResponse.withError('Data not found / connection issue');
    }
  }

  /*** Fetching My Profile listing ***/

  Future<Profile> fetchingMyProfileData() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await _dio.get('${_baseUrl}getuserprofile');
      Profile profile = Profile.fromJson(response.data);
      await SharedPrefObj.setProfileSharedPreValue(profileDetails, profile);
      return profile;
    } catch (error, stacktrace) {
      return Profile.withError('Data not found / connection issue');
    }
  }

  /*** Fetching Mentor listing ***/

  Future<MentorList> fetchingMentorListing() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response =
          await _dio.get('${_baseUrl}getmentoravailabilitylist');

      return MentorList.fromJson(response.data);
    } catch (error, stacktrace) {
      return MentorList.withError('Data not found / connection issue');
    }
  }

  /*** Fetching Training program listing ***/

  Future<TrainingProgram> fetchingTrainingProgramListing() async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      Response response = await _dio.get('${_baseUrl}gettraininglist');

      return TrainingProgram.fromJson(response.data);
    } catch (error, stacktrace) {
      return TrainingProgram.withError('Data not found / connection issue');
    }
  }

  /*** One to One Mentorship Submit Vis API  ***/

  Future<CommonSimilarResponse> submitOneToOneMentorshipDetails(
      OneToOneMentorshipPostPut oneMentorshipPostGet, bool isPost) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer ${token}";
      String requestBody = json.encode(oneMentorshipPostGet.toJson());
      Response response;
      if (isPost) {
        response = await _dio.post(
          '${_baseUrl}bookmentorship',
          data: requestBody,
        );
      } else {
        response = await _dio.put(
          '${_baseUrl}bookmentorship',
          data: requestBody,
        );
      }

      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError(
          'Data not found / connection issue');
    }
  }

  /*** Flyers Card Submit Vis API  ***/

  Future<CommonSimilarResponse> submitCorporateTrainingDetails(
      CorporateTrainingPostPut corporateTrainingPostPut, bool isPost) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(corporateTrainingPostPut.toJson());

      Response response;
      if (isPost) {
        response = await _dio.post(
          '${_baseUrl}booktraining',
          data: requestBody,
        );
      } else {
        response = await _dio.put(
          '${_baseUrl}booktraining',
          data: requestBody,
        );
      }
      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError(
          'Data not found / connection issue');
    }
  }

  /*** Profile Update Vis API  ***/

  Future<CommonSimilarResponse> updateProfileDetails(
      ProfileUpdate profileUpdate) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(profileUpdate.toJson());

      Response response = await _dio.post(
        '${_baseUrl}updateuserprofile',
        data: requestBody,
      );
      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError(
          'Data not found / connection issue');
    }
  }

  /*** Changes Password Vis API  ***/

  Future<CommonSimilarResponse> changesPasswordUpdate(
      ChangesPassword changesPassword) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(changesPassword.toJson());
      Response response = await _dio.post(
        '${_baseUrl}changepassword',
        data: requestBody,
      );
      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError(
          'Data not found / connection issue');
    }
  }

  /***  Archived My Request Row API Vis API  ***/

  Future<CommonSimilarResponse> archivedMyRequestItemDetails(
      MyRequestArchivedModel myRequestArchivedModel, String endPoint) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(myRequestArchivedModel.toJson());

      Response response = await _dio.post(
        '${_baseUrl}${endPoint}',
        data: requestBody,
      );

      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError('connection issue');
    }
  }

  /***  Reset Password Row API Vis API  ***/

  Future<CommonSimilarResponse> resetPassword(
      ResetPasswordReq resetPasswordReq, String endPoint) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(resetPasswordReq.toJson());

      Response response = await _dio.post(
        '${_baseUrl}${endPoint}',
        data: requestBody,
      );

      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError('connection issue');
    }
  }

  /***  otp validate  API Vis API  ***/

  Future<CommonSimilarResponse> otpValidateResponse(
      ResetPasswordReq resetPasswordReq, String endPoint) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(resetPasswordReq.toJson());

      Response response = await _dio.post(
        '${_baseUrl}${endPoint}',
        data: requestBody,
      );

      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError('connection issue');
    }
  }

  /***  Choose new pwd submit API Vis API  ***/

  Future<CommonSimilarResponse> choosenewPWDSubmitResponse(
      ResetPasswordReq resetPasswordReq, String endPoint) async {
    try {
      String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      String requestBody = json.encode(resetPasswordReq.toJson());

      Response response = await _dio.put(
        '${_baseUrl}${endPoint}',
        data: requestBody,
      );

      return CommonSimilarResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return CommonSimilarResponse.withError('connection issue');
    }
  }
}
