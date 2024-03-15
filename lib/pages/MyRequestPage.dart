import 'package:backdrop/backdrop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/myrequestBloc/my_request_bloc.dart';
import 'package:leap_flutter/Bloc/myrequestBloc/my_request_event.dart';
import 'package:leap_flutter/Component/items/ItemOneToOneAndTraining.dart';
import 'package:leap_flutter/db/SharedPrefObj.dart';
import 'package:leap_flutter/pages/BusinessCardsScreen.dart';
import 'package:leap_flutter/pages/CorporateTrainingPage.dart';
import 'package:leap_flutter/pages/OneToOneMentorshipPage.dart';
import '../Bloc/myrequestBloc/my_request_state.dart';
import '../Component/items/ItemMyRequestBusinessCard.dart';
import '../Component/ShimmerComponent.dart';
import '../Utils/GlabblePageRoute.dart';
import '../Utils/constants.dart';
import '../models/MyRequestDeleteArchivedModel.dart';
import '../models/MyRequestResponse.dart';
import '../models/ServiceCountResponse.dart';
import 'FlyersCardPage.dart';

class MyRequestPage extends StatefulWidget {
  MyRequestPage({super.key, required this.dashboardFilterType});

  int dashboardFilterType;

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  final MyRequestBloc _myRequestBloc = MyRequestBloc();

  bool isArchived = false;
  ServiceCountResponse? serviceCountResponse;
  List<FilterCount> filterCountList = [
    FilterCount('One to One Mentorship', 1),
    FilterCount('Corporate Training', 2),
    FilterCount('Business Card - Design and Print', 3),
    FilterCount('Monthly color Flyers - Personalize Now', 4),
  ];

  @override
  void initState() {
    super.initState();
    fetchSharedPrefServiceCountData();
    _myRequestBloc.add(GetMyRequestListEvent());
  }

  Future<void> fetchSharedPrefServiceCountData() async {
    try {
      serviceCountResponse =
          await SharedPrefObj.getServiceCountSharedPreValue(serviceCount);
      print(
          'serviceCountResponse ${serviceCountResponse!.trainingList![0].color}');
    } catch (e) {
      // Handle error fetching data from SharedPreferences
      print('Error fetching data: $e');
    }
  }

  final GlobalKey<BackdropScaffoldState> _backdropKey =
      GlobalKey<BackdropScaffoldState>();

  bool isBackdropOpen = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BackdropScaffold(
      key: _backdropKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("My Request"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _backdropKey.currentState!.fling();
              setState(() {
                isBackdropOpen = !isBackdropOpen;
              });
            },
            icon: isBackdropOpen
                ? Icon(Icons.filter_alt_off)
                : Icon(Icons.filter_alt),
          )
        ],
      ),
      headerHeight: screenHeight * 0.45,
      // 70% of the screen height,
      frontLayer: _myListViewWidgets(),
      backLayer: backLayerContainer(screenHeight),
    );
  }

  Widget _myListViewWidgets() {
    return BlocProvider(
      create: (context) => _myRequestBloc,
      child: BlocConsumer<MyRequestBloc, MyRequestState>(
        listener: (context, state) {
          if (state is MyRequestFetchingError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is MyRequestInitial) {
            return buildShimmerMyRequestListing();
          } else if (state is MyRequestLoading) {
            return buildShimmerMyRequestListing();
          } else if (state is MyRequestFetchingSuccessState) {
            return _buildListViewCard(context, state.myRequestResponse);
          } else if (state is MyRequestFetchingError) {
            return Container(
              child: noDataFoundWidget(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildListViewCard(
      BuildContext context, MyRequestResponse myRequestResponse) {
    bool isFilterTypeMatch(int type) => widget.dashboardFilterType == type;
    /*|| widget.dashboardFilterType == 101;*/

    if ((isFilterTypeMatch(1) &&
            (myRequestResponse.oneToOneMentorship == null ||
                myRequestResponse.oneToOneMentorship!.isEmpty)) ||
        (isFilterTypeMatch(2) &&
            (myRequestResponse.corporateTraining == null ||
                myRequestResponse.corporateTraining!.isEmpty)) ||
        (isFilterTypeMatch(3) &&
            (myRequestResponse.businessCards == null ||
                myRequestResponse.businessCards!.isEmpty)) ||
        (isFilterTypeMatch(4) &&
            (myRequestResponse.flyers == null ||
                myRequestResponse.flyers!.isEmpty))) {
      return Container(
        height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child: noDataFoundWidget());
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (isFilterTypeMatch(1) ||
              widget.dashboardFilterType == 101 &&
                  (myRequestResponse.oneToOneMentorship != null &&
                      myRequestResponse.oneToOneMentorship!.isNotEmpty))
            _oneToOneMentorshipListViewBUilder(
                myRequestResponse.oneToOneMentorship),
          if (isFilterTypeMatch(2) ||
              widget.dashboardFilterType == 101 &&
                  (myRequestResponse.corporateTraining != null &&
                      myRequestResponse.corporateTraining!.isNotEmpty))
            _corporatepListViewBUilder(myRequestResponse.corporateTraining),
          if (isFilterTypeMatch(3) ||
              widget.dashboardFilterType == 101 &&
                  (myRequestResponse.businessCards != null &&
                      myRequestResponse.businessCards!.isNotEmpty))
            _businessCardListViewBUilder(myRequestResponse.businessCards),
          if (isFilterTypeMatch(4) ||
              widget.dashboardFilterType == 101 &&
                  (myRequestResponse.flyers != null &&
                      myRequestResponse.flyers!.isNotEmpty))
            _flyersCardListViewBUilder(myRequestResponse.flyers),
        ],
      ),
    );
  }

  String dismissibleItem = '';

  Widget _oneToOneMentorshipListViewBUilder(
      List<OneToOneMentorship>? oneToOneMentorship) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleOfList("One to One Mentorship"),
        SizedBox(height: 15),

        /*** one to one mentorship List ***/
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: oneToOneMentorship?.length,
          itemBuilder: (BuildContext context, int index) {
            final OneToOneMentorship item = oneToOneMentorship![index];

            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ItemOneToOneAndTraining(
                key: ValueKey(item),
                // Assign a key
                rowOneTitle: 'Meeting Agenda: ',
                rowOneValue: oneToOneMentorship[index].meetingAgenda ?? '',
                rowTwoTitle: 'Mentor Name: ',
                rowTwoValue: oneToOneMentorship[index].mentorName ?? '',
                date: oneToOneMentorship[index].mentorshipDate ?? '',
                statusName: oneToOneMentorship[index].statusName ?? '',
                timeSlot: oneToOneMentorship[index].timeSlot ?? '',
                statusColor: oneToOneMentorship[index].statusColor ?? '',
                viewBorderColor:
                    serviceCountResponse?.trainingList![0].color ?? '#fff',
                isArchive: 0 /*oneToOneMentorship[index].archivedStatus ?? 0*/,
                onEditPress: () {
                  Navigator.of(context).push(GlabblePageRoute(
                      page: OneToOneMentorshipPage(
                          oneToOneMentorship: oneToOneMentorship[index])));
                },
                onDeletePress: () {
                  MyRequestDeleteModel myRequestDeleteModel =
                      MyRequestDeleteModel();
                  myRequestDeleteModel.mentorSlotUuid =
                      oneToOneMentorship[index].mentorSlotUuid;
                  _myRequestBloc.add(DeleteMyRequestItemEvent(
                      cardDelete: myRequestDeleteModel,
                      endPoint: "deleteuserbookedonetoonementorship"));
                  setState(() => oneToOneMentorship.removeAt(index));
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _corporatepListViewBUilder(
      List<CorporateTraining>? corporateTraining) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleOfList("Corporate Training"),
        SizedBox(height: 15),

        /*** corporate trainng List ***/
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: corporateTraining?.length,
          itemBuilder: (BuildContext context, int index) {
            final CorporateTraining item = corporateTraining![index];

            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ItemOneToOneAndTraining(
                key: ValueKey(item),
                // Assign a key
                rowOneTitle: 'Training Name: ',
                rowOneValue: corporateTraining[index].trainingName!,
                rowTwoTitle: 'Trainer Name: ',
                rowTwoValue: corporateTraining[index].trainerName!,
                date: corporateTraining[index].allocatedDate!,
                statusName: corporateTraining[index].statusName!,
                timeSlot: corporateTraining[index].timeSlot!,
                statusColor: corporateTraining[index].statusColor!,
                viewBorderColor:
                    serviceCountResponse?.trainingList![1].color ?? '#fff',
                isArchive: 0 /*corporateTraining[index].archivedStatus ?? 0*/,
                onEditPress: () {
                  Navigator.of(context).push(GlabblePageRoute(
                      page: CorporateTrainingPage(
                          corporateTraining: corporateTraining[index])));
                },
                onDeletePress: () {
                  MyRequestDeleteModel myRequestDeleteModel =
                      MyRequestDeleteModel();
                  myRequestDeleteModel.trainingBookingUuid =
                      corporateTraining[index].trainingBookingUuid;
                  _myRequestBloc.add(DeleteMyRequestItemEvent(
                      cardDelete: myRequestDeleteModel,
                      endPoint: "deleteuserbookedtraining"));
                  setState(() => corporateTraining.removeAt(index));
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _businessCardListViewBUilder(List<BusinessCards>? businessCards) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleOfList("Business Card - Design and Print"),
        SizedBox(height: 15),

        /*** Monthly color flyers - Personalize Now List ***/
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: businessCards!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ItemMyRequestBusinessCard(
                key: ValueKey(businessCards[index]),
                // Assign a key
                cardName: businessCards[index].vcardType!,
                date: businessCards[index].allocatedDate!,
                statusName: businessCards[index].statusName!,
                requestQuantity: businessCards[index].requestQuantity!,
                statusColor: businessCards[index].statusColor!,
                isArchive: 0 /*businessCards[index].archivedStatus!*/,
                onEditPress: () {
                  Navigator.of(context).push(GlabblePageRoute(
                      page: BusinessCardsPage(
                          businessCards: businessCards[index])));
                },
                onDeletePress: () {
                  MyRequestDeleteModel cardDelete = MyRequestDeleteModel();
                  cardDelete.vcardRequestUuid =
                      businessCards[index].vcardRequestUuid;
                  _myRequestBloc.add(DeleteMyRequestItemEvent(
                      cardDelete: cardDelete,
                      endPoint: "deleteusercardrequest"));
                  setState(() => businessCards.removeAt(index));
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _flyersCardListViewBUilder(List<Flyers>? flyers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleOfList("Monthly color Flyers - Personalize Now"),
        SizedBox(height: 15),

        /*** Monthly color flyers - Personalize Now List ***/
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: flyers!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ItemMyRequestBusinessCard(
                key: ValueKey(flyers[index]),
                // Assign a key
                cardName: flyers[index].flyerType!,
                date: flyers[index].allocatedDate!,
                statusName: flyers[index].statusName!,
                requestQuantity: flyers[index].requestQuantity!,
                statusColor: flyers[index].statusColor!,
                isArchive: 0 /*flyers[index].archivedStatus!*/,
                onEditPress: () {
                  Navigator.of(context).push(GlabblePageRoute(
                      page: FlyersCardPage(flyers: flyers[index])));
                },
                onDeletePress: () {
                  MyRequestDeleteModel cardDelete = MyRequestDeleteModel();
                  cardDelete.flyerRequestUuid = flyers[index].flyerRequestUuid;
                  _myRequestBloc.add(DeleteMyRequestItemEvent(
                      cardDelete: cardDelete,
                      endPoint: "deleteuserflyerrequest"));
                  setState(() => flyers.removeAt(index));
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTitleOfList(String title) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 10, top: 20),
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: primaryColor,
        ),
      ),
    );
  }

  int _selectedIndex = -1; // Initialize the selected state

  Widget backLayerContainer(double screenHeight) {
    return Container(
      height: screenHeight * 0.35, // 30% of the screen height
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 5,
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filterCountList.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: ItemFilterMyRequest(
                  title: filterCountList[index].name,
                  onPress: () {
                    // Update the selected index when pressed
                    setState(() {
                      print('indext check : $index');
                      _selectedIndex = index;
                    });
                  },
                  selected: _selectedIndex ==
                      index, // Check if the current item is selected based on its index
                ),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0, right: 10.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        isArchived = !isArchived;
                        if (isArchived == true) {
                          isArchived = false;
                        } else {
                          isArchived = true;
                        }
                        if (_selectedIndex == -1) {
                          widget.dashboardFilterType = 101;
                        } else {
                          widget.dashboardFilterType = _selectedIndex + 1;
                        }
                      });
                      _backdropKey.currentState!.fling();
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            primaryColor.withOpacity(0.9),
                            Colors.white.withOpacity(0.4),
                            primaryColor.withOpacity(0.9)
                          ], // Example gradient colors
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Apply',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.dashboardFilterType = 101;
                        _selectedIndex = -1;
                        isArchived = false;
                      });
                      _backdropKey.currentState!.fling();
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            primaryColor.withOpacity(0.9),
                            Colors.white.withOpacity(0.4),
                            primaryColor.withOpacity(0.9)
                          ], // Example gradient colors
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'Reset',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemFilterMyRequest extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final bool selected;

  const ItemFilterMyRequest({
    Key? key,
    required this.title,
    required this.onPress,
    required this.selected, // Define the selected parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(right: 10, left: 10),
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: selected
              ? Colors.green.withOpacity(0.1) ?? Colors.blue
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? Colors.green[200] ?? Colors.blue
                : Colors.grey[200] ?? Colors.grey,
            // Use fallback colors if the selected color is null
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                //    color: Colors.white.withOpacity(0.8),
                color: selected
                    ? Colors.green[500] ?? Colors.blue
                    : Colors.white.withOpacity(0.8) ?? Colors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
