import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:leap_flutter/Bloc/loginBloc/login_bloc.dart';
import 'package:leap_flutter/Bloc/loginBloc/login_event.dart';
import 'package:leap_flutter/models/LoginResponse.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../Bloc/loginBloc/login_state.dart';
import '../Component/buttons/primary_button.dart';
import '../Utils/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

bool _obscureTextPassword = true;

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool enableEmailPage = true;
  bool enableOtpPage = false;
  bool enableCreatePWDPage = false;
  bool canPop = true;
  bool TimerGoingOn = true;
  bool StartCountDount = false;

  final _formKey = GlobalKey<FormState>();
  final _choosePWDformKey = GlobalKey<FormState>();

  String? _userPassword;
  String? _userEmail;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvoked: (didPop) {
        if (!canPop) {
          handleOnBackPress();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back press for the app bar here
              handleOnBackPress();
            },
          ),
          title: Text("Forgot Password"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/images/leaplogo.png'),
                  ),
                ),
                if (enableEmailPage) FirstEmailPage(),
                if (enableOtpPage) SecondOtpPage(),
                if (enableCreatePWDPage) ThirdCreatePasswordPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ThirdCreatePasswordPage() {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Form(
        key: _choosePWDformKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a new password',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
            SizedBox(
              height: 12,
            ),
            Text(
                "To secure your account, choose a strong password you haven't used beforeand is at least 8 characters long.",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: titleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w300)),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: _obscureTextPassword,
              validator: passwordValidator,
              onSaved: (value) => _userPassword = value!,
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
                      _obscureTextPassword = !_obscureTextPassword;
                    });
                  },
                  child: _obscureTextPassword
                      ? const Icon(Icons.visibility_off, color: bodyTextColor)
                      : const Icon(Icons.visibility, color: bodyTextColor),
                ),
                contentPadding: kTextFieldPadding,
                border: kDefaultOutlineInputBorder,
                enabledBorder: kDefaultOutlineInputBorder,
                focusedBorder: kDefaultOutlineInputBorder.copyWith(
                    borderSide: BorderSide(
                  color: primaryColor,
                )),
                prefixIcon: Icon(
                  Icons.key,
                  color: primaryColor,
                ),
                // Left icon
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40), // Width of left icon
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              obscureText: true,
              validator: passwordValidator,
              onSaved: (value) => _userPassword = value!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: titleColor, fontSize: 14),
              cursorColor: primaryColor,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Enter retype new password",

                contentPadding: kTextFieldPadding,
                border: kDefaultOutlineInputBorder,
                enabledBorder: kDefaultOutlineInputBorder,
                focusedBorder: kDefaultOutlineInputBorder.copyWith(
                    borderSide: BorderSide(
                  color: primaryColor,
                )),
                prefixIcon: Icon(
                  Icons.key,
                  color: primaryColor,
                ),
                // Left icon
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40), // Width of left icon
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is ChooseNewPWDSubmitLoadingState) {
                  Navigator.of(context).pop();
                  showToast(
                      'Password successfully change!',
                      Colors.green,
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                      ));
                } else if (state is ChooseNewPWDSubmitErrorState) {
                  showSnackBar(
                      context, 'Something went wrong, please try again.');
                }
              },
              builder: (context, state) {
                return state is ChooseNewPWDSubmitLoadingState
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        text: 'Next',
                        press: () {
                          if (_choosePWDformKey.currentState!.validate()) {
                            _choosePWDformKey.currentState!.save();
                            ResetPasswordReq resetPasswrod = ResetPasswordReq();
                            resetPasswrod.emailId = _userEmail;
                            resetPasswrod.newPassword = _userPassword;
                            context.read<LoginBloc>().add(
                                ChooseNewPWDSubmitEvent(
                                    resetPasswrod, 'resetpassword'));
                          }
                        },
                      );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget SecondOtpPage() {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is OTPValidateLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            );
          } else if (state is OTPValidateSuccessState) {
            Navigator.of(context).pop();
            setState(() {
              enableEmailPage = false;
              enableOtpPage = false;
              enableCreatePWDPage = true;
              canPop = true;
            });
          } else if (state is OTPValidateErrorState) {
            Navigator.of(context).pop();

            showToast(
                'Invalid OTP, Please check the code and try again.',
                Colors.green,
                const Icon(
                  Icons.check,
                  color: Colors.white,
                ));
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter the 6-digit code',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 12,
              ),
              Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: titleColor.withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                  text: "Check ",
                  children: <TextSpan>[
                    TextSpan(
                      text: _userEmail,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    TextSpan(
                        text: ' for a verification code.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: titleColor.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                            fontSize: 14))
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  handleOnBackPress();
                },
                child: Text('Changes email',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: primaryColor.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        fontSize: 14)),
              ),
              SizedBox(
                height: 12,
              ),
              OtpTextField(
                fieldWidth: 45,
                numberOfFields: 6,
                cursorColor: primaryColor,
                borderColor: primaryColor,
                //set to true to show as box or false to show as dash
                showFieldAsBox: true,
                //runs when a code is typed in
                onCodeChanged: (String code) {
                  print('code $code');
                  //handle validation or checks here
                },
                //runs when every textfield is filled
                onSubmit: (String verificationCode) {
                  ResetPasswordReq resetPasswrod = ResetPasswordReq();
                  resetPasswrod.emailId = _userEmail;
                  resetPasswrod.otp = verificationCode;
                  context
                      .read<LoginBloc>()
                      .add(OTPValidateEvent(resetPasswrod, 'validateotp'));
                }, // end onSubmit
              ),
              SizedBox(
                height: 15,
              ),
              if (StartCountDount)
                Countdown(
                  key: UniqueKey(),
                  // Using UniqueKey here
                  seconds: 30,
                  build: (BuildContext context, double time) =>
                      TimerGoingOn ? timeStatusView(time) : resendOTPView(),
                  interval: Duration(milliseconds: 1000),
                  onFinished: () {
                    setState(() {
                      TimerGoingOn = !TimerGoingOn;
                    });
                  },
                ),
              SizedBox(
                height: 15,
              ),
              Text(
                  "If you don't see a code in your inbox, check your spam folder if it's not there, the email address may not be confirmed, or it may not match an existing LEAP account",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: titleColor.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.w300)),
            ],
          );
        },
      ),
    );
  }

  Widget timeStatusView(double? time) {
    if (time == null) {
      return resendOTPView();
    }
    int remainingSeconds = time.toInt();
    String minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    String seconds = (remainingSeconds % 60).toString().padLeft(2, '0');

    return Text(
      'Resend OTP in $minutes:$seconds',
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
    );
  }

  Widget resendOTPView() {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is ResetPWDSuccessState) {
            setState(() {
              TimerGoingOn = true;
              StartCountDount = true;
            });
          }
        },
        builder: (context, state) {
          return InkWell(
            onTap: () {
              ResetPasswordReq resetPasswrod = ResetPasswordReq();
              resetPasswrod.emailId = _userEmail;
              context
                  .read<LoginBloc>()
                  .add(ResetPWDSubmitEvent(resetPasswrod, 'resetpasswordmail'));
            },
            child: Text(
              'Resend OTP',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget FirstEmailPage() {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Forgot your password?',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: titleColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500)),
          SizedBox(
            height: 12,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              validator: emailValidator,
              onSaved: (value) {
                // print("Email saved: $value"); // Debugging print statement
                _userEmail = value!;
              },
              textInputAction: TextInputAction.next,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: titleColor, fontSize: 14),
              cursorColor: primaryColor,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Please Enter Email",
                contentPadding: kTextFieldPadding,
                border: kDefaultOutlineInputBorder,
                enabledBorder: kDefaultOutlineInputBorder,
                focusedBorder: kDefaultOutlineInputBorder.copyWith(
                    borderSide: BorderSide(
                  color: primaryColor,
                )),
                prefixIcon: Icon(
                  Icons.person,
                  color: primaryColor,
                ),
                // Left icon
                prefixIconConstraints:
                    BoxConstraints(minWidth: 40), // Width of left icon
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
              'We will send a verification code to this email if it matches an existing LEAP account.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: titleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w300)),
          SizedBox(
            height: 20,
          ),
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is ResetPWDSuccessState) {
                setState(() {
                  enableEmailPage = false;
                  enableOtpPage = true;
                  canPop = true;
                  StartCountDount = true;
                });
              } else if (state is FetchingErrorState) {
                showSnackBar(context, state.error ?? 'Something went wrong');
              }
            },
            builder: (context, state) {
              return state is LoginLoadingState
                  ? const Center(child: CircularProgressIndicator())
                  : PrimaryButton(
                      text: 'Next',
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          ResetPasswordReq resetPasswrod = ResetPasswordReq();
                          resetPasswrod.emailId = _userEmail;
                          context.read<LoginBloc>().add(ResetPWDSubmitEvent(
                              resetPasswrod, 'resetpasswordmail'));
                        }
                      },
                    );
            },
          ),
        ],
      ),
    );
  }

  void handleOnBackPress() {
    if (enableOtpPage) {
      setState(() {
        enableOtpPage = false;
        enableEmailPage = true;
        canPop = true;
      });
    } else {
      Navigator.of(context).pop();
    }
  }
}
