import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'users_api.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthApiService authApiService = AuthApiService();

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("The email address is already in use.");
      } else {
        print("An error occurred: ${e.code}");
      }
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        print("Invalid email or password.");
      } else {
        print("'An error occurred: ${e.code}");
      }
    }
    return null;
  }


  Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // this will show account select snake bar
      final GoogleSignInAccount? googleSignedInAccount = await googleSignIn.signIn();

      if (googleSignedInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignedInAccount.authentication;
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
        }

        // get firebase idToken from currentUser and sendToBackend
        User? currentUser = _firebaseAuth.currentUser;
        String? firebaseUserIdToken = await currentUser?.getIdToken();
        bool isSendToBackend = await authApiService.fetchGoogleSignIn(firebaseUserIdToken: firebaseUserIdToken);
        print("🥳 isSendToBackend: $isSendToBackend");
      }
    } catch (e) {
      print("🥶 an error occurred during Google Sign-In: $e");
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
