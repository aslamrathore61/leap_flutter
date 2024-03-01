import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_bloc.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_state.dart';
import 'package:leap_flutter/Component/ShimmerComponent.dart';
import 'package:leap_flutter/models/Profile.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';
import 'package:leap_flutter/pages/CorporateTrainingPage.dart';
import 'package:leap_flutter/pages/MyRequestPage.dart';
import 'package:leap_flutter/pages/OneToOneMentorshipPage.dart';
import '../Bloc/serviceCountBloc/service_count_event.dart';
import '../Component/items/ItemHomeServiceCount.dart';
import '../Utils/constants.dart';
import '../db/SharedPrefObj.dart';
import '../models/LoginResponse.dart';
import 'BusinessCardsScreen.dart';
import '../Utils/GlabblePageRoute.dart';
import 'FlyersCardPage.dart';
import 'LoginScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ServiceCountBloc _serviceCountBloc = ServiceCountBloc();
  Profile? profile;

  @override
  void initState() {
    _serviceCountBloc.add(GetProfileDataEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Aslam Rathore, Welcome Aboard!",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: _buildListTrainingRequest(),
    );
  }

  Widget _buildListTrainingRequest() {
    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _serviceCountBloc,
          child: BlocListener<ServiceCountBloc, ServiceCountState>(
            listener: (context, state) {
              if (state is ServiceCountError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message!)));
              } else if (state is ProfileDetailsFetchingSuccessState) {
                _serviceCountBloc.add(GetServiceCountListEvents());
                profile = state.profileDetails;
              } else if (state is ProfileUpdateAndFetchingErrorState) {
                if (state.error == 'SessionOut') {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(
                                Icons.timer_outlined,
                                size: 80,
                                color: Colors.red,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Session timeout!, Please login again",
                                  style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    GlabblePageRoute(page: LoginScreenPage()));
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      });
                }
              }
            },
            child: BlocBuilder<ServiceCountBloc, ServiceCountState>(
              builder: (context, state) {
                if (state is ServiceCountInitial) {
                  return ShimmerHomeLoading();
                } else if (state is ServiceCountLoading) {
                  return ShimmerHomeLoading();
                } else if (state is ProfileUpdateAndFetchingLoading) {
                  return ShimmerHomeLoading();
                } else if (state is ProfileDetailsFetchingSuccessState) {
                  return ShimmerHomeLoading();
                } else if (state is ServiceCountFetchingSuccessState) {
                  return _buildCardListViewReqTrain(
                      context, state.serviceCountResponse);
                } else if (state is ServiceCountError) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardListViewReqTrain(
      BuildContext context, ServiceCountResponse serviceCountResponse) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            _buildTitleOfList("Training and Appointments"),
            SizedBox(height: 15),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: serviceCountResponse.trainingList?.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  // Add bottom padding for the gap
                  child: ItemHomeServiceCount(
                    title:
                        serviceCountResponse.trainingList![index].trainingName!,
                    count: serviceCountResponse
                        .trainingList![index].trainingRisedCount
                        .toString(),
                    colorCode: serviceCountResponse.trainingList![index].color!,
                    icon: SvgPicture.asset(
                      'assets/icons/onetoone.svg',
                      colorFilter: ColorFilter.mode(
                        getColorFromHex(
                            serviceCountResponse.trainingList![index].color!),
                        BlendMode.srcIn,
                      ),
                      width: 25,
                      height: 25,
                    ),
                    onAddPress: () async {
                      Profile? profile =
                          await SharedPrefObj.getProfileSharedPreValue(
                              profileDetails);
                      if (index == 0) {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: OneToOneMentorshipPage(
                          profileDetails: profile,
                        )));
                      } else {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: CorporateTrainingPage(
                          profileDetails: profile,
                        )));
                      }
                    },
                    onViewPress: () {
                      if (index == 0) {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: MyRequestPage(dashboardFilterType: 1)));
                      } else {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: MyRequestPage(dashboardFilterType: 2)));
                      }
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildTitleOfList("Requests"),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: serviceCountResponse.requestList?.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  // Add bottom padding for the gap
                  child: ItemHomeServiceCount(
                    title:
                        serviceCountResponse.requestList![index].requestName!,
                    count: serviceCountResponse
                        .requestList![index].requestRisedCount
                        .toString(),
                    colorCode: serviceCountResponse.requestList![index].color!,
                    icon: SvgPicture.asset(
                      'assets/icons/businesscard.svg',
                      colorFilter: ColorFilter.mode(
                        getColorFromHex(
                            serviceCountResponse.requestList![index].color!),
                        BlendMode.srcIn,
                      ),
                      width: 25,
                      height: 25,
                    ),
                    onAddPress: () async {
                      Profile? profile =
                          await SharedPrefObj.getProfileSharedPreValue(
                              profileDetails);
                      if (index == 0) {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: BusinessCardsPage(
                          profileDetails: profile,
                        )));
                      } else {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: FlyersCardPage(profileDetails: profile)));
                      }
                    },
                    onViewPress: () {
                      if (index == 0) {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: MyRequestPage(dashboardFilterType: 3)));
                      } else {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: MyRequestPage(dashboardFilterType: 4)));
                      }
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 15),
            _userInformationWidget(),
          ],
        ),
      ),
    );
  }

  _buildTitleOfList(String s) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        width: double.infinity,
        child: Text(
          s,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: titleColor, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
    );
  }

  Widget _userInformationWidget() {
    return Card(
      elevation: 0.2,
      color: Colors.white,
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Agent Information',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: titleColor.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      )),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          size: 20,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('Tenure with SM',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: titleColor.withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      profile?.result?.tenureWithSM ?? '-',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: titleColor.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.model_training,
                          size: 20,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Model',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: titleColor.withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      profile?.result?.splitModel ?? '-',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: titleColor.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 20,
                          color: primaryColor,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text('Current Mentor',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: titleColor.withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      profile?.result?.currentMentors?[0] ?? '-',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: titleColor.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}