import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../firebase_options.dart';
import '../hive_adapters/note_adapter.dart';
import '../hive_adapters/profile_adapter.dart';
import '../hive_adapters/tab_adapter.dart';
import '../hive_adapters/users_adapter.dart';
import '../models/note.dart';
import '../models/tab.dart';
import '../models/user.dart';
import '../models/users.dart';

Future<void> setupApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: prepare directory for hive
  final appMemory = await getApplicationDocumentsDirectory();
  Hive.init(appMemory.path);

  // TODO: register adapters for hive
  Hive.registerAdapter(UsersAdapter());
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TabAdapter());

  // TODO: open boxes for store data
  await Hive.openBox<Users>("usersBox");
  await Hive.openBox<Profile>("profileBox");
  await Hive.openBox<Note>("NotesBox");
  await Hive.openBox<MyTab>("tabsBox");
  await Hive.openBox("settingsBox");

  // TODO: Enable debugInvertOversizeImages in debug mode only
  assert(() {
    debugInvertOversizedImages = true;
    return true;
  }());

  // TODO: initialize firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
