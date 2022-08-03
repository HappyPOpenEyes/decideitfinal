// To parse this JSON data, do
//
//     final addressBookApi = addressBookApiFromJson(jsonString);

import 'dart:convert';

AddressBookApi addressBookApiFromJson(String str) =>
    AddressBookApi.fromJson(json.decode(str));

String addressBookApiToJson(AddressBookApi data) => json.encode(data.toJson());

class AddressBookApi {
  AddressBookApi({
    required this.code,
    required this.message,
    required this.count,
    required this.data,
  });

  int code;
  String message;
  int count;
  List<Datums> data;

  factory AddressBookApi.fromJson(Map<String, dynamic> json) => AddressBookApi(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: List<Datums>.from(json["data"].map((x) => Datums.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datums {
  Datums({
    required this.id,
    required this.contactUserId,
    required this.userId,
    required this.contactTypeId,
    required this.contactEmail,
    this.contactFirstName,
    this.contactLastName,
    required this.contactPhone,
    this.serviceProviderId,
    required this.isInvitationSent,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.groups,
  });

  String id;
  String? contactUserId;
  String userId;
  String contactTypeId;
  String? contactEmail;
  dynamic contactFirstName;
  dynamic contactLastName;
  String? contactPhone;
  dynamic serviceProviderId;
  int isInvitationSent;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  List<GroupElement> groups;

  factory Datums.fromJson(Map<String, dynamic> json) => Datums(
        id: json["id"],
        contactUserId: json["contact_user_id"],
        userId: json["user_id"],
        contactTypeId: json["contact_type_id"],
        contactEmail:
            json["contact_email"] == null ? null : json["contact_email"],
        contactFirstName: json["contact_first_name"],
        contactLastName: json["contact_last_name"],
        contactPhone:
            json["contact_phone"] == null ? null : json["contact_phone"],
        serviceProviderId: json["service_provider_id"],
        isInvitationSent: json["is_invitation_sent"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        groups: List<GroupElement>.from(
            json["groups"].map((x) => GroupElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contact_user_id": contactUserId,
        "user_id": userId,
        "contact_type_id": contactTypeId,
        "contact_email": contactEmail == null ? null : contactEmail,
        "contact_first_name": contactFirstName,
        "contact_last_name": contactLastName,
        "contact_phone": contactPhone == null ? null : contactPhone,
        "service_provider_id": serviceProviderId,
        "is_invitation_sent": isInvitationSent,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
      };
}

class GroupElement {
  GroupElement({
    required this.id,
    required this.addressBookId,
    required this.groupNameId,
    required this.userId,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.group,
  });

  String id;
  String addressBookId;
  String groupNameId;
  String userId;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  GroupGroup group;

  factory GroupElement.fromJson(Map<String, dynamic> json) => GroupElement(
        id: json["id"],
        addressBookId: json["address_book_id"],
        groupNameId: json["group_name_id"],
        userId: json["user_id"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        group: GroupGroup.fromJson(json["group"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "address_book_id": addressBookId,
        "group_name_id": groupNameId,
        "user_id": userId,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "group": group.toJson(),
      };
}

class GroupGroup {
  GroupGroup({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdBy,
    this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String name;
  int isActive;
  String createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;

  factory GroupGroup.fromJson(Map<String, dynamic> json) => GroupGroup(
        id: json["id"],
        name: json["name"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
