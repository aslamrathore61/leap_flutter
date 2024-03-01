import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leap_flutter/Bloc/cardBloc/card_bloc.dart';
import 'package:leap_flutter/Utils/constants.dart';
import 'package:leap_flutter/models/MyRequestResponse.dart';
import '../Bloc/cardBloc/card_event.dart';
import '../Bloc/cardBloc/card_state.dart';
import '../Utils/GlabblePageRoute.dart';
import '../models/BusinessCardTemplateResponse.dart';
import '../models/CreateUpdateCardRequestResponse.dart';
import '../models/Profile.dart';
import 'SuccessPage.dart';

class BusinessCardsPage extends StatefulWidget {
  const BusinessCardsPage({Key? key, this.businessCards, this.profileDetails}) : super(key: key);

  final BusinessCards? businessCards;
  final Profile? profileDetails;

  @override
  State<BusinessCardsPage> createState() => _BusinessCardsPageState();
}

class _BusinessCardsPageState extends State<BusinessCardsPage> {
  final cardBloc = CardBloc();

  File? _image;
  final picker = ImagePicker();

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
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

  List<VisitingCards> _filteredData = [];
  List<VisitingCards> _visitingCardListing = [];

  final _formKey = GlobalKey<FormState>();

  String? _cardTemplateSrc;
  String? _userName;
  String? _mobileNumber;
  String? _email;
  String? _address;
  String? _quantity;

  String? _selectedCardImageUuid;
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
      _selectedCardImageUuid = widget.businessCards!.vcardImageUuid;
      _searchController.text = widget.businessCards!.vcardType!;
    }
  }

  void _filterList(String keyword) {
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
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString())));
              } else if (state is SubmissionCardReqErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error.toString())));
              } else if (state is BusinessCardTemplateFetchingSuccessState) {
                if (!_visitingCardListing.isNotEmpty) {
                  _visitingCardListing.addAll(
                      state.businessCardTemplateResponse.visitingCards ?? []);
                  _filteredData.addAll(
                      state.businessCardTemplateResponse.visitingCards ?? []);
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
              SizedBox(height: 10.0),
              _buildTemplateCardImage(),
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
                    Center(
                      child: _image == null
                          ? Text('No Image selected')
                          : Image.file(_image!),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),

              /***  Name TextField  ***/
              _buildTextFormField(
                label: "Name*",
                validator: requiredValidator,
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
                validator: requiredValidator,
                onSaved: (value) => _address = value,
                initialValue: widget.businessCards != null
                    ? widget.businessCards!.printAddress
                    : '',
              ),
              SizedBox(height: 10.0),

              /***  Quantity TextField  ***/
              _buildTextFormField(
                  label: 'Quantity*',
                  validator: requiredValidator,
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
                                    _selectedCardImageUuid;
                                cardRequest.vcardUuid = _businessTemplatedUuid;

                                if (widget.businessCards != null) {
                                  cardRequest.vcardRequestUuid =
                                      widget.businessCards!.vcardRequestUuid;
                                }

                                cardBloc.add(SubmitBusinesCardEvent(
                                    createUpdateCardRequest: cardRequest,
                                    isPost: widget.businessCards == null));
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
    return TextField(
      controller: _searchController,
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

  /***  ImageSetNetwork  ***/
  Widget _buildTemplateCardImage() {
    final imageUrl = widget.businessCards != null
        ? widget.businessCards!.vcardImageUrl
        : _selectedImageIndex >= 0 && _filteredData.length > _selectedImageIndex
            ? _filteredData[_selectedImageIndex].vcardImageInfo![0].imageUrl
            : null;

    if (imageUrl == null) {
      return Container(); // No image selected or available, return an empty container
    }
    return Center(
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
    );
  }

  Widget _buildTemplateListWidget(
      BuildContext context, List<VisitingCards> _filteredData) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _filteredData.length,
      itemBuilder: (context, index) {
        return RowCardTemplateSrc(
            itemName: _filteredData[index].vcardType!,
            onTap: () {
              _searchController.text = _filteredData[index].vcardType!;
              _businessTemplatedUuid = _filteredData[index].vcardUuid;
              _selectedCardImageUuid =
                  _filteredData[index].vcardImageInfo![0].imageUuid;

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
