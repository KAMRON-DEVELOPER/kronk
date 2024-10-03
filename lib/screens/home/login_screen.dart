import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kronk/widgets/auth_widgets/auth_fields.dart';
import 'package:kronk/widgets/auth_widgets/auth_icons.dart';
import 'package:provider/provider.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../models/user.dart';
import '../../provider/data_repository.dart';
import '../../provider/toggle_settings_provider.dart';
import '../../services/firebase_service.dart';
import '../../services/validator_api.dart';
import '../../utils/realtime_validators.dart';
import '../../widgets/auth_widgets/auth_texts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DataRepository dataRepository = DataRepository();

  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? usernameError, emailOrPhoneError, passwordError;

  @override
  Widget build(BuildContext context) {
    final currentTheme = dataRepository.getCurrentTheme();

    String googleIconPath = 'assets/icons/authGoogleDark.svg';
    String linkedinIconPath = 'assets/icons/authLinkedinDark.svg';
    String twitterxIconPath = 'assets/icons/authTwitterDark.svg';
    String githubIconPath = "assets/icons/authGithubDark.svg";
    double socialAuthIconSize = 64;

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        print("STATE LISTENER >> $state");
        if (state is AuthenticationSuccess) {
          Provider.of<ToggleSettingsProvider>(context, listen: false)
              .closeSettings();
          // TODO: get profile data from fetchVerify and give to home_screen
          Navigator.pushNamed(
            context,
            "/home",
            arguments: state.loginSuccessData,
          );
        } else if (state == const AuthenticationFailure()) {
          print('ERROR OCCURRED');
        }
      },
      builder: (context, state) {
        AuthenticationState authState = state;
        return Scaffold(
          backgroundColor: currentTheme.background1,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 32, right: 32),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildLoginText(),
                  const SizedBox(height: 36),
                  Column(
                    children: [
                      buildAuthInputField(
                        labelText: 'username',
                        controller: _usernameController,
                        errorText: usernameError,
                        onChanged: (value) async {
                          usernameError =
                              await loginUsernameValidator(value.trim());
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      buildAuthInputField(
                        labelText: 'password',
                        controller: _passwordController,
                        errorText: passwordError,
                        onChanged: (value) {
                          passwordError =
                              realtimePasswordValidator(value.trim());
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  buildResetPassword(onTap: () => print('✨ Reset password')),
                  const SizedBox(height: 16),
                  buildAuthButton(
                    context: context,
                    authState: authState,
                    usernameError: usernameError,
                    emailOrPhoneError: emailOrPhoneError,
                    passwordError: passwordError,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    onPressed: () {
                      if (usernameError == null || passwordError == null) {
                        print('NOT ANY ERROR >>');
                        final Profile loginData = Profile(
                          username: _usernameController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        context.read<AuthenticationBloc>().add(
                              LoginSubmitEvent(loginData: loginData),
                            );
                      }
                    },
                  ),
                  const SizedBox(height: 36),
                  buildOrContinueWith(),
                  const SizedBox(height: 36),
                  buildSocialButtons(
                    socialAuthIconSize: socialAuthIconSize,
                    googleIconPath: googleIconPath,
                    twitterxIconPath: twitterxIconPath,
                    linkedinIconPath: linkedinIconPath,
                    githubIconPath: githubIconPath,
                    onTapOnGoogle: () async {
                      await firebaseAuthService.signInWithGoogle();
                      print('Google Sign In');
                    },
                    onTapOnTwitterx: () async {
                      await firebaseAuthService.signOut();
                      print('Google Sign Out');
                    },
                    onTapOnLinkedIn: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎈 Hello, LinkedIn!'),
                          duration: Duration(seconds: 15),
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.horizontal,
                          margin:
                              EdgeInsets.only(bottom: 24, left: 16, right: 16),
                        ),
                      );
                    },
                    onTapOnGithub: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              // TODO: new
                            ),
                            child: const Center(
                              child: Text('This is a Modal Bottom Sheet'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 36),
                  buildDontHaveAccount(
                    onTap: () => Navigator.pushNamed(context, '/home/login'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
