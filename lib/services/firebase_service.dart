import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user.dart';
import 'users_api.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthApiService authApiService = AuthApiService();

  Future<Profile?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // this will show account select snake bar
      final GoogleSignInAccount? googleSignedInAccount =
          await googleSignIn.signIn();

      if (googleSignedInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignedInAccount.authentication;
        print('🥳 googleSignedInAccount: ${googleSignedInAccount.toString()}');
        // create credential using sent by google
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        // authenticate to firebase
        try {
          await _firebaseAuth.signInWithCredential(credential);
          print('🥳 User signed in with Google');
        } catch (e) {
          print('🥶 Failed to authenticate with Firebase: $e');
          return null;
        }

        // get firebase idToken from currentUser
        User? currentUser = _firebaseAuth.currentUser;
        String? firebaseUserIdToken = await currentUser?.getIdToken();

        // send idToken and fetch user data from the server
        Profile? user = await authApiService.fetchSocialAuth(
          firebaseUserIdToken: firebaseUserIdToken,
        );
        print("🥳 user: $user");
        return user;
      }
      return null;
    } catch (e) {
      print("🥶 an error occurred during Google Sign-In: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // sign out in Firebase
      await _firebaseAuth.signOut();
      print("🥳 User signed out from Firebase.");

      // sign out in Google Sign-In
      await googleSignIn.signOut();
      print("🥳 User signed out from Google.");
    } catch (e) {
      print("🥶 An error occurred during sign out: $e");
    }
  }
}
