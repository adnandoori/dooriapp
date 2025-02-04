import 'dart:convert';

import 'package:doori_mobileapp/controllers/authentication_controllers/account_controller.dart';
import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/dashboard_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/models/authentication_model/user_model.dart';
import 'package:doori_mobileapp/models/graph/bmi_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ProfileController extends BaseController {
  BuildContext context;

  ProfileController(this.context);

  late DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('Users');
  late DatabaseReference dbBMI =
      FirebaseDatabase.instance.ref().child(AppConstants.tableBMI);
  late UserModel userModel;

  var username = '';
  var email = '';
  var dob = '';
  var gender = '';
  var height = '';
  var weight = '';

  TextEditingController textNameController = TextEditingController();
  TextEditingController textDateOfBirthController = TextEditingController();
  TextEditingController textWeightController = TextEditingController();
  TextEditingController textHeightController = TextEditingController();

  int age = 0;
  String? dropDownValue = 'male'.tr;
  bool isEditable = false;
  String isSelected = "";
  var token = '';
  String userId = '';

//  late DashboardController dashboardController;
//  late AccountController accountController;

  var arguments = Get.arguments;

  var fromScreen = '';
  bool isDataUpdate = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_profile');

      try {
        fromScreen = arguments[0];
      } catch (e) {
        printf('exe---64-->${e.toString()}');
      }

      printf('--from---screen--->$fromScreen');

      //dashboardController = Get.put(DashboardController(context));
      //accountController = Get.put(AccountController(context));

      User user = AuthenticationHelper().user;
      printf('userUId-${user.uid}');
      userId = user.uid;
      getUserDetail(user.uid);
    });
  }

  void getUserDetail(userId) async {
    Utility.isConnected().then((value) async {
      if (value) {
        printf('userId-$userId');
        context.loaderOverlay.show();
        DataSnapshot snapshot = await dbRef.child('$userId').get();
        if (snapshot.exists) {
          final data = Map<String, dynamic>.from(snapshot.value as Map);
          Utility.setUserDetails(jsonEncode(data));
          userModel = UserModel.fromJson(data);
          printf('snap$data');

          /*if (userModel.name.toString().isNotEmpty) {
            username =
                "${userModel.name.toString()[0].toUpperCase()}${userModel.name.toString().substring(1).toLowerCase()}";
          }*/

          printf('---register--user--date-->${userModel.dateForRegister} time-->${userModel.time}');

          username = userModel.name.toString();

          try {
            Get.lazyPut(() => AccountController(context));
            Get.lazyPut(() => DashboardController(context));

            Get.find<AccountController>().username = username;
            Get.find<AccountController>().update();

            Get.find<DashboardController>().username = username;
            Get.find<DashboardController>().userHeight =
                textHeightController.text.trim();
            Get.find<DashboardController>().userWeight =
                textWeightController.text.trim();
            Get.find<DashboardController>().getBMIValue(
              height: textHeightController.text.trim(),
              weight: textWeightController.text.trim(),
            );

            Get.find<DashboardController>().update();
          } catch (e) {
            printf('exe---108-->${e.toString()}');
          }

          /*accountController.username = username;
          accountController.update();

          dashboardController.username = username;
          dashboardController.update();*/

          email = userModel.email.toString();
          dob = userModel.dob.toString();
          gender = userModel.gender.toString();
          height = userModel.height.toString();
          weight = userModel.weight.toString();

          textNameController.text = username.toString();

          dropDownValue = gender.toLowerCase().tr;

          textDateOfBirthController.text = userModel.dob.toString();
          textWeightController.text = weight;
          textHeightController.text = height;

          isSelected = userModel.nonVegetarian.toString();
          token = userModel.token.toString();

          printf('date - ${userModel.dob} $gender');

          Get.context!.loaderOverlay.hide();
          update();
        } else {
          printf('No data available.');
          Get.context!.loaderOverlay.hide();
        }
      } else {
        Utility.getUserDetails().then((value) {
          if (value != null) {
            userModel = value;
            printf('userOffline-${userModel.name}');
            try {
              //username = userModel.name.toString()[0].toUpperCase() + userModel.name.toString().substring(1);

              username = userModel.name.toString();

              email = userModel.email.toString();
              dob = userModel.dob.toString();
              gender = userModel.gender.toString();
              height = userModel.height.toString();
              weight = userModel.weight.toString();
            } catch (exe) {
              printf('exeOffline-$exe');
            }
            update();
          }
        });
        Utility().snackBarForInternetIssue();
      }
    });
  }

  void callUpdateUserDetail(todayKey) {
    Map<String, String> users = {
      'name': textNameController.text.trim(),
      'email': email,
      'dob': textDateOfBirthController.text.trim(),
      'gender': dropDownValue.toString(),
      'age': age.toString(),
      'height': textHeightController.text.trim(),
      'weight': textWeightController.text.trim(),
      'nonVegetarian': isSelected,
      'token': token,
    };

    printf('users-$userId');
    printf('users-$users');
    isEditable = false;
    update();

    Utility.isConnected().then((value) async {
      if (value) {
        context.loaderOverlay.show();

        await dbRef.child(userId).set(users).whenComplete(() {
          callUpdateBMIValue(todayKey).whenComplete(() {
            context.loaderOverlay.hide();

            if (fromScreen.isNotEmpty) {
              isDataUpdate = true;
            } else {
              printf('--from--is--null');
            }

            getUserDetail(userId);
          });
        });
      } else {
        Utility().snackBarForInternetIssue();
      }
    });
  }

  Future<void> callCheckTodayBMIRecords() async {
    var todayDate = DateTime.now();
    var todayDateTemp =
        DateTime(todayDate.year, todayDate.month, todayDate.day);
    var resultFormatter = DateFormat('dd-MMM-yyyy');
    var today = resultFormatter.format(todayDateTemp);
    printf('--call--check--bmi--records--for--today--$today');

    var todayKey = '';

    DataSnapshot snapshot = await dbBMI.child(userId).get();
    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        BMIModel bmiModel = BMIModel.fromJson(data);
        if (bmiModel.dateTime == today) {
          todayKey = element.key.toString();
        }
      });
      printf('---element--today-->$todayKey');
      callUpdateUserDetail(todayKey);
    } else {
      callUpdateUserDetail(todayKey);
      printf('not---today--record--found----please--add--record');
    }
  }

  Future<void> callUpdateBMIValue(String todayKey) async {
    printf('--call--update--bmi--value');

    var now = DateTime.now();
    var formatter = DateFormat('dd-MMM-yyyy');
    String formattedDate = formatter.format(now);
    var formatterMonth = DateFormat('MMM, yyyy');

    BMIModel bmiModel = BMIModel(
      userId: userId,
      username: textNameController.text.trim(),
      height: textHeightController.text.trim(),
      weight: textWeightController.text.trim(),
      dob: textDateOfBirthController.text.trim(),
      isSync: 'true',
      dateTime: formattedDate,
      monthYear: formatterMonth.format(now),
      measureTime: '${now.hour}:${now.minute}:${now.second}',
      timeStamp: now.millisecondsSinceEpoch,
    );

    printf('---bmi---value--${bmiModel.toJson()}');

    if (todayKey.isNotEmpty) {
      await dbBMI
          .child(userId)
          .child(todayKey)
          .update(bmiModel.toJson())
          .whenComplete(() {
        printf('---updated---here---$todayKey');
      });
    } else {
      await dbBMI.child(userId).push().set(bmiModel.toJson()).whenComplete(() {
        context.loaderOverlay.hide();
      });
    }
  }

  @override
  void onClose() {
    printf('close_profile');
    super.onClose();
  }
}
