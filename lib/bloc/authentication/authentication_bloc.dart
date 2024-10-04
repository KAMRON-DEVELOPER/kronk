import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kronk/provider/data_repository.dart';
import '../../models/user.dart';
import '../../services/firebase_service.dart';
import '../../services/users_api.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthApiService _authApiService = AuthApiService();

  final DataRepository dataRepository = DataRepository();
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<RegisterSubmitEvent>(_registerSubmitEvent);
    on<VerifySubmitEvent>(_verifySubmitEvent);
    on<LoginSubmitEvent>(_loginSubmitEvent);
    on<ForgotPasswordSubmitEvent>(_forgotPasswordSubmitEvent);
    on<LogoutEvent>(_logoutEvent);
    on<SocialAuthEvent>(_socialAuthEvent);
  }

  void _registerSubmitEvent(RegisterSubmitEvent event, Emitter<AuthenticationState> emit) async {
    print('_registerSubmitEvent');
    emit(AuthenticationLoading());
    try {
      final Profile? registerSuccessData =
          await _authApiService.fetchRegister(registerData: event.registerData);
      if (registerSuccessData != null) {
        await dataRepository.setSettingsAll({
          "accessToken": registerSuccessData.accessToken,
          "refreshToken": registerSuccessData.refreshToken,
        });
        emit(AuthenticationSuccess(registerSuccessData: registerSuccessData));
      } else {
        emit(
          const AuthenticationFailure(
              registerFailureMessage: 'Register failed'),
        );
      }
    } catch (error) {
      emit(
        const AuthenticationFailure(
            registerFailureMessage:
                'An unknown error occurred while registering'),
      );
    }
  }

  void _verifySubmitEvent(VerifySubmitEvent event, Emitter<AuthenticationState> emit) async {
    print('_registerSubmitEvent');
    emit(AuthenticationLoading());
    String? accessToken = await dataRepository.getAccessToken();
    try {
      final Profile? verifySuccessData = await _authApiService.fetchVerify(
        verifyData: event.verifyData,
        accessToken: accessToken,
      );
      if (verifySuccessData != null) {
        await dataRepository.setSettingsAll({
          "accessToken": verifySuccessData.accessToken,
          "refreshToken": verifySuccessData.refreshToken,
          "isAuthenticated": true,
        });
        emit(AuthenticationSuccess(registerSuccessData: verifySuccessData));
      } else {
        emit(
          const AuthenticationFailure(
              registerFailureMessage: 'Verification failed'),
        );
      }
    } catch (error) {
      emit(
        const AuthenticationFailure(
            registerFailureMessage:
                'An unknown error occurred while registering'),
      );
    }
  }

  void _loginSubmitEvent(LoginSubmitEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      final Profile? loginSuccessData =
          await _authApiService.fetchLogin(loginData: event.loginData);
      if (loginSuccessData != null) {
        await dataRepository.setSettingsAll({
          "accessToken": loginSuccessData.accessToken,
          "refreshToken": loginSuccessData.refreshToken,
          "isAuthenticated": true,
        });
        emit(AuthenticationSuccess(loginSuccessData: loginSuccessData));
      } else {
        emit(const AuthenticationFailure(loginFailureMessage: 'Login failed'));
      }
    } catch (error) {
      emit(
        const AuthenticationFailure(
            loginFailureMessage: 'An unknown error occurred while logging'),
      );
    }
  }

  void _forgotPasswordSubmitEvent(ForgotPasswordSubmitEvent event, Emitter<AuthenticationState> emit) async {}

  void _logoutEvent(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    await dataRepository.clearSettings();
    // TODO: emit(AuthenticationLoggedOut());
  }

  void _socialAuthEvent(SocialAuthEvent event, Emitter<AuthenticationState> emit) async {
    String socialProvider = event.socialProvider;
    emit(AuthenticationLoading());
    if (socialProvider == 'google') {
      String? signedInUser = await firebaseAuthService.signInWithGoogle();
      if (signedInUser != null) {
        emit(SocialAuthSuccess(socialAuthSuccessMessage: "Signed in user: $signedInUser"));
      }
      emit(const AuthenticationFailure(socialAuthFailureMessage: 'Google sign-in failed'));
    }
  }
}
