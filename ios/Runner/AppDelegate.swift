import UIKit
import Flutter
import flutter_local_notifications
import flutter_background_service_ios // add this

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

    /// Add this line
        SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"


        GeneratedPluginRegistrant.register(with: self)
        // Set the minimum background fetch interval (in seconds)
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
