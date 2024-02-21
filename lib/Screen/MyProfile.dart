import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Utils/MyCustomColors.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyCustomColors.primaryColor,
          title: Text(
            "My Profile",
            style: TextStyle(
                fontSize: 18,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: MyCustomColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(
                                'assets/images/moon.png'), // Replace 'your_image.png' with your local image path
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Aligns the text to the left side
                            children: [
                              Container(
                                child: Text(
                                  "Aslam Rathore",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "aslamrathore9@gmail.com",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
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
                        child: Icon(
                          Icons.edit_note,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
          
                /*** Horizontal Divider ***/
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 12),
                        width: double.infinity,
                        height: 1,
                        color: MyCustomColors.primaryColor,
                      ),
                    )
                  ],
                ),
          
                /***  Profile Info View  ***/
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 15, top: 23),
                    child: Text(
                      "Profile Info.",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
          
                /***   Mobile Number View ***/
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.call,
                          size: 22,
                          color: MyCustomColors.primaryColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Mobile Number",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                  ),
                                  Image.asset('assets/images/canada.png',
                                      width: 20, height: 18),
                                ],
                              ),
                              Text(
                                "9782391040",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          
                /***   Office View ***/
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    child: Row(
                      children: [
                        Image.asset('assets/images/briefcase.png',
                            width: 20, height: 18),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Office",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              Text(
                                "9782391040",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          
                /***   Current Mentor View ***/
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    child: Row(
                      children: [
                        Image.asset('assets/images/current_mentor.png',
                            width: 20, height: 18),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Mentor",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              Text(
                                "Sachin Gupta",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          
                /***   Model View ***/
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.model_training,
                          size: 22,
                          color: MyCustomColors.primaryColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Model",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              Text(
                                "40 C5",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          
                /***   Franchise/Brokerage View ***/
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    child: Row(
                      children: [
                        Image.asset('assets/images/franchise.png',
                            width: 20, height: 18),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Frachise/Brokerage",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              Text(
                                "Brokerage",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          
                /***   Tenure WithSM View ***/
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 22,
                          color: MyCustomColors.primaryColor,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tenure with SM",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black),
                              ),
                              Text(
                                "2 Year",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          
                /*** Horizontal Divider ***/
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: 1,
                        color: MyCustomColors.primaryColor,
                      ),
                    )
                  ],
                ),
          
                /***  Setting View  ***/
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18, right: 15, top: 10),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
          
                /***   Changes Password View ***/
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    child: Row(
                      children: [
                        Image.asset('assets/images/password.png',
                            width: 20, height: 18),
                        Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Change Password",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ))
                      ],
                    ),
                  ),
                ),
          
                /***   Logout View ***/
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Container(
                    child: Row(
                      children: [
                        Image.asset('assets/images/signout.png',
                            width: 20, height: 18),
                        Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Logout",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ))
                      ],
                    ),
                  ),
                ),
          
          

          
          
              ],
            ),
          ),
        ));
  }
}
