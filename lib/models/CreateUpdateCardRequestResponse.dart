class CreateUpdateCardRequest {
  String? printEmail;
  String? printName;
  String? printPhoneNumber;
  String? printAddress;
  String? requestQuantity;
  String? designImageUuid;
  String? vcardUuid;
  String? printImageData;

  CreateUpdateCardRequest(
      {this.printEmail,
      this.printName,
      this.printPhoneNumber,
      this.printAddress,
      this.requestQuantity,
      this.designImageUuid,
      this.vcardUuid,
      this.printImageData});

  CreateUpdateCardRequest.fromJson(Map<String, dynamic> json) {
    printEmail = json['printEmail'];
    printName = json['printName'];
    printPhoneNumber = json['printPhoneNumber'];
    printAddress = json['printAddress'];
    requestQuantity = json['requestQuantity'];
    designImageUuid = json['designImageUuid'];
    vcardUuid = json['vcardUuid'];
    printImageData = json['printImageData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['printEmail'] = this.printEmail;
    data['printName'] = this.printName;
    data['printPhoneNumber'] = this.printPhoneNumber;
    data['printAddress'] = this.printAddress;
    data['requestQuantity'] = this.requestQuantity;
    data['designImageUuid'] = this.designImageUuid;
    data['vcardUuid'] = this.vcardUuid;
    data['printImageData'] = this.printImageData;
    return data;
  }
}

class CreateUpdateCardResponse {
  int? code;
  String? message;
  String? error;

  CreateUpdateCardResponse({this.code, this.message});

  CreateUpdateCardResponse.withError(String errorMessage) {
    error = errorMessage;
  }

  CreateUpdateCardResponse.fromJson(Map<String, dynamic> json) {
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
