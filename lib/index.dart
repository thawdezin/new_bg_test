// import 'package:april/location/location_page.dart';
// import 'package:background_fetch/background_fetch.dart';
// import 'package:background_service_easy/background_service_easy.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:go_router/go_router.dart';
// import 'package:timezone/data/latest.dart' as tz;
//
// import 'Utils/permission_helper.dart';
// import 'firebase_options.dart';
// import 'location/notification_service.dart';
// import 'my_go_router.dart';
//
// // [Android-only] This "Headless Task" is run when the Android app is terminated with `enableHeadless: true`
// // Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
// @pragma('vm:entry-point')
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   String taskId = task.taskId;
//   bool isTimeout = task.timeout;
//   uploadToFirestore(786, 969);
//   scheduleNotification("vm:entry-point");
//
//   if (isTimeout) {
//     // This task has exceeded its allowed running-time.
//     // You must stop what you're doing and immediately .finish(taskId)
//     print("⛑[BackgroundFetch] Headless task timed-out: $taskId");
//     uploadToFirestore(786, 969);
//     scheduleNotification("isTimeout");
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//   print("⛑[BackgroundFetch] Headless event received: $taskId");
//
//   uploadToFirestore(786, 969);
//   scheduleNotification("After isTimeout");
//   // Do your work here...
//   BackgroundFetch.finish(taskId);
// }
//
//
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   tz.initializeTimeZones();
//   requestLocationPermission();
//   await initializeNotifications();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // the constructor automatically set to foreground when initialized
//   BackgroundService(
//     onForeground: () {
//       // Callback when the service is set to the foreground.
//       uploadToFirestore(111, 111);
//       scheduleNotification("onForeground");
//     },
//     onBackground: () {
//       // Callback when the service is set to the background or app is closed.
//       uploadToFirestore(222, 222);
//       scheduleNotification("onBackground");
//     },
//     onStop: () {
//       // Callback when the service is stopped.
//       uploadToFirestore(333, 333);
//       scheduleNotification("onStop");
//     },
//   );
//
//   runApp(const MyApp());
//
//   BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
//
//   BackgroundFetch.configure(
//     BackgroundFetchConfig(
//       minimumFetchInterval: 1, // Fetch interval in seconds (3.5 minutes)
//       stopOnTerminate: false,
//       startOnBoot: true,
//       enableHeadless: true,
//     ),
//         (String taskId) async {
//       print("⛑ [BackgroundFetch] Event received: $taskId");
//       uploadToFirestore(786, 969);
//       scheduleNotification("Main");
//       BackgroundService.setToBackground();
//       // Run your background task here
//       BackgroundFetch.finish(taskId);
//     },
//   );
//
// }
//
// class MyApp extends StatelessWidget {
//   //const MyApp({super.key});
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//
//
//     return MaterialApp.router(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       routerConfig: router,
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     BackgroundService.setToBackground(); // အသစ်က ဒီမှာခေါ်
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               const Text(
//                 'You have pushed the button this many times:',
//               ),
//               Text(
//                 '$_counter',
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//
//               ElevatedButton(
//                 onPressed: () => context.go('/details'),
//                 child: const Text('Details screen'),
//               ),
//
//               ElevatedButton(onPressed: (){
//                 context.go('/about');
//               }, child: Text("About")),
//
//               ElevatedButton(
//                 onPressed: () async {
//                   context.go('/location');
//                   //await requestLocationPermission(context);
//                   },
//                 child: const Text('Location'),
//               ),
//
//             ],
//           ),
//       ),
//
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
//
//
//
// Future<void> initializeNotifications() async {
//   // Initialize the plugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   // Android initialization
//   final AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/launcher_icon');
//
//   // iOS initialization
//   final DarwinInitializationSettings initializationSettingsIOS =
//   DarwinInitializationSettings();
//
//   // Initialization settings for both platforms
//   final InitializationSettings initializationSettings =
//   InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//
//   // Initialize the plugin with the initialization settings
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }
//
// void requestLocationPermission() async {
//   LocationPermission lp = await Geolocator.checkPermission();
//   if(lp == LocationPermission.always){
//     //initializeService();
//   }else{
//     await Geolocator.requestPermission();
//     requestLocationPermission();
//   }
// }
//
// /// starting Background Service lib
// // Future<void> initializeService() async {
// //   final service = FlutterBackgroundService();
// //   await service.configure(
// //     androidConfiguration: AndroidConfiguration(
// //       onStart: onStart,
// //       autoStart: true,
// //       isForegroundMode: true,
// //       autoStartOnBoot: true,
// //     ),
// //     iosConfiguration: IosConfiguration(
// //       autoStart: true,
// //       onForeground: onIosStart,
// //       onBackground: onIosBackground,
// //     ),
// //   );
// //   service.startService();
// //   if(Platform.isIOS){
// //     backgroundFetchScheduleTask();
// //   }
// // }