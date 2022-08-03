// To parse this JSON data, do
//
//     final postGoogleContacts = postGoogleContactsFromJson(jsonString);

import 'dart:convert';

PostGoogleContacts postGoogleContactsFromJson(String str) =>
    PostGoogleContacts.fromJson(json.decode(str));

String postGoogleContactsToJson(PostGoogleContacts data) =>
    json.encode(data.toJson());

class PostGoogleContacts {
  PostGoogleContacts({
    required this.userId,
    required this.importContact,
    required this.status,
  });

  String userId;
  List<ImportContact> importContact;
  int status;

  factory PostGoogleContacts.fromJson(Map<String, dynamic> json) =>
      PostGoogleContacts(
        userId: json["UserId"],
        importContact: List<ImportContact>.from(
            json["importContact"].map((x) => ImportContact.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "UserId": userId,
        "importContact":
            List<dynamic>.from(importContact.map((x) => x.toJson())),
        "status": status,
      };
}

class ImportContact {
  ImportContact({
    required this.contactEmail,
    this.contactFirstName,
    this.contactLastName,
    this.contactPhone,
  });

  String contactEmail;
  dynamic contactFirstName;
  dynamic contactLastName;
  dynamic contactPhone;

  factory ImportContact.fromJson(Map<String, dynamic> json) => ImportContact(
        contactEmail: json["contact_email"],
        contactFirstName: json["contact_first_name"],
        contactLastName: json["contact_last_name"],
        contactPhone: json["contact_phone"],
      );

  Map<String, dynamic> toJson() => {
        "contact_email": contactEmail,
        "contact_first_name": contactFirstName,
        "contact_last_name": contactLastName,
        "contact_phone": contactPhone,
      };
}
