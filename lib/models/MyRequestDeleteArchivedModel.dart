/*** Delete My Request Row  ***/

class MyRequestDeleteModel {
  String? flyerRequestUuid;
  String? vcardRequestUuid;
  String? trainingBookingUuid;
  String? mentorSlotUuid;

  MyRequestDeleteModel({this.flyerRequestUuid, this.vcardRequestUuid});

  MyRequestDeleteModel.fromJson(Map<String, dynamic> json) {
    flyerRequestUuid = json['flyerRequestUuid'];
    vcardRequestUuid = json['vcardRequestUuid'];
    trainingBookingUuid = json['trainingBookingUuid'];
    mentorSlotUuid = json['mentorSlotUuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flyerRequestUuid'] = this.flyerRequestUuid;
    data['vcardRequestUuid'] = this.vcardRequestUuid;
    data['trainingBookingUuid'] = this.trainingBookingUuid;
    data['mentorSlotUuid'] = this.mentorSlotUuid;
    return data;
  }
}

class MyRequestArchivedModel {
  String? trainingBookingUuid;
  String? mentorSlotUuid;
  String? flyerRequestUuid;
  String? vcardRequestUuid;

  MyRequestArchivedModel({this.trainingBookingUuid,this.mentorSlotUuid,this.flyerRequestUuid,this.vcardRequestUuid,});

  MyRequestArchivedModel.fromJson(Map<String, dynamic> json) {
    trainingBookingUuid = json['trainingBookingUuid'];
    mentorSlotUuid = json['mentorSlotUuid'];
    flyerRequestUuid = json['flyerRequestUuid'];
    vcardRequestUuid = json['vcardRequestUuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trainingBookingUuid'] = this.trainingBookingUuid;
    data['mentorSlotUuid'] = this.mentorSlotUuid;
    data['flyerRequestUuid'] = this.flyerRequestUuid;
    data['vcardRequestUuid'] = this.vcardRequestUuid;
    return data;
  }
}

class CommonSimilarResponse {
  int? code;
  String? message;
  String? error;

  CommonSimilarResponse({this.code, this.message});

  CommonSimilarResponse.withError(String errorMessage) {
    error = errorMessage;
  }

  CommonSimilarResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    return data;
  }
}
