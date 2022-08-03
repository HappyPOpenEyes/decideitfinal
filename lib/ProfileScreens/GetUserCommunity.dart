// To parse this JSON data, do
//
//     final getUserCommunity = getUserCommunityFromJson(jsonString);

import 'dart:convert';

List<GetUserCommunity> getUserCommunityFromJson(String str) => List<GetUserCommunity>.from(json.decode(str).map((x) => GetUserCommunity.fromJson(x)));

String getUserCommunityToJson(List<GetUserCommunity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUserCommunity {
    GetUserCommunity({
        required this.id,
        required this.userId,
        required this.communityId,
        required this.isActive,
        required this.createdBy,
        required this.updatedBy,
        required this.createdAt,
        required this.updatedAt,
        required this.community,
    });

    String id;
    String userId;
    String communityId;
    int isActive;
    String createdBy;
    String updatedBy;
    DateTime createdAt;
    DateTime updatedAt;
    Community community;

    factory GetUserCommunity.fromJson(Map<String, dynamic> json) => GetUserCommunity(
        id: json["id"],
        userId: json["user_id"],
        communityId: json["community_id"],
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        community: Community.fromJson(json["community"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "community_id": communityId,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "community": community.toJson(),
    };
}

class Community {
    Community({
        required this.id,
        required this.categoryId,
        required this.name,
        required this.communityThumbnailImage,
        required this.communityBannerImage,
        required this.description,
        required this.isActive,
        this.createdBy,
        required this.updatedBy,
        this.createdAt,
        required this.updatedAt,
        required this.category,
    });

    String id;
    String categoryId;
    String name;
    String communityThumbnailImage;
    String communityBannerImage;
    String description;
    int isActive;
    String? createdBy;
    String updatedBy;
    DateTime? createdAt;
    DateTime updatedAt;
    Category category;

    factory Community.fromJson(Map<String, dynamic> json) => Community(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        communityThumbnailImage: json["community_thumbnail_image"],
        communityBannerImage: json["community_banner_image"],
        description: json["description"],
        isActive: json["is_active"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        category: Category.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "community_thumbnail_image": communityThumbnailImage,
        "community_banner_image": communityBannerImage,
        "description": description,
        "is_active": isActive,
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "category": category.toJson(),
    };
}

class Category {
    Category({
        required this.id,
        required this.name,
        required this.description,
        required this.isActive,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
    });

    String id;
    String name;
    String description;
    int isActive;
    String? createdBy;
    String? updatedBy;
    DateTime? createdAt;
    DateTime? updatedAt;

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "is_active": isActive,
        "created_by": createdBy == null ? null : createdBy,
        "updated_by": updatedBy == null ? null : updatedBy,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}
