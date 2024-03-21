import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Utils/GlabblePageRoute.dart';
import 'package:leap_flutter/db/SharedPrefObj.dart';
import 'package:leap_flutter/models/Profile.dart';
import 'package:leap_flutter/pages/LoginScreen.dart';
import 'package:leap_flutter/pages/UpdatePasswordPage.dart';
import 'package:provider/provider.dart';
import '../Bloc/networkBloc/network_bloc.dart';
import '../Bloc/networkBloc/network_state.dart';
import '../Bloc/serviceCountBloc/service_count_bloc.dart';
import '../Bloc/serviceCountBloc/service_count_event.dart';
import '../Bloc/serviceCountBloc/service_count_state.dart';
import '../Component/CommonComponent.dart';
import '../Component/ShimmerProfileView.dart';
import '../Component/buttons/primary_button.dart';
import '../Utils/constants.dart';
import 'MyProfileEditPage.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final ServiceCountBloc _serviceCountBloc = ServiceCountBloc();

  bool emailShowOverflow = false;

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
            "My Profile",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        // body: serviceCountBlocWidget());
        body: serviceCountBlocWidget()  /*Provider<NetworkBloc>(
          create: (context) => NetworkBloc(),
          child: BlocBuilder<NetworkBloc, NetworkState>(
            builder: (context, state) {
              print('checkState ${state}');
              if (state is NetworkFailure) {
                return noInternetConnetionView();
              } else if (state is NetworkSuccess) {
                return serviceCountBlocWidget();
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        )*/

    );
  }

  Widget serviceCountBlocWidget() {
    return BlocProvider(
      create: (context) => _serviceCountBloc,
      child: BlocConsumer<ServiceCountBloc, ServiceCountState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ProfileUpdateAndFetchingLoading) {
            return ShimmerProfileView();
          } else if (state is ProfileDetailsFetchingSuccessState) {
            return buildProfileView(state.profileDetails);
          } else {
            return Container(
              child:SizedBox(),
            );
          }
        },
      ),
    );
  }

  Widget buildProfileView(Profile profile) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 15),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            buildProfileHeader(profile),
            SizedBox(
              height: 10,
            ),
            buildDivider(),
            buildSectionTitle("Profile Info."),
            buildInfoRow(
                Icons.call, "Mobile Number", profile.result?.phoneNumber ?? ''),
            buildInfoRow(
                Icons.work, "Office", profile.result?.organization ?? ''),
            buildInfoRow(Icons.person, "Current Mentor",
                profile.result?.currentMentors?[0] ?? ''),
            buildInfoRow(Icons.model_training, "Model",
                profile.result?.splitModel ?? ''),
            buildInfoRow(
                Icons.business,
                "Franchise/Brokerage",
                profile.result!.isFranchise ?? false
                    ? "Franchise"
                    : "Brokerage"),
            buildInfoRow(Icons.timer, "Tenure with SM",
                profile.result?.tenureWithSM ?? ''),
            buildDivider(),
            buildSectionTitle("Settings"),
            InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(GlabblePageRoute(page: UpdatePasswordPage()));
                  /*showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ChangePasswordDialoged();
                      });*/
                },
                child: buildOptionRow(
                    "assets/images/password.png", "Update Password")),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => _buildBottomSheet(context),
                );
              },
              child: buildOptionRow("assets/images/signout.png", "Logout"),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget buildProfileHeader(Profile profile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor,
                  width: 2,
                ),
              ),
              child: Container(
                width: 60, // Adjust the width and height as needed
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black, // Adjust border color as needed
                    width: 2, // Adjust border width as needed
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    profile.result!.profileImage ??
                        'https://upload.wikimedia.org/wikipedia/commons/7/7e/Circle-icons-profile.svg',
                    width: 100, // Adjust the width and height as needed
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }
                      return CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                progress.expectedTotalBytes!
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${capitalizeFirstLetterOfEachWord(profile.result!.firstName)} ${profile.result?.lastName}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        emailShowOverflow = !emailShowOverflow;
                      });
                    },
                    child: Text(
                      overflow: emailShowOverflow
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      '${profile.result!.email}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () async {
                final result =
                    await Navigator.of(context).push(GlabblePageRoute(
                        page: MyProfileEditPage(
                  profileDetails: profile,
                )));
                if (result != null) {
                  _serviceCountBloc.add(GetProfileDataEvents());
                }
              },
              child: Icon(
                Icons.edit_note,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Container(
      margin: EdgeInsets.only(top: 12),
      width: double.infinity,
      height: 1,
      color: primaryColor,
    );
  }

  Widget buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 15, top: 23),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    // Image.asset('assets/images/canada.png', width: 20, height: 18),
                  ],
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptionRow(String iconPath, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Row(
        children: [
          Image.asset(iconPath, width: 20, height: 18),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildBottomSheet(BuildContext context) {
    print('getcallbottomshet');
    return Container(
      width: double.infinity,
      height: 180,
      color: Colors.white,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Sign out!',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: titleColor.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
            ),
            Text(
              'Are you sure you want to sign out of LEAP?',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: titleColor.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // Your decoration properties here
                        border: Border.all(color: Colors.black, width: 0.7),
                        borderRadius:
                            BorderRadius.circular(6), // Example border radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: Text(
                          'NO, STAY',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: titleColor.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () async {
                      await SharedPrefObj.clearAll();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginScreenPage()),
                          (Route<dynamic> route) => false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.blue,
                            Colors.green
                          ], // Example gradient colors
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'YES, SURE',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
