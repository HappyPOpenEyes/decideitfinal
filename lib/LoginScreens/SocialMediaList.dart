// To parse this JSON data, do
//
//     final socialMediaList = socialMediaListFromJson(jsonString);

import 'dart:convert';

SocialMediaList socialMediaListFromJson(String str) => SocialMediaList.fromJson(json.decode(str));

String socialMediaListToJson(SocialMediaList data) => json.encode(data.toJson());

class SocialMediaList {
  SocialMediaList({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  int count;
  List<Datum> data;

  factory SocialMediaList.fromJson(Map<String, dynamic> json) => SocialMediaList(
    code: json["code"],
    message: json["message"],
    count: json["count"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "count": count,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    this.apiKey,
    this.secretKey,
    required this.classCode,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    required this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  dynamic apiKey;
  dynamic secretKey;
  String classCode;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  dynamic updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    apiKey: json["api_key"],
    secretKey: json["secret_key"],
    classCode: json["class_code"],
    isActive: json["is_active"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "api_key": apiKey,
    "secret_key": secretKey,
    "class_code": classCode,
    "is_active": isActive,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
  };
}
