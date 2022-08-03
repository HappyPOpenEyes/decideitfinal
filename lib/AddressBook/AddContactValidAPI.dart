// To parse this JSON data, do
//
//     final addContactValidApi = addContactValidApiFromJson(jsonString);

import 'dart:convert';

AddContactValidApi addContactValidApiFromJson(String str) => AddContactValidApi.fromJson(json.decode(str));

String addContactValidApiToJson(AddContactValidApi data) => json.encode(data.toJson());

class AddContactValidApi {
    AddContactValidApi({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    String data;

    factory AddContactValidApi.fromJson(Map<String, dynamic> json) => AddContactValidApi(
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
