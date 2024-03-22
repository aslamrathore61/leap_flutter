import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:leap_flutter/Bloc/trainingBloc/training_bloc.dart';
import 'package:leap_flutter/Component/buttons/primary_button.dart';
import 'package:leap_flutter/Utils/constants.dart';
import 'package:leap_flutter/models/OneToOneMentorshipPostGet.dart';
import 'package:leap_flutter/models/Profile.dart';
import '../Component/CommonComponent.dart';
import '../Component/commonRow/BorderLabeledInput.dart';
import '../Component/items/ItemMentorFilterListSrc.dart';
import '../Utils/GlabblePageRoute.dart';
import '../models/MyRequestResponse.dart';
import '../models/TrainingProgram.dart';
import 'CalenderEventPage.dart';
import 'SuccessPage.dart';

class CorporateTrainingPage extends StatefulWidget {
  const CorporateTrainingPage(
      {Key? key, this.corporateTraining, this.profileDetails})
      : super(key: key);

  final Profile? profileDetails;
  final CorporateTraining? corporateTraining;

  @override
  State<CorporateTrainingPage> createState() => _OneToOneMentorshipPageState();
}

class _OneToOneMentorshipPageState extends State<CorporateTrainingPage> {
  final _scrollController = ScrollController();

  final TrainingBloc trainingBloc = TrainingBloc();
  final _formKey = GlobalKey<FormState>();
  bool _isSearchFocused = false;

  List<Trainings> _flyersCardListing = [];
  List<Trainings> _filteredData = [];
  Trainings? mSeletedTraining;

  bool isMeetingLinkFieldVisible = true;
  bool isLocationFieldVisible = true;
  Meeting? _selecteMeeting;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _trainingTimeController = TextEditingController();
  final TextEditingController _trainingTypeController = TextEditingController();
  final TextEditingController _trainerNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _virtualMeetingLink = TextEditingController();
  final TextEditingController _trainingDateContorller = TextEditingController();

  FocusNode _searchFocusNode = FocusNode();

  String? _selectedMentorUuid;

  @override
  void initState() {
    super.initState();

    if (widget.corporateTraining != null) {
      _searchController.text = (widget.corporateTraining != null
          ? widget.corporateTraining!.trainingName
          : '')!;

      final timeSlot = TrainingTimeSlots(
          startTime: widget.corporateTraining?.timeSlot,
          trainingMode: widget.corporateTraining?.trainingMode,
          trainingSlotUuid: widget.corporateTraining?.trainingBookingUuid,
          location: widget.corporateTraining?.location,
          virtualLink: widget.corporateTraining?.virtualMeetingLink,
          allocatedDate: widget.corporateTraining?.allocatedDate,
          trainerName: widget.corporateTraining?.trainerName);
      final meeting =
          Meeting(null, null, null, timeSlot, null, null, null, null);
      _updateTextField(meeting, false);
    }

    trainingBloc.add(GetTrainingProgramListEvent());
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
          .where((item) =>
              item.trainerName!.toLowerCase().contains(keyword) ||
              item.trainingName!.toLowerCase().contains(keyword))
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
          'Corporate Training',
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
          if (state is TrainingProgramListFetchingSuccessState) {
            if (!_flyersCardListing.isNotEmpty) {
              _flyersCardListing.addAll(state.trainingProgram!.trainings!);
              _filteredData.addAll(state.trainingProgram!.trainings! ?? []);
            }
            if (widget.corporateTraining != null) {
              state.trainingProgram?.trainings?.forEach((element) {
                if (element.trainingUuid ==
                    widget.corporateTraining?.trainingUuid) {
                  mSeletedTraining = element;
                }
              });
            }
          } else if (state is SubmissionTrainingSuccessState) {
            Navigator.of(context).pushReplacement(GlabblePageRoute(
                page: SuccessPage(
                    toolbarTitle: "Corporate Training Confirmation",
                    successDescription:
                        "Your corporate training has been scheduled successfully.")));
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
              /***  Mentor Name List  ***/

              SizedBox(
                height: 10,
              ),
              Text(
                "Training Program*",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _trainingProgramsSrchField(),
              SizedBox(
                height: 10,
              ),
              if (_isSearchFocused)
                _buildMentorListWidget(context, _filteredData),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  if (mSeletedTraining != null) {
                    _navigatesAndDisplaySelection(context, mSeletedTraining);
                  } else {
                    if (widget.corporateTraining != null) {
                      showSnackBar(context,
                          'There are no further available slots for the ${widget.corporateTraining?.trainerName}');
                    } else {
                      showSnackBar(context, 'Please select program name.');
                    }
                  }
                },
                child: BorderLabeledInput(
                  controller: _trainingDateContorller,
                  label: 'Training Date*',
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
                controller: _trainingTimeController,
                label: 'Training Time*',
                hint: '00:00 AM - 00:00 AM',
              ),
              SizedBox(
                height: 10,
              ),
              buildFixedRowController(
                controller: _trainerNameController,
                label: 'Trainer Name*',
                hint: '',
              ),
              SizedBox(
                height: 10,
              ),
              buildFixedRowController(
                controller: _trainingTypeController,
                label: 'Training Type',
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
                      controller: _locationController,
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
                                if (_trainingTimeController.text.isEmpty) {
                                  showSnackBar(
                                      context, 'Please select training slot');
                                  return;
                                }
                                final corporateTrainingPostPut =
                                    CorporateTrainingPostPut();
                                corporateTrainingPostPut.trainingSlotUuid =
                                    _selecteMeeting
                                        ?.trainingTimeSlots?.trainingSlotUuid;

                                if (widget.corporateTraining != null) {
                                  corporateTrainingPostPut.trainingBookingUuid =
                                      widget.corporateTraining!
                                          .trainingBookingUuid;
                                  trainingBloc.add(
                                      SubmitCorporateTrainingpEvent(
                                          corporateTrainingPostPut:
                                              corporateTrainingPostPut,
                                          isPost: false));
                                } else {
                                  trainingBloc.add(
                                      SubmitCorporateTrainingpEvent(
                                          corporateTrainingPostPut:
                                              corporateTrainingPostPut,
                                          isPost: true));
                                }
                              } else {
                                showSnackBar(
                                    context, 'Please select training program');
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

  /***  Search field card template ***/
  Widget _trainingProgramsSrchField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _searchController,
      focusNode: _searchFocusNode,
      validator: requiredValidator('Training Program'),
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
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        hintText: "Search Training Programs",
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

  Widget _buildMentorListWidget(BuildContext context, List<Trainings> flyers) {
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
              itemName: _filteredData[index].trainingName!,
              onTap: () {
                mSeletedTraining = _filteredData[index];
                _searchController.text = _filteredData[index].trainingName!;
                _selectedMentorUuid = _filteredData[index].trainingUuid;
                // clear all other filed when choose new training
                _trainingTimeController.text = '';
                _trainerNameController.text = '';
                _trainingTypeController.text = '';
                _locationController.text = '';
                _virtualMeetingLink.text = '';

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
      context, Trainings? mSeletedTraining) async {
    final Meeting mSeletedMeeting = await Navigator.of(context).push(
        GlabblePageRoute(page: CalenderEventPage(training: mSeletedTraining)));

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

      _trainingDateContorller.text =
          '${DateFormat('yyyy-MM-dd').format(fromTime)}';
      _trainingTimeController.text = '$formattedFromTime - $formattedToTime';
    } else {
      _trainingDateContorller.text =
          '${mSeletedMeeting.trainingTimeSlots?.allocatedDate}';
      _trainingTimeController.text =
          '${mSeletedMeeting.trainingTimeSlots?.startTime}';
    }

    _locationController.text = '${mSeletedMeeting.trainingTimeSlots?.location}';
    _trainerNameController.text =
        '${mSeletedMeeting.trainingTimeSlots?.trainerName}';
    _trainingTypeController.text =
        '${mSeletedMeeting.trainingTimeSlots?.trainingMode}';
    _virtualMeetingLink.text =
        '${mSeletedMeeting.trainingTimeSlots?.virtualLink}';
    if (mSeletedMeeting.trainingTimeSlots?.trainingMode?.toLowerCase() ==
        "virtual") {
      setState(() {
        isMeetingLinkFieldVisible = true;
        isLocationFieldVisible = false;
      });
    } else {
      setState(() {
        isMeetingLinkFieldVisible = false;
        isLocationFieldVisible = true;
      });
    }
  }
}
