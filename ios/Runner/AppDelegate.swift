import UIKit
import Flutter
import Firebase
import GoogleMaps
import Braintree

@available(iOS 10.0, *)
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyCXudnefDivWtB4O7nrToB-3Bu13-TEF8A")   
    UNUserNotificationCenter.current().delegate = self
    BTAppSwitch.setReturnURLScheme("com.MOOV.ND.payments")
    
   
    GeneratedPluginRegistrant.register(with: self)
    application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "com.MOOV.ND.payments" {
            return BTAppSwitch.handleOpen(url, options:options)
        }
        
        return false
    }
//     override public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
//       {
//           completionHandler([.alert, .badge, .sound])
//       }
// }
// func application(application: UIApplication,
//                  didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//   Messaging.messaging().apnsToken = deviceToken
// }
// // All you need to see remote notification in background and foreground and show as alert when app run are this appDelegate.swift that i used in my code:

// import Firebase
// import UserNotifications
// import FirebaseMessaging

// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate  {
//     var window: UIWindow?
//     let gcmMessageIDKey = "gcm_message_id"
//     var deviceID : String!


//     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {



//         // [START set_messaging_delegate]
//         Messaging.messaging().delegate = self
//         // [END set_messaging_delegate]

//         if #available(iOS 10.0, *) {
//             // For iOS 10 display notification (sent via APNS)
//             UNUserNotificationCenter.current().delegate = self

//             let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//             UNUserNotificationCenter.current().requestAuthorization(
//                 options: authOptions,
//                 completionHandler: {_, _ in })
//         } else {
//             let settings: UIUserNotificationSettings =
//                 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//             application.registerUserNotificationSettings(settings)
//         }

//         application.registerForRemoteNotifications()
//         FirebaseApp.configure()
//         Fabric.sharedSDK().debug = true
//         return true

//     }

//     func showNotificationAlert(Title : String , Message : String, ButtonTitle : String ,window : UIWindow){
//         let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
//         alert.addAction(UIAlertAction(title: ButtonTitle, style: .cancel, handler: nil))
//         window.rootViewController?.present(alert, animated: true, completion: nil)

//     }

//     // [START receive_message] remote notification
//     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

//         // Print message ID.
//         if let messageID = userInfo[gcmMessageIDKey] {
//             print("Message ID: \(messageID)")
//         }

//         // Print full message.

//         print(userInfo)

//     }

//     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//         // Print message ID.
//         if let messageID = userInfo[gcmMessageIDKey] {
//             print("Message ID: \(messageID)")
//         }

//         // Print full message.
//         print(userInfo)
//         completionHandler(UIBackgroundFetchResult.newData)

//     }

//     func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//         print("Unable to register for remote notifications: \(error.localizedDescription)")
//     }

//     // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
//     // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
//     // the FCM registration token.
//     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//         print("APNs token retrieved: \(deviceToken)")

//         // With swizzling disabled you must set the APNs token here.
//         // Messaging.messaging().apnsToken = deviceToken
//     }
// }

// // [START ios_10_message_handling]
// @available(iOS 10, *)
// extension AppDelegate : UNUserNotificationCenterDelegate {

//     // Receive displayed notifications for iOS 10 devices.
//     func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                 willPresent notification: UNNotification,
//                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//         let userInfo = notification.request.content.userInfo

//         // With swizzling disabled you must let Messaging know about the message, for Analytics
//         // Messaging.messaging().appDidReceiveMessage(userInfo)
//         // Print message ID.
//         if let messageID = userInfo[gcmMessageIDKey] {
//             print("Message ID: \(messageID)")
//         }

//         // Print full message.
//         print(userInfo)



//         // Change this to your preferred presentation option
//         completionHandler([.alert, .badge, .sound])
//     }

//     func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                 didReceive response: UNNotificationResponse,
//                                 withCompletionHandler completionHandler: @escaping () -> Void) {
//         let userInfo = response.notification.request.content.userInfo
//         // Print message ID.
//         if let messageID = userInfo[gcmMessageIDKey] {
//             print("Message ID: \(messageID)")
//         }


//         if let aps = userInfo["aps"] as? NSDictionary {
//             if let alert = aps["alert"] as? NSDictionary {
//                 if let title = alert["title"] as? NSString {
//                     let body = alert["body"] as? NSString
//                     showNotificationAlert(Title: title as String, Message: body! as String, ButtonTitle: "Ok", window: window!)
//                 }
//             } else if let alert = aps["alert"] as? NSString {
//                 print("mohsen 6 =\(alert)")
//             }
//         }
//         // Print full message.
//         print(userInfo)


//         completionHandler()
//     }
// }
// [END ios_10_message_handling]

// extension AppDelegate : MessagingDelegate {
// //     // [START refresh_token]
// //     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
// //         print("Firebase registration token: \(fcmToken)")
// //         deviceID = fcmToken

// //         let dataDict:[String: String] = ["token": fcmToken]
// //         NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
// //         // TODO: If necessary send token to application server.
// //         // Note: This callback is fired at each app startup and whenever a new token is generated.
// //     }
// //     // [END refresh_token]
// //     // [START ios_10_data_message]
// //     // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
// //     // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
//     func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//       Messaging.messaging().shouldEstablishDirectChannel = true
//         print("Received data message: \(remoteMessage.appData)")
//     }
// //     // [END ios_10_data_message]


//  }
// override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//         if url.scheme == "com.MOOV.ND.payments" {
//             return BTAppSwitch.handleOpen(url, options:options)
//         }
        
//         return false
//     }
}
