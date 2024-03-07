// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
// import 'package:leap_flutter/Component/buttons/primary_button.dart';
// import 'package:leap_flutter/Utils/constants.dart';
//
// import '../Bloc/serviceCountBloc/service_count_bloc.dart';
// import '../Bloc/serviceCountBloc/service_count_event.dart';
// import '../db/SharedPrefObj.dart';
// import '../models/Profile.dart';
//
// class ChangePasswordDialog extends StatefulWidget {
//  /* final Function(String oldPassword, String newPassword, String confirmPassword)
//       onSubmit;*/
//
//   ServiceCountBloc? serviceCountBloc;
//   const ChangePasswordDialog({Key? key,required this.onSubmit})
//       : super(key: key);
//
//   @override
//   _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
// }
//
// class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
//   final _formKey = GlobalKey<FormState>();
//
//   String _password = '';
//   String _confirmPassword = '';
//
//   TextEditingController _oldPasswordController = TextEditingController();
//   TextEditingController _newPasswordController = TextEditingController();
//   TextEditingController _confirmPasswordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Change Password'),
//       content: SingleChildScrollView(
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 validator: passwordValidator,
//                 controller: _oldPasswordController,
//                 decoration: InputDecoration(labelText: 'Old Password'),
//                 obscureText: true,
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 validator: passwordValidator,
//                 controller: _newPasswordController,
//                 onChanged: (value) {
//                   setState(() {
//                     _newPasswordController.text = value;
//                   });
//                 },
//                 decoration: InputDecoration(labelText: 'New Password'),
//                 obscureText: true,
//               ),
//               SizedBox(height: 10),
//               TextFormField(
//                 validator: confirmPasswordValidation,
//                 controller: _confirmPasswordController,
//                 decoration: InputDecoration(labelText: 'Confirm Password'),
//                 onChanged: (value) {
//                   setState(() {
//                     _confirmPasswordController.text = value;
//                   });
//                 },
//                 obscureText: true,
//               ),
//             ],
//           ),
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Cancel'),
//         ),
//         PrimaryButton(
//             text: 'Update Password',
//             press: () async {
//               if (_formKey.currentState!.validate()) {
//                 _formKey.currentState!.save();
//                 if (_newPasswordController.text ==
//                     _confirmPasswordController.text) {
//
//                   Profile? profileDetailsss = await SharedPrefObj.getProfileSharedPreValue(profileDetails);
//                   final changePassword = ChangesPassword(
//                       oldPassword: _oldPasswordController.text,
//                       newPassword: _newPasswordController.text,
//                       emailId: profileDetailsss?.result?.email);
//                   widget.serviceCountBloc?.add(ChangesPasswordEvent(changesPassword: changePassword));
//
//                 /*  String oldPassword = _oldPasswordController.text;
//                   String newPassword = _newPasswordController.text;
//                   String confirmPassword = _confirmPasswordController.text;
//                   widget.onSubmit(oldPassword, newPassword, confirmPassword);
//                   Navigator.of(context).pop();*/
//
//
//                 }
//               }
//             })
//       ],
//     );
//   }
//
//   String? confirmPasswordValidation(String? value) {
//     print('confirmPassword : $value : newPwd : ${_newPasswordController.text}');
//     if (value != _newPasswordController.text) {
//       return 'Passwords do not match';
//     }
//     return null;
//   }
// }
