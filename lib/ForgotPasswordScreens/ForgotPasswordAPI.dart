// To parse this JSON data, do
//
//     final forgetPasswordApi = forgetPasswordApiFromJson(jsonString);

import 'dart:convert';

ForgetPasswordApi forgetPasswordApiFromJson(String str) =>
    ForgetPasswordApi.fromJson(json.decode(str));

String forgetPasswordApiToJson(ForgetPasswordApi data) =>
    json.encode(data.toJson());

class ForgetPasswordApi {
  ForgetPasswordApi({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  String count;
  Data? data;

  factory ForgetPasswordApi.fromJson(Map<String, dynamic> json) =>
      ForgetPasswordApi(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: json["data"] == "" ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    required this.userId,
    required this.phone,
  });

  String userId;
  String phone;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "phone": phone,
      };
}
