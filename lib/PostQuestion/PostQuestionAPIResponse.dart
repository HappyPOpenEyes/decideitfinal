// To parse this JSON data, do
//
//     final communityListResponse = communityListResponseFromJson(jsonString);

import 'dart:convert';

PostQuestionResponse postquestionResponseFromJson(String str) =>
    PostQuestionResponse.fromJson(json.decode(str));

String postquestionResponseToJson(PostQuestionResponse data) =>
    json.encode(data.toJson());

class PostQuestionResponse {
  PostQuestionResponse({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  dynamic code;
  String message;
  String? count;
  String data;

  factory PostQuestionResponse.fromJson(Map<String, dynamic> json) =>
      PostQuestionResponse(
        code: json["code"],
        message: json["message"],
        count: json["count"] == null ? 0 : json["count"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data,
      };
}
