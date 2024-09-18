import 'dart:convert';

import 'package:decideitfinal/AddressBook/AddressBook.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../PostQuestion/InvalidGroupNameAPI.dart';
import 'AddContactValidAPI.dart';

class AddContact extends StatefulWidget {
  late String contactname,
      contactemail,
      contactphone,
      contactisactive,
      contactid;
  late int flag, id;

  AddContact(this.contactname, this.contactemail, this.contactphone,
      this.contactisactive, this.contactid, this.flag, this.id);
  @override
  _AddContactState createState() => _AddContactState(contactname, contactemail,
      contactphone, contactisactive, contactid, flag, id);
}

class _AddContactState extends State<AddContact> {
  late String contactname,
      contactemail,
      contactphone,
      contactisactive,
      contactid;
  late int flag, id;
  var header, userid, name, email, imageurl;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  TextEditingController addcontactfirstname = TextEditingController();
  TextEditingController addcontactlastname = TextEditingController();
  TextEditingController addcontactemail = TextEditingController();
  TextEditingController addcontactphone = TextEditingController();
  bool addcontactisSelected = true;
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  bool _enabled = false;
  AppBar appbar = AppBar();

  _AddContactState(this.contactname, this.contactemail, this.contactphone,
      this.contactisactive, this.contactid, this.flag, this.id);

  @override
  void initState() {
    super.initState();
    // Transparent status bar
    if (flag == 1) {
      if (contactname != null) {
        var tempname = contactname.split(' ');
        final Map<int, String> values = {
          for (int i = 0; i < tempname.length; i++) i: tempname[i]
        };
        addcontactfirstname.text = values[0] ?? '';
        addcontactlastname.text = values[1] ?? '';
      }
      if (contactemail != null) {
        addcontactemail.text = contactemail;
      }
      if (contactphone != null) {
        addcontactphone.text = contactphone;
      }
      if (contactisactive == "1") {
        addcontactisSelected = true;
      } else {
        addcontactisSelected = false;
      }
    }
    print('ID is: $id');
    getuserdetails();
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AddressBook(id)));
                },
                child: const Icon(Icons.arrow_back_ios)),
            const Spacer(),
            SizedBox(
                height: appbar.preferredSize.height * 0.8,
                child: Image.asset('logos/DI_Logo.png')),
            const Spacer(),
          ],
        ),
        backgroundColor: kBluePrimaryColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _enabled,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Add Contact in ',
                              style: TextStyle(
                                  color: kBluePrimaryColor,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.02,
                                  fontWeight: FontWeight.bold),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Address Book',
                                    style: TextStyle(
                                        color: kOrangePrimaryColor,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        getaddcontactfirstnamefield(),
                        const SizedBox(
                          height: 10,
                        ),
                        getaddcontactlastnamefield(),
                        const SizedBox(
                          height: 10,
                        ),
                        getaddcontactemailfied(),
                        const SizedBox(
                          height: 10,
                        ),
                        getaddcontactphonefield(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Active?: ',
                              style: TextStyle(
                                  color: kBluePrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            FlutterSwitch(
                              height: 30,
                              width: 60,
                              value: addcontactisSelected,
                              onToggle: (val) {
                                setState(() {
                                  addcontactisSelected = val;
                                  print(addcontactisSelected);
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: kBluePrimaryColor,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              if (flag == 0) {
                                addcontactdata();
                              } else {
                                updatecontactdata();
                              }

                              // if all are valid then go to success screen
                              //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                            }
                          },
                          child: Text(flag == 0 ? 'Add' : 'Update',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Calibri')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getaddcontactfirstnamefield() {
    return TextFormField(
        controller: addcontactfirstname,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kNamelNullError);
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return kNamelNullError;
            //addError(error: kPassNullError);

          }
          return null;
        },
        decoration: const InputDecoration(
            //labelText: "Name",
            hintText: 'First name',
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            )));
  }

  getaddcontactlastnamefield() {
    return TextFormField(
        controller: addcontactlastname,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kNamelNullError);
          }
        },
        validator: (value) {
          if (value!.isEmpty) {
            return kNamelNullError;
            //addError(error: kPassNullError);

          }
          return null;
        },
        decoration: const InputDecoration(
            //labelText: "Name",
            hintText: 'Last name',
            hintStyle: TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            )));
  }

  getaddcontactemailfied() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: addcontactemail,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
          //addError(error: kEmailNullError);

        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
          //addError(error: kInvalidEmailError);

        }
        return null;
      },
      decoration: const InputDecoration(
          hintText: "Email Address",
          hintStyle: TextStyle(color: Colors.black),
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          //floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          )),
    );
  }

  getaddcontactphonefield() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: addcontactphone,
      onChanged: (value) {
        if (value.isNotEmpty && value.length == 10) {
          removeError(error: kPhoneNumberLengthError);
        }
      },
      validator: (value) {
        if ((value!.isNotEmpty && value.length != 10)) {
          return kPhoneNumberLengthError;
        }
      },
      decoration: const InputDecoration(
          hintText: "Phone Number",
          hintStyle: TextStyle(color: Colors.black),
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          //floatingLabelBehavior: FloatingLabelBehavior.always,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          )),
    );
  }

  void addcontactdata() async {
    var body = {
      "user_id": userid,
      "first_name": addcontactfirstname.text,
      "last_name": addcontactlastname.text,
      "email": addcontactemail.text,
      "phone": addcontactphone.text,
      "is_active": addcontactisSelected
    };

    setState(() {
      _enabled = true;
    });

    var response = await http.post(
        Uri.parse('$apiurl/user-address-book/add-contact'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(response.body);
      AddContactValidApi homeCommunity =
          addContactValidApiFromJson(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('contactadded', homeCommunity.message);

      setState(() {
        _enabled = false;
      });
      print(id);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddressBook(id)));
      getuserdetails();
    } else {
      InvalidGroupNameAPI invalidGroupNameAPI =
          invalidGroupNameAPIFromJson(response.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle('Error', invalidGroupNameAPI.message);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );

      setState(() {
        _enabled = false;
      });
      print(response.statusCode);
      print(response.body);
    }
  }

  void getuserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var sharedemail = prefs.getString('email');
    var shareduserid = prefs.getString('userid');
    var sharedimageurl = prefs.getString('imageurl');
    var sharedname = prefs.getString('name');
    var sharedtoken = prefs.getString('header');

    setState(() {
      email = sharedemail;
      userid = shareduserid;
      imageurl = sharedimageurl;
      name = sharedname;
      header = sharedtoken;
    });
    print('coming from shared preference $header$userid$name');
  }

  void updatecontactdata() async {
    var body = {
      "id": contactid,
      "first_name": addcontactfirstname.text,
      "last_name": addcontactlastname.text,
      "email": addcontactemail.text,
      "phone": addcontactphone.text,
      "is_active": addcontactisSelected
    };

    setState(() {
      _enabled = true;
    });

    var response = await http.post(
        Uri.parse('$apiurl/user-address-book/edit-contact'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(response.body);
      AddContactValidApi homeCommunity =
          addContactValidApiFromJson(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('contactadded', homeCommunity.message);

      setState(() {
        _enabled = false;
      });
      print(id);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddressBook(id)));
      getuserdetails();
    } else {
      InvalidGroupNameAPI invalidGroupNameAPI =
          invalidGroupNameAPIFromJson(response.body);
      BlurryDialogSingle alert =
          BlurryDialogSingle('Error', invalidGroupNameAPI.message);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );

      setState(() {
        _enabled = false;
      });
      print(response.statusCode);
      print(response.body);
    }
  }
}
