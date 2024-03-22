class TrainingProgram {
  List<Trainings>? trainings;
  String? error;

  TrainingProgram({this.trainings, this.error});

  TrainingProgram.fromJson(Map<String, dynamic> json) {
    if (json['trainings'] != null) {
      trainings = <Trainings>[];
      json['trainings'].forEach((v) {
        trainings!.add(new Trainings.fromJson(v));
      });
    }
  }

  TrainingProgram.withError(String errorMessage) {
    error = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trainings != null) {
      data['trainings'] = this.trainings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trainings {
  String? trainingName;
  String? trainingUuid;
  String? trainerName;
  String? trainerUuid;
  List<TrainingSlots>? trainingSlots;

  Trainings(
      {this.trainingName,
      this.trainingUuid,
      this.trainerName,
      this.trainerUuid,
      this.trainingSlots});

  Trainings.fromJson(Map<String, dynamic> json) {
    trainingName = json['trainingName'];
    trainingUuid = json['trainingUuid'];
    trainerName = json['trainerName'];
    trainerUuid = json['trainerUuid'];
    if (json['trainingSlots'] != null) {
      trainingSlots = <TrainingSlots>[];
      json['trainingSlots'].forEach((v) {
        trainingSlots!.add(new TrainingSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trainingName'] = this.trainingName;
    data['trainingUuid'] = this.trainingUuid;
    data['trainerName'] = this.trainerName;
    data['trainerUuid'] = this.trainerUuid;
    if (this.trainingSlots != null) {
      data['trainingSlots'] =
          this.trainingSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrainingSlots {
  String? date;
  List<TrainingTimeSlots>? timeSlots;

  TrainingSlots({this.date, this.timeSlots});

  TrainingSlots.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['timeSlots'] != null) {
      timeSlots = <TrainingTimeSlots>[];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(new TrainingTimeSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.timeSlots != null) {
      data['timeSlots'] = this.timeSlots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrainingTimeSlots {
  String? startTime;
  String? endTime;
  int? totalSeats;
  int? availableSeats;
  String? trainingMode;
  String? virtualLink;
  String? location;
  int? duration;
  String? trainingSlotUuid;
  String? allocatedDate;
  String? trainerName;

  TrainingTimeSlots(
      {this.startTime,
      this.endTime,
      this.totalSeats,
      this.availableSeats,
      this.trainingMode,
      this.virtualLink,
      this.location,
      this.duration,
      this.trainingSlotUuid,
      this.allocatedDate,
      this.trainerName});

  TrainingTimeSlots.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    totalSeats = json['totalSeats'];
    availableSeats = json['availableSeats'];
    trainingMode = json['trainingMode'];
    virtualLink = json['virtualLink'];
    location = json['location'];
    duration = json['duration'];
    trainingSlotUuid = json['trainingSlotUuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['totalSeats'] = this.totalSeats;
    data['availableSeats'] = this.availableSeats;
    data['trainingMode'] = this.trainingMode;
    data['virtualLink'] = this.virtualLink;
    data['location'] = this.location;
    data['duration'] = this.duration;
    data['trainingSlotUuid'] = this.trainingSlotUuid;
    return data;
  }
}

/*  Update and Crate Training  Program*/
class CorporateTrainingPostPut {
  String? trainingSlotUuid;
  String? trainingBookingUuid;

  CorporateTrainingPostPut({this.trainingSlotUuid, this.trainingBookingUuid});

  CorporateTrainingPostPut.fromJson(Map<String, dynamic> json) {
    trainingSlotUuid = json['trainingSlotUuid'];
    trainingBookingUuid = json['trainingBookingUuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trainingSlotUuid'] = this.trainingSlotUuid;
    data['trainingBookingUuid'] = this.trainingBookingUuid;
    return data;
  }
}
