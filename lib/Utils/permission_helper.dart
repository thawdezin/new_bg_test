import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

// Method to request location permission
Future<bool> requestLocationPermission(BuildContext context) async {
  // Check if the location permission is already granted
  if (await Permission.location.isGranted) {
    return true;
  }

  // Request the location permission
  var status = await Permission.location.request();

  // Check the status of the permission request
  if (status.isGranted) {
    return true;
  } else if (status.isPermanentlyDenied) {
    // Show a dialog to ask for user confirmation to enable the permission
    bool shouldOpenSettings = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Location Permission Required'),
          content: Text('Please enable location permissions in the app settings to access your location.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog and return false
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog and return true
                // Open app settings to allow the user to manually grant the permission
                openAppSettings();
              },
              child: Text('Enable'),
            ),
          ],
        );
      },
    );

    return shouldOpenSettings;

  } else {
    // Show a snackbar with an appropriate message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Location permission denied. You can grant the permission from app settings.'),
        action: SnackBarAction(
          label: 'Open Settings',
          onPressed: () {
            // Open app settings to allow the user to manually grant the permission
            openAppSettings();
          },
        ),
      ),
    );

    return false;
  }
}
