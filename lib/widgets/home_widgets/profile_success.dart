import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kronk/utils/validators.dart';
import 'package:provider/provider.dart';
import '../../bloc/profile/profile_state.dart';
import '../../provider/profile_mode_provider.dart';
import '../../provider/theme_provider.dart';
import '../../utils/url_launches.dart';
import '../half_circle.dart';

Column buildProfileSuccess(ProfileStateSuccess state, BuildContext context) {
  final theme = Provider.of<ThemeProvider>(context).currentTheme;
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  String url = "http://192.168.31.42:8000";
  final double cardWidth = screenWidth * 0.92;
  final double margin = screenWidth / 35;
  final double bannerHeight = screenHeight / 7;
  final double avatarSize = screenWidth / 3.5;
  const Color followFontColor = Colors.white;
  const double followFontSize = 16;
  const FontWeight followFontWeight = FontWeight.w600;
  final double socialIconSize = screenWidth / 12;
  final double iconSpacing = screenWidth / 60;
  final List<Map<String, dynamic>> socialLinks = [
    {
      'condition': (state.profileData?.telegramUsername ?? '').isNotEmpty,
      "icon": "assets/icons/social_telegram_light.svg",
      "onTap": () => launchApp(
            username: state.profileData?.telegramUsername,
            isTelegram: true,
          ),
    },
    {
      "condition": (state.profileData?.twitterUsername ?? '').isNotEmpty,
      "icon": "assets/icons/social_twitter_light.svg",
      "onTap": () => launchApp(
            username: state.profileData?.twitterUsername,
            isTwitter: true,
          ),
    },
    {
      "condition": (state.profileData?.instagramUsername ?? '').isNotEmpty,
      "icon": "assets/icons/social_instagram_light.svg",
      "onTap": () => launchApp(
            username: state.profileData?.instagramUsername,
            isInstagram: true,
          ),
    },
    {
      "condition": (state.profileData?.youTubeChannel ?? '').isNotEmpty,
      "icon": "assets/icons/social_youtube_light.svg",
      "onTap": () => launchApp(
            username: state.profileData?.youTubeChannel,
            isYouTube: true,
          ),
    },
    {
      "condition": (state.profileData?.gitHubUsername ?? '').isNotEmpty,
      "icon": "assets/icons/social_github_light.svg",
      "onTap": () => launchApp(
            username: state.profileData?.gitHubUsername,
            isGitHub: true,
          ),
    },
    {
      "condition": (state.profileData?.email ?? '').isNotEmpty,
      "icon": "assets/icons/social_gmail_light.svg",
      "onTap": () => launchApp(
            email: state.profileData?.email,
            isEmail: true,
          ),
    },
  ];
  const String editProfileIconPath = "assets/ui-icons/edit-profile.svg";
  print("banner path: ${state.profileData?.banner}");

  return Column(
    children: [
      Container(
        margin: EdgeInsets.only(top: margin),
        width: cardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Todo Banner
            Positioned(
              height: bannerHeight,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: CachedNetworkImage(
                  memCacheWidth: cardWidth.cacheSize(context),
                  memCacheHeight: bannerHeight.cacheSize(context),
                  fit: BoxFit.cover,
                  imageUrl: "$url${state.profileData?.banner}",
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Icon(Icons.error),
                  ),
                ),
              ),
            ),
            // Todo social links and edit button
            Positioned(
              top: margin / 2,
              left: margin / 2,
              right: margin / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: socialLinks
                        .where((link) => link['condition'])
                        .expand((link) => [
                              GestureDetector(
                                onTap: link['onTap'],
                                child: SvgPicture.asset(
                                  link['icon'],
                                  width: socialIconSize,
                                  height: socialIconSize,
                                ),
                              ),
                              SizedBox(width: iconSpacing),
                            ])
                        .toList()
                      ..removeLast(),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<ProfileModeProvider>().changeModel();
                    },
                    child: SizedBox(
                      width: socialIconSize,
                      height: socialIconSize,
                      child: SvgPicture.asset(
                        editProfileIconPath,
                        width: socialIconSize,
                        height: socialIconSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Todo Gradient Background
            Positioned.fill(
              top: bannerHeight,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  gradient: LinearGradient(
                    stops: const [0, 0.33, 0.66, 1],
                    colors: [
                      state.profileData?.bannerColor?.fromHex() ??
                          theme.background1,
                      theme.background1,
                      theme.background1,
                      theme.background1,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Todo Avatar
            Positioned(
              top: bannerHeight - avatarSize / 2,
              left: margin,
              child: CustomPaint(
                painter: AvatarPainter(
                  borderColor: state.profileData?.bannerColor!.fromHex() ??
                      theme.background1,
                  borderWidth: 10,
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      "http://192.168.31.42:8000${state.profileData?.avatar}",
                  fit: BoxFit.cover,
                  width: avatarSize,
                  height: avatarSize,
                  memCacheHeight: avatarSize.cacheSize(context),
                  memCacheWidth: avatarSize.cacheSize(context),
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: ResizeImage(
                            imageProvider,
                            width: (screenWidth * 0.75).toInt(),
                            height: (screenWidth * 0.75).toInt(),
                            allowUpscaling: true,
                          ),
                          fit: BoxFit.cover,
                          isAntiAlias: true,
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) {
                    return const Icon(
                      Icons.error,
                      size: 120,
                    );
                  },
                ),
              ),
            ),
            // Todo Follow
            Positioned(
              top: bannerHeight,
              left: 2 * margin + avatarSize,
              right: margin,
              height: avatarSize / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${state.profileData?.followers}k",
                        style: GoogleFonts.roboto(
                          color: followFontColor,
                          fontSize: followFontSize,
                          fontWeight: followFontWeight,
                          height: 0,
                        ),
                      ),
                      Text(
                        "followers",
                        style: GoogleFonts.roboto(
                          color: followFontColor,
                          fontSize: followFontSize,
                          fontWeight: followFontWeight,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${state.profileData?.followings}k",
                        style: GoogleFonts.roboto(
                          color: followFontColor,
                          fontSize: followFontSize,
                          fontWeight: followFontWeight,
                          height: 0,
                        ),
                      ),
                      Text(
                        "followings",
                        style: GoogleFonts.roboto(
                          color: followFontColor,
                          fontSize: followFontSize,
                          fontWeight: followFontWeight,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Todo Main Content
            Padding(
              padding:
                  EdgeInsets.only(left: margin, right: margin, bottom: margin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: bannerHeight + avatarSize / 2 + 16),
                  Text(
                    "${state.profileData?.fullName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      height: 0,
                    ),
                  ),
                  Text(
                    "@${state.profileData?.username}",
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                      height: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${state.profileData?.bio}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
