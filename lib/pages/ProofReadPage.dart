import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Bloc/myrequestBloc/my_request_bloc.dart';
import 'package:leap_flutter/models/ProofReadRequest.dart';
import '../Bloc/myrequestBloc/my_request_event.dart';
import '../Bloc/myrequestBloc/my_request_state.dart';
import '../Component/buttons/primary_button.dart';
import '../Utils/GlabblePageRoute.dart';
import '../Utils/constants.dart';
import '../models/MyRequestResponse.dart';
import 'DrawImageWidget.dart';
import 'SuccessPage.dart';

class ProofReadPage extends StatefulWidget {
  const ProofReadPage({Key? key, required this.businessCards})
      : super(key: key);

  final BusinessCards? businessCards;

  @override
  State<ProofReadPage> createState() => _ProofReadPageState();
}

class _ProofReadPageState extends State<ProofReadPage> {
  final myRequestbloc = MyRequestBloc();

  final TextEditingController _commentController = TextEditingController();

  String RadioOne = '';
  String RadioTwo = '';
  String selectedRadioValue = '';
  String base64EditedImage = '';
  Uint8List byteArrayImage = Uint8List(0);

  @override
  void initState() {
    super.initState();
    RadioOne =
        widget.businessCards?.proofRead?.proofReadStatus?[0] ?? 'Approved';
    RadioTwo = widget.businessCards?.proofRead?.proofReadStatus?[1] ??
        'Need Correction';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Proof Read"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocProvider(
        create: (context) => myRequestbloc,
        child: BlocListener<MyRequestBloc, MyRequestState>(
          listener: (context, state) {
            if (state is ProofReadSubmitSuccessState) {
              Navigator.of(context).pushReplacement(GlabblePageRoute(
                  page: SuccessPage(
                      toolbarTitle: "Proof Read",
                      successDescription:
                          "Proof Read Successfully Submit Your Status.")));
            } else if (state is MyRequestFetchingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error.toString())));
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 4,
                      child: RadioListTile(
                        title: Text(
                          RadioOne,
                          style: TextStyle(fontSize: 13),
                        ),
                        value: RadioOne,
                        groupValue: selectedRadioValue,
                        onChanged: (value) {
                          setState(() {
                            selectedRadioValue = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: RadioListTile(
                        title: Text(
                          RadioTwo,
                          style: TextStyle(fontSize: 13),
                        ),
                        value: RadioTwo,
                        groupValue: selectedRadioValue,
                        onChanged: (value) {
                          setState(() {
                            selectedRadioValue = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    byteArrayImage.length == 0
                        ? Image.network(
                            widget.businessCards!.proofRead!.proofReadImageUrl ??
                                '')
                        : Image.memory(
                            byteArrayImage,
                            fit: BoxFit.cover,
                          ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          selectedRadioValue == RadioTwo ? Icons.edit_road : null,
                          color: Colors.blue.shade900,
                        ),
                        onPressed: () async {
                          byteArrayImage = await Navigator.of(context).push(
                              GlabblePageRoute(
                                  page: ImagePainterPage(
                                      imageUrl: widget.businessCards?.proofRead
                                              ?.proofReadImageUrl! ??
                                          '')));
                          if (byteArrayImage.isNotEmpty) {
                            setState(() {
                              byteArrayImage;
                              String base64Image = base64Encode(byteArrayImage);
                              base64EditedImage =
                                  'data:image/png;base64,$base64Image';
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
            
                SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                   child: TextFormField(
                        controller: _commentController,
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: requiredValidator('description'),
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 14,
                        ),
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          hintText: "Please enter description",
                          contentPadding: kTextFieldPadding,
                          border: kDefaultOutlineInputBorder.copyWith(
                            borderSide: BorderSide(color: borderColor),
                          ),
                          focusedBorder: kDefaultOutlineInputBorder.copyWith(
                            borderSide: BorderSide(color: borderColor),
                          ),
                        ),
                      ),
                  ),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<MyRequestBloc, MyRequestState>(
                  builder: (context, state) {
                    return state is MyRequestLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
                            padding:
                                const EdgeInsets.only(right: 12.0, left: 12.0),
                            child: PrimaryButton(
                              text: 'Submit',
                              press: () {
                                if (selectedRadioValue.isEmpty) {
                                  showSnackBar(context, 'Please select status');
                                  return;
                                }
            
                                if (selectedRadioValue == RadioTwo &&
                                    _commentController.text.isEmpty) {
                                  showSnackBar(
                                      context, 'Please enter description');
                                  return;
                                }
            
                                savingStatusAPI();
                              },
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void savingStatusAPI() {
    final proofReadRequest = ProofReadRequest();
    proofReadRequest.proofReadStatus = selectedRadioValue;
    proofReadRequest.comment = _commentController.text;
    if (selectedRadioValue == RadioTwo) {
      proofReadRequest.correctionImage = base64EditedImage;
    }
    proofReadRequest.vcardProofReadUuid =
        widget.businessCards?.proofRead?.proofReadUuid;
    myRequestbloc
        .add(ProofReadRequestEvent(proofReadRequest: proofReadRequest));
  }
}
