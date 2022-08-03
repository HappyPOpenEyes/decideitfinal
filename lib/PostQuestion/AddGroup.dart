// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact {
  Contact({
    required this.groupName,
    required this.usersDetails,
  });

  String groupName;
  List<String> usersDetails;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        groupName: json["group_name"],
        usersDetails: List<String>.from(json["users_details"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "group_name": groupName,
        "users_details": List<dynamic>.from(usersDetails.map((x) => x)),
      };
}
