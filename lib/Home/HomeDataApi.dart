// To parse this JSON data, do
//
//     final homeData = homeDataFromJson(jsonString);

import 'dart:convert';

HomeData homeDataFromJson(String str) => HomeData.fromJson(json.decode(str));

String homeDataToJson(HomeData data) => json.encode(data.toJson());

class HomeData {
  HomeData({
    required this.topQuestions,
    required this.newQuestions,
  });

  List<Question> topQuestions;
  List<Question> newQuestions;

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
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
    required this.islike,
    required this.displayName,
  });

  String id;
  String questionText;
  String? imageVideoUrl;
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
  String? randomName;
  String? profileImageUrl;
  int comments;
  int likes;
  List<Community> community;
  String expiredOn;
  String expireTime;
  String expireTitle;
  String postedTime;
  String? isAbused;
  String? islike;
  String displayName;

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
        user: json["user"],
        userName: json["user_name"],
        randomName: json["random_name"] == null ? null : json["random_name"],
        profileImageUrl: json["profile_image_url"] == null
            ? null
            : json["profile_image_url"],
        comments: json["comments"],
        likes: json["likes"],
        community: List<Community>.from(
            json["community"].map((x) => Community.fromJson(x))),
        expiredOn: json["ExpiredOn"],
        expireTime: json["Expire_time"],
        expireTitle: json["expire_title"],
        postedTime: json["posted_time"],
        isAbused: json["is_abused"],
        islike: json["is_like"],
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
        "file_extention": fileExtention,
        "views": views,
        "weightage_average": weightageAverage,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "user_id": userId,
        "user": displayNameValues.reverse[user],
        "user_name": userNameValues.reverse[userName],
        "random_name":
            randomName == null ? null : randomNameValues.reverse[randomName],
        "profile_image_url": profileImageUrl == null ? null : profileImageUrl,
        "comments": comments,
        "likes": likes,
        "community": List<dynamic>.from(community.map((x) => x.toJson())),
        "ExpiredOn": expiredOn,
        "Expire_time": timeValues.reverse[expireTime],
        "expire_title": expireTitleValues.reverse[expireTitle],
        "posted_time": timeValues.reverse[postedTime],
        "is_abused": isAbused,
        "is_like": islike,
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

enum Name {
  HIP_HOP,
  CARROM,
  HOCKEY,
  BADMINTON,
  CHESS,
  DISCO,
  CRICKET,
  JAZZ,
  FOOTBALL,
  TENNIS,
  FOLK
}

final nameValues = EnumValues({
  "Badminton": Name.BADMINTON,
  "Carrom": Name.CARROM,
  "Chess": Name.CHESS,
  "Cricket": Name.CRICKET,
  "Disco": Name.DISCO,
  "Folk": Name.FOLK,
  "Football": Name.FOOTBALL,
  "Hip hop": Name.HIP_HOP,
  "Hockey": Name.HOCKEY,
  "Jazz": Name.JAZZ,
  "Tennis": Name.TENNIS
});

enum DisplayName {
  KRUPA_JETHVA,
  STEPHEN_WALKERRRR,
  ANKIT_MEHTA,
  JACK_MAC,
  EMPTY,
  HIREN_RATHOD,
  VEER_MEHTA,
  DI_USER113144,
  DI_USER218375
}

final displayNameValues = EnumValues({
  "Ankit Mehta": DisplayName.ANKIT_MEHTA,
  "DI-User113144": DisplayName.DI_USER113144,
  "DI-User218375": DisplayName.DI_USER218375,
  " ": DisplayName.EMPTY,
  "Hiren Rathod": DisplayName.HIREN_RATHOD,
  "Jack Mac": DisplayName.JACK_MAC,
  "krupa jethva": DisplayName.KRUPA_JETHVA,
  "Stephen Walkerrrr": DisplayName.STEPHEN_WALKERRRR,
  "Veer mehta": DisplayName.VEER_MEHTA
});

enum Time {
  TOMORROW,
  THE_2_DAYS_AGO,
  THE_4_DAYS_AGO,
  THE_5_DAYS_AGO,
  THE_6_DAYS_AGO,
  THE_7_DAYS_AGO,
  A_WEEK_AGO,
  THE_2_WEEKS_AGO,
  THE_4_WEEKS_AGO,
  A_MONTH_AGO,
  THE_13_HOURS_AGO,
  THE_3_WEEKS_AGO
}

final timeValues = EnumValues({
  "a month ago": Time.A_MONTH_AGO,
  "a week ago": Time.A_WEEK_AGO,
  "13 hours ago": Time.THE_13_HOURS_AGO,
  "2 days ago": Time.THE_2_DAYS_AGO,
  "2 weeks ago": Time.THE_2_WEEKS_AGO,
  "3 weeks ago": Time.THE_3_WEEKS_AGO,
  "4 days ago": Time.THE_4_DAYS_AGO,
  "4 weeks ago": Time.THE_4_WEEKS_AGO,
  "5 days ago": Time.THE_5_DAYS_AGO,
  "6 days ago": Time.THE_6_DAYS_AGO,
  "7 days ago": Time.THE_7_DAYS_AGO,
  "Tomorrow": Time.TOMORROW
});

enum ExpireTitle { EXPIRING, EXPIRED }

final expireTitleValues = EnumValues(
    {"Expired:": ExpireTitle.EXPIRED, "Expiring:": ExpireTitle.EXPIRING});

enum FileExtention { EMPTY, JPG }

final fileExtentionValues =
    EnumValues({"": FileExtention.EMPTY, "jpg": FileExtention.JPG});

enum RandomName { DI_USER113144, DI_USER218375, DI_USER156216 }

final randomNameValues = EnumValues({
  "DI-User113144": RandomName.DI_USER113144,
  "DI-User156216": RandomName.DI_USER156216,
  "DI-User218375": RandomName.DI_USER218375
});

enum UserName { KRUPA123, STHEPHENWALKER, ANKIT, JACKMAC, HIREN, JAYSHAH }

final userNameValues = EnumValues({
  "Ankit": UserName.ANKIT,
  "Hiren": UserName.HIREN,
  "Jackmac": UserName.JACKMAC,
  "jayshah": UserName.JAYSHAH,
  "krupa123": UserName.KRUPA123,
  "sthephenwalker": UserName.STHEPHENWALKER
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
