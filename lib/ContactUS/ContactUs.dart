import 'dart:convert';

import 'package:decideitfinal/Home/homescreen.dart';
import 'package:decideitfinal/ProfileScreens/GetPersonalData.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var email,
      name,
      userid,
      header,
      imageurl,
      firstname,
      lastname,
      updatedfirstname,
      updatedlastname,
      updatedemail;
  TextEditingController aboutController =  TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey =  GlobalKey<ScaffoldState>();
  AppBar appbar = AppBar();
  bool _isInAsyncCall = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuserdata();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: SizedBox(
            height: appbar.preferredSize.height * 0.8,
            child: Image.asset('logos/DI_Logo.png')),
        centerTitle: true,
        backgroundColor: kBluePrimaryColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Contact ',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Us',
                            style: TextStyle(
                                color: kOrangePrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius:  BorderRadius.all(Radius.circular(20))),
                      color: kBackgroundColor,
                      child: Column(
                        children: [
                          Image.asset(
                            'images/contact.png',
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 25.0, right: 25),
                child: Text(
                  'If you believe you’ve discovered an error or something vital that’s missing in DecideIt, you’re in luck! We’re brand new and open to learning and adapting to support our audience. Please share your thoughts with us as we build a database of user feedback that will help fuel our future improvements. Just leave your comments below.',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Container(
                    color: kBackgroundColor,
                    child: Column(
                      children: [
                        userid == null ? buildfirstnamefield() : const SizedBox(),
                        userid == null
                            ? const SizedBox(
                                height: 10,
                              )
                            : const SizedBox(),
                        userid == null ? buildlastnamefield() : const SizedBox(),
                        userid == null
                            ? const SizedBox(
                                height: 10,
                              )
                            : const SizedBox(),
                        userid == null ? biuldemailfield() : const SizedBox(),
                        userid == null
                            ? const SizedBox(
                                height: 10,
                              )
                            : const SizedBox(),
                        buildaboutmefield(),
                        const SizedBox(
                          height: 10,
                        ),
                        buildupdatebuttonfield(),
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

  buildfirstnamefield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          onSaved: (newValue) => updatedfirstname = newValue,
          onChanged: (value) {
            if (firstname != null || firstname != '') {
              removeError(error: 'Please enter your First Name');
            } else {
              if (value.isNotEmpty) {
                removeError(error: 'Please enter your First Name');
              }
            }

            return null;
          },
          validator: (value) {
            if (value!.isEmpty && (firstname == null || firstname == '')) {
              return 'Please enter your name';
              //addError(error: kNamelNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
              //labelText: "Name",
              hintText: firstname == null || firstname == ''
                  ? 'First Name'
                  : firstname,
              hintStyle: const TextStyle(color: Colors.black),
              border:  const OutlineInputBorder(
                borderRadius:  BorderRadius.all(
                   Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  buildlastnamefield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          onSaved: (newValue) => updatedlastname = newValue,
          onChanged: (value) {
            if (lastname != null || lastname != '') {
              removeError(error: 'Please enter your Last Name');
            } else {
              if (value.isNotEmpty) {
                removeError(error: 'Please enter your Last Name');
              }
            }
          },
          validator: (value) {
            if (value!.isEmpty && (lastname == null || lastname == '')) {
              return 'Please enter your Last name';
              //addError(error: kNamelNullError);

            }
            return null;
          },
          decoration: InputDecoration(
              //labelText: "Name",
              hintText:
                  lastname == null || lastname == '' ? 'Last Name' : lastname,
              hintStyle: const TextStyle(color: Colors.black),
              border:  const OutlineInputBorder(
                borderRadius:  BorderRadius.all(
                   Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  biuldemailfield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          onSaved: (newValue) => updatedemail = newValue,
          onChanged: (value) {
            if (email != null || email != '') {
              removeError(error: 'Please enter email');
            } else {
              if (value.isNotEmpty) {
                removeError(error: 'Please enter your email');
              }
            }
          },
          validator: (value) {
            if (value!.isEmpty && (email == null || email == '')) {
              return 'Please enter your email';
              //addError(error: kNamelNullError);

            }
            return null;
          },
          decoration: InputDecoration(
              //labelText: "Name",
              hintText: email == null || email == '' ? 'Email Address' : email,
              hintStyle: const TextStyle(color: Colors.black),
              border: const OutlineInputBorder(
                borderRadius:  BorderRadius.all(
                   Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  buildaboutmefield() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          controller: aboutController,
          onChanged: (value) {
            if (value != '') {
              removeError(error: 'Please enter your message');
            } else {
              if (value.isNotEmpty) {
                removeError(error: 'Please enter your message');
              }
            }
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your message';
              //addError(error: kNamelNullError);

            }
            return null;
          },
          decoration: const InputDecoration(
              //labelText: "Name",
              hintText: 'Message',
              hintStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this

          ),
    );
  }

  buildupdatebuttonfield() {
    return Center(
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: kBluePrimaryColor,
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              submitquery();
            }
          },
          child: RichText(
            text: const TextSpan(
                text: 'SUBMIT',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Calibri')),
          )),
    );
  }

  void getuserdata() async {
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
      if (userid != null) {
        getprofiledata();
      }
    });
    print('coming from shared preference $email$userid$name');
  }

  void submitquery() async {
    if (updatedemail == '' || updatedemail == null) {
      updatedemail = email;
    }
    if (updatedfirstname == '' || updatedfirstname == null) {
      updatedfirstname = firstname;
    }
    if (updatedlastname == '' || updatedlastname == null) {
      updatedlastname = lastname;
    }
    var body;
    if (userid == null) {
      body = {
        "email": updatedemail,
        "first_name": updatedfirstname,
        "last_name": updatedlastname,
        "message": aboutController.text
      };
    } else {
      body = {
        "email": updatedemail,
        "first_name": updatedfirstname,
        "last_name": updatedlastname,
        "message": aboutController.text,
        "user_name": name
      };
    }
    setState(() {
      _isInAsyncCall = true;
    });

    var response = await http.post(Uri.parse('$apiurl/contactUs'),
        body: json.encode(body),
        headers: {"Content-Type": "application/json", "Authorization": header},
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      _isInAsyncCall = false;
    });
    if (response.statusCode == 200) {
      print(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Contactus',
          'Thank you for writing to us. We will ge back to you as soon as possible.');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      print(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Contactus', 'Something went wrong');
      print(response.statusCode);
      print(response.body);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void getprofiledata() async {
    setState(() {
      _isInAsyncCall = true;
    });
    var profileresponse = await http.get(
        Uri.parse('$apiurl/getProfileData/personal_details'),
        headers: {"Authorization": header});

    setState(() {
      _isInAsyncCall = false;
    });
    if (profileresponse.statusCode == 200) {
      GetPersonalData getPersonalData =
          getPersonalDataFromJson(profileresponse.body);
      setState(() {
        firstname = getPersonalData.firstName;
        lastname = getPersonalData.lastName;
      });
    }
  }
}
