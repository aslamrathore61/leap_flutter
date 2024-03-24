import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_bloc.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_state.dart';
import 'package:leap_flutter/Component/ShimmerComponent.dart';
import 'package:leap_flutter/models/Profile.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';
import 'package:leap_flutter/pages/CorporateTrainingPage.dart';
import 'package:leap_flutter/pages/MyRequestPage.dart';
import 'package:leap_flutter/pages/OneToOneMentorshipPage.dart';
import '../Bloc/serviceCountBloc/service_count_event.dart';
import '../Component/CommonComponent.dart';
import '../Component/items/ItemHomeServiceCount.dart';
import '../Utils/constants.dart';
import '../controller/NetworkController.dart';
import '../db/SharedPrefObj.dart';
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
  String? toolbarName;

  @override
  void initState() {
    super.initState();
    _serviceCountBloc.add(GetProfileDataEvents());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          toolbarName ?? 'Welcome Aboard!',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Center(
        child: GetBuilder<NetworkController>(
          builder: (controller) {
            print('controllerStatus ${controller.connectivityStatus}');
            if (controller.connectivityStatus == ConnectivityResult.none) {
              return noInternetConnetionView();
            } else {
              return _buildListTrainingRequest();
            }
          },
        ),
      ),
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
              print('listinerStatue $state');
              if (state is ServiceCountError) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message!)));
              } else if (state is ProfileDetailsFetchingSuccessState) {
                _serviceCountBloc.add(GetServiceCountListEvents());
                profile = state.profileDetails;
                setState(() {
                  toolbarName =
                      "${capitalizeFirstLetterOfEachWord(profile?.result?.firstName.toString())} ${capitalizeFirstLetterOfEachWord(profile?.result?.lastName.toString())}, Welcome Aboard!";
                });
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
                print('builderStatue $state');

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
                    isTraining: true,
                    title: serviceCountResponse
                            .trainingList?[index].trainingName ??
                        '',
                    unPaidTitle: " Remaining Training",
                    unPaidMaxLimit: serviceCountResponse
                            .trainingList?[index].remaining_training_count ??
                        0,
                    completedInLimit: 0,
                    count: serviceCountResponse
                            .trainingList?[index].trainingRisedCount ??
                        0,
                    colorCode:
                        serviceCountResponse.trainingList?[index].color ??
                            '#fff',
                    icon: SvgPicture.asset(
                      'assets/icons/onetoone.svg',
                      colorFilter: ColorFilter.mode(
                        getColorFromHex(
                            serviceCountResponse.trainingList?[index].color ??
                                '#fff'),
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
                            page: MyRequestPage(
                          dashboardFilterType: 1,
                          comingWithFilter: true,
                        )));
                      } else {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: MyRequestPage(
                          dashboardFilterType: 2,
                          comingWithFilter: true,
                        )));
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
                    isTraining: false,
                    title:
                        serviceCountResponse.requestList![index].requestName!,
                    unPaidTitle: "Available Free Limit",
                    unPaidMaxLimit: serviceCountResponse
                            .requestList?[index].unpaid_max_limit ??
                        0,
                    completedInLimit: serviceCountResponse
                            .requestList?[index].requested_quantity ??
                        0,
                    count: serviceCountResponse
                            .requestList![index].requestRisedCount ??
                        0,
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
                            page: MyRequestPage(
                          dashboardFilterType: 3,
                          comingWithFilter: true,
                        )));
                      } else {
                        Navigator.of(context).push(GlabblePageRoute(
                            page: MyRequestPage(
                          dashboardFilterType: 4,
                          comingWithFilter: true,
                        )));
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
