// To parse this JSON data, do
//
//     final addContacttoGroupValid = addContacttoGroupValidFromJson(jsonString);

import 'dart:convert';

AddContacttoGroupValid addContacttoGroupValidFromJson(String str) => AddContacttoGroupValid.fromJson(json.decode(str));

String addContacttoGroupValidToJson(AddContacttoGroupValid data) => json.encode(data.toJson());

class AddContacttoGroupValid {
    AddContacttoGroupValid({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    int count;
    String data;

    factory AddContacttoGroupValid.fromJson(Map<String, dynamic> json) => AddContacttoGroupValid(
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
