import Flutter
import UIKit
import UserNotifications
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // This is required to make any communication available in the action isolate.
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)
    }

    registerNotificationCategories()

    // Ensure FlutterAppDelegate is the notification delegate so
    // flutter_local_notifications can present notifications in foreground
    UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func registerNotificationCategories() {
    let acceptAction = UNNotificationAction(
      identifier: "accept_chat",
      title: "Accept",
      options: [.foreground]
    )
    let rejectAction = UNNotificationAction(
      identifier: "reject_chat",
      title: "Reject",
      options: [.foreground]
    )
    let chatCategory = UNNotificationCategory(
      identifier: "chat_actions_category",
      actions: [acceptAction, rejectAction],
      intentIdentifiers: [],
      options: []
    )
    UNUserNotificationCenter.current().setNotificationCategories([chatCategory])
  }
}
