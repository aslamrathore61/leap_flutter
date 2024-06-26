import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Bloc/serviceCountBloc/service_count_bloc.dart';
import '../Bloc/serviceCountBloc/service_count_event.dart';
import '../Bloc/serviceCountBloc/service_count_state.dart';
import '../Component/buttons/primary_button.dart';
import '../Utils/constants.dart';
import '../models/Profile.dart';

class MyProfileEditPage extends StatefulWidget {
  const MyProfileEditPage({Key? key, this.profileDetails}) : super(key: key);
  final Profile? profileDetails;

  @override
  State<MyProfileEditPage> createState() => _MyProfileEditPageState();
}

class _MyProfileEditPageState extends State<MyProfileEditPage> {
  final ServiceCountBloc _serviceCountBloc = ServiceCountBloc();
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  String? _firstName;
  String? _lastName;
  String? _mobileNumber;
  String? _mProfileImagePath;

  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Edit Profile",
          style: Theme
              .of(context)
              .textTheme
              .bodyLarge!
              .copyWith(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: Container(
        color: primaryColor,
        child: BlocProvider(
          create: (context) => _serviceCountBloc,
          child: BlocListener<ServiceCountBloc, ServiceCountState>(
            listener: (context, state) {
              if (state is ProfileUpdateAndFetchingErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString())));
              } else if (state is ProfileUpdateSuccessState) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LottieBuilder.asset(
                              'assets/lottie/success_file.json',
                              height: 100,
                              repeat: false,
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Profile Update Successful!",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.pop(context, "1");
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                color: primaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 12),
                      width: double.infinity,
                      height: 1,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    _buildProfileImage(),
                    SizedBox(
                      height: 50,
                    ),
                    _buildTopCornerReduceContainer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        Container(
          width: 80, // Adjust the width and height as needed
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.black, // Adjust border color as needed
              width: 2, // Adjust border width as needed
            ),
          ),
          child: buildCircularImage(
            imageUrl: widget.profileDetails?.result?.profileImage,
            fileImage: _image,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.camera), // You can use any icon you want
            onPressed: () async {
              showOptions();
            },
          ),
        ),
      ],
    );
  }

  Widget buildCircularImage({String? imageUrl, File? fileImage}) {
    return ClipOval(
      child: fileImage == null
          ? Image.network(
        imageUrl ??
            'https://www.vectorstock.com/royalty-free-vectors/profile-male-vectors',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return CircularProgressIndicator(
            value: progress.expectedTotalBytes != null
                ? progress.cumulativeBytesLoaded /
                progress.expectedTotalBytes!
                : null,
          );
        },
      )
          : Image.file(
        fileImage,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTopCornerReduceContainer() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          )),
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildEditRow(
                  label: 'First Name*',
                  validator: requiredValidator('First Name'),
                  onSaved: (value) => _firstName = value,
                  initialValue: capitalizeFirstLetterOfEachWord(
                      widget.profileDetails?.result?.firstName ?? ''),
                  keyboardType: TextInputType.text),
              SizedBox(
                height: 10,
              ),
              buildEditRow(
                  label: 'Last Name*',
                  validator: requiredValidator('Last Name'),
                  onSaved: (value) => _lastName = value,
                  initialValue: capitalizeFirstLetterOfEachWord(
                      widget.profileDetails?.result?.lastName ?? ''),
                  keyboardType: TextInputType.text),
              SizedBox(
                height: 10,
              ),
              buildEditRow(
                  maxLength: 10,
                  label: 'Mobile Number*',
                  validator: minLengthValidator('Mobile Number'),
                  onSaved: (value) => _mobileNumber = value,
                  initialValue:
                  widget.profileDetails?.result?.phoneNumber ?? '',
                  keyboardType: TextInputType.number),
              SizedBox(
                height: 10,
              ),
              buildFixedRow(
                label: 'Email Address',
                initialValue: widget.profileDetails?.result?.email ?? '',
              ),
              buildFixedRow(
                label: 'Office',
                initialValue: widget.profileDetails?.result?.organization ?? '',
              ),
              buildFixedRow(
                label: 'Current Mentors',
                initialValue:
                widget.profileDetails?.result?.currentMentors![0] ?? '',
              ),
              buildFixedRow(
                label: 'Model',
                initialValue: widget.profileDetails?.result?.splitModel ?? '',
              ),
              buildFixedRow(
                label: 'Franchise / Brokerage',
                initialValue:
                widget.profileDetails?.result!.isFranchise ?? false
                    ? "Franchise"
                    : "Brokerage",
              ),
              buildFixedRow(
                label: 'Tenure with SM',
                initialValue: widget.profileDetails?.result?.tenureWithSM ?? '',
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<ServiceCountBloc, ServiceCountState>(
                builder: (context, state) {
                  return state is ProfileUpdateAndFetchingLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(
                      text: 'Submit',
                      press: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final profileUpdate = ProfileUpdate();
                          profileUpdate.phoneNumber = _mobileNumber;
                          profileUpdate.userFirstName = _firstName;
                          profileUpdate.userLastName = _lastName;

                          if (_image != null) {
                            List<int> imageBytes = _image!.readAsBytesSync();
                            String base64Image = base64Encode(imageBytes);
                            _mProfileImagePath = 'data:image/png;base64,$base64Image';
                            profileUpdate.imageData = _mProfileImagePath;
                          }

                          _serviceCountBloc.add(UpdateProfileDetailsEvent(
                              profileUpdate: profileUpdate));
                        } else {
                          // Find the first error in the form and scroll to it
                          final FocusScopeNode currentFocus =
                          FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus &&
                              currentFocus.focusedChild != null) {
                            currentFocus.focusedChild!.unfocus();
                          }

                          _scrollController.animateTo(
                            0.0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                },
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditRow({
    int? maxLength,
    required String label,
    required String? Function(String?)? validator,
    required void Function(String?)? onSaved,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
          maxLength: maxLength ?? 20,
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: titleColor,
            fontSize: 14,
          ),
          cursorColor: primaryColor,
          decoration: InputDecoration(
              hintText: "Please Enter $label",
              contentPadding: kTextFieldPadding,
              border: kDefaultOutlineInputBorder.copyWith(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: borderColor.withOpacity(0.9)),
              ),
              focusedBorder: kDefaultOutlineInputBorder.copyWith(
                borderSide: BorderSide(color: borderColor),
              ),
              counterText: ''),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget buildNumberInputEditRow({
    required String label,
    required String? Function(String?)? validator,
    required void Function(String?)? onSaved,
    String? initialValue,
    TextInputType keyboardType = TextInputType.text,
  }) {
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
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          keyboardType: keyboardType,
          textInputAction: TextInputAction.next,
          style: TextStyle(
            color: titleColor,
            fontSize: 14,
          ),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            hintText: "Please Enter $label",
            contentPadding: kTextFieldPadding,
            border: kDefaultOutlineInputBorder.copyWith(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor.withOpacity(0.9)),
            ),
            focusedBorder: kDefaultOutlineInputBorder.copyWith(
              borderSide: BorderSide(color: borderColor),
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget buildFixedRow({
    required String label,
    String? initialValue,
  }) {
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
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            // Set your desired background color here
            borderRadius: BorderRadius.circular(
                10), // Optional: Add border radius for rounded corners
          ),
          child: TextFormField(
            initialValue: initialValue,
            textInputAction: TextInputAction.next,
            enabled: false,
            style: TextStyle(
              color: titleColor,
              fontSize: 14,
            ),
            cursorColor: primaryColor,
            decoration: InputDecoration(
              border: InputBorder
                  .none, // Optional: Remove the border of the TextFormField
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 25)
        .then((value) =>
    {
      if (value != null) {cropImageCall(File(value.path))}
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 25)
        .then((value) async =>
    {
      if (value != null) {cropImageCall(File(value.path))}
    });
  }

  cropImageCall(File imgFile) async {
    String? croppedImagePath = await cropImage(imgFile);
    if (croppedImagePath != null) {
      imageCache.clear();
      setState(() {
        _image = File(croppedImagePath);
      });
    }
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text('Photo Gallery'),
                onPressed: () async {
                  // close the options modal
                  Navigator.of(context).pop();

                  AndroidDeviceInfo? deviceInfo;

                  if (Platform.isAndroid) {
                    deviceInfo = await DeviceInfoPlugin().androidInfo;
                  }

                  if (Platform.isAndroid &&
                      deviceInfo != null &&
                      deviceInfo.version.sdkInt <= 32) {
                    Map<Permission, PermissionStatus> galleryPermission =
                    await [Permission.storage].request();
                    if (galleryPermission[Permission.storage]!.isGranted) {
                      getImageFromGallery();
                    } else if (galleryPermission[Permission.storage]!
                        .isPermanentlyDenied) {
                      showPermissionSettingsDialog(context,
                          'Please enable storage permission in app settings to use this feature.');
                    }
                  } else {
                    Map<Permission, PermissionStatus> galleryPermission =
                    await [Permission.photos].request();
                    if (galleryPermission[Permission.photos]!.isGranted) {
                      getImageFromGallery();
                    } else if (galleryPermission[Permission.photos]!
                        .isPermanentlyDenied) {
                      showPermissionSettingsDialog(context,
                          'Please enable storage permission in app settings to use this feature.');
                    }
                  }

                },
              ),
              CupertinoActionSheetAction(
                child: Text('Camera'),
                onPressed: () async {
                  // close the options modal
                  Navigator.of(context).pop();

                  Map<Permission, PermissionStatus> cameraPermission =
                  await [Permission.camera].request();
                  if (cameraPermission[Permission.camera]!.isGranted) {
                    // get image from camera
                    getImageFromCamera();
                  } else if (cameraPermission[Permission.camera]!
                      .isPermanentlyDenied) {
                    showPermissionSettingsDialog(context,
                        'Please enable storage permission in app settings to use this feature.');
                  }
                },
              ),
            ],
          ),
    );
  }
}

