import 'dart:convert';
import 'dart:ui';

import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ValidOTP.dart';

class OTPDialog extends StatefulWidget {
  String title;
  String content;
  int code;
  String userid, mobile;

  OTPDialog(this.title, this.content, this.userid, this.mobile, this.code);

  @override
  _OTPDialogState createState() => _OTPDialogState();
}

class _OTPDialogState extends State<OTPDialog> {
  final _formKey2 = GlobalKey<FormState>();
  final List<String> errors = [];
  String otp = "";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    // ignore: missing_required_param

    getuserDeatils();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      body: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(const Radius.circular(10)),
            ),
            title: Column(
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                        onTap: () {
                          if (widget.code == 1) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content:
                                     Text('One Time Password not entered.')));
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => ForgotPassword()));
                          } else if (widget.code == 2) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content:
                                     Text('One Time Password not entered.')));
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content:
                                     Text('One Time Password not entered.')));
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => PersonalProfile()));
                          }
                        },
                        child: const Icon(Icons.close))),
                 Text(
                  widget.title,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.content),
                Form(
                  key: _formKey2,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    onSaved: (newValue) => otp = newValue!,
                    onChanged: (value) {
                      if (value.isEmpty) {
                        removeError(
                            error: 'Please enter your One Time Password');
                      }

                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your One Time Password';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter your One Time Password",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: kBackgroundColor,
                    //width: double.maxFinite,
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: kBluePrimaryColor,
                      child: const Text("Submit OTP",
                      style: TextStyle(
                        color: kBackgroundColor
                      ),),
                      onPressed: () async {
                        if (_formKey2.currentState!.validate()) {
                          _formKey2.currentState!.save();
                          var body = {
                            'user_id': widget.userid,
                            'mobile': widget.mobile,
                            'otp': otp
                          };
                          print(body);
                          var response = await http.post(
                             Uri.parse( '$apiurl/register/otp-verification'),
                              body: json.encode(body),
                              headers: {"Content-Type": "application/json"},
                              encoding: Encoding.getByName("utf-8"));
                          print(response.statusCode);
                          print(response.body);
                          if (response.statusCode == 200) {
                            if (widget.code == 1) {
                              Navigator.pop(context);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => ResetPassword(
                              //         'Your mobile has been verified successfully. You can login now.',
                              //         widget.userid,
                              //         widget.mobile)));
                            } else if (widget.code == 2) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content:  Text(
                                      'Your mobile has been verified successfully. You can login now.')));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            } else {
                              ValidOtp validOtp =
                                  validOtpFromJson(response.body);
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content:  Text(
                                      'One Time Password has been verified')));
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => PersonalProfile()));
                            }
                          } else {
                            ValidOtp validOtp = validOtpFromJson(response.body);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(validOtp.message)));
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: kBackgroundColor,
                    //width: double.maxFinite,
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: kOrangePrimaryColor,
                      child: const Text("Resend OTP",
                      style: TextStyle(color: kBackgroundColor),
                      ),
                      onPressed: () async {
                        var body = {
                          'user_id': widget.userid,
                          'mobile': widget.mobile
                        };
                        print(body);
                        var response = await http.post(
                            Uri.parse( '$apiurl/register/otp-resend'),
                            body: json.encode(body),
                            headers: {"Content-Type": "application/json"},
                            encoding: Encoding.getByName("utf-8"));
                        if (response.statusCode == 200) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content:  Text(
                                  'One Time Password has been resend successfully')));
                        }
                        print(response.statusCode);
                        print(response.body);
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }

  Future<void> getuserDeatils() async {
    SharedPreferences userprefs = await SharedPreferences.getInstance();
    var sharedregister = userprefs.getString('Registration');
    if (sharedregister != null) {
      showSnackBar(sharedregister);
      userprefs.remove('Registration');
    }
  }

  void showSnackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(s),
    ));
  }
}
