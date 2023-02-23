// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:socify/constants.dart';
import 'package:socify/model/data/user.dart';
import 'package:socify/view/screens/home_screen.dart';
import 'package:socify/view/screens/login_screen.dart';
import 'package:socify/view/widgets/show_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socify/view_model/respositories/user_respository.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
    required TextEditingController nameController,
    required TextEditingController emailController,
  }) async {
    try {
      UserData userData = Provider.of<UserData>(
        context,
        listen: false,
      );
      List<String> name = nameController.text.split(" ");
      userData.firstName = name[0];
      userData.lastName = name[1] ?? "";
      userData.email = emailController.text;
      userData.picture =
          "https://static.vecteezy.com/system/resources/previews/008/442/086/original/illustration-of-human-icon-user-symbol-icon-modern-design-on-blank-background-free-vector.jpg";
      DatabaseReference ref = FirebaseDatabase.instance
          .ref('users/${emailController.text.replaceAll('.', "-")}');
      await UserRepositories(context).createUser(userData: userData);
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);
      var box = await Hive.openBox(hiveBoxId);
      await box.put(
        boxUserId,
        context.read<UserData>().id,
      );
      await ref.set({"id": context.read<UserData>().id});
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
      print("alkjdsfhal" + e.message.toString());
      showSnackBar(
        context,
        e.message!,
      ); // Displaying the usual firebase error message
    } catch (e) {
      print("WEKSDJFHLKSD" + e.toString());
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('users/${email.replaceAll('.', "-")}');
      String val = (await ref.child('/id').once(DatabaseEventType.value))
              .snapshot
              .value
              ?.toString() ??
          "";
      UserRepositories(context).getUserData(id: val);
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      }
      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
          child: HomeScreen(),
          type: PageTransitionType.fade,
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  // GOOGLE SIGN IN
  Future<dynamic> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          // if you want to do specific task like storing information in fire store
          // only for new users using google sign in (since there are no two options
          // for google sign in and google sign up, only one as of now),
          // do the following:

          if (userCredential.user != null) {
            DatabaseReference ref = FirebaseDatabase.instance.ref(
                'users/${userCredential.user!.email!.replaceAll('.', "-")}');
            if (userCredential.additionalUserInfo!.isNewUser) {
              UserData userData = Provider.of<UserData>(
                context,
                listen: false,
              );
              List<String> name = userCredential.user!.displayName!.split(" ");
              userData.firstName = name[0];
              userData.lastName = name[1];
              userData.email = userCredential.user!.email;
              userData.picture = userCredential.user!.photoURL;

              await UserRepositories(context).createUser(userData: userData);
              var box = await Hive.openBox(hiveBoxId);
              await box.put(
                boxUserId,
                context.read<UserData>().id,
              );
              await ref.set({"id": context.read<UserData>().id});
            } else {
              String val =
                  (await ref.child('/id').once(DatabaseEventType.value))
                          .snapshot
                          .value
                          ?.toString() ??
                      "";
              print("WHAYTTT" + val);
              UserRepositories(context).getUserData(id: val);
            }
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                child: HomeScreen(),
                type: PageTransitionType.fade,
              ),
              (route) => false,
            );
            return true;
          }
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          child: LoginScreen(),
          type: PageTransitionType.fade,
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }
}
