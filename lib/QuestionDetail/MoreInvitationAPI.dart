// To parse this JSON data, do
//
//     final moreInvitationsApi = moreInvitationsApiFromJson(jsonString);

import 'dart:convert';

MoreInvitationsApi moreInvitationsApiFromJson(String str) => MoreInvitationsApi.fromJson(json.decode(str));

String moreInvitationsApiToJson(MoreInvitationsApi data) => json.encode(data.toJson());

class MoreInvitationsApi {
    MoreInvitationsApi({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    String code;
    String message;
    String count;
    String data;

    factory MoreInvitationsApi.fromJson(Map<String, dynamic> json) => MoreInvitationsApi(
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
