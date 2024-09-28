import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../models/user.dart';
import '../../provider/theme_provider.dart';
import '../../services/validator_api.dart';
import '../../utils/realtime_validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? usernameError;
  String? emailOrPhoneError;
  String? passwordError;
  final _formKey = GlobalKey<FormState>();
  ValidateApiService validateUsersService = ValidateApiService();
  double socialAuthIconSize = 64;
  final String currentTheme =
      Hive.box('settingsBox').get('theme', defaultValue: 'blue');

  bool hasAnyError(
      String? usernameError, String? emailOrPhoneError, String? passwordError) {
    return usernameError != null ||
        emailOrPhoneError != null ||
        passwordError != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    bool hasError = hasAnyError(
      usernameError,
      emailOrPhoneError,
      passwordError,
    );
    String googleIconPath = 'assets/icons/authGoogleDark.svg';
    String linkedinIconPath = 'assets/icons/authLinkedinDark.svg';
    String twitterxIconPath = 'assets/icons/authTwitterDark.svg';
    String githubIconPath = currentTheme == "dark"
        ? "assets/icons/authGithubDark.svg"
        : "assets/icons/authGithubLight.svg";

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        print('STATE LISTENER >> $state');
        if (state is AuthenticationSuccess) {
          print("I'm pushing to verify_screen");
          try {
            Navigator.pushNamed(context, '/home/verify');
          } catch (error) {
            print('unexpected error >> $error');
          }
        } else if (state == const AuthenticationFailure()) {
          print('ERROR OCCURRED');
        }
      },
      builder: (context, state) {
        AuthenticationState authState = state;
        print('STATE BUILDER >> $state');
        return Scaffold(
          backgroundColor: theme.background1,
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 32, right: 32),
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Enter your username, password and email or phone number. Then we send verification code.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Form(
                    key: _formKey,
                    onChanged: () => print('value'),
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) async {
                            usernameError =
                                await registerUsernameValidator(value.trim());
                            setState(() {});
                          },
                          controller: _usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'username',
                            errorText: usernameError,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                            counterStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) async {
                            emailOrPhoneError =
                                await realtimeEmailOrPhoneValidator(
                                    value.trim());
                            setState(() {});
                          },
                          controller: _emailOrPhoneController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'email or phone',
                            errorText: emailOrPhoneError,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                            counterStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) {
                            passwordError =
                                realtimePasswordValidator(value.trim());
                            setState(() {});
                          },
                          controller: _passwordController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'password',
                            errorText: passwordError,
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                            counterStyle: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: const Text(
                          'Reset password',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () => print('FORGOT PASSWORD!!!'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!hasError) {
                          print('NOT ANY ERROR >>');
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      child: authState == AuthenticationLoading()
                          ? const Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.white70),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'or continue with',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        googleIconPath,
                        width: socialAuthIconSize,
                        height: socialAuthIconSize,
                      ),
                      SvgPicture.asset(
                        twitterxIconPath,
                        width: socialAuthIconSize,
                        height: socialAuthIconSize,
                      ),
                      SvgPicture.asset(
                        linkedinIconPath,
                        width: socialAuthIconSize,
                        height: socialAuthIconSize,
                      ),
                      SvgPicture.asset(
                        githubIconPath,
                        width: socialAuthIconSize,
                        height: socialAuthIconSize,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.green,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () =>
                            Navigator.pushNamed(context, '/home/login'),
                      )
                    ],
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
