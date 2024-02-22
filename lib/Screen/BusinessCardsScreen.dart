import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:leap_flutter/Bloc/cardBloc/card_bloc.dart';
import 'package:leap_flutter/constants.dart';
import '../models/BusinessCardTemplateResponse.dart';
import '../Utils/MyCustomColors.dart';
import '../models/CreateUpdateCardRequestResponse.dart';

class BusinessCardsScreen extends StatefulWidget {
  const BusinessCardsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessCardsScreen> createState() => _BusinessCardsScreenState();
}

class _BusinessCardsScreenState extends State<BusinessCardsScreen> {
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

  @override
  void initState() {
    super.initState();
     cardBloc.add(GetBusinessCardListEvent());
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _searchFocusNode.addListener(_onFocusChange);
  }

  void _filterList(String keyword) {
    print('keyword $keyword');
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
          title: Text("My Request"),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          backgroundColor: MyCustomColors.primaryColor,
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
              } else if (state is BusinessCardTemplateFetchingSuccessState) {
                if (!_visitingCardListing.isNotEmpty) {
                  _visitingCardListing.addAll(state.businessCardTemplateResponse.visitingCards ?? []);
                  _filteredData.addAll(state.businessCardTemplateResponse.visitingCards ?? []);
                }
              } else if (state is SubmissionCardReqSuccessState) {
                showSnackBar(context, 'The request for a business card was successfully created.');
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
              _buildImageView(),
              SizedBox(height: 10.0),
              Text(
                "Agent Details",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: MyCustomColors.primaryColor,
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
                            style:
                                TextStyle(
                                    fontSize: 14),
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

              /***  Name Field ***/
              Text(
                "Name*",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  _userName = value!;
                  },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Please enter name',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                //    onChanged: _filterList,
              ),
              SizedBox(height: 10.0),

              /***  Mobile Number Field ***/
              Text(
                "Mobile Number*",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  _mobileNumber = value!;
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Please enter mobile number',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                //  onChanged: _filterList,
              ),
              SizedBox(height: 10.0),

              /***  Email ID Field ***/

              Text(
                "Email ID*",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  _email = value!;
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Please enter email id',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                // onChanged: _filterList,
              ),
              SizedBox(height: 10.0),

              /***  Address Field ***/

              Text(
                "Address*",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  _address = value!;
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Please enter address',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                //   onChanged: _filterList,
              ),
              SizedBox(height: 10.0),

              /***  Quantity Field ***/

              Text(
                "Quantity*",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextFormField(
                onSaved: (value) {
                  _quantity = value!;
                },
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: 'Please enter quantity',
                  hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                // onChanged: _filterList,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: BlocBuilder<CardBloc, CardState>(
                  builder: (context, state) {
                    if (state is SubmissionCardReqSuccessState) {
                      //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully Created Request'),duration: Duration(seconds:  2),));
                      return Container();
                    }

                    return state is SubmissionCardLoadingState
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                // Instantiate the CreateUpdateCardRequest object with the required data
                                CreateUpdateCardRequest cardRequest = CreateUpdateCardRequest(
                                  printEmail: _email,
                                  printName: _userName,
                                  printPhoneNumber: _mobileNumber,
                                  printAddress: _address,
                                  requestQuantity: _quantity,
                                  designImageUuid:
                                      _filteredData[_selectedImageIndex]
                                          .vcardImageInfo![0]
                                          .imageUuid,
                                  vcardUuid: _filteredData[_selectedImageIndex]
                                      .vcardUuid,
                                  //     printImageData: "data:image/png;base64,",
                                );
                                cardBloc.add(SubmitBusinesCardEvent(createUpdateCardRequest: cardRequest));
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
  Widget _buildImageView() {
    // we make this condition because of filter time lenght of list get short but index still having old vlaue
    if (_selectedImageIndex < 0 ||
        _filteredData.length < _selectedImageIndex + 1) {
      return Container(); // No image selected, return an empty container
    }
    return Center(
      child: Image.network(
        _filteredData[_selectedImageIndex].vcardImageInfo![0].imageUrl!,
        // Replace with your image URL
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
