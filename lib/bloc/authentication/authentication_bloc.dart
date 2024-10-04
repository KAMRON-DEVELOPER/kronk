import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kronk/provider/data_repository.dart';
import '../../models/user.dart';
import '../../services/users_api.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthApiService _authApiService = AuthApiService();
  final DataRepository _dataRepository = DataRepository();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<RegisterSubmitEvent>(_registerSubmitEvent);
    on<VerifySubmitEvent>(_verifySubmitEvent);
    on<LoginSubmitEvent>(_loginSubmitEvent);
    on<ForgotPasswordSubmitEvent>(_forgotPasswordSubmitEvent);
    on<LogoutEvent>(_logoutEvent);
    on<SocialAuthEvent>(_socialAuthEvent);
  }


  void _registerSubmitEvent(RegisterSubmitEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());

    try {
      final Profile? registeredUser = await _authApiService.fetchRegister(registerData: event.registerData);
      if (registeredUser != null) {
        await _dataRepository.setSettingsAll({
          "accessToken": registeredUser.accessToken,
          "refreshToken": registeredUser.refreshToken,
          "isAuthenticated": true,
        });
        emit(AuthenticationSuccess(authSuccessData: registeredUser));
      } else {
        print('🥶 Register failed');
        emit(
          const AuthenticationFailure(
              authFailureMessage: '🥶 an error occurred while registering',
          ),
        );
      }
    } catch (e) {
      print('🥶 Register failed: $e');
      emit(
        const AuthenticationFailure(
            authFailureMessage: '🥶 an error occurred while registering',
        ),
      );
    }
  }

  
  void _verifySubmitEvent(VerifySubmitEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());

    String? temporaryUserToken = await _dataRepository.getTemporaryUserToken();
    try {
      final Profile? verifiedUser = await _authApiService.fetchVerify(
        verifyData: event.verifyData,
        temporaryUserToken: temporaryUserToken,
      );
      if (verifiedUser != null) {
        await _dataRepository.setSettingsAll({
          "accessToken": verifiedUser.accessToken,
          "refreshToken": verifiedUser.refreshToken,
          "isAuthenticated": true,
        });
        emit(AuthenticationSuccess(authSuccessData: verifiedUser));
      } else {
        print('🥶 verification failed');
        emit(
          const AuthenticationFailure(
              authFailureMessage: '🥶 verification failed',
          ),
        );
      }
    } catch (e) {
      emit(
        AuthenticationFailure(
            authFailureMessage: '🥶 an error occurred while verifying: $e',
        ),
      );
    }
  }

  
  void _loginSubmitEvent(LoginSubmitEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());

    try {
      final Profile? loggedInUser = await _authApiService.fetchLogin(loginData: event.loginData);
      if (loggedInUser != null) {
        await _dataRepository.setSettingsAll({
          "accessToken": loggedInUser.accessToken,
          "refreshToken": loggedInUser.refreshToken,
          "isAuthenticated": true,
        });
        emit(AuthenticationSuccess(authSuccessData: loggedInUser));
      } else {
        emit(const AuthenticationFailure(authFailureMessage: '🥶 Login failed'));
      }
    } catch (e) {
      print('🥶 An error occurred while logging: $e');
      emit(
        AuthenticationFailure(
            authFailureMessage: '🥶 An unknown error occurred while logging: $e',
        ),
      );
    }
  }

  
  void _forgotPasswordSubmitEvent(ForgotPasswordSubmitEvent event, Emitter<AuthenticationState> emit) async {}

  
  void _logoutEvent(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    print('🗑️ User logged out and data is wiped');
    await _dataRepository.clearSettings();
    emit(AuthenticationLogout());
  }

  
  void _socialAuthEvent(SocialAuthEvent event, Emitter<AuthenticationState> emit) async {
    String socialAuthProvider = event.socialProvider;
    emit(AuthenticationLoading());

    if (socialAuthProvider == 'google') {
      _providerGoogleAuth(event, emit);
    }
  }

  
  _providerGoogleAuth(SocialAuthEvent event, Emitter<AuthenticationState> emit) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // this will show account select snake bar
      final GoogleSignInAccount? selectedGoogleAccount = await googleSignIn.signIn();

      if (selectedGoogleAccount != null) {
        // get the authentication token from googleSignInAccount to create credential
        final GoogleSignInAuthentication retrievedGoogleAccount = await selectedGoogleAccount.authentication;
        // create credential with google's idToken and accessToken
        final AuthCredential firebaseCredential = GoogleAuthProvider.credential(
          idToken: retrievedGoogleAccount.idToken,
          accessToken: retrievedGoogleAccount.accessToken,
        );

        // sign in with Google's credential in FirebaseAuth
        try {
          await _firebaseAuth.signInWithCredential(firebaseCredential);
        } catch (e) {
          print('🥶 an error occurred during Firebase Auth: $e');
          emit(AuthenticationFailure(
            authFailureMessage: '🥶 an error occurred during Firebase Auth: $e',
          ),
          );
        }

        // get firebase idToken from signInWithCredential -> user
        User? signedInWithCredentialUser = _firebaseAuth.currentUser;
        String? firebaseUserIdToken = await signedInWithCredentialUser?.getIdToken();

        // send idToken and fetch user data from the server
        Profile? user = await _authApiService.fetchSocialAuth(
          firebaseUserIdToken: firebaseUserIdToken,
        );
        print("🥳 user signed in successfully: ${user?.username}");
        emit(AuthenticationSuccess(authSuccessData: user));
      } else {
        emit(
          const AuthenticationFailure(
            authFailureMessage: '🥶 Google sign-in failed',
          ),
        );
      }
    } catch (e) {
      print("🥶 an error occurred during Google Sign-In: $e");
      return emit(
        AuthenticationFailure(
          authFailureMessage: '🥶 an error occurred during Google Sign-In: $e',
        ),
      );
    }
  }
}