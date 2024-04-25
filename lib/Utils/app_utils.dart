import 'package:april/global_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:june/core/src/june_main.dart';
import 'package:june/instance/june_instance.dart';

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account != null) {
      // Successfully signed in, do something with the account information
      print("Google Sign-In successful: ${account.displayName}");

      var state = June.getState(MyAccount());
      state.email = account.email;
      state.setState();

      // Obtain authentication credentials from the GoogleSignInAccount
      GoogleSignInAuthentication googleAuth = await account.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // Assign the authenticated user to FirebaseAuth.instance.currentUser
      User? user = userCredential.user;
      //FirebaseAuth.instance.user = user;

      print('Google Sign-In successful: ${user!.displayName} (${user.email})');

    }
  } catch (error) {
    // Handle sign-in errors
    print("Error signing in with Google: $error");

  }
}

String getCurrentTime() {
  DateTime now = DateTime.now();
  String period = now.hour >= 12 ? 'PM' : 'AM';
  int hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
  String minute = now.minute.toString().padLeft(2, '0');
  String second = now.second.toString().padLeft(2, '0');
  String month;
  switch (now.month) {
    case 1:
      month = 'January';
      break;
    case 2:
      month = 'February';
      break;
    case 3:
      month = 'March';
      break;
    case 4:
      month = 'April';
      break;
    case 5:
      month = 'May';
      break;
    case 6:
      month = 'June';
      break;
    case 7:
      month = 'July';
      break;
    case 8:
      month = 'August';
      break;
    case 9:
      month = 'September';
      break;
    case 10:
      month = 'October';
      break;
    case 11:
      month = 'November';
      break;
    case 12:
      month = 'December';
      break;
    default:
      month = '';
  }
  String day = now.day.toString();
  String year = now.year.toString();

  return '$hour:$minute:$second $period @ $month $day, $year';
}

