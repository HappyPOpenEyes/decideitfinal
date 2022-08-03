// To parse this JSON data, do
//
//     final groupData = groupDataFromJson(jsonString);

import 'dart:convert';

GroupData groupDataFromJson(String str) => GroupData.fromJson(json.decode(str));

String groupDataToJson(GroupData data) => json.encode(data.toJson());

class GroupData {
  GroupData({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  String code;
  String message;
  String count;
  List<String> data;

  factory GroupData.fromJson(Map<String, dynamic> json) => GroupData(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: List<String>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
