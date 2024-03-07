class ServiceCountResponse {
  List<TrainingList>? trainingList;
  List<RequestList>? requestList;
  String? error;

  ServiceCountResponse({this.trainingList, this.requestList});

  ServiceCountResponse.withError(String errorMessage) {
    error = errorMessage;
  }

  ServiceCountResponse.fromJson(Map<String, dynamic> json) {
    if (json['trainingList'] != null) {
      trainingList = <TrainingList>[];
      json['trainingList'].forEach((v) {
        trainingList!.add(new TrainingList.fromJson(v));
      });
    }
    if (json['requestList'] != null) {
      requestList = <RequestList>[];
      json['requestList'].forEach((v) {
        requestList!.add(new RequestList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trainingList != null) {
      data['trainingList'] = this.trainingList!.map((v) => v.toJson()).toList();
    }
    if (this.requestList != null) {
      data['requestList'] = this.requestList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrainingList {
  int? trainingUuid;
  String? trainingName;
  String? color;
  int? trainingRisedCount;

  TrainingList(
      {this.trainingUuid,
      this.trainingName,
      this.color,
      this.trainingRisedCount});

  TrainingList.fromJson(Map<String, dynamic> json) {
    trainingUuid = json['trainingUuid'];
    trainingName = json['trainingName'];
    color = json['color'];
    trainingRisedCount = json['trainingRisedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trainingUuid'] = this.trainingUuid;
    data['trainingName'] = this.trainingName;
    data['color'] = this.color;
    data['trainingRisedCount'] = this.trainingRisedCount;
    return data;
  }
}

class RequestList {
  int? requestUuid;
  String? requestName;
  String? unpaid_max_limit;
  String? color;
  int? requestRisedCount;

  RequestList(
      {this.requestUuid,
      this.requestName,
      this.unpaid_max_limit,
      this.color,
      this.requestRisedCount});

  RequestList.fromJson(Map<String, dynamic> json) {
    requestUuid = json['requestUuid'];
    requestName = json['requestName'];
    unpaid_max_limit = json['unpaid_max_limit'];
    color = json['color'];
    requestRisedCount = json['requestRisedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestUuid'] = this.requestUuid;
    data['requestName'] = this.requestName;
    data['unpaid_max_limit'] = this.unpaid_max_limit;
    data['color'] = this.color;
    data['requestRisedCount'] = this.requestRisedCount;
    return data;
  }
}


/*  for my Request list filter*/
class FilterCount {
  String name;
  int value;

  FilterCount(this.name, this.value);
}
