import 'package:hive/hive.dart';
import '../models/user.dart';

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 1;

  @override
  Profile read(BinaryReader reader) {
    return Profile(
      id: reader.readString(),
      username: reader.readString(),
      firstName: reader.readString(),
      lastName: reader.readString(),
      email: reader.readString(),
      phoneNumber: reader.readString(),
      fullName: reader.readString(),
      daysSinceJoined: reader.readInt(),
      avatar: reader.readString(),
      banner: reader.readString(),
      dateOfBirth: reader.readString(),
      gender: reader.readString(),
      location: reader.readString(),
      bio: reader.readString(),
      bannerColor: reader.readString(),
      followers: reader.readInt(),
      followings: reader.readInt(),
      telegramUsername: reader.readString(),
      instagramUsername: reader.readString(),
      twitterUsername: reader.readString(),
      youTubeChannel: reader.readString(),
      gitHubUsername: reader.readString(),
      education: reader.readString(),
      professionName: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer.writeString(obj.id ?? '');
    writer.writeString(obj.username ?? '');
    writer.writeString(obj.firstName ?? '');
    writer.writeString(obj.lastName ?? '');
    writer.writeString(obj.email ?? '');
    writer.writeString(obj.phoneNumber ?? '');
    writer.writeString(obj.fullName ?? '');
    writer.writeInt(obj.daysSinceJoined ?? 0);
    writer.writeString(obj.avatar ?? '');
    writer.writeString(obj.banner ?? '');
    writer.writeString(obj.dateOfBirth ?? '');
    writer.writeString(obj.gender ?? '');
    writer.writeString(obj.location ?? '');
    writer.writeString(obj.bio ?? '');
    writer.writeString(obj.bannerColor ?? "");
    writer.writeInt(obj.followers ?? 0);
    writer.writeInt(obj.followings ?? 0);
    writer.writeString(obj.telegramUsername ?? "");
    writer.writeString(obj.instagramUsername ?? "");
    writer.writeString(obj.twitterUsername ?? "");
    writer.writeString(obj.youTubeChannel ?? "");
    writer.writeString(obj.gitHubUsername ?? "");
    writer.writeString(obj.professionName ?? "");
    writer.writeString(obj.education ?? "");
  }
}
