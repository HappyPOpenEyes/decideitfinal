// To parse this JSON data, do
//
//     final communityQuestionApi = communityQuestionApiFromJson(jsonString);

import 'dart:convert';

CommunityQuestionApi communityQuestionApiFromJson(String str) => CommunityQuestionApi.fromJson(json.decode(str));

String communityQuestionApiToJson(CommunityQuestionApi data) => json.encode(data.toJson());

class CommunityQuestionApi {
    CommunityQuestionApi({
        required this.id,
        required this.categoryId,
        required this.name,
        required this.communityThumbnailImage,
        required this.communityBannerImage,
        required this.description,
        required this.isActive,
        this.createdBy,
        this.updatedBy,
        required this.createdAt,
        required this.updatedAt,
        required this.category,
        required this.users,
    });

    String id;
    String categoryId;
    String name;
    String communityThumbnailImage;
    String communityBannerImage;
    String description;
    int isActive;
    dynamic createdBy;
    dynamic updatedBy;
    DateTime createdAt;
    DateTime updatedAt;
    Category category;
    List<Category> users;

    factory CommunityQuestionApi.fromJson(Map<String, dynamic> json) => CommunityQuestionApi(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        communityThumbnailImage: json["community_thumbnail_image"],
        communityBannerImage: json["community_banner_image"],
        description: json["description"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        category: Category.fromJson(json["category"]),
        users: List<Category>.from(json["users"].map((x) => Category.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "community_thumbnail_image": communityThumbnailImage,
        "community_banner_image": communityBannerImage,
        "description": description,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "category": category.toJson(),
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
    };
}

class Category {
    Category({
        required this.id,
        required this.name,
        required this.description,
        required this.isActive,
        required this.createdBy,
        required this.updatedBy,
        required this.createdAt,
        required this.updatedAt,
        required this.userId,
        required this.communityId,
    });

    String? id;
    String? name;
    String? description;
    int isActive;
    String createdBy;
    String updatedBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    String? userId;
    String? communityId;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"] == null ? null : json["name"],
        description: json["description"] == null ? null : json["description"],
        isActive: json["is_active"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        userId: json["user_id"] == null ? null : json["user_id"],
        communityId: json["community_id"] == null ? null : json["community_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name == null ? null : name,
        "description": description == null ? null : description,
        "is_active": isActive,
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy == null ? null : updatedBy,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "user_id": userId == null ? null : userId,
        "community_id": communityId == null ? null : communityId,
    };
}
