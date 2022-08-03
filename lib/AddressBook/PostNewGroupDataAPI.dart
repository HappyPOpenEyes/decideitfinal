// To parse this JSON data, do
//
//     final postGroupDataApi = postGroupDataApiFromJson(jsonString);

import 'dart:convert';

PostNewGroupDataApi postGroupDataApiFromJson(String str) =>
    PostNewGroupDataApi.fromJson(json.decode(str));

String postNewGroupDataApiToJson(PostNewGroupDataApi data) =>
    json.encode(data.toJson());

class PostNewGroupDataApi {
  PostNewGroupDataApi({
    required this.details,
    required this.groupNameAvailable,
    required this.groupName,
    required this.userId,
  });

  List<NewDetail> details;
  int groupNameAvailable;
  String groupName;
  String userId;

  factory PostNewGroupDataApi.fromJson(Map<String, dynamic> json) =>
      PostNewGroupDataApi(
        details: List<NewDetail>.from(
            json["details"].map((x) => NewDetail.fromJson(x))),
        groupNameAvailable: json["group_name_available"],
        groupName: json["group_name"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "details": List<dynamic>.from(details.map((x) => x.toJson())),
        "group_name_available": groupNameAvailable,
        "group_name": groupName,
        "user_id": userId,
      };
}

class NewDetail {
  NewDetail({
    required this.addressBookId,
  });

  String addressBookId;

  factory NewDetail.fromJson(Map<String, dynamic> json) => NewDetail(
        addressBookId: json["address_book_id"],
      );

  Map<String, dynamic> toJson() => {
        "address_book_id": addressBookId,
      };
}
