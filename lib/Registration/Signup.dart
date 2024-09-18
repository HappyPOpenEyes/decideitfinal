import 'dart:convert';
import 'package:decideitfinal/LoginScreens/Login.dart';
import 'package:decideitfinal/Registration/OTPDialog.dart';
import 'package:decideitfinal/SplashScreens/splashscreen.dart';
import 'package:decideitfinal/alertdialog_single.dart';
import 'package:decideitfinal/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  String email = "",
      mobile = "",
      password = "",
      username = "",
      firstname = "",
      lastname = "";
  bool remember = false;
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
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        // demo of some additional parameters
        opacity: 0.5,
        progressIndicator: const CircularProgressIndicator(),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("images/Login-Bg.png"),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8), BlendMode.dstATop),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.16,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SplashScreen()));
                              },
                              child: const Icon(Icons.arrow_back_ios)),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.32,
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.width * 0.13,
                              child: Image.asset('logos/DI_Logo.png'))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Register",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.056,
                          fontWeight: FontWeight.bold,
                          color: kBluePrimaryColor,
                          height: 1.5,
                        )),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Enter your details to Register: ",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kBluePrimaryColor),
                    ),
                  ),
                  Form(
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
                          const SizedBox(
                            height: 2,
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '*Minimum 8 characters. Letters, numbers and these symbols (!@#\$&*_-) can be used',
                              style: TextStyle(fontSize: 12.5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildAcceptTermsField(),
                          RaisedButton(
                            child: const Text(
                              "Register",
                              style: TextStyle(
                                  color: kBackgroundColor, fontSize: 20),
                            ),
                            color: kBluePrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState?.save();
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
                  const SizedBox(height: 5),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Already Registered? ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                              },
                            text: 'Login',
                            style: const TextStyle(
                                color: kOrangePrimaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildEmailorPhoneFormField() {
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
        return null;
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
          return "";
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
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (newValue) {
            setState(() {
              rememberMe = newValue!;
            });
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: 'I have read and agree with the ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      // await launchUrl(
                      //   Uri.parse(
                      //       'https://decideit.uatbyopeneyes.com/termsConditions'),
                      // );
                    },
                  text: 'User Agreement ',
                  style: const TextStyle(
                      color: kBluePrimaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                  text: 'and ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                  ),
                ),
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      // await launch(
                      //     'https://decideit.uatbyopeneyes.com/privacyPolicy',
                      //     forceSafariVC: false);
                    },
                  text: 'Privacy Policy',
                  style: const TextStyle(
                      color: kBluePrimaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    /*return CheckboxListTile(
      title: 
      value: rememberMe,
      onChanged: (newValue) {
        setState(() {
          rememberMe = newValue;
        });
      },
      controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
    );*/
  }

  Future<void> signupvalidate(
      String username, String email, String password) async {
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
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        setState(() {
          _isInAsyncCall = false;
        });
        if (mobile.isNotEmpty) {
          setuserdetails();
          OTPDialog alert = OTPDialog('Verify OTP',
              'Enter your OTP to verify your mobile number', "", mobile, 2);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;
              return alert;
            },
          );
        } else {
          setuserdetails();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginScreen()));
        }
      } else {
        setState(() {
          _isInAsyncCall = false;
        });
        print(response.statusCode);
        print(response.body);
        
      }
      
    } else {
      BlurryDialogSingle alert = BlurryDialogSingle("Error",
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
    userprefs.setString('Registration',
        'Your profile has been created successfully. Kindly check your email for verification.');
  }
}
