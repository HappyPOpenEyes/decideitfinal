// To parse this JSON data, do
//
//     final sendOptionQuestionDetail = sendOptionQuestionDetailFromJson(jsonString);

import 'dart:convert';

SendOptionQuestionDetail sendOptionQuestionDetailFromJson(String str) =>
    SendOptionQuestionDetail.fromJson(json.decode(str));

String sendOptionQuestionDetailToJson(SendOptionQuestionDetail data) =>
    json.encode(data.toJson());

class SendOptionQuestionDetail {
  SendOptionQuestionDetail({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  String code;
  String message;
  String count;
  Data data;

  factory SendOptionQuestionDetail.fromJson(Map<String, dynamic> json) =>
      SendOptionQuestionDetail(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.key,
    required this.value,
    required this.displayText,
    required this.description,
    required this.displayOrder,
    required this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String key;
  String value;
  String displayText;
  String description;
  int displayOrder;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic createdAt;
  dynamic updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        displayText: json["display_text"],
        description: json["description"],
        displayOrder: json["display_order"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
        "display_text": displayText,
        "description": description,
        "display_order": displayOrder,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
