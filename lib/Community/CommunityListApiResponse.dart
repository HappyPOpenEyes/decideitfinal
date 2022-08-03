// To parse this JSON data, do
//
//     final communityListResponse = communityListResponseFromJson(jsonString);

import 'dart:convert';

CommunityListResponse communityListResponseFromJson(String str) =>
    CommunityListResponse.fromJson(json.decode(str));

String communityListResponseToJson(CommunityListResponse data) =>
    json.encode(data.toJson());

class CommunityListResponse {
  CommunityListResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  String code;
  String message;
  String count;
  String data;

  factory CommunityListResponse.fromJson(Map<String, dynamic> json) =>
      CommunityListResponse(
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
