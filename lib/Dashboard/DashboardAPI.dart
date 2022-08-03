// To parse this JSON data, do
//
//     final dashboardApi = dashboardApiFromJson(jsonString);

import 'dart:convert';

DashboardApi dashboardApiFromJson(String str) =>
    DashboardApi.fromJson(json.decode(str));

String dashboardApiToJson(DashboardApi data) => json.encode(data.toJson());

class DashboardApi {
  DashboardApi({
    required this.openQuestions,
    required this.completedQuestions,
    required this.draftQuestions,
  });

  List<Question> openQuestions;
  List<Question> completedQuestions;
  List<DraftQuestion> draftQuestions;

  factory DashboardApi.fromJson(Map<String, dynamic> json) => DashboardApi(
        openQuestions: List<Question>.from(
            json["open_questions"].map((x) => Question.fromJson(x))),
        completedQuestions: List<Question>.from(
            json["completed_questions"].map((x) => Question.fromJson(x))),
        draftQuestions: List<DraftQuestion>.from(
            json["draft_questions"].map((x) => DraftQuestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "open_questions":
            List<dynamic>.from(openQuestions.map((x) => x.toJson())),
        "completed_questions":
            List<dynamic>.from(completedQuestions.map((x) => x.toJson())),
        "draft_questions":
            List<dynamic>.from(draftQuestions.map((x) => x.toJson())),
      };
}

class Question {
  Question({
    required this.id,
    required this.userId,
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
    required this.user,
    required this.userName,
    required this.profileImageUrl,
    required this.comments,
    required this.likes,
    required this.community,
    required this.isActive,
    required this.expiredOn,
    required this.expireTime,
    required this.expireTitle,
    required this.postedTime,
    this.isAbused,
    this.isLike,
    required this.displayName,
  });

  String id;
  String userId;
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
  User? user;
  String userName;
  String? profileImageUrl;
  int comments;
  int likes;
  List<Community> community;
  int isActive;
  DateTime expiredOn;
  String expireTime;
  String expireTitle;
  String postedTime;
  dynamic isAbused;
  dynamic isLike;
  String displayName;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        userId: json["user_id"],
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
        user: userValues.map[json["user"]],
        userName: json["user_name"],
        profileImageUrl: json["profile_image_url"],
        comments: json["comments"],
        likes: json["likes"],
        community: List<Community>.from(
            json["community"].map((x) => Community.fromJson(x))),
        isActive: json["is_active"],
        expiredOn: DateTime.parse(json["ExpiredOn"]),
        expireTime: json["Expire_time"],
        expireTitle: json["expire_title"],
        postedTime: json["posted_time"],
        isAbused: json["is_abused"],
        isLike: json["is_like"],
        displayName: json["display_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
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
        "user": userValues.reverse[user],
        "user_name": userName,
        "profile_image_url": profileImageUrl,
        "comments": comments,
        "likes": likes,
        "community": List<dynamic>.from(community.map((x) => x.toJson())),
        "is_active": isActive,
        "ExpiredOn": expiredOn.toIso8601String(),
        "Expire_time": timeValues.reverse[expireTime],
        "expire_title": expireTitleValues.reverse[expireTitle],
        "posted_time": postedTimeValues.reverse[postedTime],
        "is_abused": isAbused,
        "is_like": isLike,
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

enum DisplayName { ANKIT_MEHTA, DI_USER218375 }

final displayNameValues = EnumValues({
  "Ankit Mehta": DisplayName.ANKIT_MEHTA,
  "DI-User218375": DisplayName.DI_USER218375
});

enum Time {
  THE_16_HOURS_AGO,
  THE_17_HOURS_AGO,
  THE_2_DAYS_AGO,
  THE_3_DAYS_AGO,
  THE_3_WEEKS_AGO,
  THE_4_WEEKS_AGO,
  A_MONTH_AGO,
  THE_2_MONTHS_AGO,
  IN_2_DAYS
}

final timeValues = EnumValues({
  "a month ago": Time.A_MONTH_AGO,
  " in 2 days": Time.IN_2_DAYS,
  "16 hours ago": Time.THE_16_HOURS_AGO,
  "17 hours ago": Time.THE_17_HOURS_AGO,
  "2 days ago": Time.THE_2_DAYS_AGO,
  "2 months ago": Time.THE_2_MONTHS_AGO,
  "3 days ago": Time.THE_3_DAYS_AGO,
  "3 weeks ago": Time.THE_3_WEEKS_AGO,
  "4 weeks ago": Time.THE_4_WEEKS_AGO
});

enum ExpireTitle { EXPIRED, EXPIRING }

final expireTitleValues = EnumValues(
    {"Expired:": ExpireTitle.EXPIRED, "Expiring:": ExpireTitle.EXPIRING});

enum PostedTime {
  THE_3_DAYS_AGO,
  THE_4_DAYS_AGO,
  THE_5_DAYS_AGO,
  THE_4_WEEKS_AGO,
  A_MONTH_AGO,
  THE_2_MONTHS_AGO,
  JUST_NOW
}

final postedTimeValues = EnumValues({
  "a month ago": PostedTime.A_MONTH_AGO,
  "Just Now": PostedTime.JUST_NOW,
  "2 months ago": PostedTime.THE_2_MONTHS_AGO,
  "3 days ago": PostedTime.THE_3_DAYS_AGO,
  "4 days ago": PostedTime.THE_4_DAYS_AGO,
  "4 weeks ago": PostedTime.THE_4_WEEKS_AGO,
  "5 days ago": PostedTime.THE_5_DAYS_AGO
});

enum User { ANKIT_MEHTA, STEPHEN_WALKERRRR }

final userValues = EnumValues({
  "Ankit Mehta": User.ANKIT_MEHTA,
  "Stephen Walkerrrr": User.STEPHEN_WALKERRRR
});

enum UserName { ANKIT, STHEPHENWALKER }

final userNameValues = EnumValues(
    {"Ankit": UserName.ANKIT, "sthephenwalker": UserName.STHEPHENWALKER});

class DraftQuestion {
  DraftQuestion({
    required this.id,
    required this.questionText,
    this.imageVideoUrl,
    required this.inviteeCanInviteOthers,
    required this.fileExtention,
    required this.views,
    required this.weightageAverage,
    required this.createdBy,
    required this.createdAt,
    required this.user,
    this.userName,
    required this.profileImageUrl,
    required this.comments,
    required this.community,
    required this.expiredOn,
    this.expireTime,
    this.expireTitle,
    required this.postedTime,
  });

  String id;
  String questionText;
  dynamic imageVideoUrl;
  String inviteeCanInviteOthers;
  String fileExtention;
  int views;
  int weightageAverage;
  String createdBy;
  DateTime createdAt;
  User? user;
  UserName? userName;
  String profileImageUrl;
  int comments;
  List<Community> community;
  DateTime expiredOn;
  Time? expireTime;
  ExpireTitle? expireTitle;
  String postedTime;

  factory DraftQuestion.fromJson(Map<String, dynamic> json) => DraftQuestion(
        id: json["id"],
        questionText: json["question_text"],
        imageVideoUrl: json["image_video_url"],
        inviteeCanInviteOthers: json["invitee_can_invite_others"],
        fileExtention: json["file_extention"],
        views: json["views"],
        weightageAverage: json["weightage_average"],
        createdBy: json["created_by"],
        createdAt: DateTime.parse(json["created_at"]),
        user: userValues.map[json["user"]],
        userName: userNameValues.map[json["user_name"]],
        profileImageUrl: json["profile_image_url"],
        comments: json["comments"],
        community: List<Community>.from(
            json["community"].map((x) => Community.fromJson(x))),
        expiredOn: DateTime.parse(json["ExpiredOn"]),
        expireTime: timeValues.map[json["Expire_time"]],
        expireTitle: expireTitleValues.map[json["expire_title"]],
        postedTime: json["posted_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "question_text": questionText,
        "image_video_url": imageVideoUrl,
        "invitee_can_invite_others": inviteeCanInviteOthers,
        "file_extention": fileExtention,
        "views": views,
        "weightage_average": weightageAverage,
        "created_by": createdBy,
        "created_at": createdAt.toIso8601String(),
        "user": userValues.reverse[user],
        "user_name": userNameValues.reverse[userName],
        "profile_image_url": profileImageUrl,
        "comments": comments,
        "community": List<dynamic>.from(community.map((x) => x)),
        "ExpiredOn": expiredOn.toIso8601String(),
        "Expire_time": timeValues.reverse[expireTime],
        "expire_title": expireTitleValues.reverse[expireTitle],
        "posted_time": timeValues.reverse[postedTime],
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
