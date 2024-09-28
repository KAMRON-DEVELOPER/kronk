import 'package:kronk/utils/validators.dart';
import '../models/users.dart';
import '../provider/data_repository.dart';

DataRepository dataRepository = DataRepository();

Future<String?> registerUsernameValidator(String value) async {
  List<Users?> users = await dataRepository.getUsers();
  List<String?> usernames = users.map((userObj) => userObj?.username).toList();
  return usernames.contains(value)
      ? 'Oops, the username is already in use'
      : value.isValidName;
}

Future<String?> loginUsernameValidator(String value) async {
  List<Users?> users = await dataRepository.getUsers();
  List<String?> usernames = users.map((userObj) => userObj?.username).toList();
  // print("VALUE * $value, VALUE>LENGTH * ${value.length}");
  // print("VALUE * $value, VALUE>LENGTH * ${value.length}");
  return usernames.contains(value) ? value.isValidName : 'Username not found';
}

String? realtimePasswordValidator(String value) {
  return value.isValidPassword;
}

Future<String?> realtimeEmailOrPhoneValidator(String value) async {
  List<Users?> users = await dataRepository.getUsers();
  List<String?> phoneNumbers =
      users.map((userObj) => userObj?.phoneNumber).toList();
  List<String?> emails = users.map((userObj) => userObj?.email).toList();
  if (value.startsWith('+') && phoneNumbers.contains(value)) {
    return "Oops, this phone number is already in use";
  } else if (value.startsWith(RegExp(r'^[a-zA-Z0-9]')) &&
      emails.contains(value)) {
    return "Oops, this email is already in use";
  }
  return value.isValidEmailOrPhone;
}

String? realtimeCodeValidator(String value) {
  return value.isValidCode;
}
