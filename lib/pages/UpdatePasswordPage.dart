import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/serviceCountBloc/service_count_bloc.dart';
import '../Bloc/serviceCountBloc/service_count_event.dart';
import '../Bloc/serviceCountBloc/service_count_state.dart';
import '../Component/buttons/primary_button.dart';
import '../Utils/constants.dart';
import '../db/SharedPrefObj.dart';
import '../models/Profile.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

bool oldObscurePassword = true;
bool newObscurePassword = true;

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final ServiceCountBloc _serviceCountBloc = ServiceCountBloc();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        title: Text(
          "Update Password",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: BlocProvider(
        create: (context) => _serviceCountBloc,
        child: BlocListener<ServiceCountBloc, ServiceCountState>(
          listener: (context, state) {
            if (state is ChangesPasswordErrorState) {
              showToast(
                  state.error.toString(),
                  Colors.red,
                  const Icon(
                    Icons.close,
                    color: Colors.white,
                  ));
            } else if (state is ChangesPasswordSuccessState) {
              _oldPasswordController.text = '';
              _newPasswordController.text = '';
              _confirmPasswordController.text = '';
              Navigator.of(context).pop();
              showToast(
                  'Password successfully changed',
                  Colors.green,
                  const Icon(
                    Icons.check,
                    color: Colors.white,
                  ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: oldObscurePassword,
                      validator: passwordValidator,
                      controller: _oldPasswordController,
                      onSaved: (value) {},
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: titleColor, fontSize: 14),
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter old password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              oldObscurePassword = !oldObscurePassword;
                            });
                          },
                          child: oldObscurePassword
                              ? const Icon(Icons.visibility_off,
                                  color: bodyTextColor)
                              : const Icon(Icons.visibility,
                                  color: bodyTextColor),
                        ),
                        contentPadding: kTextFieldPadding,
                        border: kDefaultOutlineInputBorder,
                        enabledBorder: kDefaultOutlineInputBorder,
                        focusedBorder: kDefaultOutlineInputBorder.copyWith(
                            borderSide: BorderSide(
                          color: primaryColor,
                        )),
                     /*   prefixIcon: Icon(
                          Icons.key,
                          color: primaryColor,
                        ),*/
                        // Left icon
                        prefixIconConstraints:
                            BoxConstraints(minWidth: 40), // Width of left icon
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      obscureText: newObscurePassword,
                      validator: passwordValidator,
                      controller: _newPasswordController,
                      onSaved: (value) {},
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: titleColor, fontSize: 14),
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter new password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              newObscurePassword = !newObscurePassword;
                            });
                          },
                          child: newObscurePassword
                              ? const Icon(Icons.visibility_off,
                                  color: bodyTextColor)
                              : const Icon(Icons.visibility,
                                  color: bodyTextColor),
                        ),
                        contentPadding: kTextFieldPadding,
                        border: kDefaultOutlineInputBorder,
                        enabledBorder: kDefaultOutlineInputBorder,
                        focusedBorder: kDefaultOutlineInputBorder.copyWith(
                            borderSide: BorderSide(
                          color: primaryColor,
                        )),
                       /* prefixIcon: Icon(
                          Icons.key,
                          color: primaryColor,
                        ),*/
                        // Left icon
                        prefixIconConstraints:
                        BoxConstraints(minWidth: 40), // Width of left icon
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    TextFormField(
                      obscureText: true,
                      validator: confirmPasswordValidation,
                      controller: _confirmPasswordController,
                      onSaved: (value) {},
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: titleColor, fontSize: 14),
                      cursorColor: primaryColor,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Enter retype password",
                        contentPadding: kTextFieldPadding,
                        border: kDefaultOutlineInputBorder,
                        enabledBorder: kDefaultOutlineInputBorder,
                        focusedBorder: kDefaultOutlineInputBorder.copyWith(
                            borderSide: BorderSide(
                              color: primaryColor,
                            )),
                        // Left icon
                        prefixIconConstraints:
                        BoxConstraints(minWidth: 40), // Width of left icon
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    BlocBuilder<ServiceCountBloc, ServiceCountState>(
                      builder: (context, state) {
                        return state is ChangesPasswordLoading
                            ? const Center(child: CircularProgressIndicator())
                            : PrimaryButton(
                                text: 'Update Password',
                                press: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    if (_newPasswordController.text ==
                                        _confirmPasswordController.text) {
                                      Profile? profileDetailsss =
                                          await SharedPrefObj
                                              .getProfileSharedPreValue(
                                                  profileDetails);
                                      final changePassword = ChangesPassword(
                                          oldPassword:
                                              _oldPasswordController.text,
                                          newPassword:
                                              _newPasswordController.text,
                                          emailId:
                                              profileDetailsss?.result?.email);

                                      _serviceCountBloc.add(
                                          ChangesPasswordEvent(
                                              changesPassword: changePassword));
                                    }
                                  }
                                });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? confirmPasswordValidation(String? value) {
    print('confirmPassword : $value : newPwd : ${_newPasswordController.text}');
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
