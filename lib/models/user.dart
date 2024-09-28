import 'package:hive/hive.dart';

class Profile extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? username;
  @HiveField(2)
  String? firstName;
  @HiveField(3)
  String? lastName;
  @HiveField(4)
  String? email;
  @HiveField(5)
  String? phoneNumber;
  @HiveField(6)
  String? password;
  @HiveField(7)
  String? fullName;
  @HiveField(8)
  int? daysSinceJoined;
  @HiveField(9)
  String? avatar;
  @HiveField(10)
  String? banner;
  @HiveField(11)
  String? dateOfBirth;
  @HiveField(12)
  String? gender;
  @HiveField(13)
  String? location;
  @HiveField(14)
  String? bio;
  @HiveField(15)
  String? code;
  @HiveField(16)
  String? emailOrPhone;
  @HiveField(17)
  String? accessToken;
  @HiveField(18)
  String? refreshToken;
  @HiveField(19)
  String? bannerColor;
  @HiveField(20)
  int? followers;
  @HiveField(21)
  int? followings;
  @HiveField(22)
  String? telegramUsername;
  @HiveField(23)
  String? instagramUsername;
  @HiveField(24)
  String? twitterUsername;
  @HiveField(25)
  String? youTubeChannel;
  @HiveField(26)
  String? gitHubUsername;
  @HiveField(27)
  String? professionName;
  @HiveField(28)
  String? education;

  Profile({
    this.id,
    this.username,
    this.fullName,
    this.daysSinceJoined,
    this.avatar,
    this.banner,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.location,
    this.bio,
    this.password,
    this.code,
    this.emailOrPhone,
    this.accessToken,
    this.refreshToken,
    this.bannerColor,
    this.followers,
    this.followings,
    this.telegramUsername,
    this.instagramUsername,
    this.twitterUsername,
    this.youTubeChannel,
    this.gitHubUsername,
    this.professionName,
    this.education,
  });

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "avatar": avatar,
      "banner": banner,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone_number": phoneNumber,
      "date_of_birth": dateOfBirth,
      "gender": gender,
      "province": location,
      "bio": bio,
      "password": password,
      "telegram_username": telegramUsername,
      "instagram_username": instagramUsername,
      "twitter_username": twitterUsername,
      "youtube_channel": youTubeChannel,
      "github_username": gitHubUsername,
    };
  }

  Map<String, dynamic> toJsonForRegister() {
    return {
      'username': username,
      'email_or_phone': emailOrPhone,
      'password': password,
    };
  }

  Map<String, dynamic> toJsonForVerify() {
    return {'code': code};
  }

  Map<String, dynamic> toJsonForLogin() {
    return {'username': username, 'password': password};
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      fullName: json['full_name'],
      daysSinceJoined: json['days_since_joined'],
      avatar: json['avatar'],
      banner: json['banner'],
      bannerColor: json['banner_color'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      location: json['location'],
      bio: json['bio'],
      accessToken: json['access'],
      refreshToken: json['refresh'],
      followers: json['followers'],
      followings: json['followings'],
      telegramUsername: json['telegram_username'],
      instagramUsername: json['instagram_username'],
      twitterUsername: json['twitter_username'],
      youTubeChannel: json['youtube_channel'],
      gitHubUsername: json['github_username'],
      professionName: json['profession_name'],
      education: json['education'],
    );
  }

  factory Profile.fromJsonToToken(Map<String, dynamic> json) {
    return Profile(
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
    };
  }

  forUpdate(Profile? updateData) {
    return Profile(
      username: updateData?.username ?? username,
      fullName: updateData?.fullName ?? fullName,
      daysSinceJoined: daysSinceJoined,
      avatar: updateData?.avatar ?? avatar,
      banner: updateData?.banner ?? banner,
      firstName: updateData?.firstName ?? firstName,
      lastName: updateData?.lastName ?? lastName,
      email: updateData?.email ?? email,
      phoneNumber: updateData?.phoneNumber ?? phoneNumber,
      dateOfBirth: updateData?.dateOfBirth ?? dateOfBirth,
      gender: updateData?.gender ?? gender,
      location: updateData?.location ?? location,
      bio: updateData?.bio ?? bio,
    );
  }
}
