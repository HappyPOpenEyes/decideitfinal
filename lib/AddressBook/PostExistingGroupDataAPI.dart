// To parse this JSON data, do
//
//     final postGroupDataApi = postGroupDataApiFromJson(jsonString);

import 'dart:convert';

PostGroupDataApi postGroupDataApiFromJson(String str) =>
    PostGroupDataApi.fromJson(json.decode(str));

String postGroupDataApiToJson(PostGroupDataApi data) =>
    json.encode(data.toJson());

class PostGroupDataApi {
  PostGroupDataApi({
    required this.details,
    required this.groupNameAvailable,
    required this.groupNameId,
    required this.userId,
  });

  List<Detail> details;
  String groupNameAvailable;
  String groupNameId;
  String userId;

  factory PostGroupDataApi.fromJson(Map<String, dynamic> json) =>
      PostGroupDataApi(
        details:
            List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
        groupNameAvailable: json["group_name_available"],
        groupNameId: json["group_name_id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "group_name_available": groupNameAvailable,
        "group_name_id": groupNameId,
        "user_id": userId,
      };
}

class Detail {
  Detail({
    required this.addressBookId,
  });

  String addressBookId;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        addressBookId: json["address_book_id"],
      );

  Map<String, dynamic> toJson() => {
        "address_book_id": addressBookId,
      };
}
