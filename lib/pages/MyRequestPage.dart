import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/myrequestBloc/my_request_bloc.dart';
import 'package:leap_flutter/Bloc/myrequestBloc/my_request_event.dart';
import 'package:leap_flutter/Component/items/ItemOneToOneAndTraining.dart';
import 'package:leap_flutter/pages/BusinessCardsScreen.dart';
import 'package:leap_flutter/pages/CorporateTrainingPage.dart';
import 'package:leap_flutter/pages/OneToOneMentorshipPage.dart';

import '../Bloc/myrequestBloc/my_request_state.dart';
import '../Component/items/ItemMyRequestBusinessCard.dart';
import '../Component/ShimmerComponent.dart';
import '../Utils/GlabblePageRoute.dart';
import '../Utils/constants.dart';
import '../models/MyRequestDeleteModel.dart';
import '../models/MyRequestResponse.dart';
import 'FlyersCardPage.dart';

class MyRequestPage extends StatefulWidget {
  const MyRequestPage({super.key, required this.dashboardFilterType});

  final int dashboardFilterType;

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {
  final MyRequestBloc _myRequestBloc = MyRequestBloc();

  @override
  void initState() {
    super.initState();
    _myRequestBloc.add(GetMyRequestListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("My Request"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: primaryColor,
      ),
      body: _myListViewWidgets(),
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

  Widget _businessCardListViewBUilder(List<BusinessCards>? businessCards) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleOfList("Business Card - Design and Print"),
        SizedBox(height: 15),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: businessCards?.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ItemMyRequestBusinessCard(
                cardName: businessCards![index].vcardType!,
                date: businessCards[index].allocatedDate!,
                statusName: businessCards[index].statusName!,
                requestQuantity: businessCards[index].requestQuantity!,
                statusColor: businessCards[index].statusColor!,
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
            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ItemOneToOneAndTraining(
                key: ValueKey(oneToOneMentorship![index]),
                // Assign a key
                rowOneTitle: 'Meeting Agenda: ',
                rowOneValue: oneToOneMentorship[index].meetingAgenda ?? '',
                rowTwoTitle: 'Mentor Name: ',
                rowTwoValue: oneToOneMentorship[index].mentorName ?? '',
                date: oneToOneMentorship[index].mentorshipDate ?? '',
                statusName: oneToOneMentorship[index].statusName ?? '',
                timeSlot: oneToOneMentorship[index].timeSlot ?? '',
                statusColor: oneToOneMentorship[index].statusColor ?? '',
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

        /*** corporate training List ***/
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: corporateTraining?.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ItemOneToOneAndTraining(
                key: ValueKey(corporateTraining![index]),
                // Assign a key
                rowOneTitle: 'Training Name: ',
                rowOneValue: corporateTraining[index].trainingName!,
                rowTwoTitle: 'Trainer Name: ',
                rowTwoValue: corporateTraining[index].trainerName!,
                date: corporateTraining[index].allocatedDate!,
                statusName: corporateTraining[index].statusName!,
                timeSlot: corporateTraining[index].timeSlot!,
                statusColor: corporateTraining[index].statusColor!,
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

  Widget _flyersCardListViewBUilder(List<Flyers>? flyers) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTitleOfList("Monthly color Flyers - Personalize Now"),
        SizedBox(height: 15),

        /*** FlyersCard List ***/
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: flyers?.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: ItemMyRequestBusinessCard(
                key: ValueKey(flyers![index]),
                // Assign a key
                cardName: flyers[index].flyerType!,
                date: flyers[index].allocatedDate!,
                statusName: flyers[index].statusName!,
                requestQuantity: flyers[index].requestQuantity!,
                statusColor: flyers[index].statusColor!,
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
}
