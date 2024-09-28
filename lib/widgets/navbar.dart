import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../provider/change_active_index_provider.dart';
import '../provider/theme_provider.dart';
import '../provider/toggle_settings_provider.dart';
import 'custom_theme.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final activeIndexProvider = Provider.of<ActiveIndexProvider>(context);
    final activeIndex = activeIndexProvider.activeIndex;
    final toggleSettingsProvider =
        Provider.of<ToggleSettingsProvider>(context, listen: false);

    // print('navbar building...');
    return BottomAppBar(
      height: 64,
      color: theme.background1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavbarItem(
            Iconsax.home_2,
            0,
            activeIndex,
            activeIndexProvider,
            toggleSettingsProvider,
            context,
            theme,
          ),
          _buildNavbarItem(
            Iconsax.message,
            1,
            activeIndex,
            activeIndexProvider,
            toggleSettingsProvider,
            context,
            theme,
          ),
          _buildNavbarItem(
            Iconsax.book_saved,
            2,
            activeIndex,
            activeIndexProvider,
            toggleSettingsProvider,
            context,
            theme,
          ),
          _buildNavbarItem(
            Iconsax.video_play,
            3,
            activeIndex,
            activeIndexProvider,
            toggleSettingsProvider,
            context,
            theme,
          ),
          _buildNavbarItem(
            Iconsax.brifecase_cross,
            4,
            activeIndex,
            activeIndexProvider,
            toggleSettingsProvider,
            context,
            theme,
          ),
          _buildNavbarItem(
            Iconsax.cpu,
            5,
            activeIndex,
            activeIndexProvider,
            toggleSettingsProvider,
            context,
            theme,
          ),
        ],
      ),
    );
  }

  Widget _buildNavbarItem(
    IconData icon,
    int itemIndex,
    int selectedIndex,
    ActiveIndexProvider changeActiveIndexProvider,
    ToggleSettingsProvider toggleSettingsProvider,
    BuildContext context,
    MyTheme theme,
  ) {
    return GestureDetector(
      onTap: () => {
        if (selectedIndex != itemIndex)
          {
            changeActiveIndexProvider.changeActiveIndex(itemIndex),
            _navigateToPage(itemIndex, context),
          }
      },
      onLongPress: () => toggleSettingsProvider.toggleSettings(),
      child: SizedBox(
        height: 64,
        child: Icon(
          icon,
          size: 28,
          color:
              selectedIndex == itemIndex ? theme.activeTabColor : theme.text1,
        ),
      ),
    );
  }

  void _navigateToPage(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/community');
        break;
      case 2:
        Navigator.pushNamed(context, '/education');
        break;
      case 3:
        Navigator.pushNamed(context, '/entertainment');
        break;
      case 4:
        Navigator.pushNamed(context, '/jobs');
        break;
      case 5:
        Navigator.pushNamed(context, '/ai');
        break;
      default:
        break;
    }
  }
}
