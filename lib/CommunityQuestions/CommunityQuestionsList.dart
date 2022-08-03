// To parse this JSON data, do
//
//     final communityQuestionslistApi = communityQuestionslistApiFromJson(jsonString);

import 'dart:convert';

CommunityQuestionslistApi communityQuestionslistApiFromJson(String str) =>
    CommunityQuestionslistApi.fromJson(json.decode(str));

String communityQuestionslistApiToJson(CommunityQuestionslistApi data) =>
    json.encode(data.toJson());

class CommunityQuestionslistApi {
  CommunityQuestionslistApi({
    required this.topQuestions,
    required this.newQuestions,
  });

  List<Question> topQuestions;
  List<Question> newQuestions;

  factory CommunityQuestionslistApi.fromJson(Map<String, dynamic> json) =>
      CommunityQuestionslistApi(
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
    required this.randomName,
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
    this.displayName,
  });

  String id;
  String questionText;
  String? imageVideoUrl;
  String inviteeCanInviteOthers;
  String sendAnonymously;
  String inviteesOnlyToMe;
  String answerOnlyToMe;
  String? fileExtention;
  int views;
  int weightageAverage;
  String createdBy;
  DateTime createdAt;
  String userId;
  User? user;
  DisplayNameEnum? userName;
  RandomName? randomName;
  String profileImageUrl;
  int comments;
  int likes;
  List<Community> community;
  String expiredOn;
  String expireTime;
  String expireTitle;
  String postedTime;
  dynamic isAbused;
  dynamic isLike;
  String? displayName;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        questionText: json["question_text"],
        imageVideoUrl:
            json["image_video_url"] == null ? null : json["image_video_url"],
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
        user: userValues.map[json["user"]],
        userName: displayNameEnumValues.map[json["user_name"]],
        randomName: randomNameValues.map[json["random_name"]],
        profileImageUrl: json["profile_image_url"],
        comments: json["comments"],
        likes: json["likes"],
        community: List<Community>.from(
            json["community"].map((x) => Community.fromJson(x))),
        expiredOn: json["ExpiredOn"],
        expireTime: json["Expire_time"],
        expireTitle: json["expire_title"],
        postedTime: json["posted_time"],
        isAbused: json["is_abused"],
        isLike: json["is_like"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_text": questionText,
        "image_video_url": imageVideoUrl == null ? null : imageVideoUrl,
        "invitee_can_invite_others": inviteeCanInviteOthers,
        "send_anonymously": sendAnonymously,
        "invitees_only_to_me": inviteesOnlyToMe,
        "answer_only_to_me": answerOnlyToMe,
        "file_extention": fileExtentionValues.reverse[fileExtention],
        "views": views,
        "weightage_average": weightageAverage,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "user_id": userId,
        "user": userValues.reverse[user],
        "user_name": displayNameEnumValues.reverse[userName],
        "random_name": randomNameValues.reverse[randomName],
        "profile_image_url": profileImageUrl,
        "comments": comments,
        "likes": likes,
        "community": List<dynamic>.from(community.map((x) => x.toJson())),
        "ExpiredOn": expiredOn,
        "Expire_time": timeValues.reverse[expireTime],
        "expire_title": expireTitleValues.reverse[expireTitle],
        "posted_time": timeValues.reverse[postedTime],
        "is_abused": isAbused,
        "is_like": isLike,
        "display_name": displayNameEnumValues.reverse[displayName],
      };
}

class Community {
  Community({
    this.name,
    this.id,
  });

  Name? name;
  String? id;

  factory Community.fromJson(Map<String, dynamic> json) => Community(
        name: nameValues.map[json["name"]],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": nameValues.reverse[name],
        "id": id,
      };
}

enum Name { BALLROOM }

final nameValues = EnumValues({"Ballroom": Name.BALLROOM});

enum DisplayNameEnum { JERRYKINGSTON1111, MKAGRANA }

final displayNameEnumValues = EnumValues({
  "jerrykingston1111": DisplayNameEnum.JERRYKINGSTON1111,
  "mkagrana": DisplayNameEnum.MKAGRANA
});

enum Time { THE_5_MONTHS_AGO, THE_6_MONTHS_AGO }

final timeValues = EnumValues({
  "5 months ago": Time.THE_5_MONTHS_AGO,
  "6 months ago": Time.THE_6_MONTHS_AGO
});

enum ExpireTitle { EXPIRED }

final expireTitleValues = EnumValues({"Expired:": ExpireTitle.EXPIRED});

enum FileExtention { EMPTY, JPG }

final fileExtentionValues =
    EnumValues({"": FileExtention.EMPTY, "jpg": FileExtention.JPG});

enum RandomName { DI_USER409321, DI_USER911739 }

final randomNameValues = EnumValues({
  "DI-User409321": RandomName.DI_USER409321,
  "DI-User911739": RandomName.DI_USER911739
});

enum User { JERRY_KINGSTON, MIHIR_KAGRANA }

final userValues = EnumValues({
  "Jerry Kingston": User.JERRY_KINGSTON,
  "Mihir Kagrana": User.MIHIR_KAGRANA
});

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
