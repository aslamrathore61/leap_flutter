import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:leap_flutter/db/SharedPrefObj.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';

import '../Utils/GlabblePageRoute.dart';
import '../models/FlyersCardTemplateResponse.dart';
import '../models/MyRequestResponse.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../Bloc/cardBloc/card_bloc.dart';
import '../Bloc/cardBloc/card_event.dart';
import '../Bloc/cardBloc/card_state.dart';
import '../Utils/constants.dart';
import '../models/CreateUpdateCardRequestResponse.dart';
import '../models/Profile.dart';
import 'SuccessPage.dart';

class FlyersCardPage extends StatefulWidget {
  const FlyersCardPage({Key? key, this.flyers, this.profileDetails})
      : super(key: key);
  final Flyers? flyers;
  final Profile? profileDetails;

  @override
  State<FlyersCardPage> createState() => _FlyersCardsPageState();
}

class _FlyersCardsPageState extends State<FlyersCardPage> {
  final _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

  bool _isSearchFocused = false;

  final CardBloc cardBloc = CardBloc();
  List<FlyersTemplate> _flyersCardListing = [];
  List<FlyersTemplate> _filteredData = [];
  int _selectedImageIndex = -1;
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  String? _quantity;

  String? _propertyDescription;
  String? _mlsId;
  String? _propertyImageData;

  String? _flyerTemplatedUuid;

  @override
  void initState() {
    super.initState();
    _searchController.text =
        (widget.flyers != null ? widget.flyers!.flyerName : '')!;
    if (widget.flyers != null) _flyerTemplatedUuid = widget.flyers!.flyerUuid;

    print('widgetFlyers ${widget.flyers?.mlsId}');
    cardBloc.add(GetFlyersCardListEvent());
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _searchFocusNode.addListener(_onFocusChange);
  }

  File? _image;
  final picker = ImagePicker();

  void _onFocusChange() {
    if (_searchFocusNode.hasFocus) {
      _filterList(_searchController.text);
    }
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isSearchFocused = _searchFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flyers Request"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: _buildListTrainingRequest());
  }

//            child: _buildFormWidget(context)),
  Widget _buildListTrainingRequest() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: BlocProvider(
          create: (context) => cardBloc,
          child: BlocListener<CardBloc, CardState>(
            listener: (context, state) {
              if (state is CardTemplateErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString())));
              } else if (state is FlyersCardTemplateFetchingSuccessState) {
                if (!_flyersCardListing.isNotEmpty) {
                  _flyersCardListing
                      .addAll(state.flyersCardTemplateResponse.flyers!);
                  _filteredData
                      .addAll(state.flyersCardTemplateResponse.flyers! ?? []);
                }
              } else if (state is SubmissionCardReqErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString())));
              } else if (state is SubmissionCardReqSuccessState) {
                Navigator.of(context).pushReplacement(GlabblePageRoute(
                    page: SuccessPage(
                        toolbarTitle: "Flyers Card Confimration",
                        successDescription:
                            "Flyers card request created successfully. Our team will inform you of the next steps.")));
              }
            },
            child: _buildFormWidget(context),
          )),
    );
  }

  Widget _buildFormWidget(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /***  Card Template   ***/
              Text(
                "Card Template*",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _CardTemplateSrchField(),
              SizedBox(height: 10.0),
              if (_isSearchFocused)
                _buildTemplateListWidget(context, _filteredData),
              SizedBox(height: 10.0),
              _buildTemplateCardImage(),
              SizedBox(height: 10.0),
              Text(
                "Agent Details",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),


              /***  Name MLS ID  ***/
              SizedBox(height: 10.0),
              _buildTextFormField(
                label: "MLS ID*",
                validator: requiredValidator('MLS ID'),
                onSaved: (value) => _mlsId = value,
                initialValue: widget.flyers != null ? widget.flyers!.mlsId : '',
                keyboardType: TextInputType.text,
              ),

              /***  Name Property Descriptio  ***/
              SizedBox(height: 10.0),
              _buildTextFormField(
                  label: "Property Description*",
                  validator: requiredValidator('Property Description'),
                  onSaved: (value) => _propertyDescription = value,
                  initialValue: widget.flyers != null ? widget.flyers!.propertyDescription : '',
                  keyboardType: TextInputType.text),


              SizedBox(height: 10.0),


              /***    Property Image View  ***/
                SizedBox(height: 10.0),
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: showOptions,
                      child: Row(
                        children: [
                          Text(
                            "Property Image",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: titleColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.add_a_photo_rounded,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),

                    previewDisplayImage()
                  ],
                ),
              ),
              SizedBox(height: 10.0),




              /***  Quantity TextField  ***/
              _buildTextFormField(
                  label: 'Quantity*',
                  validator: requiredValidator('Quantity'),
                  onSaved: (value) => _quantity = value,
                  initialValue: widget.flyers != null
                      ? widget.flyers!.requestQuantity
                      : '',
                  keyboardType: TextInputType.number),
              SizedBox(height: 10.0),
              BlocBuilder<CardBloc, CardState>(
                builder: (context, state) {
                  return state is SubmissionCardLoadingState
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              final cardRequest = CreateUpdateCardRequest();

                              if (_image != null) {
                                List<int> imageBytes =
                                _image!.readAsBytesSync();
                                String base64Image = base64Encode(imageBytes);
                                _propertyImageData = 'data:image/png;base64,$base64Image';
                                cardRequest.propertyImageData = _propertyImageData;
                              }

                              cardRequest.mlsId = _mlsId;
                              cardRequest.propertyDescription = _propertyDescription;
                              cardRequest.propertyImageData = _propertyImageData;

                              cardRequest.requestQuantity = _quantity;
                              cardRequest.flyerUuid = _flyerTemplatedUuid;

                              if (widget.flyers != null) {
                                cardRequest.flyerRequestUuid =
                                    widget.flyers!.flyerRequestUuid;
                              }

                              cardBloc.add(SubmitFlyersCardEvent(
                                  createUpdateCardRequest: cardRequest,
                                  isPost: widget.flyers == null));
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
                          },
                          child: Text(widget.flyers != null
                              ? "Update Order".toUpperCase()
                              : 'Place Order'.toUpperCase()),
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget previewDisplayImage() {
    if (_image != null) {
      return Center(
        child: _image == null ? Text('No Image Selected') : Image.file(_image!),
      );
    } else {
      return Center(
        child: widget.flyers?.propertyImage == null
            ? Text('No Image Selected')
            : Image.network(widget.flyers?.propertyImage,
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
            }),
      );
    }
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

  
  /***  Search field card template ***/
  Widget _CardTemplateSrchField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _searchController,
      focusNode: _searchFocusNode,
      validator: requiredValidator("Card Template"),
      onChanged: (value) {
        // get data while typing
        // if (value.length >= 3) showResult();
        _filterList(value);
      },
      onFieldSubmitted: (value) {
        if (_formKey.currentState!.validate()) {
          // If all data are correct then save data to out variables
          _formKey.currentState!.save();

          // Once user pree on submit
        } else {}
      },
      textInputAction: TextInputAction.search,
      style: Theme.of(context)
          .textTheme
          .bodyMedium!
          .copyWith(color: titleColor, fontSize: 14),
      cursorColor: primaryColor,
      decoration: InputDecoration(
        hintText: "Search Template",
        contentPadding: kTextFieldPadding,
        border: kDefaultOutlineInputBorder.copyWith(
            borderSide: BorderSide(
          color: borderColor,
        )),
        focusedBorder: kDefaultOutlineInputBorder.copyWith(
            borderSide: BorderSide(
          color: borderColor,
        )),
        prefixIcon: Icon(
          Icons.search,
          color: borderColor,
        ),
        // Left icon
        prefixIconConstraints:
            BoxConstraints(minWidth: 40), // Width of left icon
      ),
    );
  }

  Widget _buildTemplateListWidget(
      BuildContext context, List<FlyersTemplate> flyers) {
    if (_filteredData.isEmpty && _searchController.text.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 8.0),
        child: Text('No result found'),
      );
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredData.length,
        itemBuilder: (context, index) {
          return RowCardTemplateSrc(
              itemName: _filteredData[index].flyerType!,
              onTap: () {
                _searchController.text = _filteredData[index].flyerType!;
                _flyerTemplatedUuid = _filteredData[index].flyerUuid;
                if (_isSearchFocused) {
                  _isSearchFocused = false;
                  FocusManager.instance.primaryFocus?.unfocus();
                }
                setState(() {
                  _selectedImageIndex = index;
                });
              });
        },
      );
    }
  }

  /*** Card ImageSet from Network  ***/
  Widget _buildTemplateCardImage() {
    final imageUrl = widget.flyers != null
        ? widget.flyers!.flyerImageUrl
        : _selectedImageIndex >= 0 && _filteredData.length > _selectedImageIndex
            ? _filteredData[_selectedImageIndex].flyerImageUrl
            : null;

    if (imageUrl == null) {
      return Container(); // No image selected or available, return an empty container
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Stack(
              children: [
                Center(
                  child: Hero(
                    tag: "imageHero", // Unique tag for the hero animation
                    child: PhotoView(
                      imageProvider: NetworkImage(
                        imageUrl ??
                            'https://www.vectorstock.com/royalty-free-vectors/profile-male-vectors',
                      ),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  right: 10,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
      },
      child: Hero(
        tag: "imageHero", // Same tag as above for the hero animation
        child: Image.network(
          imageUrl,
          loadingBuilder: (context, child, progress) {
            if (progress == null) {
              return child;
            }
            return CircularProgressIndicator(
              value: progress.expectedTotalBytes != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                  : null,
            );
          },
        ),
      ),
    );
  }

  /*** Filter data from main list  ***/
  void _filterList(String keyword) {
    keyword = keyword.toLowerCase();
    setState(() {
      _filteredData = _flyersCardListing
          .where((item) => item.flyerType!.toLowerCase().contains(keyword))
          .toList();
    });
  }

  Widget _buildTextFormField({
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
              borderSide: BorderSide(color: borderColor),
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
}

class RowCardTemplateSrc extends StatelessWidget {
  final String itemName;
  final VoidCallback onTap;

  const RowCardTemplateSrc(
      {Key? key, required this.itemName, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Text(
            itemName,
            style: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}
