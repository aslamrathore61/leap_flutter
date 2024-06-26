import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leap_flutter/Bloc/trainingBloc/training_bloc.dart';
import 'package:leap_flutter/Component/buttons/primary_button.dart';
import 'package:leap_flutter/Utils/constants.dart';
import 'package:leap_flutter/models/MentorList.dart';
import 'package:leap_flutter/models/OneToOneMentorshipPostGet.dart';
import 'package:leap_flutter/models/Profile.dart';

import '../Component/CommonComponent.dart';
import '../Component/commonRow/BorderLabeledInput.dart';
import '../Component/items/ItemMentorFilterListSrc.dart';
import '../Utils/GlabblePageRoute.dart';
import '../models/MyRequestResponse.dart';
import 'BusinessCardsScreen.dart';
import 'CalenderEventPage.dart';
import 'SuccessPage.dart';

class OneToOneMentorshipPage extends StatefulWidget {
  const OneToOneMentorshipPage(
      {Key? key, this.oneToOneMentorship, this.profileDetails})
      : super(key: key);

  final Profile? profileDetails;
  final OneToOneMentorship? oneToOneMentorship;

  @override
  State<OneToOneMentorshipPage> createState() => _OneToOneMentorshipPageState();
}

class _OneToOneMentorshipPageState extends State<OneToOneMentorshipPage> {
  final _scrollController = ScrollController();

  final TrainingBloc trainingBloc = TrainingBloc();
  final _formKey = GlobalKey<FormState>();
  bool _isSearchFocused = false;

  List<Mentors> _flyersCardListing = [];
  List<Mentors> _filteredData = [];
  Mentors? mSeletedMentor;
  String? newMontorSlotUuid;

  bool isMeetingLinkFieldVisible = true;
  bool isLocationFieldVisible = true;
  Meeting? _selecteMeeting;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _meetingAgendaController =
  TextEditingController();
  final TextEditingController _meetingTimeController = TextEditingController();
  final TextEditingController _meetingModeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _virtualMeetingLink = TextEditingController();
  final TextEditingController _meetingDateContorller = TextEditingController();

  FocusNode _searchFocusNode = FocusNode();

  String? _selectedMentorUuid;

  @override
  void initState() {
    super.initState();

    if (widget.oneToOneMentorship != null) {
      if (widget.oneToOneMentorship?.meetingAgenda != null) {
        _meetingAgendaController.text =
        widget.oneToOneMentorship!.meetingAgenda!;
      }

      _searchController.text = (widget.oneToOneMentorship != null
          ? widget.oneToOneMentorship!.mentorName
          : '')!;

      final timeSlot = TimeSlots(
          startTime: widget.oneToOneMentorship?.timeSlot,
          mentorshipMode: widget.oneToOneMentorship?.meetingMode,
          locations: widget.oneToOneMentorship?.location,
          virtualLink: widget.oneToOneMentorship?.virtualMeetingLink,
          mentorSlotUuid: widget.oneToOneMentorship?.mentorSlotUuid,
          mentorshipDate: widget.oneToOneMentorship?.mentorshipDate);
      final meeting =
      Meeting(null, null, timeSlot, null, null, null, null, null);
      _updateTextField(meeting, false);
    }

    trainingBloc.add(GetMentorListEvent());
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus) {
      _filterList(_searchController.text);
    }
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  /*** Filter data from main list  ***/
  void _filterList(String keyword) {
    keyword = keyword.toLowerCase();
    setState(() {
      _filteredData = _flyersCardListing
          .where((item) => item.mentorName!.toLowerCase().contains(keyword))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'One to One Mentorship',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: buildMentorshipListBlocProvider(context),
    );
  }

  Widget buildMentorshipListBlocProvider(BuildContext context) {
    return BlocProvider(
      create: (context) => trainingBloc,
      child: BlocListener<TrainingBloc, TrainingState>(
        listener: (context, state) {
          if (state is MentorListFetchingSuccessState) {
            if (!_flyersCardListing.isNotEmpty) {
              _flyersCardListing.addAll(state.mentorList!.mentors!);
              _filteredData.addAll(state.mentorList!.mentors! ?? []);
            }
            if (widget.oneToOneMentorship != null) {
              state.mentorList?.mentors?.forEach((element) {
                if (element.mentorUuid ==
                    widget.oneToOneMentorship?.mentorUuid) {
                  mSeletedMentor = element;
                }
              });
            }
          }
          if (state is MentorAndTrainingListFetchingError) {
            showSnackBar(context, state.str!);
          } else if (state is SubmissionTrainingSuccessState) {
            Navigator.of(context).pushReplacement(GlabblePageRoute(
                page: SuccessPage(
                    toolbarTitle: "One to One Mentorship Confirmation",
                    successDescription:
                    "Your One to One Mentorship has been scheduled successfully.")));
          }
        },
        child: buildMentorshipListWidget(context),
      ),
    );
  }

  Widget buildMentorshipListWidget(context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /***  Meeting Agenda  ***/
              Text(
                "Meeting Agenda*",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _meetingAgendaField(),
              SizedBox(
                height: 20,
              ),

              /***  Mentor Name List  ***/
              Text(
                "Mentor Name*",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _mentorNameSrchField(),
              SizedBox(
                height: 10,
              ),
              if (_isSearchFocused)
                _buildMentorListWidget(context, _filteredData),
              SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {
                  if (mSeletedMentor != null) {
                    _navigatesAndDisplaySelection(context, mSeletedMentor);
                  } else {
                    if (widget.oneToOneMentorship != null) {
                      showSnackBar(context,
                          'There are no further available slots for the ${widget.oneToOneMentorship?.mentorName}');
                    } else {
                      showSnackBar(context, 'Please select mentor');
                    }
                  }
                },
                child: BorderLabeledInput(
                  controller: _meetingDateContorller,
                  label: 'Meeting Date*',
                  icon: Icon(
                    Icons.calendar_month,
                    color: borderColor.withOpacity(0.8),
                  ),
                  press: () {},
                  enabled: false,
                  hint: 'DD-MM-YYYY', // Disable user input
                ),
              ),
              SizedBox(
                height: 10,
              ),
              buildFixedRowController(
                controller: _meetingTimeController,
                label: 'Meeting Time*',
                hint: '00:00 AM - 00:00 AM',
              ),
              SizedBox(
                height: 10,
              ),
              buildFixedRowController(
                controller: _meetingModeController,
                label: 'Meeting Mode*',
                hint: '',
              ),
              Visibility(
                visible: isLocationFieldVisible,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    buildFixedRowController(
                      controller: _locationController,
                      label: 'Location*',
                      hint: '',
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isMeetingLinkFieldVisible,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    buildFixedRowController(
                      controller: _virtualMeetingLink,
                      label: 'Virtual Meeting Link*',
                      hint: '',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<TrainingBloc, TrainingState>(
                builder: (context, state) {
                  return state is SubmissionTrainingLoadingState
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(
                    text: 'Submit',
                    press: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        if (_selecteMeeting != null) {
                          final oneToOneMentorship =
                          OneToOneMentorshipPostPut();
                          oneToOneMentorship.meetingAgenda =
                              _meetingAgendaController.text;
                          oneToOneMentorship.meetingMode = _selecteMeeting
                              ?.mentorTimeSlots?.mentorshipMode;
                          if (_selecteMeeting
                              ?.mentorTimeSlots?.mentorshipMode
                              ?.toLowerCase() ==
                              "virtual") {
                            oneToOneMentorship.virtualMeetingLink =
                                _selecteMeeting
                                    ?.mentorTimeSlots?.virtualLink;
                          } else {
                            oneToOneMentorship.location = _selecteMeeting
                                ?.mentorTimeSlots?.locations;
                          }

                          if (widget.oneToOneMentorship != null) {
                            oneToOneMentorship.mentorSlotUuidOld =
                                widget.oneToOneMentorship!.mentorSlotUuid;
                            oneToOneMentorship.mentorSlotUuidNew =
                                _selecteMeeting
                                    ?.mentorTimeSlots?.mentorSlotUuid;
                            trainingBloc.add(
                                SubmitOneToOneMentorshipEvent(
                                    oneToOneMentorshipPostGet:
                                    oneToOneMentorship,
                                    isPost: false));
                          } else {
                            oneToOneMentorship.mentorSlotUuid =
                                _selecteMeeting
                                    ?.mentorTimeSlots?.mentorSlotUuid;
                            trainingBloc.add(
                                SubmitOneToOneMentorshipEvent(
                                    oneToOneMentorshipPostGet:
                                    oneToOneMentorship,
                                    isPost: true));
                          }
                        } else {
                          showSnackBar(
                              context, 'Please select meeting date');
                        }
                      } else {
                        // Find the first error in the form and scroll to it
                        final FocusScopeNode currentFocus =
                        FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          currentFocus.focusedChild!.unfocus();
                        }

                        _scrollController.animateTo(
                          0.0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  /*** meeting agenda ***/

  Widget _meetingAgendaField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _meetingAgendaController,
      validator: requiredValidator('Meeting Agenda'),
      textInputAction: TextInputAction.next,
      style: TextStyle(
        color: titleColor,
        fontSize: 14,
      ),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        hintText: "Please Enter Meeting Agenda",
        contentPadding: kTextFieldPadding,
        border: kDefaultOutlineInputBorder.copyWith(
            borderSide: BorderSide(
              color: borderColor,
            )),
        focusedBorder: kDefaultOutlineInputBorder.copyWith(
            borderSide: BorderSide(
              color: borderColor,
            )),
        // Width of left icon
        errorMaxLines: 1, // Limit the error message to a single line
      ),
    );
  }

  /***  Search field card template ***/
  Widget _mentorNameSrchField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _searchController,
      focusNode: _searchFocusNode,
      validator: requiredValidator("Mentor Name"),
      onChanged: (value) {
        _filterList(value);
      },
      onFieldSubmitted: (value) {
        if (_formKey.currentState!.validate()) {
          // If all data are correct then save data to out variables
          _formKey.currentState!.save();

          // Once user pree on submit
        } else {}
      },
      textInputAction: TextInputAction.search,
      style: TextStyle(
        color: titleColor,
        fontSize: 14,
      ),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        hintText: "Search Mentor Name",
        contentPadding: kTextFieldPadding,
        border: kDefaultOutlineInputBorder.copyWith(
            borderSide: BorderSide(
              color: borderColor,
            )),
        focusedBorder: kDefaultOutlineInputBorder.copyWith(
            borderSide: BorderSide(
              color: borderColor,
            )),
        suffixIcon: Icon(
          Icons.search,
          color: borderColor.withOpacity(0.8),
        ),
        // Left icon
        prefixIconConstraints:
        BoxConstraints(minWidth: 40), // Width of left icon
      ),
    );
  }

  Widget _buildMentorListWidget(BuildContext context, List<Mentors> flyers) {
    if (_filteredData.isEmpty && _searchController.text.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text('No result found'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredData.length,
        itemBuilder: (context, index) {
          return ItemMentorFilterListSrc(
              itemName: _filteredData[index].mentorName!,
              onTap: () {
                mSeletedMentor = _filteredData[index];
                print('mentor ${mSeletedMentor?.toJson()}');
                _searchController.text = _filteredData[index].mentorName!;
                _selectedMentorUuid = _filteredData[index].mentorUuid;
                if (_isSearchFocused) {
                  _isSearchFocused = false;
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              });
        },
      );
    }
  }

  Future<void> _navigatesAndDisplaySelection(
      context, Mentors? mSeletedMentor) async {
    final Meeting mSeletedMeeting = await Navigator.of(context).push(
        GlabblePageRoute(page: CalenderEventPage(mentors: mSeletedMentor)));

    _updateTextField(mSeletedMeeting, true);
  }

  void _updateTextField(Meeting mSeletedMeeting, bool newValue) {
    _selecteMeeting = mSeletedMeeting;
    if (newValue == true) {
      DateTime fromTime = DateTime(
          mSeletedMeeting.from!.year,
          mSeletedMeeting.from!.month,
          mSeletedMeeting.from!.day,
          mSeletedMeeting.from!.hour,
          mSeletedMeeting.from!.minute);
      DateTime toTime = DateTime(
          mSeletedMeeting.to!.year,
          mSeletedMeeting.to!.month,
          mSeletedMeeting.to!.day,
          mSeletedMeeting.to!.hour,
          mSeletedMeeting.to!.minute);
      String formattedFromTime = DateFormat('hh:mm a')
          .format(fromTime); // Convert to 12-hour format with AM/PM
      String formattedToTime = DateFormat('hh:mm a')
          .format(toTime); // Convert to 12-hour format with AM/PM

      _meetingDateContorller.text =
      '${DateFormat('yyyy-MM-dd').format(fromTime)}';
      _meetingTimeController.text = '$formattedFromTime - $formattedToTime';
    } else {
      _meetingDateContorller.text =
      '${mSeletedMeeting.mentorTimeSlots?.mentorshipDate}';
      _meetingTimeController.text = '${mSeletedMeeting.mentorTimeSlots?.startTime}';
    }

    _locationController.text = '${mSeletedMeeting.mentorTimeSlots?.locations}';
    _meetingModeController.text =
    '${mSeletedMeeting.mentorTimeSlots?.mentorshipMode}';
    _virtualMeetingLink.text =
    '${mSeletedMeeting.mentorTimeSlots?.virtualLink}';
    if (mSeletedMeeting.mentorTimeSlots?.mentorshipMode?.toLowerCase() ==
        "virtual") {
      setState(() {
        isMeetingLinkFieldVisible = true;
        isLocationFieldVisible = false;
      });
    }else if(mSeletedMeeting.mentorTimeSlots?.mentorshipMode?.toLowerCase() ==
        "Both") {
      setState(() {
        isMeetingLinkFieldVisible = true;
        isLocationFieldVisible = true;
      });

    } else {
      setState(() {
        isMeetingLinkFieldVisible = false;
        isLocationFieldVisible = true;
      });
    }
  }
}

