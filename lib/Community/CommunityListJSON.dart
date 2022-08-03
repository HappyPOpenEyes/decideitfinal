// To parse this JSON data, do
//
//     final communityListApi = communityListApiFromJson(jsonString);

import 'dart:convert';

List<CommunityListApi> communityListApiFromJson(String str) => List<CommunityListApi>.from(json.decode(str).map((x) => CommunityListApi.fromJson(x)));

String communityListApiToJson(List<CommunityListApi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommunityListApi {
    CommunityListApi({
        required this.id,
        required this.name,
        required this.description,
        required this.isActive,
        required this.createdBy,
        required this.updatedBy,
        required this.createdAt,
        required this.updatedAt,
        required this.communities,
    });

    String id;
    String name;
    String description;
    int isActive;
    String? createdBy;
    String? updatedBy;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<Community> communities;

    factory CommunityListApi.fromJson(Map<String, dynamic> json) => CommunityListApi(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isActive: json["is_active"],
        createdBy: json["created_by"] == null ? null : json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        communities: List<Community>.from(json["communities"].map((x) => Community.fromJson(x))),
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
        "communities": List<dynamic>.from(communities.map((x) => x.toJson())),
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
        required this.createdBy,
        required this.updatedBy,
        required this.createdAt,
        required this.updatedAt,
    });

    String id;
    String categoryId;
    String name;
    String communityThumbnailImage;
    String communityBannerImage;
    String description;
    int isActive;
    String? createdBy;
    String? updatedBy;
    DateTime? createdAt;
    DateTime updatedAt;

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
    };
}
