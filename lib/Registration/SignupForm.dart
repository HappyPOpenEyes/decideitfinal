import 'dart:convert';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../alertDialog.dart';
import 'package:http/http.dart' as http;

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String mobile = "";
  String password = "";
  String username = "", firstname = "", lastname = "";
  String conform_password = "";
  bool remember = false;
  int _groupValue = 0;
  bool rememberMe = false;
  final List<String> errors = [];
  bool obscuretext = true;
  bool _isInAsyncCall = false;

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isInAsyncCall,
      // demo of some additional parameters
      opacity: 0.5,
      progressIndicator: const CircularProgressIndicator(),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              buildFirstNameFormField(),
              const SizedBox(height: 10),
              buildLastNameFormField(),
              const SizedBox(height: 10),
              buildPhoneNumberFormField(),
              const SizedBox(
                height: 2,
              ),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '*Standard Text Message Rates Apply',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              buildUserNameFormField(),
              const SizedBox(height: 10),
              buildEmailorPhoneFormField(),
              const SizedBox(height: 10),
              buildPasswordFormField(),
              const SizedBox(height: 10),
              buildAcceptTermsField(),
              ElevatedButton(
                child: Text(
                  "Register",
                  style: TextStyle(color: kBackgroundColor, fontSize: 20),
                ),
                style: buttonStyle(),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // if all are valid then go to success screen
                    signupvalidate(username, email, password);
                    //Navigator.pushNamed(context, CompleteProfileScreen.routeName);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstname = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Please enter your First Name');
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your First Name';
          //addError(error: kNamelNullError);

        }
      },
      decoration: const InputDecoration(
        hintText: "First Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastname = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: 'Please enter your Last Name');
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your Last Name';
          //addError(error: kNamelNullError);

        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Last Name",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onSaved: (newValue) => mobile = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty && value.length == 10) {
          removeError(error: kPhoneNumberLengthError);
        }
      },
      validator: (value) {
        if ((value!.isNotEmpty && value.length != 10)) {
          return kPhoneNumberLengthError;
        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Phone Number (Optional)",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildUserNameFormField() {
    return TextFormField(
      onSaved: (newValue) => username = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          return kNamelNullError;
          //addError(error: kNamelNullError);

        }
        return null;
      },
      decoration: const InputDecoration(
        hintText: "Username",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  buildChooseNumberorEmailField() {
    return InkWell(
      child: Row(
        children: [
          Radio(
            value: 0,
            groupValue: _groupValue,
            onChanged: (newValue) =>
                setState(() => _groupValue = int.parse(newValue.toString())),
          ),
          const Text('Email'),
          Radio(
            value: 1,
            groupValue: _groupValue,
            onChanged: (newValue) =>
                setState(() => _groupValue = int.parse(newValue.toString())),
          ),
          const Text('Phone'),
        ],
      ),
    );
  }

  Widget buildEmailorPhoneFormField() {
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
    } else {
      return Container();
    }
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: obscuretext,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        password = value;
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
      decoration: InputDecoration(
        hintText: "Password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: obscuretext
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    obscuretext = false;
                  });
                },
                child: Image.asset(
                  'images/invisible.png',
                  //fit: BoxFit.cover,
                ),
              )
            : GestureDetector(
                onTap: () {
                  setState(() {
                    obscuretext = true;
                  });
                },
                child: Image.asset(
                  'images/eye.png',
                  //fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }

  

  buildAcceptTermsField() {
    return CheckboxListTile(
      title: RichText(
        text: const TextSpan(
          children: [
             TextSpan(
              text: 'I have read and agree with the ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            TextSpan(
              text: 'privacy policy ',
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
             TextSpan(
              text: 'and, ',
              style:  TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            TextSpan(
              text: 'terms and conditions',
              style: TextStyle(
                  color: kBluePrimaryColor,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      value: rememberMe,
      onChanged: (newValue) {
        setState(() {
          rememberMe = newValue!;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );
  }

  Future<void> signupvalidate(
      String username, String email, String password) async {
    //String filename = _pickedImage.path.split('/').last;
    
    if (rememberMe == true) {
      setState(() {
        _isInAsyncCall = true;
      });
      var url = Uri.parse('$apiurl/register');
      var body;
      if (mobile.isEmpty) {
        body = {
          'first_name': firstname,
          'last_name': lastname,
          'user_email': email,
          'user_name': username,
          'social_network_id': 1,
          'password': password,
          'country_code_id': null,
          'is_checked': true
        };
      } else {
        body = {
          'first_name': firstname,
          'last_name': lastname,
          'user_email': email,
          'user_name': username,
          'social_network_id': 1,
          'password': password,
          'user_mobile': mobile,
          'country_code_id': null,
          'is_checked': true
        };
      }

      print(body);

      var response = await http.post(url,
          body: json.encode(body),
          headers: {"Content-Type": "application/json"},
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        setState(() {
          _isInAsyncCall = false;
        });
        setuserdetails();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        setState(() {
          _isInAsyncCall = false;
        });
      }
    } else {
      print('Errrrrooooooorrr');
      BlurryDialog alert = BlurryDialog("Error",
          "Please read and accept privacy policy and terms and conditions.");
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

  setuserdetails() async {
    SharedPreferences userprefs = await SharedPreferences.getInstance();
    userprefs.setString('UserName', username);
    userprefs.setString('Email', email);
    userprefs.setString('Number', mobile);
    userprefs.setString('Registration', 'Registration Completed Successfully');
  }
}
