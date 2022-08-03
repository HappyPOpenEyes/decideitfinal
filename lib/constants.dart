import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff002060);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kBluePrimaryColor = Color(0xff002060);
const kOrangePrimaryColor = Color(0xFFEB6B15);
const kBorderColor = Color(0xFFF1F1F1);
const kBackgroundColor = Color(0xFFF6F6F6);

//prod links
const apiurl = "https://api.decideit.com/public/api";
const imageapiurl = "https://d3e2abno88e1ok.cloudfront.net";

// dev links
// const apiurl = "https://api.decideit.uatbyopeneyes.com/public/api";
// const imageapiurl = "https://api.decideit.uatbyopeneyes.com/public";
const imagextensions = ['jpg', 'jpeg', 'png', 'JPEG', 'JPG', 'PNG'];
const videoextensions = ['mp4', 'MP4', 'MKV', 'mkv', 'WEBM', 'webm', 'avi'];

ButtonStyle buttonStyle() {
  return ElevatedButton.styleFrom(
      primary: kPrimaryColor, // background
      onPrimary: kBackgroundColor);
}

const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password must be 8 characters or more";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kPhoneNumberLengthError = "Please enter a valid phone number";
const String kAddressNullError = "Please Enter your address";
