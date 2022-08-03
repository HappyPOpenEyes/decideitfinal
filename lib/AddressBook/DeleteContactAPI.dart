// To parse this JSON data, do
//
//     final addContactValidApi = addContactValidApiFromJson(jsonString);

import 'dart:convert';

DeleteContactAPI deleteContactAPIFromJson(String str) =>
    DeleteContactAPI.fromJson(json.decode(str));

String deleteContactAPIToJson(DeleteContactAPI data) =>
    json.encode(data.toJson());

class DeleteContactAPI {
  DeleteContactAPI({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  String code;
  String message;
  String count;
  String data;

  factory DeleteContactAPI.fromJson(Map<String, dynamic> json) =>
      DeleteContactAPI(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data,
      };
}
