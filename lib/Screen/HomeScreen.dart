import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_bloc.dart';
import 'package:leap_flutter/Bloc/serviceCountBloc/service_count_state.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';
import '../Bloc/serviceCountBloc/service_count_event.dart';
import '../Utils/MyCustomColors.dart';
import 'CreationOptionScreen.dart';
import '../Utils/GlabblePageRoute.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ServiceCountBloc _serviceCountBloc = ServiceCountBloc();

  @override
  void initState() {
    _serviceCountBloc.add(GetServiceCountListEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyCustomColors.primaryColor,
        title: Text(
          "Aslam Rathore, Welcome Aboard!",
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
      ),
      body: _buildListTrainingRequest(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipOval(
          child: FloatingActionButton(
            onPressed: () {
              // Navigate to the next screen with glabble animation
              Navigator.of(context)
                  .push(GlabblePageRoute(page: CreationOptionScreen()));
            },
            backgroundColor: MyCustomColors.primaryColor,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListTrainingRequest() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _serviceCountBloc,
        child: BlocListener<ServiceCountBloc, ServiceCountState>(
          listener: (context, state) {
            if (state is ServiceCountError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message!)));
            }
          },
          child: BlocBuilder<ServiceCountBloc, ServiceCountState>(
            builder: (context, state) {
              if (state is ServiceCountInitial) {
                return _buildLoading();
              } else if (state is ServiceCountLoading) {
                return _buildLoading();
              } else if (state is ServiceCountFetchingSuccessState) {
                return _buildCard(context, state.serviceCountResponse);
              } else if (state is ServiceCountError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, ServiceCountResponse serviceCountResponse) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(right: 18.0, left: 18.0, top: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Text(
                "Training and Appointments",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w800,
                  color: MyCustomColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              itemCount: serviceCountResponse.trainingList?.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  // Add bottom padding for the gap
                  child: RowItemHome(
                    title:
                        serviceCountResponse.trainingList![index].trainingName!,
                    count: serviceCountResponse
                        .trainingList![index].trainingRisedCount
                        .toString()!,
                    colorCode: '#fff',
                    onTap: () {
                      print('Tapped on Item $index');
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: Text(
                "Requests",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w800,
                  color: MyCustomColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              itemCount: serviceCountResponse.requestList?.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  // Add bottom padding for the gap
                  child: RowItemHome(
                    title: serviceCountResponse.requestList![index].requestName!,
                    count: serviceCountResponse.requestList![index].requestRisedCount.toString(),
                    colorCode: '#fff',
                    onTap: () {
                      print('Tapped on Item $index');
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLoading() => Center(
      child: CircularProgressIndicator(),
    );

class RowItemHome extends StatelessWidget {
  final String title;
  final String count;
  final String colorCode;
  final VoidCallback onTap;

  const RowItemHome({
    Key? key,
    required this.title,
    required this.count,
    required this.colorCode,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Colors.black45,
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity, // Match parent height
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        topLeft: Radius.circular(8.0))),
              ),
            ),
            Expanded(
              flex: 14,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Center(
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
