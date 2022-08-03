// To parse this JSON data, do
//
//     final resendEmail = resendEmailFromJson(jsonString);

import 'dart:convert';

ResendEmail resendEmailFromJson(String str) => ResendEmail.fromJson(json.decode(str));

String resendEmailToJson(ResendEmail data) => json.encode(data.toJson());

class ResendEmail {
    ResendEmail({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    int code;
    String message;
    String count;
    Data data;

    factory ResendEmail.fromJson(Map<String, dynamic> json) => ResendEmail(
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
        required this.userId,
        required this.userEmailMobilePending,
        required this.email,
    });

    String userId;
    int userEmailMobilePending;
    String email;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        userEmailMobilePending: json["user_email_mobile_pending"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_email_mobile_pending": userEmailMobilePending,
        "email": email,
    };
}
