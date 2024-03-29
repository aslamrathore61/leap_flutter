import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:card_swiper/card_swiper.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leap_flutter/Bloc/cardBloc/card_bloc.dart';
import 'package:leap_flutter/Utils/constants.dart';
import 'package:leap_flutter/models/MyRequestResponse.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import '../Bloc/cardBloc/card_event.dart';
import '../Bloc/cardBloc/card_state.dart';
import '../Utils/GlabblePageRoute.dart';
import '../models/BusinessCardTemplateResponse.dart';
import '../models/CreateUpdateCardRequestResponse.dart';
import '../models/Profile.dart';
import 'SuccessPage.dart';

class BusinessCardsPage extends StatefulWidget {
  const BusinessCardsPage({Key? key, this.businessCards, this.profileDetails})
      : super(key: key);

  final BusinessCards? businessCards;
  final Profile? profileDetails;

  @override
  State<BusinessCardsPage> createState() => _BusinessCardsPageState();
}

class _BusinessCardsPageState extends State<BusinessCardsPage> {
  final _scrollController = ScrollController();

  final cardBloc = CardBloc();

  bool needToUpdateIndext = false;

  File? _image;
  String printImageData = "";

  int initialIndex = 0;
  List<VcardImageInfo>? vcardImageInfo;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 25)
        .then((value) => {
              if (value != null) {cropImageCall(File(value.path))}
            });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 25)
        .then((value) async => {
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
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () async {
              // close the options modal
              Navigator.of(context).pop();

              final deviceInfo = await DeviceInfoPlugin().androidInfo;

              if (Platform.isAndroid && deviceInfo.version.sdkInt <= 32) {
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

  int _selectedImageIndex = -1;

  TextEditingController _searchController = TextEditingController();

  FocusNode _searchFocusNode = FocusNode();
  bool _isSearchFocused = false;
  bool _cardTemplateSelected = false;

  List<VisitingCards> _filteredData = [];
  List<VisitingCards> _visitingCardListing = [];

  final _formKey = GlobalKey<FormState>();

  String? _cardTemplateSrc;
  String? _userName;
  String? _mobileNumber;
  String? _email;
  String? _address;
  String? _quantity;

  String? _businessTemplatedUuid;

  @override
  void initState() {
    super.initState();

    cardBloc.add(GetBusinessCardListEvent());
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _searchFocusNode.addListener(_onFocusChange);

    //set old value for uppdate
    if (widget.businessCards != null) {
      _businessTemplatedUuid = widget.businessCards!.vcardUuid;

      // _selectedCardImageUuid = widget.businessCards!.vcardImageUuid;
      _searchController.text = widget.businessCards!.vcardType!;
    }
  }

  void _filterList(String keyword) {
    setState(() {
      _cardTemplateSelected = false;
    });
    keyword = keyword.toLowerCase();
    setState(() {
      _filteredData = _visitingCardListing
          .where((item) => item.vcardType!.toLowerCase().contains(keyword))
          .toList();
    });
  }

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
          title: Text("Business Card Request"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: _buildListTrainingRequest());
  }

  Widget _buildListTrainingRequest() {
    return Container(
      margin: EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (context) => cardBloc,
        child: BlocListener<CardBloc, CardState>(
            listener: (context, state) {
              if (state is CardTemplateErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
              } else if (state is SubmissionCardReqErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error.toString())));
              } else if (state is BusinessCardTemplateFetchingSuccessState) {
                if (!_visitingCardListing.isNotEmpty) {
                  _visitingCardListing.addAll(
                      state.businessCardTemplateResponse.visitingCards ?? []);
                  _filteredData.addAll(
                      state.businessCardTemplateResponse.visitingCards ?? []);
                }

                if (widget.businessCards != null) {
                  state.businessCardTemplateResponse.visitingCards
                      ?.forEach((element) {
                    print(
                        '11 ${element.vcardUuid} ${widget.businessCards?.vcardUuid}');
                    if (element.vcardUuid == widget.businessCards?.vcardUuid) {
                      print(
                          '22 ${element.vcardUuid} ${widget.businessCards?.vcardUuid}');

                      vcardImageInfo = element.vcardImageInfo;
                      vcardImageInfo?.asMap().forEach((idx, element) {
                        if (element.imageUuid ==
                            widget.businessCards?.vcardImageUuid) {
                          print(
                              '22 ${element.imageUuid} ${widget.businessCards?.vcardImageUuid}');

                          initialIndex = idx;
                          setState(() {
                            _cardTemplateSelected = true;
                          });
                          //  print('itemSelectedCardTempIndext $itemSelectedCardTempIndext');
                        }
                      });
                    }
                  });
                }
              } else if (state is SubmissionCardReqSuccessState) {
                Navigator.of(context).pushReplacement(GlabblePageRoute(
                    page: SuccessPage(
                        toolbarTitle: "Business Card Confimration",
                        successDescription:
                            "Business card request created successfully. Our team will inform you of the next steps.")));
              }
            },
            child: _buildFormWidget(context)),
      ),
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
              Text(
                "Card Template*",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildSearchField(),
              if (_isSearchFocused)
                _buildTemplateListWidget(context, _filteredData),
              if (_cardTemplateSelected) _buildSwapCardTemplate(),
              SizedBox(height: 10.0),
              Text(
                "Agent Details",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: showOptions,
                      child: Row(
                        children: [
                          Text(
                            "Display Image",
                            style: TextStyle(fontSize: 14),
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

              /***  Name TextField  ***/
              _buildTextFormField(
                label: "Name*",
                validator: requiredValidator('Name'),
                onSaved: (value) => _userName = value,
                initialValue: widget.businessCards != null
                    ? widget.businessCards!.printName
                    : ' ${widget.profileDetails?.result?.firstName} ${widget.profileDetails?.result?.lastName}',
              ),
              SizedBox(height: 10.0),

              /***  Mobile Number Field ***/
              _buildTextFormField(
                label: "Mobile Number*",
                validator: phoneNumberValidator,
                onSaved: (value) => _mobileNumber = value,
                initialValue: widget.businessCards != null
                    ? widget.businessCards!.printPhoneNumber
                    : '${widget.profileDetails?.result?.phoneNumber}',
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10.0),

              /***  Email ID Field ***/

              _buildTextFormField(
                  label: "Email ID*",
                  validator: emailValidator,
                  onSaved: (value) => _email = value,
                  initialValue: widget.businessCards != null
                      ? widget.businessCards!.printEmail
                      : '${widget.profileDetails?.result?.email}',
                  keyboardType: TextInputType.emailAddress),
              SizedBox(height: 10.0),

              /***  Address  TextField  ***/
              _buildTextFormField(
                label: 'Address*',
                validator: requiredValidator('Address'),
                onSaved: (value) => _address = value,
                initialValue: widget.businessCards != null
                    ? widget.businessCards!.printAddress
                    : '',
              ),
              SizedBox(height: 10.0),

              /***  Quantity TextField  ***/
              _buildTextFormField(
                  label: 'Quantity*',
                  validator: requiredValidator('Quantity'),
                  onSaved: (value) => _quantity = value,
                  initialValue: widget.businessCards != null
                      ? widget.businessCards!.requestQuantity
                      : '',
                  keyboardType: TextInputType.number),
              SizedBox(height: 10.0),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: BlocBuilder<CardBloc, CardState>(
                  builder: (context, state) {
                    return state is SubmissionCardLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                final cardRequest = CreateUpdateCardRequest();
                                cardRequest.printEmail = _email;
                                cardRequest.printName = _userName;
                                cardRequest.printPhoneNumber = _mobileNumber;
                                cardRequest.printAddress = _address;
                                cardRequest.requestQuantity = _quantity;
                                cardRequest.designImageUuid =
                                    vcardImageInfo?[initialIndex].imageUuid;
                                cardRequest.vcardUuid = _businessTemplatedUuid;

                                if (_image != null) {
                                  List<int> imageBytes =
                                      _image!.readAsBytesSync();
                                  String base64Image = base64Encode(imageBytes);
                                  printImageData =
                                      'data:image/png;base64,$base64Image';
                                  cardRequest.printImageData = printImageData;
                                }

                                if (widget.businessCards != null) {
                                  cardRequest.vcardRequestUuid =
                                      widget.businessCards!.vcardRequestUuid;
                                }

                                cardBloc.add(SubmitBusinesCardEvent(
                                    createUpdateCardRequest: cardRequest,
                                    isPost: widget.businessCards == null));
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
                            child: Text("Place Order"),
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /***  Search field card template ***/
  Widget _buildSearchField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: _searchController,
      validator: requiredValidator("Card Template"),
      textAlignVertical: TextAlignVertical.center,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black87, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onChanged: _filterList,
    );
  }

  Widget _buildSwapCardTemplate() {
    return Container(
      height: 400,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Stack(
                children: [
                  Center(
                    child: PhotoView(
                      imageProvider:
                          NetworkImage(vcardImageInfo![initialIndex].imageUrl!),
                      minScale: PhotoViewComputedScale.contained * 0.8,
                      maxScale: PhotoViewComputedScale.covered * 2.0,
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
        child: Swiper(
          index: initialIndex,
          itemBuilder: (BuildContext context, int index) {
            return _buildSwiperList(vcardImageInfo![index], index);
          },
          itemWidth: MediaQuery.of(context).size.width,
          itemHeight: 350,
          itemCount: vcardImageInfo!.length,
          layout: SwiperLayout.TINDER,
          pagination: const SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                color: Colors.grey, // Set your desired dot color here
                activeColor:
                    primaryColor, // Set your desired active dot color here
              ),
              margin: EdgeInsets.only(top: 40)),
          // control:SwiperControl(),
          onIndexChanged: (int indext) {
            setState(() {
              initialIndex = indext;
            });
          },
        ),
      ),
    );
  }


  Future<Size> getImageDimensions(String imageUrl) async {
    final Image image = Image.network(imageUrl);
    final Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    return completer.future;
  }




  Widget _buildSwiperList(VcardImageInfo items, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      child: Image.network(
        vcardImageInfo![index].imageUrl!,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTemplateListWidget(
      BuildContext context, List<VisitingCards> _filteredData) {
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
              itemName: _filteredData[index].vcardType!,
              onTap: () {
                _searchController.text = _filteredData[index].vcardType!;
                _businessTemplatedUuid = _filteredData[index].vcardUuid;
                // _selectedCardImageUuid = _filteredData[index].vcardImageInfo![0].imageUuid;
                vcardImageInfo = _filteredData[index].vcardImageInfo;
                if (_isSearchFocused) {
                  _isSearchFocused = false;
                  FocusManager.instance.primaryFocus?.unfocus();
                }
                setState(() {
                  _selectedImageIndex = index;
                  _cardTemplateSelected = true;
                });
              });
        },
      );
    }
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
            hintText: "Please enter $label",
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

  Widget previewDisplayImage() {
    if (_image != null) {
      return Center(
        child: _image == null ? Text('No Image Selected') : Image.file(_image!),
      );
    } else {
      return Center(
        child: widget.businessCards?.printimage == null
            ? Text('No Image Selected')
            : Image.network(widget.businessCards?.printimage,
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
