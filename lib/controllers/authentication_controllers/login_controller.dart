import 'dart:convert';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginController extends BaseController {
  BuildContext context;

  LoginController(this.context);

  TextEditingController textEmailController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();

  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  var deviceId = '';
  var fcmToken = '';

  late DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('Users');

  @override
  void onInit() {
    super.onInit();
    textEmailController.clear();
    textPasswordController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_login');
      getDeviceId();
      printFCMKey();
    });
  }

  /*@override
  void onReady() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('on_ready_login');
      printFCMKey();
    });
  }*/

  printFCMKey() async {
    try {
      fcmToken = (await FirebaseMessaging.instance.getToken())!;
    } catch (e) {
      printf('fcm-token-$fcmToken');
    }
    printf('fcmToken-$fcmToken');
  }

  @override
  void onClose() {
    printf('close_login');
    super.onClose();
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

  void callUserLogin() {
    Utility.isConnected().then((value) {
      if (value) {
        context.loaderOverlay.show();

        AuthenticationHelper()
            .signIn(
                email: textEmailController.text.trim(),
                password: textPasswordController.text.trim())
            .then((result) {
          if (result == null) {
            User user = AuthenticationHelper().user;
            printf('success-login-${user.uid}');
            Utility.setIsUserLoggedIn(true);

            Utility.setUserId(user.uid);
            //Utility.setUserId('v9OGlEA8h2hAPg1AzmGIFnOQzh42');
            var userId = user.uid; // 'v9OGlEA8h2hAPg1AzmGIFnOQzh42';

            //
            setUserDetails(userId).whenComplete(() {
              if (deviceId.isNotEmpty) {
                Get.offNamedUntil(Routes.dashboardScreen, (route) => false);
              } else {
                //Get.offNamedUntil(Routes.scanDeviceScreen, (route) => false);
                Get.offNamedUntil(Routes.startScanScreen, (route) => false);
              }

              context.loaderOverlay.hide();
              //       Get.offNamedUntil(Routes.dashboardScreen, (route) => false);
            });
          } else {
            printf('error-$result');
            context.loaderOverlay.hide();
            commonSnackBar(context, result.toString());
          }
        });
      } else {
        printf("offline");
        Utility().snackBarForInternetIssue();
      }
    });
  }

  Future<void> setUserDetails(String userId) async {
    if (userId.isNotEmpty) {
      dbRef.child(userId).update({'token': fcmToken});
      DataSnapshot snapshot = await dbRef.child(userId).get();
      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        Utility.setUserDetails(jsonEncode(data));
        update();
      }
    }
  }
}
