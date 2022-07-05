import 'dart:convert';

import 'package:auctioneer/home.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:auctioneer/roundedbuttons.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class AdditemsScreen extends StatefulWidget {
  static String id = 'Additemscreen';
  @override
  _AdditemsScreenState createState() => _AdditemsScreenState();
}

class _AdditemsScreenState extends State<AdditemsScreen> {
  final _auth = FirebaseAuth.instance;
  final formkey = GlobalKey<FormState>();
  bool showSpinner = false;
  late String name;
  late String description = "";
  late DateTime pickedDate;
  late String dateinput;
  late TimeOfDay pickedTime;
  late DateTime pickedDateTime;
  late String timeinput;
  late var imageURL = "";
  TextEditingController timeinputcontroller = TextEditingController();
  TextEditingController dateinputcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  late var _imageFile = null;
  @override
  void initState() {
    super.initState();
    dateinput = ""; //set the initial value of text field
    timeinput = "";
    timeinputcontroller.text = "";
    dateinputcontroller.text = "";
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        print((loggedInUser.email));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Items for Auction'),
      ),
      backgroundColor: Colors.white70,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                imageProfile(),
                SizedBox(
                  height: 7,
                ),
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'You must Enter the name';
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Description',
                        border: OutlineInputBorder()),
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Flexible(
                  child: TextFormField(
                    controller: dateinputcontroller,
                    decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.calendar_today), //icon of text field
                        labelText:
                            "Enter Start Date for Auction", //label text of field
                        border: OutlineInputBorder()),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'You must Enter the Start Date';
                      } else {
                        return null;
                      }
                    },
                    onTap: () async {
                      pickedDate = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              2000), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101)))!;

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement

                        setState(() {
                          dateinputcontroller.text = formattedDate;
                          dateinput =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                  ),
                ),
                SizedBox(height: 15),
                Flexible(
                  child: TextFormField(
                    controller: timeinputcontroller,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.timer), //icon of text field
                        labelText:
                            "Enter Start Time for Auction", //label text of field
                        border: OutlineInputBorder()),
                    readOnly:
                        true, //set it true, so that user will not able to edit text
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'You must Enter the Start Time';
                      } else {
                        return null;
                      }
                    },

                    onTap: () async {
                      pickedTime = (await showTimePicker(
                        initialTime: TimeOfDay.now(),
                        context: context,
                      ))!;
                      if (pickedTime != null) {
                        print(pickedTime.format(context)); //output 10:51 PM
                        DateTime parsedTime = DateFormat.jm()
                            .parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime =
                            DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.
                        setState(() {
                          timeinputcontroller.text = formattedTime;
                          timeinput =
                              formattedTime; //set the value of text field.
                          pickedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute);
                        });
                      } else {
                        print("Time is not selected");
                      }
                    },
                  ),
                ),
                Roundedbutton(Colors.blueAccent, 'Add The Item', () async {
                  if (_imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Please attach the Image",
                        textAlign: TextAlign.center,
                      ),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ));
                    return;
                  } else {
                    if (formkey.currentState?.validate() != null &&
                        _imageFile != null) {
                      var bytes = _imageFile!
                          .readAsBytesSync(); // toconvert imageFile to bytes
                      var headers = {
                        'Authorization': 'Client-ID 9b51bb2c5b0f6cb',
                      };
                      var request = http.MultipartRequest(
                          'POST', Uri.parse('https://api.imgur.com/3/image'));
                      request.fields.addAll({
                        'image': base64Encode(bytes),
                        // encoding bytes in base64 string for uploading
                      });

                      request.headers.addAll(headers);

                      http.StreamedResponse response = await request.send();
                      if (response.statusCode == 200) {
                        setState(() {
                          showSpinner = true;
                        });
                        var data = await response.stream.bytesToString();
                        var body = jsonDecode(data);
                        imageURL = body["data"]
                            ["link"]; // this is the uploaded image url
// now, we have all the fields of the auctionItem Schema and we can now add new document to firestore
                        print(pickedDateTime);
                        await FirebaseFirestore.instance
                            .collection('autionitem')
                            .add({
                          "Name": name,
                          "Description": description,
                          "imageURL": imageURL,
                          "timestamp": Timestamp.fromDate(pickedDateTime),
                          "seller": loggedInUser.email,
                          "bidPrice": 0,
                          "bidder": "",
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Item added to auctions")));
                        Navigator.pop(context); // come back to home screen
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(context, HomePageWidget.id);
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Failed to upload image',
                            textAlign: TextAlign.center,
                          ),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ));
                        print(response.reasonPhrase); // failed image upload
                      }
                    }
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: (_imageFile != null)
              ? FileImage(_imageFile!) as ImageProvider
              : AssetImage("images/mouse.jpg"),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => bottomSheet()),
              );
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
              label: Text("Camera"),
            ),
            FlatButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
              label: Text("Gallery"),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }
}

///9b51bb2c5b0f6cb
///46480013230c62d796d9aed367e35bdf22515060
