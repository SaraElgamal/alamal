// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:lost/src/config/res/constants_manager.dart';
// import 'package:lost/src/core/navigation/routes/app_router.dart';
// import 'package:lost/src/core/widgets/custom_messages.dart';

// abstract class FirebaseMessagingHelper {
//   static final FirebaseMessaging _firebaseMessaging = sl<FirebaseMessaging>();
//   static bool initialized = false;

//   static Future<void> onInitializeFirebaseMessaging() async {
//     if (initialized != true) {
//       final settings = await onSetNotificationSettings();
//       if (settings != null) {
//         if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//           if (Platform.isIOS) {
//             onSetForegroundIosOptions();
//           }
//           await onTerminatedMessagesHandler();
//           onMessageHandler();
//           onMessageOpenedHandler();
//         }
//       }
//       initialized = true;
//     }
//   }

//   static Future<NotificationSettings?> onSetNotificationSettings() async {
//     try {
//       final NotificationSettings settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         announcement: false,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//       );
//       return settings;
//     } catch (exception) {
//       return null;
//     }
//   }

//   static void onSetForegroundIosOptions() async =>
//       await _firebaseMessaging.setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );

//   static Future<String?> onGetDeviceToken() async {
//     try {
//       final String? token = await _firebaseMessaging.getToken();
//       return token;
//     } catch (exception) {
//       return null;
//     }
//   }

//   static Future<void> onTerminatedMessagesHandler() async {
//     final RemoteMessage? message = await _firebaseMessaging.getInitialMessage();
//     if (kDebugMode) {
//       print('onTerminatedMessagesHandler');
//       print('data => ${message?.data}');
//       print('notification => ${message?.notification?.title}');
//     }
//   }

//   static Future<void> onMessageHandler() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showOpenedAppNotification(message: message);
//       if (kDebugMode) {
//         print('onMessage');
//         print('data => ${message.data}');
//         print('notification => ${message.notification?.title}');
//       }
//     });
//   }

//   static Future<void> onMessageOpenedHandler() async {
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print('onMessageOpenedApp');
//         print('data => ${message.data}');
//         print('notification => ${message.notification?.title}');
//       }
//     });
//   }

//   static void _showOpenedAppNotification({required RemoteMessage message}) {
//     if (message.notification?.title != null && message.notification?.body != null) {
//       MessageUtils.showNotification(
//         title: message.notification!.title!,
//         body: message.notification!.body!,
//         onTap: () {
//           if (message.data.containsKey('ad_id')) {
//             final id = int.tryParse(message.data['ad_id'].toString());
//             if (id != null) {
//               AppRouter.router.pushNamed('adDetails', extra: id);
//             }
//           }
//         },
//       );
//     }
//   }
// }
