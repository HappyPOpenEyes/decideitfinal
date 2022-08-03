// To parse this JSON data, do
//
//     final googleContacts = googleContactsFromJson(jsonString);

import 'dart:convert';

GoogleContacts googleContactsFromJson(String str) =>
    GoogleContacts.fromJson(json.decode(str));

String googleContactsToJson(GoogleContacts data) => json.encode(data.toJson());

class GoogleContacts {
  GoogleContacts({
    required this.connections,
    required this.nextPageToken,
    required this.totalPeople,
    required this.totalItems,
  });

  List<Connection> connections;
  String nextPageToken;
  int totalPeople;
  int totalItems;

  factory GoogleContacts.fromJson(Map<String, dynamic> json) => GoogleContacts(
        connections: List<Connection>.from(
            json["connections"].map((x) => Connection.fromJson(x))),
        nextPageToken: json["nextPageToken"],
        totalPeople: json["totalPeople"],
        totalItems: json["totalItems"],
      );

  Map<String, dynamic> toJson() => {
        "connections": List<dynamic>.from(connections.map((x) => x.toJson())),
        "nextPageToken": nextPageToken,
        "totalPeople": totalPeople,
        "totalItems": totalItems,
      };
}

class Connection {
  Connection({
    required this.resourceName,
    required this.etag,
    required this.names,
    required this.phoneNumbers,
    required this.emailAddresses,
  });

  String resourceName;
  String etag;
  List<Name>? names;
  List<EmailAddress>? phoneNumbers;
  List<EmailAddress>? emailAddresses;

  factory Connection.fromJson(Map<String, dynamic> json) => Connection(
        resourceName: json["resourceName"],
        etag: json["etag"],
        names: json["names"] == null
            ? null
            : List<Name>.from(json["names"].map((x) => Name.fromJson(x))),
        phoneNumbers: json["phoneNumbers"] == null
            ? null
            : List<EmailAddress>.from(
                json["phoneNumbers"].map((x) => EmailAddress.fromJson(x))),
        emailAddresses: json["emailAddresses"] == null
            ? null
            : List<EmailAddress>.from(
                json["emailAddresses"].map((x) => EmailAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resourceName": resourceName,
        "etag": etag,
        "names": names == null
            ? null
            : List<dynamic>.from(names!.map((x) => x.toJson())),
        "phoneNumbers": phoneNumbers == null
            ? null
            : List<dynamic>.from(phoneNumbers!.map((x) => x.toJson())),
        "emailAddresses": emailAddresses == null
            ? null
            : List<dynamic>.from(emailAddresses!.map((x) => x.toJson())),
      };
}

class EmailAddress {
  EmailAddress({
    required this.metadata,
    required this.value,
    required this.type,
    required this.formattedType,
    required this.canonicalForm,
  });

  Metadata metadata;
  String value;
  EmailAddressType? type;
  FormattedType? formattedType;
  String? canonicalForm;

  factory EmailAddress.fromJson(Map<String, dynamic> json) => EmailAddress(
        metadata: Metadata.fromJson(json["metadata"]),
        value: json["value"],
        type: emailAddressTypeValues.map[json["type"]],
        formattedType: formattedTypeValues.map[json["formattedType"]],
        canonicalForm:
            json["canonicalForm"] == null ? null : json["canonicalForm"],
      );

  Map<String, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "value": value,
        "type": emailAddressTypeValues.reverse[type],
        "formattedType": formattedTypeValues.reverse[formattedType],
        "canonicalForm": canonicalForm == null ? null : canonicalForm,
      };
}

enum FormattedType { OTHER, MOBILE, FORMATTED_TYPE_MOBILE }

final formattedTypeValues = EnumValues({
  "MOBILE": FormattedType.FORMATTED_TYPE_MOBILE,
  "Mobile": FormattedType.MOBILE,
  "Other": FormattedType.OTHER
});

class Metadata {
  Metadata({
    required this.primary,
    required this.source,
  });

  bool primary;
  Source source;

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        primary: json["primary"],
        source: Source.fromJson(json["source"]),
      );

  Map<String, dynamic> toJson() => {
        "primary": primary,
        "source": source.toJson(),
      };
}

class Source {
  Source({
    required this.type,
    required this.id,
  });

  SourceType? type;
  String id;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        type: sourceTypeValues.map[json["type"]],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "type": sourceTypeValues.reverse[type],
        "id": id,
      };
}

enum SourceType { CONTACT }

final sourceTypeValues = EnumValues({"CONTACT": SourceType.CONTACT});

enum EmailAddressType { OTHER, MOBILE, TYPE_MOBILE }

final emailAddressTypeValues = EnumValues({
  "mobile": EmailAddressType.MOBILE,
  "other": EmailAddressType.OTHER,
  "MOBILE": EmailAddressType.TYPE_MOBILE
});

class Name {
  Name({
    required this.metadata,
    required this.displayName,
    required this.familyName,
    required this.givenName,
    required this.displayNameLastFirst,
    required this.unstructuredName,
    required this.middleName,
  });

  Metadata metadata;
  String displayName;
  String? familyName;
  String givenName;
  String displayNameLastFirst;
  String unstructuredName;
  String? middleName;

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        metadata: Metadata.fromJson(json["metadata"]),
        displayName: json["displayName"],
        familyName: json["familyName"] == null ? null : json["familyName"],
        givenName: json["givenName"],
        displayNameLastFirst: json["displayNameLastFirst"],
        unstructuredName: json["unstructuredName"],
        middleName: json["middleName"] == null ? null : json["middleName"],
      );

  Map<String, dynamic> toJson() => {
        "metadata": metadata.toJson(),
        "displayName": displayName,
        "familyName": familyName == null ? null : familyName,
        "givenName": givenName,
        "displayNameLastFirst": displayNameLastFirst,
        "unstructuredName": unstructuredName,
        "middleName": middleName == null ? null : middleName,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
