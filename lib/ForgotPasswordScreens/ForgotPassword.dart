import 'dart:convert';
import 'dart:ui';

import 'package:decideitfinal/ForgotPasswordScreens/ForgotPasswordAPI.dart';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/LoginScreens/LoginValidate.dart';
import 'package:decideitfinal/Registration/OTPDialog.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  int _groupValue = 0;
  String email = "", mobile = "";
  final List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  AppBar appbar = AppBar();

  bool _isInAsyncCall = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Container(
            height: appbar.preferredSize.height * 0.8,
            child: Image.asset('logos/DI_Logo.png')),
        centerTitle: true,
        backgroundColor: kBluePrimaryColor,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: const Icon(Icons.arrow_back_ios)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Forgot ',
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
                        borderRadius:  BorderRadius.all(Radius.circular(20))),
                    color: kBackgroundColor,
                    child: Column(
                      children: [
                        Image.asset(
                          'images/forgotpassword.png',
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
              const SizedBox(height: 25.0),
              buildtext(),
              const SizedBox(height: 10.0),
              chooseemailorphone(),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: buildemailorphone(),
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

  buildtext() {
    if (_groupValue == 0) {
      return const Text(
        'Enter your Registered Email Address:',
        style:  TextStyle(
          color: kBluePrimaryColor,
          fontFamily: 'OpenSans',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const Text(
        'Enter your Registered Phone Number:',
        style:  TextStyle(
          color: kBluePrimaryColor,
          fontFamily: 'OpenSans',
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  chooseemailorphone() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        child: Row(
          children: [
            Radio(
              value: 0,
              groupValue: _groupValue,
              onChanged: (newValue) => setState(() => _groupValue = int.parse(newValue.toString())),
            ),
            GestureDetector(
                onTap: () {
                  setState(() => _groupValue = 0);
                },
                child: const Text('Email')),
            Radio(
              value: 1,
              groupValue: _groupValue,
              onChanged: (newValue) => setState(() => _groupValue = int.parse(newValue.toString())),
            ),
            GestureDetector(
                onTap: () {
                  setState(() => _groupValue = 1);
                },
                child: const Text('Phone')),
          ],
        ),
      ),
    );
  }

  buildemailorphone() {
    if (_groupValue == 0) {
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        onSaved: (newValue) => email = newValue!,
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
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      );
    } else if (_groupValue == 1) {
      return TextFormField(
        keyboardType: TextInputType.number,
        onSaved: (newValue) => mobile = newValue!,
        onChanged: (value) {
          if (value.isNotEmpty && value.length == 10) {
            removeError(error: kPhoneNumberLengthError);
          } else if (value.isEmpty) {
            removeError(error: kPhoneNumberNullError);
          }

        },
        validator: (value) {
          if ((value!.isNotEmpty && value.length != 10)) {
            return kPhoneNumberLengthError;
          } else if (value.isEmpty) {
            return kPhoneNumberNullError;
          }
          return null;
        },
        decoration: const InputDecoration(
          hintText: "Phone Number",
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      );
    }
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
            forgotpassword();
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

  Future<void> forgotpassword() async {
    var emailphone;
    if (_groupValue == 0) {
      emailphone = email;
    } else {
      emailphone = mobile;
    }

    setState(() {
      _isInAsyncCall = true;
    });
    var url = Uri.parse( "$apiurl/forget-password");
    var body = {
      'user_email_mobile': emailphone,
      'ResetPasswordURL': 'resetPassword'
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
      if (mobile.isNotEmpty) {
        ForgetPasswordApi forgetPasswordApi =
            forgetPasswordApiFromJson(response.body);
        String userid = forgetPasswordApi.data!.userId;
        String mobile = forgetPasswordApi.data!.phone;
        showotpdialog(userid, mobile);
      } else {
        ForgetPasswordApi forgetPasswordApi =
            forgetPasswordApiFromJson(response.body);
        SharedPreferences userprefs = await SharedPreferences.getInstance();
        userprefs.setString('ForgotPassword', forgetPasswordApi.message);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      }
    } else {
      setState(() {
        _isInAsyncCall = false;
      });
      ValidateLogin validatelogin = validateLoginFromJson(response.body);
      var mesage = validatelogin.message;
      var alert = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            title: const Text(
              'Error',
              style:  TextStyle(color: Colors.black),
            ),
            content: Text(
              mesage,
              style: const TextStyle(color: Colors.black),
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
                      child: const Text("OK",style: TextStyle(
                        color: kBackgroundColor
                      ),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              )
            ],
          ));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return alert;
        },
      );
    }
  }

  void showotpdialog(String userid, String mobile) {
    OTPDialog alert = OTPDialog(
        'Verify One Time Password',
        'Enter your One Time Password to verify your mobile number',
        userid,
        mobile,
        1);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return alert;
      },
    );
  }
}
