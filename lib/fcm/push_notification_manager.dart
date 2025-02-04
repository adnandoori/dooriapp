import 'dart:convert';
import 'dart:io';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'alerts_channel',
    'Alerts',
    description:
        'Doori device measures vital body parameters such as heart rate, oxygen level, blood pressure, and HRV (Heart Rate Variability) with unparalleled accuracy and convenience. ',
    importance: Importance.max,
    enableVibration: true,
    showBadge: true,
  );

  Future<void> init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
          );
    } else {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _showNotificationWithDefaultSound(message);
      }
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      printf("====================initialMessage=======================");
      printRemoteMessage(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onBackgroundMessage(_showNotificationWithDefaultSound);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
    );

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      printf("====================onMessageOpenedApp=======================");
      printRemoteMessage(message);
      updateNavigation(message);
    });

    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = const IOSInitializationSettings();
    var platform = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(
      platform,
      onSelectNotification: (payload) {
        printf(
            "====================onSelectNotification=======================");
        printf('paylod$payload');
        updateNavigation(jsonDecode(payload!));
      },
    );
  }

  Future _showNotificationWithDefaultSound(RemoteMessage payload) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'customer_channel 2', 'Customer Update',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: false,
        styleInformation: BigTextStyleInformation(''),
        enableVibration: true,
        autoCancel: true);

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    var notification = payload.notification;
    var data = payload.data;
    print(payload.notification);
    print(
        "====================_showNotificationWithDefaultSound=======================");
    printRemoteMessage(payload);

    await flutterLocalNotificationsPlugin.show(
      0,
      notification?.title,
      notification?.body,
      platformChannelSpecifics,
      payload: jsonEncode(payload.data),
    );
    // updateNavigation(payload);
  }
}

const String pollPush = "poll_push";
const String storyPush = "story_push";
const String quizPush = "quiz_push";

void updateNavigation(/*Map<String, dynamic> data*/ RemoteMessage data) {
  print("===============updateNavigation=================");
  //print(jsonEncode(data));
  print("${data.notification!.title} title..........");
  print("${data.notification!.body} body..........");
  print("${data.data} data..........");
  print("${data.data['orderId']} order id..........");
//  print(data.notification!.id.toString() + " data..........");
  print("${data.notification!.titleLocArgs} titleLocArgs..........");
  print("${data.notification!.bodyLocArgs} bodyLocArgs..........");

  var argumet = "";
  if (data.notification!.title.toString().toLowerCase().contains("news")) {
    argumet = "news";
  } else if (data.notification!.title
      .toString()
      .toLowerCase()
      .contains("video")) {
    argumet = "video";
  } else if (data.notification!.title
      .toString()
      .toLowerCase()
      .contains("image")) {
    argumet = "image";
  } else if (data.notification!.title
      .toString()
      .toLowerCase()
      .contains("ott")) {
    argumet = "ott";
  }

  print("order place notification push......");

  /*switch (data.data['Type'].toString()) {
    case "Your order placed":
      print("order place notification push......");
      Get.to(() => DashboardScreen(""));
      break;
  }*/

  // print(data["title"]);
  // print(data["action_id"]);
}

printRemoteMessage(RemoteMessage message) {
  // print("Notification_TITLE: ${jsonEncode(message.notification)}");
  // print("Notification_TITLE: ${jsonEncode(message)}");
  // print("Notification_TITLE: ${jsonEncode(message.notification!.title)}");
  //print("Notification_BODY: ${jsonEncode(message.notification!.body)}");
  //print("Data: ${jsonEncode(message.data)}");
}

//It must not be an anonymous function.
//It must be a top-level function (e.g. not a class method which requires initialization).

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  printf('Handling a background message ${message.messageId}');
  updateNavigation(message);
}
