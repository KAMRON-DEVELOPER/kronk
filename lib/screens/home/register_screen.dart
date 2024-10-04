import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kronk/provider/data_repository.dart';
import 'package:kronk/widgets/auth_widgets/auth_fields.dart';
import 'package:kronk/widgets/auth_widgets/auth_icons.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../models/user.dart';
import '../../utils/realtime_validators.dart';
import '../../widgets/auth_widgets/auth_texts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final DataRepository dataRepository = DataRepository();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailOrPhoneController = TextEditingController();
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
        print('👂 STATE LISTENER >> $state');
        if (state is AuthenticationSuccess) {
          print("🎯 I'm pushing to verify_screen");
          try {
            Navigator.pushNamed(context, '/home/verify');
          } catch (error) {
            print('🌋 unexpected error >> $error');
          }
        } else if (state is AuthenticationFailure) {
          print('🥶 ERROR OCCURRED');
          if (state.socialAuthFailureMessage != null) {
            String errorMessage = state.socialAuthFailureMessage!;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Column(
                  children: [
                    const Text('🥶 Social Auth Failure!'),
                    Text(errorMessage),
                  ],
                ),
                duration: const Duration(seconds: 15),
                behavior: SnackBarBehavior.floating,
                dismissDirection: DismissDirection.horizontal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
              ),
            );
          }
        } else if (state is SocialAuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                children: [
                  const Text('🎈 User has registered successfully!'),
                  Text(state.socialAuthSuccessMessage),
                ],
              ),
              duration: const Duration(seconds: 15),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            ),
          );
        }
      },
      builder: (context, state) {
        AuthenticationState authState = state;
        print('🚨 STATE BUILDER >> $state');
        return Scaffold(
          backgroundColor: currentTheme.background1,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 32, right: 32),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRegisterText(),
                  const SizedBox(height: 36),
                  Column(
                    children: [
                      buildAuthInputField(
                        labelText: 'username',
                        controller: _usernameController,
                        errorText: usernameError,
                        onChanged: (value) async {
                          usernameError =
                              await registerUsernameValidator(value.trim());
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 16),
                      buildAuthInputField(
                        labelText: 'email or phone',
                        controller: _emailOrPhoneController,
                        errorText: emailOrPhoneError,
                        onChanged: (value) async {
                          emailOrPhoneError =
                              await realtimeEmailOrPhoneValidator(value.trim());
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
                      )
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
                    emailOrPhoneController: _emailOrPhoneController,
                    passwordController: _passwordController,
                    onPressed: () {
                      if (usernameError == null &&
                          emailOrPhoneError == null &&
                          passwordError == null) {
                        print('🚀 NOT ANY ERROR');
                        final Profile registerData = Profile(
                          username: _usernameController.text.trim(),
                          emailOrPhone: _emailOrPhoneController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        context.read<AuthenticationBloc>().add(
                              RegisterSubmitEvent(registerData: registerData),
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
                    onTapOnGoogle: () {
                      context
                          .read<AuthenticationBloc>()
                          .add(const SocialAuthEvent(socialProvider: 'google'));
                      print('📡 Google Sign In');
                    },
                    onTapOnTwitterx: () {
                      context.read<AuthenticationBloc>().add(LogoutEvent());
                      print('Google Sign Out');
                    },
                    onTapOnLinkedIn: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Column(
                            children: [
                              Text('🎈 Hello, LinkedIn!'),
                              Text('📝 info ...'),
                            ],
                          ),
                          duration: const Duration(seconds: 15),
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.horizontal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.only(
                              bottom: 24, left: 16, right: 16),
                        ),
                      );
                    },
                    onTapOnGithub: () => print('��‍��� Github'),
                  ),
                  const SizedBox(height: 36),
                  buildAlreadyHaveAccount(
                    onTap: () => Navigator.pushNamed(context, '/home/login'),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
