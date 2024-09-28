import 'package:flutter/material.dart';
import 'package:kronk/provider/data_repository.dart';
import 'package:kronk/provider/language_provider.dart';
import 'package:kronk/provider/network_provider.dart';
import 'package:kronk/provider/theme_provider.dart';
import 'package:kronk/utils/routes.dart';
import 'package:kronk/utils/setup_app.dart';
import 'package:provider/provider.dart';

void main() async {
  await setupApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataRepository().getIsAuthenticated(),
      builder: (context, snapshot) {

        print("⌛️ snapshot.connectionState: ${snapshot.connectionState}");
        print("⌛️ snapshot.data: ${snapshot.data}");
        print("⌛️ snapshot.hasError: ${snapshot.hasError}");

        bool isAuthenticated = snapshot.data ?? false;
        String initialRoute = isAuthenticated ? "/home" : "/intro";

        print("🥳 isAuthenticated: $isAuthenticated");
        print("🥳 initialRoute: $initialRoute");

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ChangeNotifierProvider(create: (_) => LanguageProvider()),
            ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "kronk",
            initialRoute: initialRoute,
            onGenerateRoute: (settings) => routes(settings, context),
          ),
        );
      },
    );
  }
}

/*

📝
🔗
🔑
📡
💾
💎
⌛️
⏰
🎄
⚔️
🛡️
🥳
🥶
🍺
💡
🌋
👑
🚨
🔥
🌈
🎁
🎯
🎉
✨
🔎
🗑️
📐
☢️
☣️
⚠️
✅
❌
🇺🇲
🇺🇿
💥
🍏
🍿
🌐
🚦
🚥
🚧
🛰️
🚀
❄️
🎈

*/