// To parse this JSON data, do
//
//     final topQuestionCommunity = topQuestionCommunityFromJson(jsonString);

import 'dart:convert';

TopQuestionCommunity topQuestionCommunityFromJson(String str) =>
    TopQuestionCommunity.fromJson(json.decode(str));

String topQuestionCommunityToJson(TopQuestionCommunity data) =>
    json.encode(data.toJson());

class TopQuestionCommunity {
  TopQuestionCommunity({
    required this.topQuestions,
    required this.newQuestions,
  });

  List<Question> topQuestions;
  List<Question> newQuestions;

  factory TopQuestionCommunity.fromJson(Map<String, dynamic> json) =>
      TopQuestionCommunity(
        topQuestions: List<Question>.from(
            json["top_questions"].map((x) => Question.fromJson(x))),
        newQuestions: List<Question>.from(
            json["new_questions"].map((x) => Question.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "top_questions":
            List<dynamic>.from(topQuestions.map((x) => x.toJson())),
        "new_questions":
            List<dynamic>.from(newQuestions.map((x) => x.toJson())),
      };
}

class Question {
  Question({
    required this.id,
    required this.questionText,
    required this.imageVideoUrl,
    required this.inviteeCanInviteOthers,
    required this.fileExtention,
    required this.views,
    required this.weightageAverage,
    required this.createdBy,
    required this.createdAt,
    required this.userId,
    required this.user,
    required this.userName,
    required this.profileImageUrl,
    required this.comments,
    required this.communityName,
    required this.communityId,
    required this.expiredOn,
    required this.expireTime,
    required this.expireTitle,
    required this.postedTime,
    this.isAbused,
  });

  String id;
  String questionText;
  String imageVideoUrl;
  String inviteeCanInviteOthers;
  String fileExtention;
  int views;
  int weightageAverage;
  String createdBy;
  DateTime createdAt;
  String userId;
  User? user;
  String userName;
  String profileImageUrl;
  int comments;
  String communityName;
  String communityId;
  DateTime expiredOn;
  String expireTime;
  String expireTitle;
  String postedTime;
  dynamic isAbused;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        questionText: json["question_text"],
        imageVideoUrl:
            json["image_video_url"] == null ? null : json["image_video_url"],
        inviteeCanInviteOthers: json["invitee_can_invite_others"],
        fileExtention: json["file_extention"],
        views: json["views"],
        weightageAverage: json["weightage_average"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        userId: json["user_id"],
        user: userValues.map[json["user"]],
        userName: json["user_name"],
        profileImageUrl: json["profile_image_url"],
        comments: json["comments"],
        communityName: json["community_name"],
        communityId: json["community_id"],
        expiredOn: DateTime.parse(json["ExpiredOn"]),
        expireTime: json["Expire_time"],
        expireTitle: json["expire_title"],
        postedTime: json["posted_time"],
        isAbused: json["is_abused"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_text": questionText,
        "image_video_url": imageVideoUrl == null ? null : imageVideoUrl,
        "invitee_can_invite_others": inviteeCanInviteOthers,
        "file_extention": fileExtention,
        "views": views,
        "weightage_average": weightageAverage,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "user_id": userId,
        "user": userValues.reverse[user],
        "user_name": userName,
        "profile_image_url": profileImageUrl,
        "comments": comments,
        "community_name": communityName,
        "community_id": communityId,
        "ExpiredOn": expiredOn.toIso8601String(),
        "Expire_time": expireTime,
        "expire_title": expireTitle,
        "posted_time": postedTime,
        "is_abused": isAbused,
      };
}

/*enum CommunityName { CARROM }

final communityNameValues = EnumValues({"Carrom": CommunityName.CARROM});

enum ExpireTime { TOMORROW, THE_2_DAYS_AGO, THE_16_HOURS_AGO, THE_2_WEEKS_AGO }

final expireTimeValues = EnumValues({
  "16 hours ago": ExpireTime.THE_16_HOURS_AGO,
  "2 days ago": ExpireTime.THE_2_DAYS_AGO,
  "2 weeks ago": ExpireTime.THE_2_WEEKS_AGO,
  "Tomorrow": ExpireTime.TOMORROW
});

enum ExpireTitle { EXPIRING, EXPIRED }

final expireTitleValues = EnumValues(
    {"Expired:": ExpireTitle.EXPIRED, "Expiring:": ExpireTitle.EXPIRING});

enum FileExtention { EMPTY, JPG }

final fileExtentionValues =
    EnumValues({"": FileExtention.EMPTY, "jpg": FileExtention.JPG});

enum PostedTime { THE_6_HOURS_AGO, THE_2_DAYS_AGO, THE_2_WEEKS_AGO }

final postedTimeValues = EnumValues({
  "2 days ago": PostedTime.THE_2_DAYS_AGO,
  "2 weeks ago": PostedTime.THE_2_WEEKS_AGO,
  "6 hours ago": PostedTime.THE_6_HOURS_AGO
});*/

enum User { STEPHEN_WALKER, VEER_MEHTA }

final userValues = EnumValues(
    {"Stephen Walker": User.STEPHEN_WALKER, "Veer mehta": User.VEER_MEHTA});

enum UserName { STHEPHENWALKER, JAYSHAH }

final userNameValues = EnumValues(
    {"jayshah": UserName.JAYSHAH, "sthephenwalker": UserName.STHEPHENWALKER});

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
