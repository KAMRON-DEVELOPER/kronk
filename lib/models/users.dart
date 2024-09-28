import 'package:hive/hive.dart';

class Users extends HiveObject {
  @HiveField(0)
  String? username;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? phoneNumber;

  Users({required this.username, this.email, this.phoneNumber});

  factory Users.toUsers(Map<String, dynamic> json) {
    return Users(
        username: json["username"],
        email: json["email"],
        phoneNumber: json["phone_number"],
    );
  }
}
