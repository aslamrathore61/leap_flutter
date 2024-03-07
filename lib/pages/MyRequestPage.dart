import 'package:backdrop/backdrop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/myrequestBloc/my_request_bloc.dart';
import 'package:leap_flutter/Bloc/myrequestBloc/my_request_event.dart';
import 'package:leap_flutter/Component/items/ItemOneToOneAndTraining.dart';
import 'package:leap_flutter/pages/BusinessCardsScreen.dart';
import 'package:leap_flutter/pages/CorporateTrainingPage.dart';
import 'package:leap_flutter/pages/OneToOneMentorshipPage.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
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

  List<FilterCount> filterCountList = [
    FilterCount('One to One Mentorship', 1),
    FilterCount('Corporate Training', 2),
    FilterCount('Business Card - Design and Print', 3),
    FilterCount('Monthly color Flyers - Personalize Now', 4),
  ];

  @override
  void initState() {
    super.initState();
    _myRequestBloc.add(GetMyRequestListEvent());
  }

/*  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("My Request"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: primaryColor,
        // Change to your primaryColor
        actions: <Widget>[
          IconButton(
            onPressed: () {

            },
            icon: Icon(Icons.filter_alt),
          )
        ],
      ),
      body: _myListViewWidgets(),
    );
  }*/

  final GlobalKey<BackdropScaffoldState> _backdropKey =
      GlobalKey<BackdropScaffoldState>();

  bool isBackdropOpen = false;

  @override
  Widget build(BuildContext context) {
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
      headerHeight: 350,
      frontLayer: _myListViewWidgets(),
      backLayer: backLayerContainer(),
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
              child: Center(child: Text("Something went Wrong")),
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (myRequestResponse.oneToOneMentorship != null &&
              myRequestResponse.oneToOneMentorship!.isNotEmpty &&
              (widget.dashboardFilterType == 101 ||
                  widget.dashboardFilterType == 1))
            _oneToOneMentorshipListViewBUilder(
                myRequestResponse.oneToOneMentorship),
          if (myRequestResponse.corporateTraining != null &&
              myRequestResponse.corporateTraining!.isNotEmpty &&
              (widget.dashboardFilterType == 101 ||
                  widget.dashboardFilterType == 2))
            _corporatepListViewBUilder(myRequestResponse.corporateTraining),
          if (myRequestResponse.businessCards != null &&
              myRequestResponse.businessCards!.isNotEmpty &&
              (widget.dashboardFilterType == 101 ||
                  widget.dashboardFilterType == 3))
            _businessCardListViewBUilder(myRequestResponse.businessCards),
          if (myRequestResponse.flyers != null &&
              myRequestResponse.flyers!.isNotEmpty &&
              (widget.dashboardFilterType == 101 ||
                  widget.dashboardFilterType == 4))
            _flyersCardListViewBUilder(myRequestResponse.flyers),
        ],
      ),
    );
  }

  String dismissibleItem = '';

  Widget _oneToOneMentorshipListViewBUilder(
      List<OneToOneMentorship>? oneToOneMentorship) {
    int archivedCount = 0;
    int notArchivedCount = 0;

    oneToOneMentorship?.forEach((element) {
      if (element.archivedStatus == 1) {
        archivedCount++;
      } else {
        notArchivedCount++;
      }
    });

    if ((archivedCount == 0 && isArchived) ||
        (notArchivedCount == 0 && !isArchived)) {
      return Container();
    }

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

            if (item.archivedStatus == 1 && !isArchived) {
              return Container();
            }

            if (item.archivedStatus == 0 && isArchived) {
              return Container();
            }

            return Dismissible(
              key: ValueKey(item),
              onDismissed: (DismissDirection dir) {
                dismissibleItem = item.mentorSlotUuid!;
                setState(() => oneToOneMentorship.removeAt(index));
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                      content: Text(dir == DismissDirection.startToEnd
                          ? '${item.meetingAgenda} Add in archived'
                          : '${item.mentorName} Remove from archived'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          setState(
                              () => oneToOneMentorship.insert(index, item));
                        },
                      ),
                      duration: const Duration(
                          seconds: 1), // Set the duration to 5 seconds
                    ))
                    .closed
                    .then((reason) {
                  if (reason == SnackBarClosedReason.action) {
                    // SnackBar dismissed by tapping on the action button
                    // Perform any additional actions here
                  } else if (reason == SnackBarClosedReason.timeout) {
                    // SnackBar dismissed by the framework (e.g., due to a timeout)
                    // Perform any additional actions here
                    MyRequestArchivedModel myArchivedReq =
                        MyRequestArchivedModel();
                    myArchivedReq.mentorSlotUuid = dismissibleItem;
                    _myRequestBloc.add(ArchivedMyRequestItemEvent(
                        myRequestArchivedModel: myArchivedReq,
                        endPoint: "archiveuserbookedonetoonementorship"));

                    // update list locally because we not fetching api again whenever update archived
                    item.archivedStatus = isArchived ? 0 : 1;
                    oneToOneMentorship.add(item);
                  }
                });
              },
              confirmDismiss: (direction) async {
                // Allow dismiss only if swiping from left to right
                if (!isArchived) {
                  return direction == DismissDirection.startToEnd;
                } else {
                  return direction == DismissDirection.endToStart;
                }
              },
              background: Container(
                color: Colors.green.shade400,
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Icon(Icons.archive_outlined, color: Colors.white)),
              ),
              secondaryBackground: Container(
                color: Colors.red.shade400,
                alignment: Alignment.centerRight,
                child: Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Icon(
                      Icons.cancel_rounded,
                      color: Colors.white,
                    )),
              ),
              child: Padding(
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
                  isArchive: oneToOneMentorship[index].archivedStatus ?? 0,
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
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _corporatepListViewBUilder(
      List<CorporateTraining>? corporateTraining) {
    int archivedCount = 0;
    int notArchivedCount = 0;

    corporateTraining?.forEach((element) {
      if (element.archivedStatus == 1) {
        archivedCount++;
      } else {
        notArchivedCount++;
      }
    });

    if ((archivedCount == 0 && isArchived) ||
        (notArchivedCount == 0 && !isArchived)) {
      return Container();
    }

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

            if (item.archivedStatus == 1 && !isArchived) {
              return Container();
            }

            if (item.archivedStatus == 0 && isArchived) {
              return Container();
            }

            return Dismissible(
              key: ValueKey(item),
              onDismissed: (DismissDirection dir) {
                dismissibleItem = item.trainingBookingUuid!;
                setState(() => corporateTraining.removeAt(index));
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                      content: Text(dir == DismissDirection.startToEnd
                          ? '${item.trainingName} Add in archived'
                          : '${item.trainingName} Remove from archived'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          setState(() => corporateTraining.insert(index, item));
                        },
                      ),
                      duration: const Duration(
                          seconds: 1), // Set the duration to 5 seconds
                    ))
                    .closed
                    .then((reason) {
                  if (reason == SnackBarClosedReason.action) {
                    // SnackBar dismissed by tapping on the action button
                    // Perform any additional actions here
                  } else if (reason == SnackBarClosedReason.timeout) {
                    // SnackBar dismissed by the framework (e.g., due to a timeout)
                    // Perform any additional actions here

                    MyRequestArchivedModel myArchivedReq =
                        MyRequestArchivedModel();
                    myArchivedReq.trainingBookingUuid = dismissibleItem;
                    _myRequestBloc.add(ArchivedMyRequestItemEvent(
                        myRequestArchivedModel: myArchivedReq,
                        endPoint: "archiveuserbookedtraining"));

                    // update list locally because we not fetching api again whenever update archived
                    item.archivedStatus = isArchived ? 0 : 1;
                    corporateTraining.add(item);
                  }
                });
              },
              confirmDismiss: (direction) async {
                // Allow dismiss only if swiping from left to right
                if (!isArchived) {
                  return direction == DismissDirection.startToEnd;
                } else {
                  return direction == DismissDirection.endToStart;
                }
              },
              background: Container(
                color: Colors.green.shade400,
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Icon(Icons.archive_outlined, color: Colors.white)),
              ),
              secondaryBackground: Container(
                color: Colors.red.shade400,
                alignment: Alignment.centerRight,
                child: Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Icon(
                      Icons.cancel_rounded,
                      color: Colors.white,
                    )),
              ),
              child: Padding(
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
                  isArchive: corporateTraining[index].archivedStatus ?? 0,
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
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _businessCardListViewBUilder(List<BusinessCards>? businessCards) {
    int archivedCount = 0;
    int notArchivedCount = 0;

    businessCards?.forEach((element) {
      if (element.archivedStatus == 1) {
        archivedCount++;
      } else {
        notArchivedCount++;
      }
    });

    if ((archivedCount == 0 && isArchived) ||
        (notArchivedCount == 0 && !isArchived)) {
      return Container();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleOfList("Business Card - Design and Print"),
        SizedBox(height: 15),

        /*** Monthly color flyers - Personalize Now List ***/
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: businessCards?.length,
          itemBuilder: (BuildContext context, int index) {
            final BusinessCards item = businessCards![index];

            // Check if the item is archived, and if it is, return an empty container to hide it
            if (item.archivedStatus == 1 && !isArchived) {
              return Container();
            }

            if (item.archivedStatus == 0 && isArchived) {
              return Container();
            }

            return Dismissible(
              key: ValueKey(item),
              onDismissed: (DismissDirection dir) {
                dismissibleItem = item.vcardRequestUuid!;
                setState(() => businessCards.removeAt(index));
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                      content: Text(dir == DismissDirection.startToEnd
                          ? '${item.vcardName} Add in archived'
                          : '${item.vcardName} Remove from archived'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          setState(() => businessCards.insert(index, item));
                        },
                      ),
                      duration: const Duration(
                          seconds: 1), // Set the duration to 5 seconds
                    ))
                    .closed
                    .then((reason) {
                  if (reason == SnackBarClosedReason.action) {
                    // SnackBar dismissed by tapping on the action button
                    // Perform any additional actions here
                  } else if (reason == SnackBarClosedReason.timeout) {
                    // SnackBar dismissed by the framework (e.g., due to a timeout)
                    // Perform any additional actions here
                    MyRequestArchivedModel myArchivedReq =
                        MyRequestArchivedModel();
                    myArchivedReq.vcardRequestUuid = dismissibleItem;
                    _myRequestBloc.add(ArchivedMyRequestItemEvent(
                        myRequestArchivedModel: myArchivedReq,
                        endPoint: "archiveusercardrequest"));

                    // update list locally because we not fetching api again whenever update archived
                    item.archivedStatus = isArchived ? 0 : 1;
                    businessCards.add(item);
                  }
                });
              },
              confirmDismiss: (direction) async {
                // Allow dismiss only if swiping from left to right
                if (!isArchived) {
                  return direction == DismissDirection.startToEnd;
                } else {
                  return direction == DismissDirection.endToStart;
                }
              },
              background: Container(
                color: Colors.green.shade400,
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Icon(Icons.archive_outlined, color: Colors.white)),
              ),
              secondaryBackground: Container(
                color: Colors.red.shade400,
                alignment: Alignment.centerRight,
                child: Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Icon(
                      Icons.cancel_rounded,
                      color: Colors.white,
                    )),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: ItemMyRequestBusinessCard(
                  key: ValueKey(businessCards[index]),
                  // Assign a key
                  cardName: businessCards[index].vcardType!,
                  date: businessCards[index].allocatedDate!,
                  statusName: businessCards[index].statusName!,
                  requestQuantity: businessCards[index].requestQuantity!,
                  statusColor: businessCards[index].statusColor!,
                  isArchive: businessCards[index].archivedStatus!,
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
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _flyersCardListViewBUilder(List<Flyers>? flyers) {
    int archivedCount = 0;
    int notArchivedCount = 0;

    flyers?.forEach((element) {
      if (element.archivedStatus == 1) {
        archivedCount++;
      } else {
        notArchivedCount++;
      }
    });

    if ((archivedCount == 0 && isArchived) ||
        (notArchivedCount == 0 && !isArchived)) {
      return Container();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleOfList("Monthly color Flyers - Personalize Now"),
        SizedBox(height: 15),

        /*** Monthly color flyers - Personalize Now List ***/
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: flyers?.length,
          itemBuilder: (BuildContext context, int index) {
            final Flyers item = flyers![index];

            // Check if the item is archived, and if it is, return an empty container to hide it
            if (item.archivedStatus == 1 && !isArchived) {
              return Container();
            }

            if (item.archivedStatus == 0 && isArchived) {
              return Container();
            }

            return Dismissible(
              key: ValueKey(item),
              onDismissed: (DismissDirection dir) {
                dismissibleItem = item.flyerRequestUuid!;
                setState(() => flyers.removeAt(index));
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                      content: Text(dir == DismissDirection.startToEnd
                          ? '${item.flyerName} Add in archived'
                          : '${item.flyerName} Remove from archived'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          setState(() => flyers.insert(index, item));
                        },
                      ),
                      duration: const Duration(
                          seconds: 1), // Set the duration to 5 seconds
                    ))
                    .closed
                    .then((reason) {
                  if (reason == SnackBarClosedReason.action) {
                    // SnackBar dismissed by tapping on the action button
                    // Perform any additional actions here
                  } else if (reason == SnackBarClosedReason.timeout) {
                    // SnackBar dismissed by the framework (e.g., due to a timeout)
                    // Perform any additional actions here
                    MyRequestArchivedModel myArchivedReq =
                        MyRequestArchivedModel();
                    myArchivedReq.flyerRequestUuid = dismissibleItem;
                    _myRequestBloc.add(ArchivedMyRequestItemEvent(
                        myRequestArchivedModel: myArchivedReq,
                        endPoint: "archiveuserflyerrequest"));

                    // update list locally because we not fetching api again whenever update archived
                    item.archivedStatus = isArchived ? 0 : 1;
                    flyers.add(item);
                  }
                });
              },
              confirmDismiss: (direction) async {
                // Allow dismiss only if swiping from left to right
                if (!isArchived) {
                  return direction == DismissDirection.startToEnd;
                } else {
                  return direction == DismissDirection.endToStart;
                }
              },
              background: Container(
                color: Colors.green.shade400,
                alignment: Alignment.centerLeft,
                child: Container(
                    margin: EdgeInsets.only(left: 30),
                    child: Icon(Icons.archive_outlined, color: Colors.white)),
              ),
              secondaryBackground: Container(
                color: Colors.red.shade400,
                alignment: Alignment.centerRight,
                child: Container(
                    margin: EdgeInsets.only(right: 30),
                    child: Icon(
                      Icons.cancel_rounded,
                      color: Colors.white,
                    )),
              ),
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: ItemMyRequestBusinessCard(
                  key: ValueKey(flyers[index]),
                  // Assign a key
                  cardName: flyers[index].flyerType!,
                  date: flyers[index].allocatedDate!,
                  statusName: flyers[index].statusName!,
                  requestQuantity: flyers[index].requestQuantity!,
                  statusColor: flyers[index].statusColor!,
                  isArchive: flyers[index].archivedStatus!,
                  onEditPress: () {
                    Navigator.of(context).push(GlabblePageRoute(
                        page: FlyersCardPage(flyers: flyers[index])));
                  },
                  onDeletePress: () {
                    MyRequestDeleteModel cardDelete = MyRequestDeleteModel();
                    cardDelete.flyerRequestUuid =
                        flyers[index].flyerRequestUuid;
                    _myRequestBloc.add(DeleteMyRequestItemEvent(
                        cardDelete: cardDelete,
                        endPoint: "deleteuserflyerrequest"));
                    setState(() => flyers.removeAt(index));
                  },
                ),
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

  Widget backLayerContainer() {
    return Column(
      children: [
        SizedBox(
          height: 30,
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
          padding: EdgeInsets.only(top: 8.0, right: 10.0, left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Center(
                  child: Container(
                    height: 40,
                    child: LiteRollingSwitch(
                      width: 140,
                      //initial value
                      value: isArchived,
                      textOn: 'Archived Only',
                      textOff: 'Hide Archived',
                      colorOn: Colors.greenAccent.withOpacity(0.8),
                      colorOff: Colors.redAccent.withOpacity(0.8),
                      iconOn: Icons.done,
                      iconOff: Icons.remove_circle_outline,
                      textSize: 12.0,
                      onChanged: (bool state) {
                        //Use it to manage the different states
                        print('ChangesState: $state');
                        isArchived = state;
                      },
                      onTap: () {},
                      onDoubleTap: () {},
                      onSwipe: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
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
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                      ),
                    ),
                  ),
                ),
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
                  child: Icon(
                    Icons.lock_reset_outlined,
                    color: Colors.red.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

/*

Container(
      width: double.infinity,
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Text(
              'One to One Mentorship',
              textAlign: TextAlign.center,
              style:
              Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );


*/
