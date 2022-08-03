// To parse this JSON data, do
//
//     final getResponse = getResponseFromJson(jsonString);

import 'dart:convert';

GetResponse getResponseFromJson(String str) =>
    GetResponse.fromJson(json.decode(str));

String getResponseToJson(GetResponse data) => json.encode(data.toJson());

class GetResponse {
  GetResponse({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory GetResponse.fromJson(Map<String, dynamic> json) => GetResponse(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
