// To parse this JSON data, do
//
//     final getLoginToken = getLoginTokenFromJson(jsonString);

import 'dart:convert';

GetLoginToken getLoginTokenFromJson(String str) =>
    GetLoginToken.fromJson(json.decode(str));

String getLoginTokenToJson(GetLoginToken data) => json.encode(data.toJson());

class GetLoginToken {
  GetLoginToken({
    required this.accessToken,
    required this.tokenType,
    required this.firstTimeLogin,
    required this.forceChangePassword,
    required this.emailAvailable,
  });

  String accessToken;
  String tokenType;
  int firstTimeLogin;
  int forceChangePassword;
  int emailAvailable;

  factory GetLoginToken.fromJson(Map<String, dynamic> json) => GetLoginToken(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        firstTimeLogin: json["first_time_login"],
        forceChangePassword: json["force_change_password"],
        emailAvailable: json["email_available"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "first_time_login": firstTimeLogin,
        "force_change_password": forceChangePassword,
        "email_available": emailAvailable,
      };
}
