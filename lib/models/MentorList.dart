class MentorList {
  List<Mentors>? mentors;
  String? error;

  MentorList({this.mentors});

  MentorList.fromJson(Map<String, dynamic> json) {
    if (json['mentors'] != null) {
      mentors = <Mentors>[];
      json['mentors'].forEach((v) {
        mentors!.add(new Mentors.fromJson(v));
      });
    }
  }

  MentorList.withError(String errorMessage) {
    error = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mentors != null) {
      data['mentors'] = this.mentors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mentors {
  String? mentorName;
  String? mentorUuid;
  String? department;
  List<Availability>? availability;

  Mentors(
      {this.mentorName, this.mentorUuid, this.department, this.availability});

  Mentors.fromJson(Map<String, dynamic> json) {
    mentorName = json['mentorName'];
    mentorUuid = json['mentorUuid'];
    department = json['department'];
    if (json['availability'] != null) {
      availability = <Availability>[];
      json['availability'].forEach((v) {
        availability!.add(new Availability.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mentorName'] = this.mentorName;
    data['mentorUuid'] = this.mentorUuid;
    data['department'] = this.department;
    if (this.availability != null) {
      data['availability'] = this.availability!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Availability {
  String? date;
  List<TimeSlots>? timeSlots;

  Availability({this.date, this.timeSlots});

  Availability.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['timeSlots'] != null) {
      timeSlots = <TimeSlots>[];
      json['timeSlots'].forEach((v) {
        timeSlots!.add(new TimeSlots.fromJson(v));
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

class TimeSlots {
  String? startTime;
  String? endTime;
  String? mentorshipMode;
  String? locations;
  String? virtualLink;
  String? mentorSlotUuid;
  String? mentorshipDate;

  TimeSlots(
      {this.startTime,
        this.endTime,
        this.mentorshipMode,
        this.locations,
        this.virtualLink,
        this.mentorSlotUuid,
        this.mentorshipDate
      });

  TimeSlots.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    mentorshipMode = json['mentorshipMode'];
    locations = json['locations'];
    virtualLink = json['virtualLink'];
    mentorSlotUuid = json['mentorSlotUuid'];
    mentorshipDate = json['mentorshipDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['mentorshipMode'] = this.mentorshipMode;
    data['locations'] = this.locations;
    data['virtualLink'] = this.virtualLink;
    data['mentorSlotUuid'] = this.mentorSlotUuid;
    data['mentorshipDate'] = this.mentorshipDate;
    return data;
  }
}