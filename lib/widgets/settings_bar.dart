import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../provider/language_provider.dart';
import '../provider/theme_provider.dart';

class SettingsBar extends StatelessWidget {
  final String currentTheme =
      Hive.box('settingsBox').get('theme', defaultValue: 'dark');
  // final String currentLanguage =
  //     Hive.box('settingsBox').get('language', defaultValue: "english");
  SettingsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final language = Provider.of<LanguageProvider>(context).currentLanguage;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    const double itemWidth = 64;
    final List<Map<String, dynamic>> themes = [
      {"color": Colors.white, "name": 'white'},
      {"color": Colors.blueGrey, "name": 'blue'},
      {"color": Colors.green, "name": 'green'},
      {"color": Colors.yellow, "name": 'yellow'},
    ];
    final List<Map<String, dynamic>> languages = [
      {"icon": "assets/icons/uz-circular.svg", "name": "o'zbekcha"},
      {"icon": "assets/icons/en-circular.svg", "name": 'english'},
      {"icon": "assets/icons/ru-circular.svg", "name": 'russian'},
      {"icon": "assets/icons/tr-circular.svg", "name": 'turkish'},
    ];

    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.background1,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //! Theme
              Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.background2,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Text(
                      'Themes',
                      style: TextStyle(
                          fontSize: 20.0, color: theme.activeTabColor),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 84,
                      child: LayoutBuilder(builder: (context, constraints) {
                        final separatorWidth = (constraints.maxWidth -
                                (itemWidth * themes.length)) /
                            (themes.length - 1);
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: themes.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: separatorWidth),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => themeProvider
                                      .changeTheme(themes[index]['name']),
                                  child: Container(
                                    width: itemWidth,
                                    height: itemWidth,
                                    decoration: BoxDecoration(
                                      color: themes[index]['color'],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: currentTheme ==
                                                themes[index]['name']
                                            ? Colors.blueAccent
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  themes[index]['name'],
                                  style: TextStyle(
                                    color: currentTheme == themes[index]['name']
                                        ? theme.activeTabColor
                                        : theme.text1,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              //! Languages
              Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: theme.background2,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Text(
                      'Languages',
                      style: TextStyle(
                          fontSize: 20.0, color: theme.activeTabColor),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 84,
                      child: LayoutBuilder(builder: (context, constraints) {
                        final separatorWidth = (constraints.maxWidth -
                                (itemWidth * themes.length)) /
                            (themes.length - 1);
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: themes.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: separatorWidth),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () => languageProvider
                                      .switchLanguage(languages[index]['name']),
                                  child: Container(
                                    width: itemWidth,
                                    height: itemWidth,
                                    decoration: BoxDecoration(
                                      // color: languages[index]['icon'],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            language == languages[index]['name']
                                                ? Colors.blueAccent
                                                : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: SvgPicture.asset(
                                      languages[index]['icon'],
                                      height: itemWidth,
                                      width: itemWidth,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Text(
                                  languages[index]['name'],
                                  style: TextStyle(
                                    color: language == languages[index]['name']
                                        ? theme.activeTabColor
                                        : theme.text1,
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: theme.activeTabColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/home/login',
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: theme.activeTabColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/home/register',
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
