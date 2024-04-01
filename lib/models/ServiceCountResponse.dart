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
  int? remaining_training_count;

  TrainingList(
      {this.trainingUuid,
      this.trainingName,
      this.color,
      this.trainingRisedCount,
      this.remaining_training_count,

      });

  TrainingList.fromJson(Map<String, dynamic> json) {
    trainingUuid = json['trainingUuid'];
    trainingName = json['trainingName'];
    color = json['color'];
    trainingRisedCount = json['trainingRisedCount'];
    remaining_training_count = json['remaining_training_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trainingUuid'] = this.trainingUuid;
    data['trainingName'] = this.trainingName;
    data['color'] = this.color;
    data['trainingRisedCount'] = this.trainingRisedCount;
    data['remaining_training_count'] = this.remaining_training_count;
    return data;
  }
}

class RequestList {
  int? requestUuid;
  String? requestName;
  int? unpaid_max_limit;
  int? remainingQuantity;
  int? requested_quantity;
  String? color;
  int? requestRisedCount;

  RequestList(
      {this.requestUuid,
      this.requestName,
      this.unpaid_max_limit,
      this.requested_quantity,
      this.color,
      this.requestRisedCount});

  RequestList.fromJson(Map<String, dynamic> json) {
    requestUuid = json['requestUuid'];
    requestName = json['requestName'];
    unpaid_max_limit = json['unpaidMaxLimit'];
    remainingQuantity = json['remainingQuantity'];
    requested_quantity = json['requested_quantity'];
    color = json['color'];
    requestRisedCount = json['requestRisedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['requestUuid'] = this.requestUuid;
    data['requestName'] = this.requestName;
    data['unpaidMaxLimit'] = this.unpaid_max_limit;
    data['remainingQuantity'] = this.remainingQuantity;
    data['requested_quantity'] = this.requested_quantity;
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
