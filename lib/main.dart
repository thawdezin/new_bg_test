import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
import 'package:get/get.dart';
import 'dart:convert';

import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BackgroundGeolocation Demo',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class HomeController extends GetxController {
  var isMoving = false.obs;
  var enabled = false.obs;
  var motionActivity = 'UNKNOWN'.obs;
  var odometer = '0'.obs;
  var content = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initBackgroundGeolocation();
  }

  void _initBackgroundGeolocation() async {
    bg.BackgroundGeolocation.onLocation(_onLocation);
    bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
    bg.BackgroundGeolocation.onActivityChange(_onActivityChange);
    bg.BackgroundGeolocation.onProviderChange(_onProviderChange);
    bg.BackgroundGeolocation.onConnectivityChange(_onConnectivityChange);

    bg.State state = await bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 10.0,
      stopOnTerminate: false,
      startOnBoot: true,
      debug: true,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      reset: true,
    ));

    enabled.value = state.enabled;
    isMoving.value = state.isMoving!;
  }

  void onClickEnable(bool enabled) async {
    if (enabled) {
      bg.State state = await bg.BackgroundGeolocation.start();
      //enabled.value = state.enabled;
      isMoving.value = state.isMoving!;
    } else {
      bg.State state = await bg.BackgroundGeolocation.stop();
      bg.BackgroundGeolocation.setOdometer(0.0);
      odometer.value = '0.0';
      //enabled.value = state.enabled;
      isMoving.value = state.isMoving!;
    }
  }

  void onClickChangePace() {
    isMoving.value = !isMoving.value;
    bg.BackgroundGeolocation.changePace(isMoving.value).then((bool isMoving) {
      print('[changePace] success $isMoving');
    }).catchError((e) {
      print('[changePace] ERROR: ' + e.code.toString());
    });
  }

  void onClickGetCurrentPosition() {
    bg.BackgroundGeolocation.getCurrentPosition(
      persist: false,
      desiredAccuracy: 0,
      timeout: 30000,
      samples: 3,
    ).then((bg.Location location) {
      print('[getCurrentPosition] - $location');
    }).catchError((error) {
      print('[getCurrentPosition] ERROR: $error');
    });
  }

  void _onLocation(bg.Location location) {
    String odometerKM = (location.odometer / 1000.0).toStringAsFixed(1);
    content.value = JsonEncoder.withIndent("     ").convert(location.toMap());
    odometer.value = odometerKM;
  }

  void _onMotionChange(bg.Location location) {
    print('[motionchange] - $location');
  }

  void _onActivityChange(bg.ActivityChangeEvent event) {
    print('[activitychange] - $event');
    motionActivity.value = event.activity;
  }

  void _onProviderChange(bg.ProviderChangeEvent event) {
    print('$event');
    content.value = JsonEncoder.withIndent("     ").convert(event.toMap());
  }

  void _onConnectivityChange(bg.ConnectivityChangeEvent event) {
    print('$event');
  }
}

class MyHomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Background Geolocation'),
        actions: <Widget>[
          Obx(() => Switch(
            value: controller.enabled.value,
            onChanged: controller.onClickEnable,
          )),
        ],
      ),
      body: SingleChildScrollView(child: Obx(() => Text('${controller.content.value}'))),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.gps_fixed),
                onPressed: controller.onClickGetCurrentPosition,
              ),
              Obx(() => Text('${controller.motionActivity.value} · ${controller.odometer.value} km')),
              MaterialButton(
                minWidth: 50.0,
                child: Obx(() => Icon(controller.isMoving.value ? Icons.pause : Icons.play_arrow, color: Colors.white)),
                color: controller.isMoving.value ? Colors.red : Colors.green,
                onPressed: controller.onClickChangePace,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
