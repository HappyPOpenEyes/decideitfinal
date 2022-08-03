import 'dart:convert';

import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../Registration/OTPDialog.dart';

class ResetPassword extends StatefulWidget {
  late String msg, userid, mobile;

  ResetPassword(this.msg, this.userid, this.mobile, {super.key});
  @override
  _ResetPasswordState createState() => _ResetPasswordState(msg);
}

class _ResetPasswordState extends State<ResetPassword> {
  int _groupValue = 0;
  String email = "", mobile = "";
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  AppBar appbar = AppBar();
  var oldpassword, newpassword, confirmpassword;
  late String msg;

  _ResetPasswordState(String msg) {
    this.msg = msg;
  }

  bool _isInAsyncCall = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Transparent status bar
    //displaysnackbar();
    //_scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Container(
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Reset ',
                      style: TextStyle(
                          color: kBluePrimaryColor,
                          fontSize: MediaQuery.of(context).size.width * 0.055,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Password',
                            style: TextStyle(
                                color: kOrangePrimaryColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.055,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius:  BorderRadius.all(const Radius.circular(20))),
                    color: kBackgroundColor,
                    child: Column(
                      children: [
                        Image.asset(
                          'images/resetpassword.png',
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
              const SizedBox(height: 5.0),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:  Text(
                        'Reset your password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: buildnewPasswordField(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: buildConformPassFormField(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    submitbtn(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildnewPasswordField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          obscureText: true,
          cursorColor: Colors.black,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Calibri',
          ),
          onSaved: (newValue) => newpassword = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPassNullError);
            } else if (value.length >= 8) {
              removeError(error: kShortPassError);
            }
            newpassword = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return kPassNullError;
              //addError(error: kPassNullError);

            } else if (value.length < 8) {
              return kShortPassError;
              //addError(error: kShortPassError);

            }
            return null;
          },
          decoration: const InputDecoration(
              //labelText: "Password",
              contentPadding:  EdgeInsets.all(8.0),
              hintText: "New Password",
              hintStyle:  TextStyle(
                color: Colors.black,
                fontFamily: 'Calibri',
              ),
              border:  OutlineInputBorder(
                borderRadius:  BorderRadius.all(
                   Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  buildConformPassFormField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width * 0.95,
      child: TextFormField(
          obscureText: true,
          onSaved: (newValue) => confirmpassword = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kPassNullError);
            } else if (value.isNotEmpty && newpassword == confirmpassword) {
              removeError(error: kMatchPassError);
            }
            confirmpassword = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              return kPassNullError;
              //addError(error: kPassNullError);

            } else if ((newpassword != value)) {
              return kMatchPassError;
              //addError(error: kMatchPassError);

            }
            return null;
          },
          decoration: const InputDecoration(
              contentPadding:  EdgeInsets.all(8.0),
              hintText: "Confirm Password",
              hintStyle:  TextStyle(
                color: Colors.black,
                fontFamily: 'Calibri',
              ),
              border:  OutlineInputBorder(
                borderRadius:  BorderRadius.all(
                   Radius.circular(10.0),
                ),
              ))
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          ),
    );
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  submitbtn() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            // if all are valid then go to success screen
            resetpassword();
            //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
          }
        },
        color: kBluePrimaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: const BorderSide(color: kBluePrimaryColor)),
        child: const Text(
          'Submit',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Future<void> resetpassword() async {
    setState(() {
      _isInAsyncCall = true;
    });
    var url = Uri.parse( "$apiurl/reset-password");
    var body = {
      'password': newpassword,
      'password_confirmation': confirmpassword,
      'LoginURL': 'login',
      'ForgotPasswordURL': 'forgotPassword',
      'type': '0f0fe9bc-3aea-11eb-9657-9c5c8e3e299c',
      'user_id': widget.userid
    };

    var response = await http.post(url,
        body: json.encode(body),
        headers: {"Content-Type": "application/json"},
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      setState(() {
        _isInAsyncCall = false;
      });
      print(response.body);
      SharedPreferences userprefs = await SharedPreferences.getInstance();
      userprefs.setString(
          'ResetPassword', 'You password has been reset. Login to continue');
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
    }
  }

  void showotpdialog(String userid, String mobile) {
    OTPDialog alert = OTPDialog('Verify OTP',
        'Enter your OTP to verify your mobile number', userid, mobile, 1);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return alert;
      },
    );
  }

  void displaysnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
