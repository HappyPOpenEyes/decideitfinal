// To parse this JSON data, do
//
//     final validOtp = validOtpFromJson(jsonString);

import 'dart:convert';

ValidOtp validOtpFromJson(String str) => ValidOtp.fromJson(json.decode(str));

String validOtpToJson(ValidOtp data) => json.encode(data.toJson());

class ValidOtp {
    ValidOtp({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    String data;

    factory ValidOtp.fromJson(Map<String, dynamic> json) => ValidOtp(
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
