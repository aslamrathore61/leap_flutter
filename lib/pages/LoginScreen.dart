import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/loginBloc/login_event.dart';
import 'package:leap_flutter/db/SharedPrefObj.dart';
import '../Bloc/loginBloc/login_bloc.dart';
import '../Bloc/loginBloc/login_state.dart';
import '../Utils/GlabblePageRoute.dart';
import '../Utils/constants.dart';
import 'DashboardBottomNavigation.dart';

class LoginScreenPage extends StatefulWidget {
  const LoginScreenPage({Key? key}) : super(key: key);

  @override
  State<LoginScreenPage> createState() => _LoginScreenPageState();
}

bool _obscureTextPassword = true;

class _LoginScreenPageState extends State<LoginScreenPage> {
  final _formKey = GlobalKey<FormState>();

  String? _userEmail;
  String? _userPassword;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        "Please sign in to continue.",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
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
                                hintText: "Please Enter EmailID",
                                contentPadding: kTextFieldPadding,
                                border: kDefaultOutlineInputBorder,
                                enabledBorder: kDefaultOutlineInputBorder,
                                focusedBorder:
                                    kDefaultOutlineInputBorder.copyWith(
                                        borderSide: BorderSide(
                                  color: primaryColor,
                                )),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: primaryColor,
                                ),
                                // Left icon
                                prefixIconConstraints: BoxConstraints(
                                    minWidth: 40), // Width of left icon
                              ),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              obscureText: _obscureTextPassword,
                              validator: passwordValidator,
                              onSaved: (value) => _userPassword = value!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: titleColor, fontSize: 14),
                              cursorColor: primaryColor,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Please Enter Password",
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureTextPassword =
                                          !_obscureTextPassword;
                                    });
                                  },
                                  child: _obscureTextPassword
                                      ? const Icon(Icons.visibility_off,
                                          color: bodyTextColor)
                                      : const Icon(Icons.visibility,
                                          color: bodyTextColor),
                                ),
                                contentPadding: kTextFieldPadding,
                                border: kDefaultOutlineInputBorder,
                                enabledBorder: kDefaultOutlineInputBorder,
                                focusedBorder:
                                    kDefaultOutlineInputBorder.copyWith(
                                        borderSide: BorderSide(
                                  color: primaryColor,
                                )),
                                prefixIcon: Icon(
                                  Icons.key,
                                  color: primaryColor,
                                ),
                                // Left icon
                                prefixIconConstraints: BoxConstraints(
                                    minWidth: 40), // Width of left icon
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              // Forgot password action
                            },
                            child: Text(
                              "Forgot Your Password?",
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginFetchingErrorState) {
                            showErrorDialog(context, state.error!);
                          } else if (state is LoginFetchingSuccessState &&
                              state.loginResponse != null) {
                            // save token for future api
                            SharedPrefObj.setSharedPrefValue(bearerToken,
                                state.loginResponse!.result!.token!);
                            SharedPrefObj.setSharedPrefValue(loginStatus, "1");
                            Navigator.of(context).pushReplacement(
                                GlabblePageRoute(
                                    page: DashboardBottomNavigation()));
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                if (state is LoginLoadingState) {
                                  // Loading state
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  // Initial state or other states
                                  return Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          context.read<LoginBloc>().add(
                                              LoginSubmittedEvent(
                                                  _userEmail!, _userPassword!));
                                        }
                                      },
                                      child: Text("Login".toUpperCase()),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
