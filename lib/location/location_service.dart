import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

import 'dart:async';
import 'dart:math';

import 'package:location/location.dart';
import 'dart:math' as math;



class UserLocation {
  final double latitude;
  final double longitude;
  final double altitude;
  final DateTime time;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.time,
  });
}

class LocationService {
  static final LocationService _instance = LocationService._internal();
  bool _isStreamInitialized = false;

  factory LocationService() {
    return _instance;
  }

  LocationService._internal({BuildContext? context}) {
    if (context != null) {
      getLocationOnchange(context);
    }
  }

  Location location = Location();
  final StreamController<UserLocation> _locationController =
  StreamController<UserLocation>.broadcast();
  StreamSubscription<LocationData>? listener;

  Stream<UserLocation> get locationStream => _locationController.stream;

  Future<void> getLocationOnchange(BuildContext context) async {
    print("🔰 getLocationOnchange");
    await showPermissionDialogAndAskPermission(
        context, perm.Permission.location);
    listener ??= initListener();
  }

  Future<void> showPermissionDialogAndAskPermission(
      BuildContext context, perm.Permission permission) async {
    print("🔰 showPermissionDialogAndAskPermission");
    final perm.PermissionStatus status = await permission.status;
    if (status.isGranted) {
      print("🔰 Permission is already granted");
      location.enableBackgroundMode(enable: true);
      location.changeSettings(
        interval: 10000,
        accuracy: LocationAccuracy.high,
      );
      listener = initListener();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      print("🔰 Permission is denied or permanently denied");
      _showPermissionDialog(context, permission);
    } else {
      // Handle other permission statuses if needed
      _showPermissionErrorDialog(context, status);
    }
  }

  void _showPermissionDialog(
      BuildContext context, perm.Permission permission) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: const Text("Permission Required")),

              // GestureDetector(
              //   onTap: () {
              //     Navigator.pop(dialogContext);
              //   },
              //   child: const Icon(
              //     Icons.close,
              //     size: 14.0,
              //   ),
              // ),
            ],
          ),
          content: const Text(
            "We need access to your location to suggest interesting places.",
          ),
          actionsPadding: const EdgeInsets.fromLTRB(10, 10, 10, 5.0),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final perm.PermissionStatus newStatus =
                await permission.request();
                if (newStatus.isGranted) {
                  // Permission granted after user interaction, proceed with location updates
                  location.enableBackgroundMode(enable: true);
                  location.changeSettings(
                    interval: 10000,
                    accuracy: LocationAccuracy.high,
                  );
                  initListenerIfNeeded();
                } else if (newStatus.isDenied) {
                  // Permission denied
                  _showPermissionDeniedDialog(context);
                } else if (newStatus.isPermanentlyDenied) {
                  // Permission permanently denied
                  _showPermissionPermanentlyDeniedDialog(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 5),
              ),
              child: const Text(
                "Grant",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceAround,
        );
      },
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext innerDialogContext) {
        return AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text(
            "Location permission was denied. You can enable it from your device's settings.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(innerDialogContext);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext innerDialogContext) {
        return AlertDialog(
          title: const Text("Permission Permanently Denied"),
          content: const Text(
            "Location permission was permanently denied. You can enable it from your device's settings.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(innerDialogContext);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionErrorDialog(
      BuildContext context, perm.PermissionStatus status) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Permission Error"),
          content: Text(
            "Unexpected permission status: ${status.toString()}",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  StreamSubscription<LocationData>? getListener() {
    print("🔰 getListener");
    return listener;
  }

  void initListenerIfNeeded() {
    print("🔰 initListenerIfNeeded");
    if (!_isStreamInitialized) {
      listener = initListener();
      _isStreamInitialized = true;
    }
  }

  StreamSubscription<LocationData> initListener() {
    print("🔰 initListener");
    return location.onLocationChanged.listen((locationData) {
      if (!_locationController.isClosed) {
        _locationController.add(UserLocation(
          latitude: locationData.latitude ?? 0.0,
          longitude: locationData.longitude ?? 0.0,
          altitude: locationData.altitude ?? 0.0,
          time: DateTime.now(),
        ));
      }
    });
  }

  void dispose() {
    print("🔰 dispose");
    _locationController.close();
    listener?.cancel();
    listener = null;
  }
}
