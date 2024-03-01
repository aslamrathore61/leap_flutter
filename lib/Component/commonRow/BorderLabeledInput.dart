import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Utils/constants.dart';

class BorderLabeledInput extends StatelessWidget {
  final String label;
  final String hint;
  final Icon? icon;
  final bool enabled; // Add this line
  final GestureTapCallback press;
  final TextEditingController controller;

  const BorderLabeledInput(
      {Key? key,
      required this.label,
      required this.controller,
      required this.hint,
      this.icon,
      required this.press,
      required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextFormField(
          enabled: enabled,
          controller: controller,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: titleColor,
            fontSize: 14,
          ),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: kTextFieldPadding,
            border: kDefaultOutlineInputBorder.copyWith(
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: kDefaultOutlineInputBorder.copyWith(
              borderSide: BorderSide(color: borderColor),
            ),
            disabledBorder: kDefaultOutlineInputBorder.copyWith(
              borderSide: BorderSide(color: borderColor.withOpacity(0.4)),
            ),
            suffixIcon: icon,
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }
}
