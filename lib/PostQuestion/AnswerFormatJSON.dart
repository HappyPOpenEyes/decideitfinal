// To parse this JSON data, do
//
//     final postQuestionAnswerFormat = postQuestionAnswerFormatFromJson(jsonString);

import 'dart:convert';

PostQuestionAnswerFormat postQuestionAnswerFormatFromJson(String str) => PostQuestionAnswerFormat.fromJson(json.decode(str));

String postQuestionAnswerFormatToJson(PostQuestionAnswerFormat data) => json.encode(data.toJson());

class PostQuestionAnswerFormat {
    PostQuestionAnswerFormat({
        required this.code,
        required this.message,
        required this.count,
        required this.data,
    });

    String code;
    String message;
    String count;
    Data data;

    factory PostQuestionAnswerFormat.fromJson(Map<String, dynamic> json) => PostQuestionAnswerFormat(
        code: json["code"],
        message: json["message"],
        count: json["count"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "count": count,
        "data": data.toJson(),
    };
}

class Data {
    Data({
        required this.categories,
        required this.questionTypes,
        required this.questionSendOptions,
        required this.groups,
        required this.questions,
        required this.communityEmails,
    });

    List<Category> categories;
    List<Question> questionTypes;
    List<Question> questionSendOptions;
    List<Group> groups;
    int questions;
    List<String> communityEmails;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        questionTypes: List<Question>.from(json["questionTypes"].map((x) => Question.fromJson(x))),
        questionSendOptions: List<Question>.from(json["questionSendOptions"].map((x) => Question.fromJson(x))),
        groups: List<Group>.from(json["groups"].map((x) => Group.fromJson(x))),
        questions: json["questions"],
        communityEmails: List<String>.from(json["communityEmails"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "questionTypes": List<dynamic>.from(questionTypes.map((x) => x.toJson())),
        "questionSendOptions": List<dynamic>.from(questionSendOptions.map((x) => x.toJson())),
        "groups": List<dynamic>.from(groups.map((x) => x.toJson())),
        "questions": questions,
        "communityEmails": List<dynamic>.from(communityEmails.map((x) => x)),
    };
}

class Category {
    Category({
        required this.name,
        this.itemClass,
        this.id,
    });

    String name;
    ItemClass? itemClass;
    String? id;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json["name"],
        itemClass: itemClassValues.map[json["itemClass"]],
        id: json["id"] == null ? null : json["id"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "itemClass": itemClassValues.reverse[itemClass],
        "id": id == null ? null : id,
    };
}

enum ItemClass { FIRST_LEVEL, SECOND_LEVEL }

final itemClassValues = EnumValues({
    "first-level": ItemClass.FIRST_LEVEL,
    "second-level": ItemClass.SECOND_LEVEL
});

class Group {
    Group({
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

    factory Group.fromJson(Map<String, dynamic> json) => Group(
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

class Question {
    Question({
        required this.id,
        required this.key,
        required this.value,
        required this.displayText,
        required this.description,
        required this.displayOrder,
        required this.isActive,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
    });

    String id;
    String key;
    String value;
    String displayText;
    String description;
    int displayOrder;
    int isActive;
    String? createdBy;
    String? updatedBy;
    dynamic createdAt;
    DateTime? updatedAt;

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        displayText: json["display_text"],
        description: json["description"],
        displayOrder: json["display_order"],
        isActive: json["is_active"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
        "display_text": displayText,
        "description": description,
        "display_order": displayOrder,
        "is_active": isActive,
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy == null ? null : updatedBy,
        "created_at": createdAt,
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
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
