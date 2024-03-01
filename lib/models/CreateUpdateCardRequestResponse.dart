class CreateUpdateCardRequest {
  String? printEmail;
  String? printName;
  String? printPhoneNumber;
  String? printAddress;
  String? printDescription;
  String? flyerUuid;
  String? requestQuantity;
  String? designImageUuid;
  String? vcardUuid;
  String? printImageData;
  String? flyerRequestUuid;
  String? vcardRequestUuid;

  CreateUpdateCardRequest(
      {this.printEmail,
      this.printName,
      this.printPhoneNumber,
      this.printAddress,
      this.printDescription,
      this.flyerUuid,
      this.requestQuantity,
      this.designImageUuid,
      this.vcardUuid,
      this.printImageData,
      this.flyerRequestUuid,
      this.vcardRequestUuid
      });

  CreateUpdateCardRequest.fromJson(Map<String, dynamic> json) {
    printEmail = json['printEmail'];
    printName = json['printName'];
    printPhoneNumber = json['printPhoneNumber'];
    printAddress = json['printAddress'];
    printDescription = json['printDescription'];
    flyerUuid = json['flyerUuid'];
    requestQuantity = json['requestQuantity'];
    designImageUuid = json['designImageUuid'];
    vcardUuid = json['vcardUuid'];
    printImageData = json['printImageData'];
    flyerRequestUuid = json['flyerRequestUuid'];
    vcardRequestUuid = json['vcardRequestUuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['printEmail'] = this.printEmail;
    data['printName'] = this.printName;
    data['printPhoneNumber'] = this.printPhoneNumber;
    data['printAddress'] = this.printAddress;
    data['printDescription'] = this.printDescription;
    data['flyerUuid'] = this.flyerUuid;
    data['requestQuantity'] = this.requestQuantity;
    data['designImageUuid'] = this.designImageUuid;
    data['vcardUuid'] = this.vcardUuid;
    data['printImageData'] = this.printImageData;
    data['flyerRequestUuid'] = this.flyerRequestUuid;
    data['vcardRequestUuid'] = this.vcardRequestUuid;
    return data;
  }
}


