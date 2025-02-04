import 'dart:async';
import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/fcm/push_notification_manager.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class SplashController extends BaseController {
  BuildContext context;

  SplashController(this.context);

  bool isUserLogin = false;

  var deviceId = '';
  var fcmToken = '';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PushNotificationsManager().init();
      checkLoginOrNot();
      getDeviceId();
      navigateToHomeScreen();
      //checkPermissionStatus();

      printFCMKey();
    });
  }

  //eEU3vcRKR1qstE-EgS19mD:APA91bGogOkHwp2LN0BAUKcKkcrTTp4whg2iT5NDwL3NqJABtyiIZPajpCgi8H5QJLIqzeBAQ5T4KQ9yZi8tgNdjEgUJsRhdPFiZTRqMcM-QbG-XyhgTBEBvn7rp3lDFssGkyf1rIprg

  void navigateToHomeScreen() {
    var duration = const Duration(
      seconds: 4,
    );
    Timer(duration, () async {
      if (isUserLogin)
      {
        if (kDebugMode) {
          Get.offNamedUntil(Routes.dashboardScreen, (route) => false);
        } else {
          if (deviceId.isNotEmpty) {
            Get.offNamedUntil(Routes.dashboardScreen, (route) => false);
          } else {
            Get.offNamedUntil(Routes.startScanScreen, (route) => false);
          }
        }
      } else {
        Get.offNamedUntil(Routes.loginScreen, (route) => false);
      }
    });
  }

  printFCMKey() async {
    try {
      fcmToken = (await FirebaseMessaging.instance.getToken())!;
    } catch (e) {
      printf('fcm-token-$fcmToken');
    }
    printf('fcmToken-$fcmToken');
  }

  void getDeviceId() async {
    printf('get_device_id');
    try {
      deviceId = await Utility.getDeviceId();
      printf('deviceId-$deviceId');
    } catch (exe) {
      printf('exe-deviceToken$exe');
    }
  }

  void checkLoginOrNot() async {
    try {
      isUserLogin = (await Utility.getIsUserLoggedIn())!;
    } catch (e) {
      printf('exe_$e');
    }
    printf('checkLogin->$isUserLogin');
  }
}
