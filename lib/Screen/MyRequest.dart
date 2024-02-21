import 'package:flutter/material.dart';

import '../Utils/MyCustomColors.dart';

class MyRequest extends StatelessWidget {
  const MyRequest({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Request"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: MyCustomColors.primaryColor,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            height: 150,
            width: 150,
         child: Text("My Request Screen"),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ClipOval(
          child: FloatingActionButton(
            onPressed: () {
              // Add your onPressed logic here
            },
            backgroundColor: MyCustomColors.primaryColor,
            child: Icon(Icons.add,color: Colors.white,),
          ),
        ),
      ),
    );
  }
}
