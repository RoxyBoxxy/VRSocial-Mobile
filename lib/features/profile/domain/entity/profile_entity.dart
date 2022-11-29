import 'package:auto_route/auto_route.dart';

import 'package:colibri/features/authentication/data/models/login_response.dart';
import 'package:colibri/features/profile/data/models/response/profile_response.dart';
import 'package:flutter/foundation.dart';

class ProfileEntity {
  final String id;
  final String profileUrl;
  final String backgroundUrl;
  final String fullName;
  final String userName;
  final String about;
  final String country;
  final String website;
  final String memberSince;
  final String postCounts;
  final String followingCount;
  final String followerCount;
  final bool isVerified;
  final String email;
  final String gender;
  final String language;
  final String firstName;
  final String lastName;
  final bool isFollowing;
  final String countryFlag;
  const ProfileEntity._({
    @required this.profileUrl,
    @required this.backgroundUrl,
    @required this.fullName,
    @required this.userName,
    @required this.about,
    @required this.country,
    @required this.website,
    @required this.memberSince,
    @required this.postCounts,
    @required this.followingCount,
    @required this.isVerified,
    @required this.followerCount,
    @required this.email,
    @required this.gender,
    @required this.language,
    @required this.firstName,
    @required this.lastName,
    @required this.isFollowing,
    @required this.id,
    @required this.countryFlag,
  });

  factory ProfileEntity.fromProfileResponse(
      {@required ProfileResponse profileResponse,
      @required LoginResponse loginResponse}) {
    var profileData = profileResponse.data;

    return ProfileEntity._(
        profileUrl: profileData.avatar,
        backgroundUrl: profileData.cover,
        fullName: profileData.firstName != null && profileData.lastName != null
            ? "${profileData.firstName} ${profileData.lastName}"
            : "--",
        userName: "@" + profileData.userName,
        about: profileData.aboutYou.isNotEmpty
            ? profileData.aboutYou
            : "About not available",
        country: profileData.country,
        website: profileData.website,
        memberSince: profileData.memberSince,
        postCounts: profileData.postCount.toString(),
        followingCount: profileData.followingCount.toString(),
        isVerified: profileData.isVerified,
        followerCount: profileData.followerCount.toString(),
        email: profileData.email,
        gender:
            profileData.gender.toLowerCase().contains("m") ? "Male" : "Female",
        language: profileData.language,
        firstName: profileData.firstName,
        lastName: profileData.lastName,
        isFollowing: profileData?.user?.isFollowing ?? false,
        countryFlag: profileData.countryFlag,
        id: profileData.id.toString());
  }

  ProfileEntity copyWith(
          {String profileUrl,
          String coverUrl,
          bool isFollowing,
          String backgroundImage,
          String profileImage}) =>
      ProfileEntity._(
          profileUrl: profileImage ?? this.profileUrl,
          backgroundUrl: backgroundImage ?? this.backgroundUrl,
          fullName: fullName,
          userName: userName,
          about: about,
          country: country,
          website: website,
          memberSince: memberSince,
          postCounts: postCounts,
          followingCount: followingCount,
          isVerified: isVerified,
          followerCount: followerCount,
          email: email,
          gender: gender,
          language: language,
          firstName: firstName,
          countryFlag: countryFlag,
          lastName: lastName,
          isFollowing: isFollowing ?? this.isFollowing,
          id: this.id);
}
