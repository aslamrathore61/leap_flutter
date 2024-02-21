import 'package:flutter/material.dart';
import 'package:leap_flutter/Screen/FlyersCardPage.dart';
import 'package:leap_flutter/models/ServiceCountResponse.dart';
import '../Utils/MyCustomColors.dart';
import 'BusinessCardsScreen.dart';
import '../Utils/GlabblePageRoute.dart';

class CreationOptionScreen extends StatelessWidget {
  const CreationOptionScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    List<String> TrainingList = ['One to One Mentorship', 'Corporate Training'];
    List<String> CardList = [
      'Business Cards - Design and Print',
      'Flyer - Personalized'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyCustomColors.primaryColor,
        title: Text(
          "Create Request",
          style: TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        iconTheme:
            IconThemeData(color: Colors.white), // Change back arrow color here
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0, left: 18.0, top: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /***   Title Training and Appointment  ***/
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyCustomColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 7.0, bottom: 7.0, left: 10.0, right: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Container(
                          child: Text(
                            "Training and Appointments",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: TrainingList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    // Add bottom padding for the gap
                    child: RowItemCreation(
                      title: TrainingList[index],
                      onTap: () {
                        print('Tapped on Item $index');
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 20),

              /***   Requests  ***/
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyCustomColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 7.0, bottom: 7.0, left: 10.0, right: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Container(
                          child: Text(
                            "Requests",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              ListView.builder(
                shrinkWrap: true,
                itemCount: CardList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    // Add bottom padding for the gap
                    child: RowItemCreation(
                      title: CardList[index],
                      onTap: () {
                        if (index == 0) {
                          Navigator.of(context).push(
                              GlabblePageRoute(page: BusinessCardsScreen()));
                        } else {
                          Navigator.of(context)
                              .push(GlabblePageRoute(page: FlyersCardPage()));
                        }
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RowItemCreation extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const RowItemCreation({
    Key? key,
    required this.title,
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
                child: Icon(
                  Icons.double_arrow,
                  color: MyCustomColors.primaryColor,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
