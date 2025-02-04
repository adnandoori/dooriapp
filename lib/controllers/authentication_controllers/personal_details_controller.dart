import 'dart:convert';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PersonalDetailsController extends BaseController {
  BuildContext context;

  PersonalDetailsController(this.context);

  TextEditingController wightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String isSelected = "";

  FocusNode focusNodeHeight = FocusNode();
  FocusNode focusNodeWight = FocusNode();

  var arguments = Get.arguments;

  var name = '';
  var email = '';
  var gender = '';
  var dob = '';
  var password = '';
  var token = '';
  var userUId = '';
  int age = 0;
  late DatabaseReference dbRef;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dbRef = FirebaseDatabase.instance.ref().child('Users');

      printf('init_personal_detail');

      if (arguments != null) {
        name = arguments[0];
        email = arguments[1];
        dob = arguments[2];
        password = arguments[3];
        gender = arguments[4];
        userUId = arguments[5];
        age = arguments[6];
        token = arguments[7];
      } else {
        printf('null_arguments');
      }
    });
  }

  void callAddUser() {
    var now = DateTime.now();
    var formatter = DateFormat('dd-MMM-yyyy');
    String formattedDate = formatter.format(now);
    var formatterMonth = DateFormat('MMM, yyyy');
    Map<String, String> users = {
      'name': name,
      'email': email,
      'dob': dob,
      'gender': gender,
      'age': age.toString(),
      'height': heightController.text.trim(),
      'weight': wightController.text.trim(),
      'nonVegetarian': isSelected,
      'token': token,
      'date': formattedDate,
      'time': '${now.hour}:${now.minute}:${now.second}',
      'timeStamp': now.millisecondsSinceEpoch.toString(),
    };

    printf('usersUid-$userUId');
    printf('users-$users');

    Utility.isConnected().then((value) {
      if (value) {
        context.loaderOverlay.show();

        dbRef.child(userUId).set(users).whenComplete(() {
          Utility.setIsUserLoggedIn(true);
          Utility.setUserId(userUId);
          Utility.setUserDetails(jsonEncode(users));
          //Get.offNamedUntil(Routes.scanDeviceScreen, (route) => false);
          Get.offNamedUntil(Routes.startScanScreen, (route) => false);

          context.loaderOverlay.hide();
        });
      } else {
        Utility().snackBarForInternetIssue();
      }
    });
  }

  @override
  void onClose() {
    printf('close_login');
    super.onClose();
  }
}
