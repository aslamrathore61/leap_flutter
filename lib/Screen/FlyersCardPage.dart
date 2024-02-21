import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../Bloc/cardBloc/card_bloc.dart';
import '../constants.dart';
import '../Utils/MyCustomColors.dart';
import '../models/FlyersCardTemplateResponse.dart';

class FlyersCardPage extends StatefulWidget {
  const FlyersCardPage({Key? key}) : super(key: key);

  @override
  State<FlyersCardPage> createState() => _FlyersCardsPageState();
}

class _FlyersCardsPageState extends State<FlyersCardPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCardTye;
  bool _isSearchFocused = false;

  final CardBloc cardBloc = CardBloc();
  List<Flyers> _flyersCardListing = [];
  List<Flyers> _filteredData = [];
  int _selectedImageIndex = -1;
  TextEditingController _searchController = TextEditingController();

  FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    super.dispose();
  }

  @override
  void initState() {
    cardBloc.add(GetFlyersCardListEvent());
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _searchFocusNode.addListener(_onFocusChange);
    super.initState();
  }

  String? _cardTemplateSrc;
  String? _userName;
  String? _mobileNumber;
  String? _email;
  String? _address;
  String? _quantity;

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
        title: Text("My Request"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: MyCustomColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocProvider(
        create: (context) => cardBloc,
        child: SingleChildScrollView(
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
                  if (_isSearchFocused) _buildSearchResultsForListView(),
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

                  /***    Display Image View  ***/
                  SizedBox(height: 10.0),
                  Container(
                    child: Column(
                      children: [
                        GestureDetector(
                          //    onTap: showOptions,
                          child: Row(
                            children: [
                              Text(
                                "Display Image",
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
                  Text(
                    "Name*",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    validator: requiredValidator,
                    onSaved: (value) {
                      _userName = value!;
                    },
                    textInputAction: TextInputAction.next,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: titleColor, fontSize: 14),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Please enter name",
                      contentPadding: kTextFieldPadding,
                      border: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                      focusedBorder: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                    ),
                  ),
                  SizedBox(height: 10.0),

                  /***  Mobile Number TextField  ***/
                  Text(
                    "Mobile Number*",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    validator: phoneNumberValidator,
                    onSaved: (value) {
                      _mobileNumber = value!;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: titleColor, fontSize: 14),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Please enter mobile number",
                      contentPadding: kTextFieldPadding,
                      border: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                      focusedBorder: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                    ),
                  ),
                  SizedBox(height: 10.0),

                  /***  EmailID TextField  ***/
                  Text(
                    "Email ID*",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    validator: emailValidator,
                    onSaved: (value) {
                      _email = value!;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: titleColor, fontSize: 14),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Please enter email ID",
                      contentPadding: kTextFieldPadding,
                      border: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                      focusedBorder: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                    ),
                  ),
                  SizedBox(height: 10.0),

                  /***  Address TextField  ***/
                  Text(
                    "Address*",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    validator: requiredValidator,
                    onSaved: (value) {
                      _address = value!;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: titleColor, fontSize: 14),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Please enter address",
                      contentPadding: kTextFieldPadding,
                      border: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                      focusedBorder: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                    ),
                  ),
                  SizedBox(height: 10.0),

                  /***  Quantity TextField  ***/
                  Text(
                    "Quantity*",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    validator: requiredValidator,
                    onSaved: (value) {
                      _quantity = value!;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: titleColor, fontSize: 14),
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: "Please enter address",
                      contentPadding: kTextFieldPadding,
                      border: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                      focusedBorder: kDefaultOutlineInputBorder.copyWith(
                          borderSide: BorderSide(
                        color: borderColor,
                      )),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                    },
                    child: Text("Place Order".toUpperCase()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /***  Search field card template ***/
  Widget _CardTemplateSrchField() {
    return TextFormField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      validator: requiredValidator,
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

  /*** ListView of filter ***/
  Widget _buildSearchResultsForListView() {
    print("getcall ${"_buildSearchResultsForListView"}");
    return BlocProvider(
      create: (context) => cardBloc,
      child: BlocConsumer<CardBloc, CardState>(
        listener: (context, state) {
          print('listener : ${state}');

          if (state is CardTemplateErrorState) {
            print('error : ${state.error}');
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          print('builder : ${state}');

          if (state is FlyersCardTemplateFetchingSuccessState) {
            print(
                'success CardTemplateFetchingSuccess : ${state.flyersCardTemplateResponse.serviceName}');
            return _buildTemplateListWidget(
                context, state.flyersCardTemplateResponse.flyers!);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _buildTemplateListWidget(BuildContext context, List<Flyers> flyers) {
    if (!_flyersCardListing.isNotEmpty) {
      _flyersCardListing.addAll(flyers);
      _filteredData.addAll(flyers ?? []);
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _filteredData.length,
      itemBuilder: (context, index) {
        return RowCardTemplateSrc(
            itemName: _filteredData[index].flyerType!,
            onTap: () {
              _selectedCardTye = flyers[index].flyerType!;
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

  /*** Card ImageSet from Network  ***/
  Widget _buildTemplateCardImage() {
    // we make this condition because of filter time lenght of list get short but index still having old vlaue
    if (_selectedImageIndex < 0 ||
        _filteredData.length < _selectedImageIndex + 1) {
      return Container(); // No image selected, return an empty container
    }
    return Center(
      child: Image.network(
        _filteredData[_selectedImageIndex].flyerImageUrl!,
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

  /*** Filter data from main list  ***/
  void _filterList(String keyword) {
    keyword = keyword.toLowerCase();
    setState(() {
      _filteredData = _flyersCardListing
          .where((item) => item.flyerType!.toLowerCase().contains(keyword))
          .toList();
    });
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
