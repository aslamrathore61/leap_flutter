class BusinessCardTemplateResponse {
  String? serviceName;
  String? error;
  List<VisitingCards>? visitingCards;

  BusinessCardTemplateResponse({this.serviceName, this.visitingCards});

  BusinessCardTemplateResponse.withError(String errorMessage) {
    error = errorMessage;
  }

  BusinessCardTemplateResponse.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
    if (json['visitingCards'] != null) {
      visitingCards = <VisitingCards>[];
      json['visitingCards'].forEach((v) {
        visitingCards!.add(new VisitingCards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceName'] = this.serviceName;
    if (this.visitingCards != null) {
      data['visitingCards'] =
          this.visitingCards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitingCards {
  String? vcardUuid;
  String? vcardType;
  List<VcardImageInfo>? vcardImageInfo;
  List<int>? vcardRequestQuantity;

  VisitingCards(
      {this.vcardUuid,
        this.vcardType,
        this.vcardImageInfo,
        this.vcardRequestQuantity});

  VisitingCards.fromJson(Map<String, dynamic> json) {
    vcardUuid = json['vcardUuid'];
    vcardType = json['vcardType'];
    if (json['vcardImageInfo'] != null) {
      vcardImageInfo = <VcardImageInfo>[];
      json['vcardImageInfo'].forEach((v) {
        vcardImageInfo!.add(new VcardImageInfo.fromJson(v));
      });
    }
    vcardRequestQuantity = json['vcardRequestQuantity'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vcardUuid'] = this.vcardUuid;
    data['vcardType'] = this.vcardType;
    if (this.vcardImageInfo != null) {
      data['vcardImageInfo'] =
          this.vcardImageInfo!.map((v) => v.toJson()).toList();
    }
    data['vcardRequestQuantity'] = this.vcardRequestQuantity;
    return data;
  }
}

class VcardImageInfo {
  String? imageUrl;
  String? imageUuid;

  VcardImageInfo({this.imageUrl, this.imageUuid});

  VcardImageInfo.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    imageUuid = json['image_uuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['image_uuid'] = this.imageUuid;
    return data;
  }
}