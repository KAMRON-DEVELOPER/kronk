import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../models/user.dart';
import '../../provider/theme_provider.dart';
import '../../provider/toggle_settings_provider.dart';
import '../../utils/realtime_validators.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController _codeController = TextEditingController();
  String? codeError;
  final _formKey = GlobalKey<FormState>();
  final String currentTheme =
      Hive.box('settingsBox').get('theme', defaultValue: 'blue');

  bool hasAnyError(String? codeError) {
    return codeError != null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    bool hasError = hasAnyError(codeError);
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        print('STATE LISTENER >> $state');
        if (state is AuthenticationSuccess) {
          Provider.of<ToggleSettingsProvider>(context, listen: false)
              .closeSettings();
          //! get profile data from fetchVerify and give to home_screen
          Navigator.pushNamed(
            context,
            '/home',
            arguments: state.loginSuccessData,
          );
        } else if (state == const AuthenticationFailure()) {
          print('ERROR OCCURRED');
        }
      },
      builder: (context, state) {
        AuthenticationState authState = state;
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
                    'Verification',
                    style: TextStyle(color: Colors.white, fontSize: 48),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'please be patient, one more step!',
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
                          onChanged: (value) {
                            codeError = realtimeCodeValidator(value.trim());
                            setState(() {});
                          },
                          controller: _codeController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'code',
                            errorText: codeError,
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!hasError) {
                          print('NOT ANY ERROR >>');
                          final Profile verifyData = Profile(
                            code: _codeController.text.trim(),
                          );
                          context.read<AuthenticationBloc>().add(
                                VerifySubmitEvent(verifyData: verifyData),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                      ),
                      child: authState == AuthenticationLoading()
                          ? const Text(
                              "Loading...",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              "Verify",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                    ),
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
