import 'package:april/location/location_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';

import '../Utils/app_utils.dart';
import 'notification_service.dart';

Future<void> uploadToFirestore(double lat, double lng) async {
  try {
    // var lat = 0.0;
    // var lng = 0.0;

    try {
      // final Location location = Location();
      // final LocationData currentLocation = await location.getLocation();
      // print('Latitude: ${currentLocation.latitude}');
      // print('Longitude: ${currentLocation.longitude}');
      //
      // lat = currentLocation.latitude ?? 1111.0;
      // lng = currentLocation.longitude ?? 1111;

      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get current user's email
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Collection reference
        DocumentReference userDoc =
            firestore.collection('user').doc("check_this");

        // Add document to collection
        await userDoc.set({
          'email': user.email,
          'lat': lat,
          'lng': lng,
          'time': getCurrentTime(),
        });

        print('Data uploaded to Firestore successfully!');
      } else {
        print(
            'Error: Unauthorized access or user is not signed in with thawdezin.office@gmail.com.');
      }
    } catch (e1) {
      print('Error fetching location: $e1');
    }
  } catch (e) {
    print('Error uploading data to Firestore: $e');
  }
}

/// The LocationPage
class LocationPage extends StatelessWidget {
  /// Constructs a [DetailsScreen]
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    LocationService().getLocationOnchange(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Location Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/location'),
              child: const Text('Go back to the Home screen'),
            ),
            ElevatedButton(
                onPressed: () {
                  signInWithGoogle(context);
                },
                child: const Text("Google Login")),
            ElevatedButton(
                onPressed: () async {
                  // final Location location = Location();
                  // final LocationData currentLocation =
                  //     await location.getLocation();
                  // print('Latitude: ${currentLocation.latitude}');
                  // print('Longitude: ${currentLocation.longitude}');

                  // await uploadToFirestore(currentLocation.latitude ?? 111.0, currentLocation.latitude ?? 111.0);
                  await uploadToFirestore(111.0, 111.0);
                },
                child: const Text("Upload Current Location")),

            ElevatedButton(onPressed: (){
              scheduleNotification("OnClick");
            }, child: Text("show Noti")),
          ],
        ),
      ),
    );
  }
}
