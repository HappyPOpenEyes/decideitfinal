// To parse this JSON data, do
//
//     final updateProfileApi = updateProfileApiFromJson(jsonString);

import 'dart:convert';

UpdateProfileApi updateProfileApiFromJson(String str) => UpdateProfileApi.fromJson(json.decode(str));

String updateProfileApiToJson(UpdateProfileApi data) => json.encode(data.toJson());

class UpdateProfileApi {
    UpdateProfileApi({
        required this.code,
        required this.message,
    });

    int code;
    String message;

    factory UpdateProfileApi.fromJson(Map<String, dynamic> json) => UpdateProfileApi(
        code: json["code"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
    };
}
