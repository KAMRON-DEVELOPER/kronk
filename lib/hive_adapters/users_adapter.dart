import 'package:hive/hive.dart';
import '../models/users.dart';

class UsersAdapter extends TypeAdapter<Users> {
  @override
  final int typeId = 0;

  @override
  Users read(BinaryReader reader) {
    final String? username = reader.read();
    final String? email = reader.read();
    final String? phoneNumber = reader.read();

    return Users(username: username, email: email, phoneNumber: phoneNumber);
  }

  @override
  void write(BinaryWriter writer, Users obj) {
    writer.write(obj.username);
    writer.write(obj.email);
    writer.write(obj.phoneNumber);
  }
}
