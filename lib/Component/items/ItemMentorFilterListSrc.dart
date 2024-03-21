import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemMentorFilterListSrc extends StatelessWidget {
  final String itemName;
  final VoidCallback onTap;

  const ItemMentorFilterListSrc(
      {Key? key, required this.itemName, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
        //  borderRadius: BorderRadius.circular(10.0), // Set the radius for rounded corners
          color: Colors.grey.shade100,
          border: Border(
            bottom: BorderSide(
              color: Colors.black87,
              width: 0.0,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Text(
            itemName,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
