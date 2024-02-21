class FlyersCardTemplateResponse {
  String? serviceName;
  String? error;
  List<Flyers>? flyers;

  FlyersCardTemplateResponse({this.serviceName, this.flyers});

  FlyersCardTemplateResponse.withError(String errorMessage) {
    error = errorMessage;
  }

  FlyersCardTemplateResponse.fromJson(Map<String, dynamic> json) {
    serviceName = json['serviceName'];
    if (json['flyers'] != null) {
      flyers = <Flyers>[];
      json['flyers'].forEach((v) {
        flyers!.add(new Flyers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serviceName'] = this.serviceName;
    if (this.flyers != null) {
      data['flyers'] = this.flyers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Flyers {
  String? flyerUuid;
  String? flyerType;
  String? flyerImageUrl;
  List<int>? flyerRequestQuantity;

  Flyers(
      {this.flyerUuid,
        this.flyerType,
        this.flyerImageUrl,
        this.flyerRequestQuantity});

  Flyers.fromJson(Map<String, dynamic> json) {
    flyerUuid = json['flyerUuid'];
    flyerType = json['flyerType'];
    flyerImageUrl = json['flyerImageUrl'];
    flyerRequestQuantity = json['flyerRequestQuantity'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flyerUuid'] = this.flyerUuid;
    data['flyerType'] = this.flyerType;
    data['flyerImageUrl'] = this.flyerImageUrl;
    data['flyerRequestQuantity'] = this.flyerRequestQuantity;
    return data;
  }
}