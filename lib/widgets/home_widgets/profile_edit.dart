import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kronk/utils/validators.dart';
import 'package:provider/provider.dart';
import '../../bloc/profile/profile_state.dart';
import '../../provider/profile_mode_provider.dart';
import '../../provider/theme_provider.dart';
import '../half_circle.dart';

SingleChildScrollView buildProfileEdit(ProfileStateSuccess state, BuildContext context) {
  final theme = Provider.of<ThemeProvider>(context).currentTheme;
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  String url = "http://192.168.31.42:8000";
  final double cardWidth = screenWidth * 0.92;
  final double margin = screenWidth / 35;
  final double bannerHeight = screenHeight / 7;
  final double avatarSize = screenWidth / 3.5;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  String? usernameError;
  String? emailError;
  String? phoneNumberError;

  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    scrollDirection: Axis.vertical,
    child: Column(
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
              // Todo Main Content
              Padding(
                padding:
                    EdgeInsets.only(left: margin, right: margin, bottom: margin),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: bannerHeight + avatarSize / 2 + 16),
                    TextFormField(
                      controller: usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "username",
                        errorText: usernameError,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintStyle: const TextStyle(color: Colors.white),
                        counterStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "email",
                        errorText: emailError,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintStyle: const TextStyle(color: Colors.white),
                        counterStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextFormField(
                      controller: phoneNumberController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "phone number",
                        errorText: phoneNumberError,
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintStyle: const TextStyle(color: Colors.white),
                        counterStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextFormField(
                      controller: genderController,
                      style: const TextStyle(color: Colors.white),
                      cursorHeight: 2,
                      decoration: InputDecoration(
                        labelText: "gender",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintStyle: const TextStyle(color: Colors.white),
                        counterStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    TextFormField(
                      controller: bioController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "bio",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hintStyle: const TextStyle(color: Colors.white),
                        counterStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<ProfileModeProvider>().changeModel();
                          },
                          child: const Text("Done"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
