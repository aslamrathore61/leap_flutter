class LoginResponse {
  int? code;
  String? error;
  Result? result;

  LoginResponse({this.code, this.result});

  LoginResponse.withError(String errorMessage) {
    error = errorMessage;
  }

  LoginResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? userType;
  bool? isActive;
  String? name;
  String? token;

  Result({this.userType, this.isActive, this.name, this.token});

  Result.fromJson(Map<String, dynamic> json) {
    userType = json['userType'];
    isActive = json['isActive'];
    name = json['name'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userType'] = this.userType;
    data['isActive'] = this.isActive;
    data['name'] = this.name;
    data['token'] = this.token;
    return data;
  }
}


class ResetPasswordReq {
  String? emailId;
  String? otp;
  String? newPassword;

  ResetPasswordReq({this.emailId, this.otp, this.newPassword});

  ResetPasswordReq.fromJson(Map<String, dynamic> json) {
    emailId = json['emailId'];
    otp = json['otp'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['emailId'] = this.emailId;
    data['otp'] = this.otp;
    data['newPassword'] = this.newPassword;
    return data;
  }
}

