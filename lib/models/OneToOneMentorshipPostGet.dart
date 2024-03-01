class OneToOneMentorshipPostPut {
  String? mentorSlotUuid;
  String? mentorSlotUuidNew;
  String? mentorSlotUuidOld;
  String? meetingAgenda;
  String? meetingMode;
  String? location;
  String? virtualMeetingLink;

  OneToOneMentorshipPostPut(
      {this.mentorSlotUuid,
      this.mentorSlotUuidNew,
      this.mentorSlotUuidOld,
      this.meetingAgenda,
      this.meetingMode,
      this.location,
      this.virtualMeetingLink});

  OneToOneMentorshipPostPut.fromJson(Map<String, dynamic> json) {
    mentorSlotUuid = json['mentorSlotUuid'];
    mentorSlotUuidNew = json['mentorSlotUuidNew'];
    mentorSlotUuidOld = json['mentorSlotUuidOld'];
    meetingAgenda = json['meetingAgenda'];
    meetingMode = json['meetingMode'];
    location = json['location'];
    virtualMeetingLink = json['virtualMeetingLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mentorSlotUuid'] = this.mentorSlotUuid;
    data['mentorSlotUuidNew'] = this.mentorSlotUuidNew;
    data['mentorSlotUuidOld'] = this.mentorSlotUuidOld;
    data['meetingAgenda'] = this.meetingAgenda;
    data['meetingMode'] = this.meetingMode;
    data['location'] = this.location;
    data['virtualMeetingLink'] = this.virtualMeetingLink;
    return data;
  }
}
