// To parse this JSON data, do
//
//     final contactUsApi = contactUsApiFromJson(jsonString);

import 'dart:convert';

ContactUsApi contactUsApiFromJson(String str) => ContactUsApi.fromJson(json.decode(str));

String contactUsApiToJson(ContactUsApi data) => json.encode(data.toJson());

class ContactUsApi {
    ContactUsApi({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    String code;
    String message;
    String count;
    String data;

    factory ContactUsApi.fromJson(Map<String, dynamic> json) => ContactUsApi(
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
