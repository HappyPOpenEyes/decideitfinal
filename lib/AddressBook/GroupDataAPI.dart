// To parse this JSON data, do
//
//     final groupDataApi = groupDataApiFromJson(jsonString);

import 'dart:convert';

GroupDataApi groupDataApiFromJson(String str) =>
    GroupDataApi.fromJson(json.decode(str));

String groupDataApiToJson(GroupDataApi data) => json.encode(data.toJson());

class GroupDataApi {
  GroupDataApi({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  int count;
  List<DatumGroup> data;

  factory GroupDataApi.fromJson(Map<String, dynamic> json) => GroupDataApi(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: List<DatumGroup>.from(json["data"].map((x) => DatumGroup.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumGroup {
  DatumGroup({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory DatumGroup.fromJson(Map<String, dynamic> json) => DatumGroup(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
