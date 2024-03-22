import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leap_flutter/models/MentorList.dart';
import 'package:leap_flutter/models/TrainingProgram.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Utils/constants.dart';

class CalenderEventPage extends StatefulWidget {
  const CalenderEventPage({Key? key, this.mentors, this.training})
      : super(key: key);

  final Mentors? mentors;
  final Trainings? training;

  @override
  State<CalenderEventPage> createState() => _CalenderEventPageState();
}

class _CalenderEventPageState extends State<CalenderEventPage> {
  @override
  Widget build(BuildContext context) {
    List<DateTime> blackoutDates =
        _getAllDaysInTwelveMonths(); // Get all days in 12 months

    List<DateTime> eventDates = [];

    if (widget.mentors != null) {
      widget.mentors?.availability?.forEach((element) {
        final String? dateString = element.date;
        final DateTime date = DateTime.parse(dateString!);
        final DateTime dateTime = DateTime(date.year, date.month, date.day);
        print('dateTime, $dateTime');
        eventDates.add(dateTime);
      });
    } else {
      widget.training?.trainingSlots?.forEach((element) {
        final String? dateString = element.date;
        final DateTime date = DateTime.parse(dateString!);
        final DateTime dateTime = DateTime(date.year, date.month, date.day);
        print('dateTime, $dateTime');
        eventDates.add(dateTime);
      });
    }

    // Remove event dates from blackout dates
    eventDates.forEach((date) {
      blackoutDates.remove(date);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Event Calendar"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        child: SfCalendar(
          view: CalendarView.month,
          onTap: (CalendarTapDetails details) {
            if (details.targetElement == CalendarElement.appointment) {
              final dynamic appointment = details.appointments?.first;
              Meeting meeting = appointment;
              Navigator.pop(context, meeting);
            }
          },
          blackoutDates: blackoutDates,
          blackoutDatesTextStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Colors.black
                .withOpacity(0.6), // Set color to grey with reduced opacity
          ),

          /* blackoutDatesTextStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Colors.red,
              decoration: TextDecoration.lineThrough),*/
          dataSource: MeetingDataSource(_getDataSource()),
          monthViewSettings: MonthViewSettings(
            showTrailingAndLeadingDates: true,
            showAgenda: true,
            agendaViewHeight: 330,
            agendaItemHeight: 60,
            appointmentDisplayCount: 6,
            navigationDirection: MonthNavigationDirection.horizontal,
            monthCellStyle: MonthCellStyle(
                backgroundColor: Colors.white,
                trailingDatesBackgroundColor: Colors.grey.shade100,
                leadingDatesBackgroundColor: Colors.grey.shade50,
                todayBackgroundColor: Colors.white,
                textStyle: TextStyle(
                  color: titleColor,
                  fontSize: 12,
                ),
                trailingDatesTextStyle: TextStyle(
                  fontSize: 12,
                ),
                leadingDatesTextStyle: TextStyle(
                  fontSize: 12,
                )),
            agendaStyle: AgendaStyle(
                backgroundColor: Colors.transparent,
                appointmentTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontStyle: FontStyle.italic),
                dayTextStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontStyle: FontStyle.italic),
                dateTextStyle: TextStyle(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),

               /* placeholderTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    backgroundColor: Colors.red)*/
            ),
          ),
          todayTextStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Change the text color of today to red
          ),
        ),
      ),
    );
  }

  List<DateTime> _getAllDaysInTwelveMonths() {
    List<DateTime> days = [];
    for (int month = 1; month <= 12; month++) {
      for (int day = 1; day <= 31; day++) {
        try {
          days.add(DateTime(2024, month, day));
        } catch (e) {
          // Do nothing if the date is invalid
        }
      }
    }
    return days;
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];

    if (widget.mentors != null) {
      widget.mentors?.availability?.forEach((_element) {
        final String? dateString = _element.date;
        final DateTime date = DateTime.parse(dateString!);
        final DateTime dateTime = DateTime(date.year, date.month, date.day);

        _element.timeSlots?.forEach((element) {
          if (element.startTime != null) {
            final String? timeString = element.startTime;
            final List<String>? timeParts = timeString?.split(' ');
            final List<int> hoursMinutes =
                timeParts![0].split(':').map((e) => int.parse(e)).toList();
            int hours = hoursMinutes[0];
            if (timeParts[1].toUpperCase() == 'PM' && hours != 12) {
              hours += 12;
            }
            final int minutes = hoursMinutes[1];
            final DateTime time = dateTime.add(Duration(hours: hours, minutes: minutes));

            DateTime startTime = _parseTime(element.startTime, _element.date);
            DateTime endTime = _parseTime(element.endTime, _element.date);

            Duration duration = endTime.difference(startTime);
            final DateTime end = time.add(duration);

            meetings.add(Meeting(
                'Meeting Mode : ${element.mentorshipMode!}',
                element.locations,
                element,
                null,
                time,
                end,
                getRandomColor().withOpacity(0.7),
                false));
          }
        });
      });
    } else {
      widget.training?.trainingSlots?.forEach((_element) {
        final String? dateString = _element.date;
        final DateTime date = DateTime.parse(dateString!);
        final DateTime dateTime = DateTime(date.year, date.month, date.day);

        _element.timeSlots?.forEach((element) {
          final String? timeString = element.startTime;
          final List<String>? timeParts = timeString?.split(' ');
          final List<int> hoursMinutes =
              timeParts![0].split(':').map((e) => int.parse(e)).toList();
          int hours = hoursMinutes[0];
          if (timeParts[1].toUpperCase() == 'PM' && hours != 12) {
            hours += 12;
          }
          final int minutes = hoursMinutes[1];
          final DateTime time = dateTime.add(Duration(hours: hours, minutes: minutes));



          DateTime startTime = _parseTime(element.startTime, _element.date);
          DateTime endTime = _parseTime(element.endTime, _element.date);

          Duration duration = endTime.difference(startTime);
          final DateTime end = time.add(duration);

          element.trainerName = widget.training?.trainerName;
          meetings.add(Meeting(
              'Training Mode : ${element.trainingMode!}',
              element.location,
              null,
              element,
              time,
              end,
              getRandomColor().withOpacity(0.7),
              false));
        });
      });
    }

    return meetings;
  }
}

DateTime _parseTime(String? timeString, String? dateString) {
  final parts = timeString!.split(' ');
  final time = parts[0];
  final period = parts[1];

  final timeParts = time.split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  if (period == 'PM' && hour != 12) {
    hour += 12;
  } else if (period == 'AM' && hour == 12) {
    hour = 0;
  }

  List<String> dateParts = dateString!.split("-");

  return DateTime(int.parse(dateParts[0]), int.parse(dateParts[1]), int.parse(dateParts[2]), hour, minute);
}

// calender model

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  String? getLocation(int index) {
    return appointments![index].location;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(
      this.eventName,
      this.location,
      this.mentorTimeSlots,
      this.trainingTimeSlots,
      this.from,
      this.to,
      this.background,
      this.isAllDay);

  String? eventName;
  String? location;
  TimeSlots? mentorTimeSlots;
  TrainingTimeSlots? trainingTimeSlots;
  DateTime? from;
  DateTime? to;
  Color? background;
  bool? isAllDay;
}
