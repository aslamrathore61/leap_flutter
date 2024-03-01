import 'dart:convert';

MyRequestResponse myRequestResponseFromJson(String str) =>
    MyRequestResponse.fromJson(json.decode(str));

String myRequestResponseToJson(MyRequestResponse data) =>
    json.encode(data.toJson());

class MyRequestResponse {
  MyRequestResponse({
    this.oneToOneMentorship,
    this.corporateTraining,
    this.businessCards,
    this.flyers,
    this.error,
  });

  MyRequestResponse.withError(String errorMessage) {
    error = errorMessage;
  }

  MyRequestResponse.fromJson(dynamic json) {
    if (json['oneToOneMentorship'] != null) {
      oneToOneMentorship = [];
      json['oneToOneMentorship'].forEach((v) {
        oneToOneMentorship?.add(OneToOneMentorship.fromJson(v));
      });
    }
    if (json['corporateTraining'] != null) {
      corporateTraining = [];
      json['corporateTraining'].forEach((v) {
        corporateTraining?.add(CorporateTraining.fromJson(v));
      });
    }
    if (json['businessCards'] != null) {
      businessCards = [];
      json['businessCards'].forEach((v) {
        businessCards?.add(BusinessCards.fromJson(v));
      });
    }
    if (json['flyers'] != null) {
      flyers = [];
      json['flyers'].forEach((v) {
        flyers?.add(Flyers.fromJson(v));
      });
    }
  }

  List<OneToOneMentorship>? oneToOneMentorship;
  List<CorporateTraining>? corporateTraining;
  List<BusinessCards>? businessCards;
  List<Flyers>? flyers;
  String? error;

  MyRequestResponse copyWith({
    List<OneToOneMentorship>? oneToOneMentorship,
    List<CorporateTraining>? corporateTraining,
    List<BusinessCards>? businessCards,
    List<Flyers>? flyers,
  }) =>
      MyRequestResponse(
        oneToOneMentorship: oneToOneMentorship ?? this.oneToOneMentorship,
        corporateTraining: corporateTraining ?? this.corporateTraining,
        businessCards: businessCards ?? this.businessCards,
        flyers: flyers ?? this.flyers,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (oneToOneMentorship != null) {
      map['oneToOneMentorship'] =
          oneToOneMentorship?.map((v) => v.toJson()).toList();
    }
    if (corporateTraining != null) {
      map['corporateTraining'] =
          corporateTraining?.map((v) => v.toJson()).toList();
    }
    if (businessCards != null) {
      map['businessCards'] = businessCards?.map((v) => v.toJson()).toList();
    }
    if (flyers != null) {
      map['flyers'] = flyers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Flyers flyersFromJson(String str) => Flyers.fromJson(json.decode(str));

String flyersToJson(Flyers data) => json.encode(data.toJson());

class Flyers {
  Flyers({
    this.requestBy,
    this.flyerRequestUuid,
    this.allocatedDate,
    this.requestQuantity,
    this.statusUuid,
    this.statusName,
    this.statusColor,
    this.archivedStatus,
    this.flyerImageUrl,
    this.flyerType,
    this.flyerName,
    this.flyerUuid,
    this.printName,
    this.printEmail,
    this.printPhoneNumber,
    this.printDescription,
  });

  Flyers.fromJson(dynamic json) {
    requestBy = json['requestBy'];
    flyerRequestUuid = json['flyerRequestUuid'];
    allocatedDate = json['allocatedDate'];
    requestQuantity = json['requestQuantity'];
    statusUuid = json['statusUuid'];
    statusName = json['statusName'];
    statusColor = json['statusColor'];
    archivedStatus = json['archivedStatus'];
    flyerImageUrl = json['flyerImageUrl'];
    flyerType = json['flyerType'];
    flyerName = json['flyerName'];
    flyerUuid = json['flyerUuid'];
    printName = json['printName'];
    printEmail = json['printEmail'];
    printPhoneNumber = json['printPhoneNumber'];
    printDescription = json['printDescription'];
  }

  String? requestBy;
  String? flyerRequestUuid;
  String? allocatedDate;
  String? requestQuantity;
  String? statusUuid;
  String? statusName;
  String? statusColor;
  int? archivedStatus;
  String? flyerImageUrl;
  String? flyerType;
  String? flyerName;
  String? flyerUuid;
  String? printName;
  String? printEmail;
  String? printPhoneNumber;
  String? printDescription;

  Flyers copyWith({
    String? requestBy,
    String? flyerRequestUuid,
    String? allocatedDate,
    String? requestQuantity,
    String? statusUuid,
    String? statusName,
    String? statusColor,
    int? archivedStatus,
    String? flyerImageUrl,
    String? flyerType,
    String? flyerName,
    String? flyerUuid,
    String? printName,
    String? printEmail,
    String? printPhoneNumber,
    String? printDescription,
  }) =>
      Flyers(
        requestBy: requestBy ?? this.requestBy,
        flyerRequestUuid: flyerRequestUuid ?? this.flyerRequestUuid,
        allocatedDate: allocatedDate ?? this.allocatedDate,
        requestQuantity: requestQuantity ?? this.requestQuantity,
        statusUuid: statusUuid ?? this.statusUuid,
        statusName: statusName ?? this.statusName,
        statusColor: statusColor ?? this.statusColor,
        archivedStatus: archivedStatus ?? this.archivedStatus,
        flyerImageUrl: flyerImageUrl ?? this.flyerImageUrl,
        flyerType: flyerType ?? this.flyerType,
        flyerName: flyerName ?? this.flyerName,
        flyerUuid: flyerUuid ?? this.flyerUuid,
        printName: printName ?? this.printName,
        printEmail: printEmail ?? this.printEmail,
        printPhoneNumber: printPhoneNumber ?? this.printPhoneNumber,
        printDescription: printDescription ?? this.printDescription,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestBy'] = requestBy;
    map['flyerRequestUuid'] = flyerRequestUuid;
    map['allocatedDate'] = allocatedDate;
    map['requestQuantity'] = requestQuantity;
    map['statusUuid'] = statusUuid;
    map['statusName'] = statusName;
    map['statusColor'] = statusColor;
    map['archivedStatus'] = archivedStatus;
    map['flyerImageUrl'] = flyerImageUrl;
    map['flyerType'] = flyerType;
    map['flyerName'] = flyerName;
    map['flyerUuid'] = flyerUuid;
    map['printName'] = printName;
    map['printEmail'] = printEmail;
    map['printPhoneNumber'] = printPhoneNumber;
    map['printDescription'] = printDescription;
    return map;
  }
}

BusinessCards businessCardsFromJson(String str) =>
    BusinessCards.fromJson(json.decode(str));

String businessCardsToJson(BusinessCards data) => json.encode(data.toJson());

class BusinessCards {
  BusinessCards({
    this.requestBy,
    this.vcardRequestUuid,
    this.allocatedDate,
    this.requestQuantity,
    this.statusUuid,
    this.statusName,
    this.statusColor,
    this.isStatusProofRead,
    this.archivedStatus,
    this.vcardImageUuid,
    this.vcardImageUrl,
    this.vcardType,
    this.vcardName,
    this.vcardUuid,
    this.printimage,
    this.printName,
    this.printEmail,
    this.printPhoneNumber,
    this.printAddress,
    this.proofRead,
  });

  BusinessCards.fromJson(dynamic json) {
    requestBy = json['requestBy'];
    vcardRequestUuid = json['vcardRequestUuid'];
    allocatedDate = json['allocatedDate'];
    requestQuantity = json['requestQuantity'];
    statusUuid = json['statusUuid'];
    statusName = json['statusName'];
    statusColor = json['statusColor'];
    isStatusProofRead = json['isStatusProofRead'];
    archivedStatus = json['archivedStatus'];
    vcardImageUuid = json['vcardImageUuid'];
    vcardImageUrl = json['vcardImageUrl'];
    vcardType = json['vcardType'];
    vcardName = json['vcardName'];
    vcardUuid = json['vcardUuid'];
    printimage = json['printimage'];
    printName = json['printName'];
    printEmail = json['printEmail'];
    printPhoneNumber = json['printPhoneNumber'];
    printAddress = json['printAddress'];
    proofRead = json['proofRead'];
  }

  String? requestBy;
  String? vcardRequestUuid;
  String? allocatedDate;
  String? requestQuantity;
  String? statusUuid;
  String? statusName;
  String? statusColor;
  bool? isStatusProofRead;
  int? archivedStatus;
  String? vcardImageUuid;
  String? vcardImageUrl;
  String? vcardType;
  String? vcardName;
  String? vcardUuid;
  dynamic printimage;
  String? printName;
  String? printEmail;
  String? printPhoneNumber;
  String? printAddress;
  dynamic proofRead;

  BusinessCards copyWith({
    String? requestBy,
    String? vcardRequestUuid,
    String? allocatedDate,
    String? requestQuantity,
    String? statusUuid,
    String? statusName,
    String? statusColor,
    bool? isStatusProofRead,
    int? archivedStatus,
    String? vcardImageUuid,
    String? vcardImageUrl,
    String? vcardType,
    String? vcardName,
    String? vcardUuid,
    dynamic printimage,
    String? printName,
    String? printEmail,
    String? printPhoneNumber,
    String? printAddress,
    dynamic proofRead,
  }) =>
      BusinessCards(
        requestBy: requestBy ?? this.requestBy,
        vcardRequestUuid: vcardRequestUuid ?? this.vcardRequestUuid,
        allocatedDate: allocatedDate ?? this.allocatedDate,
        requestQuantity: requestQuantity ?? this.requestQuantity,
        statusUuid: statusUuid ?? this.statusUuid,
        statusName: statusName ?? this.statusName,
        statusColor: statusColor ?? this.statusColor,
        isStatusProofRead: isStatusProofRead ?? this.isStatusProofRead,
        archivedStatus: archivedStatus ?? this.archivedStatus,
        vcardImageUuid: vcardImageUuid ?? this.vcardImageUuid,
        vcardImageUrl: vcardImageUrl ?? this.vcardImageUrl,
        vcardType: vcardType ?? this.vcardType,
        vcardName: vcardName ?? this.vcardName,
        vcardUuid: vcardUuid ?? this.vcardUuid,
        printimage: printimage ?? this.printimage,
        printName: printName ?? this.printName,
        printEmail: printEmail ?? this.printEmail,
        printPhoneNumber: printPhoneNumber ?? this.printPhoneNumber,
        printAddress: printAddress ?? this.printAddress,
        proofRead: proofRead ?? this.proofRead,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestBy'] = requestBy;
    map['vcardRequestUuid'] = vcardRequestUuid;
    map['allocatedDate'] = allocatedDate;
    map['requestQuantity'] = requestQuantity;
    map['statusUuid'] = statusUuid;
    map['statusName'] = statusName;
    map['statusColor'] = statusColor;
    map['isStatusProofRead'] = isStatusProofRead;
    map['archivedStatus'] = archivedStatus;
    map['vcardImageUuid'] = vcardImageUuid;
    map['vcardImageUrl'] = vcardImageUrl;
    map['vcardType'] = vcardType;
    map['vcardName'] = vcardName;
    map['vcardUuid'] = vcardUuid;
    map['printimage'] = printimage;
    map['printName'] = printName;
    map['printEmail'] = printEmail;
    map['printPhoneNumber'] = printPhoneNumber;
    map['printAddress'] = printAddress;
    map['proofRead'] = proofRead;
    return map;
  }
}

CorporateTraining corporateTrainingFromJson(String str) =>
    CorporateTraining.fromJson(json.decode(str));

String corporateTrainingToJson(CorporateTraining data) =>
    json.encode(data.toJson());

class CorporateTraining {
  CorporateTraining({
    this.bookedBy,
    this.trainingBookingUuid,
    this.trainingName,
    this.trainingUuid,
    this.trainerName,
    this.trainerUuid,
    this.allocatedDate,
    this.timeSlot,
    this.statusUuid,
    this.statusName,
    this.statusColor,
    this.archivedStatus,
    this.trainingAgenda,
    this.trainingMode,
    this.location,
    this.virtualMeetingLink,
  });

  CorporateTraining.fromJson(dynamic json) {
    bookedBy = json['bookedBy'];
    trainingBookingUuid = json['trainingBookingUuid'];
    trainingName = json['trainingName'];
    trainingUuid = json['trainingUuid'];
    trainerName = json['trainerName'];
    trainerUuid = json['trainerUuid'];
    allocatedDate = json['allocatedDate'];
    timeSlot = json['timeSlot'];
    statusUuid = json['statusUuid'];
    statusName = json['statusName'];
    statusColor = json['statusColor'];
    archivedStatus = json['archivedStatus'];
    trainingAgenda = json['trainingAgenda'];
    trainingMode = json['training_mode'];
    location = json['location'];
    virtualMeetingLink = json['virtualMeetingLink'];
  }

  String? bookedBy;
  String? trainingBookingUuid;
  String? trainingName;
  String? trainingUuid;
  String? trainerName;
  String? trainerUuid;
  String? allocatedDate;
  String? timeSlot;
  String? statusUuid;
  String? statusName;
  String? statusColor;
  int? archivedStatus;
  String? trainingAgenda;
  String? trainingMode;
  String? location;
  String? virtualMeetingLink;

  CorporateTraining copyWith({
    String? bookedBy,
    String? trainingBookingUuid,
    String? trainingName,
    String? trainingUuid,
    String? trainerName,
    String? trainerUuid,
    String? allocatedDate,
    String? timeSlot,
    String? statusUuid,
    String? statusName,
    String? statusColor,
    int? archivedStatus,
    String? trainingAgenda,
    String? trainingMode,
    String? location,
    String? virtualMeetingLink,
  }) =>
      CorporateTraining(
        bookedBy: bookedBy ?? this.bookedBy,
        trainingBookingUuid: trainingBookingUuid ?? this.trainingBookingUuid,
        trainingName: trainingName ?? this.trainingName,
        trainingUuid: trainingUuid ?? this.trainingUuid,
        trainerName: trainerName ?? this.trainerName,
        trainerUuid: trainerUuid ?? this.trainerUuid,
        allocatedDate: allocatedDate ?? this.allocatedDate,
        timeSlot: timeSlot ?? this.timeSlot,
        statusUuid: statusUuid ?? this.statusUuid,
        statusName: statusName ?? this.statusName,
        statusColor: statusColor ?? this.statusColor,
        archivedStatus: archivedStatus ?? this.archivedStatus,
        trainingAgenda: trainingAgenda ?? this.trainingAgenda,
        trainingMode: trainingMode ?? this.trainingMode,
        location: location ?? this.location,
        virtualMeetingLink: virtualMeetingLink ?? this.virtualMeetingLink,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bookedBy'] = bookedBy;
    map['trainingBookingUuid'] = trainingBookingUuid;
    map['trainingName'] = trainingName;
    map['trainingUuid'] = trainingUuid;
    map['trainerName'] = trainerName;
    map['trainerUuid'] = trainerUuid;
    map['allocatedDate'] = allocatedDate;
    map['timeSlot'] = timeSlot;
    map['statusUuid'] = statusUuid;
    map['statusName'] = statusName;
    map['statusColor'] = statusColor;
    map['archivedStatus'] = archivedStatus;
    map['trainingAgenda'] = trainingAgenda;
    map['training_mode'] = trainingMode;
    map['location'] = location;
    map['virtualMeetingLink'] = virtualMeetingLink;
    return map;
  }
}

OneToOneMentorship oneToOneMentorshipFromJson(String str) =>
    OneToOneMentorship.fromJson(json.decode(str));

String oneToOneMentorshipToJson(OneToOneMentorship data) =>
    json.encode(data.toJson());

class OneToOneMentorship {
  OneToOneMentorship({
    this.bookedBy,
    this.mentorUuid,
    this.mentorSlotUuid,
    this.mentorName,
    this.mentorshipDate,
    this.timeSlot,
    this.statusUuid,
    this.statusName,
    this.statusColor,
    this.archivedStatus,
    this.meetingAgenda,
    this.meetingMode,
    this.location,
    this.virtualMeetingLink,
  });

  OneToOneMentorship.fromJson(dynamic json) {
    bookedBy = json['bookedBy'];
    mentorUuid = json['mentorUuid'];
    mentorSlotUuid = json['mentorSlotUuid'];
    mentorName = json['mentorName'];
    mentorshipDate = json['mentorshipDate'];
    timeSlot = json['timeSlot'];
    statusUuid = json['statusUuid'];
    statusName = json['statusName'];
    statusColor = json['statusColor'];
    archivedStatus = json['archivedStatus'];
    meetingAgenda = json['meetingAgenda'];
    meetingMode = json['meetingMode'];
    location = json['location'];
    virtualMeetingLink = json['virtualMeetingLink'];
  }

  String? bookedBy;
  String? mentorUuid;
  String? mentorSlotUuid;
  String? mentorName;
  String? mentorshipDate;
  String? timeSlot;
  String? statusUuid;
  String? statusName;
  String? statusColor;
  int? archivedStatus;
  String? meetingAgenda;
  String? meetingMode;
  String? location;
  dynamic virtualMeetingLink;

  OneToOneMentorship copyWith({
    String? bookedBy,
    String? mentorUuid,
    String? mentorSlotUuid,
    String? mentorName,
    String? mentorshipDate,
    String? timeSlot,
    String? statusUuid,
    String? statusName,
    String? statusColor,
    int? archivedStatus,
    String? meetingAgenda,
    String? meetingMode,
    String? location,
    dynamic virtualMeetingLink,
  }) =>
      OneToOneMentorship(
        bookedBy: bookedBy ?? this.bookedBy,
        mentorUuid: mentorUuid ?? this.mentorUuid,
        mentorSlotUuid: mentorSlotUuid ?? this.mentorSlotUuid,
        mentorName: mentorName ?? this.mentorName,
        mentorshipDate: mentorshipDate ?? this.mentorshipDate,
        timeSlot: timeSlot ?? this.timeSlot,
        statusUuid: statusUuid ?? this.statusUuid,
        statusName: statusName ?? this.statusName,
        statusColor: statusColor ?? this.statusColor,
        archivedStatus: archivedStatus ?? this.archivedStatus,
        meetingAgenda: meetingAgenda ?? this.meetingAgenda,
        meetingMode: meetingMode ?? this.meetingMode,
        location: location ?? this.location,
        virtualMeetingLink: virtualMeetingLink ?? this.virtualMeetingLink,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bookedBy'] = bookedBy;
    map['mentorUuid'] = mentorUuid;
    map['mentorSlotUuid'] = mentorSlotUuid;
    map['mentorName'] = mentorName;
    map['mentorshipDate'] = mentorshipDate;
    map['timeSlot'] = timeSlot;
    map['statusUuid'] = statusUuid;
    map['statusName'] = statusName;
    map['statusColor'] = statusColor;
    map['archivedStatus'] = archivedStatus;
    map['meetingAgenda'] = meetingAgenda;
    map['meetingMode'] = meetingMode;
    map['location'] = location;
    map['virtualMeetingLink'] = virtualMeetingLink;
    return map;
  }
}
