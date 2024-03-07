class Profile {
  int? code;
  Result? result;
  Result? error;

  Profile({this.code, this.result, this.error});

  Profile.withError(String errorMessage) {
    error = error;
  }

  // Create Model from JSON
  Profile.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  // Convert Model to JSON
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
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  Null? userType;
  String? profileImage;
  Null? designation;
  Null? department;
  Null? organization;
  bool? isFranchise;
  List<String>? currentMentors;
  Null? splitModel;
  Null? tenureWithSM;
  String? registerDate;

  Result(
      {this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.userType,
      this.profileImage,
      this.designation,
      this.department,
      this.organization,
      this.isFranchise,
      this.currentMentors,
      this.splitModel,
      this.tenureWithSM,
      this.registerDate});

  Result.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    userType = json['userType'];
    profileImage = json['profileImage'];
    designation = json['designation'];
    department = json['department'];
    organization = json['organization'];
    isFranchise = json['isFranchise'];
    currentMentors = json['currentMentors'].cast<String>();
    splitModel = json['splitModel'];
    tenureWithSM = json['tenureWithSM'];
    registerDate = json['registerDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['userType'] = this.userType;
    data['profileImage'] = this.profileImage;
    data['designation'] = this.designation;
    data['department'] = this.department;
    data['organization'] = this.organization;
    data['isFranchise'] = this.isFranchise;
    data['currentMentors'] = this.currentMentors;
    data['splitModel'] = this.splitModel;
    data['tenureWithSM'] = this.tenureWithSM;
    data['registerDate'] = this.registerDate;
    return data;
  }
}

/* For Update Profile details  */

class ProfileUpdate {
  String? imageData;
  String? phoneNumber;
  String? userFirstName;
  String? userLastName;

  ProfileUpdate(
      {this.imageData,
      this.phoneNumber,
      this.userFirstName,
      this.userLastName});

  ProfileUpdate.fromJson(Map<String, dynamic> json) {
    imageData = json['imageData'];
    phoneNumber = json['phoneNumber'];
    userFirstName = json['userFirstName'];
    userLastName = json['userLastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageData'] = this.imageData;
    data['phoneNumber'] = this.phoneNumber;
    data['userFirstName'] = this.userFirstName;
    data['userLastName'] = this.userLastName;
    return data;
  }
}

class ChangesPassword {
  String? oldPassword;
  String? newPassword;
  String? emailId;

  ChangesPassword({this.newPassword, this.oldPassword, this.emailId});

  ChangesPassword.fromJson(Map<String, dynamic> json) {
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    data['emailId'] = this.emailId;
    return data;
  }
}
