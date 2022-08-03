import 'dart:convert';

SignupUser welcomeFromJson(String str) => SignupUser.fromJson(json.decode(str));

String welcomeToJson(SignupUser data) => json.encode(data.toJson());

class SignupUser {
  SignupUser({
    required this.userEmailMobile,
    required this.userName,
    required this.socialNetworkId,
    required this.countryCodeId,
    required this.password,
  });

  String userEmailMobile;
  String userName;
  int socialNetworkId;
  dynamic countryCodeId;
  String password;

  factory SignupUser.fromJson(Map<String, dynamic> json) => SignupUser(
    userEmailMobile: json["user_email_mobile"],
    userName: json["user_name"],
    socialNetworkId: json["social_network_id"],
    countryCodeId: json["country_code_id"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "user_email_mobile": userEmailMobile,
    "user_name": userName,
    "social_network_id": socialNetworkId,
    "country_code_id": countryCodeId,
    "password": password,
  };
}
