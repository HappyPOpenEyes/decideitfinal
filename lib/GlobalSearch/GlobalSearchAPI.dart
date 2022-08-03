// To parse this JSON data, do
//
//     final globalSearchApi = globalSearchApiFromJson(jsonString);

import 'dart:convert';

List<GlobalSearchApi> globalSearchApiFromJson(String str) =>
    List<GlobalSearchApi>.from(
        json.decode(str).map((x) => GlobalSearchApi.fromJson(x)));

String globalSearchApiToJson(List<GlobalSearchApi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GlobalSearchApi {
  GlobalSearchApi({
    required this.id,
    required this.questionText,
    this.imageVideoUrl,
    required this.inviteeCanInviteOthers,
    required this.sendAnonymously,
    required this.inviteesOnlyToMe,
    required this.answerOnlyToMe,
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
    required this.likes,
    required this.community,
    required this.expiredOn,
    required this.expireTime,
    required this.expireTitle,
    required this.postedTime,
    this.isAbused,
    this.isLike,
    this.answerText,
    required this.displayName,
  });

  String id;
  String questionText;
  dynamic imageVideoUrl;
  String inviteeCanInviteOthers;
  String sendAnonymously;
  String inviteesOnlyToMe;
  String answerOnlyToMe;
  String fileExtention;
  int views;
  int weightageAverage;
  String createdBy;
  DateTime createdAt;
  String userId;
  String user;
  String userName;
  String? profileImageUrl;
  int comments;
  int likes;
  List<Community> community;
  DateTime expiredOn;
  String expireTime;
  String expireTitle;
  String postedTime;
  dynamic isAbused;
  dynamic isLike;
  dynamic answerText;
  String displayName;

  factory GlobalSearchApi.fromJson(Map<String, dynamic> json) =>
      GlobalSearchApi(
        id: json["id"],
        questionText: json["question_text"],
        imageVideoUrl: json["image_video_url"],
        inviteeCanInviteOthers: json["invitee_can_invite_others"],
        sendAnonymously: json["send_anonymously"],
        inviteesOnlyToMe: json["invitees_only_to_me"],
        answerOnlyToMe: json["answer_only_to_me"],
        fileExtention: json["file_extention"],
        views: json["views"],
        weightageAverage: json["weightage_average"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        userId: json["user_id"],
        user: json["user"],
        userName: json["user_name"],
        profileImageUrl: json["profile_image_url"] == null
            ? null
            : json["profile_image_url"],
        comments: json["comments"],
        likes: json["likes"],
        community: List<Community>.from(
            json["community"].map((x) => Community.fromJson(x))),
        expiredOn: DateTime.parse(json["ExpiredOn"]),
        expireTime: json["Expire_time"],
        expireTitle: json["expire_title"],
        postedTime: json["posted_time"],
        isAbused: json["is_abused"],
        isLike: json["is_like"],
        answerText: json["answer_text"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_text": questionText,
        "image_video_url": imageVideoUrl,
        "invitee_can_invite_others": inviteeCanInviteOthers,
        "send_anonymously": sendAnonymously,
        "invitees_only_to_me": inviteesOnlyToMe,
        "answer_only_to_me": answerOnlyToMe,
        "file_extention": fileExtention,
        "views": views,
        "weightage_average": weightageAverage,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "user_id": userId,
        "user": user,
        "user_name": userName,
        "profile_image_url": profileImageUrl == null ? null : profileImageUrl,
        "comments": comments,
        "likes": likes,
        "community": List<dynamic>.from(community.map((x) => x.toJson())),
        "ExpiredOn": expiredOn.toIso8601String(),
        "Expire_time": expireTime,
        "expire_title": expireTitle,
        "posted_time": postedTime,
        "is_abused": isAbused,
        "is_like": isLike,
        "answer_text": answerText,
        "display_name": displayName,
      };
}

class Community {
  Community({
    required this.name,
    required this.id,
  });

  String name;
  String id;

  factory Community.fromJson(Map<String, dynamic> json) => Community(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
