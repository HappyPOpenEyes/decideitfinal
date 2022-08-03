// To parse this JSON data, do
//
//     final groupData = groupDataFromJson(jsonString);

import 'dart:convert';

InvalidGroupNameAPI invalidGroupNameAPIFromJson(String str) =>
    InvalidGroupNameAPI.fromJson(json.decode(str));

String invalidGroupNameAPIToJson(InvalidGroupNameAPI data) =>
    json.encode(data.toJson());

class InvalidGroupNameAPI {
  InvalidGroupNameAPI({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory InvalidGroupNameAPI.fromJson(Map<String, dynamic> json) =>
      InvalidGroupNameAPI(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
