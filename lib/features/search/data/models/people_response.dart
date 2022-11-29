// To parse this JSON data, do
//
//     final peopleResponse = peopleResponseFromJson(jsonString);

import 'dart:convert';

PeopleResponse peopleResponseFromJson(String str) =>
    PeopleResponse.fromJson(json.decode(str));

String peopleResponseToJson(PeopleResponse data) => json.encode(data.toJson());

class PeopleResponse {
  PeopleResponse({
    this.valid,
    this.code,
    this.message,
    this.data,
  });

  bool? valid;
  int? code;
  String? message;
  List<PeopleModel>? data;

  factory PeopleResponse.fromJson(Map<String, dynamic> json) => PeopleResponse(
        valid: json["valid"] == null ? null : json["valid"],
        code: json["code"] == null ? null : json["code"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<PeopleModel>.from(
                json["data"].map((x) => PeopleModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "valid": valid == null ? null : valid,
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class PeopleModel {
  PeopleModel({
    this.id,
    this.about,
    this.followers,
    this.posts,
    this.avatar,
    this.lastActive,
    this.username,
    this.fname,
    this.lname,
    this.email,
    this.verified,
    this.name,
    this.url,
    this.isUser,
    this.isFollowing,
  });

  int? id;
  String? about;
  int? followers;
  int? posts;
  String? avatar;
  String? lastActive;
  String? username;
  String? fname;
  String? lname;
  String? email;
  String? verified;
  String? name;
  String? url;
  bool? isUser;
  bool? isFollowing;

  factory PeopleModel.fromJson(Map<String, dynamic> json) => PeopleModel(
        id: json["id"] == null ? null : json["id"],
        about: json["about"] == null ? null : json["about"],
        followers: json["followers"] == null ? null : json["followers"],
        posts: json["posts"] == null ? null : json["posts"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        lastActive: json["last_active"] == null ? null : json["last_active"],
        username: json["username"] == null ? null : json["username"],
        fname: json["fname"] == null ? null : json["fname"],
        lname: json["lname"] == null ? null : json["lname"],
        email: json["email"] == null ? null : json["email"],
        verified: json["verified"] == null ? null : json["verified"],
        name: json["name"] == null ? null : json["name"],
        url: json["url"] == null ? null : json["url"],
        isUser: json["is_user"] == null ? null : json["is_user"],
        isFollowing: json["is_following"] == null ? null : json["is_following"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "about": about == null ? null : about,
        "followers": followers == null ? null : followers,
        "posts": posts == null ? null : posts,
        "avatar": avatar == null ? null : avatar,
        "last_active": lastActive == null ? null : lastActive,
        "username": username == null ? null : username,
        "fname": fname == null ? null : fname,
        "lname": lname == null ? null : lname,
        "email": email == null ? null : email,
        "verified": verified == null ? null : verified,
        "name": name == null ? null : name,
        "url": url == null ? null : url,
        "is_user": isUser == null ? null : isUser,
        "is_following": isFollowing == null ? null : isFollowing,
      };
}
