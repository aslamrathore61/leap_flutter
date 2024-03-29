import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_painter/image_painter.dart';
import '../Component/buttons/primary_button.dart';
import '../Utils/constants.dart';
import '../models/TouchPoint.dart';

class ImagePainterPage extends StatefulWidget {
  final String imageUrl;

  const ImagePainterPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImagePainterPageState createState() => _ImagePainterPageState();
}

class _ImagePainterPageState extends State<ImagePainterPage> {
  List<TouchPoint> circleList = [];
  final imagePainterController = ImagePainterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proof Read View"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 12,
              child: ImagePainter.network(
                widget.imageUrl,
                scalable: true,
                controller: imagePainterController,
              )),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, left: 10.0),
              child: PrimaryButton(
                text: 'Save',
                press: () async {
                  Uint8List? byteArray =
                      await imagePainterController.exportImage();
                  Navigator.pop(context, byteArray);
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
