import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/personal_details_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SignUpController extends BaseController {
  BuildContext context;

  SignUpController(this.context);

  TextEditingController textEmailController = TextEditingController();
  TextEditingController textPasswordController = TextEditingController();
  TextEditingController textConfirmPasswordController = TextEditingController();
  TextEditingController textNameController = TextEditingController();
  TextEditingController textDateOfBirthController = TextEditingController();

  String? dropDownValue = 'male'.tr;

  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  FocusNode focusNodeName = FocusNode();
  FocusNode focusNodeConfirm = FocusNode();

  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('Users');

  //late ScrollController? scrollController;

  int age = 0;

  bool isChecked = false;
  var fcmToken = '';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_register');
      printFCMKey();
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

  @override
  void onClose() {
    printf('close_register');
    //scrollController?.dispose();
    super.onClose();
  }

  void callUserRegister() {
    Utility.isConnected().then((value) {
      if (value) {
        context.loaderOverlay.show();
        AuthenticationHelper()
            .signUp(
                email: textEmailController.text.trim(),
                password: textConfirmPasswordController.text.trim())
            .then((result) {
          if (result == null) {
            User user = AuthenticationHelper().user;
            printf('success-register-${user.uid}');
            Utility.setIsUserLoggedIn(true);
            Utility.setUserId(user.uid);

            var now = DateTime.now();
            var formatter = DateFormat('dd-MMM-yyyy');
            String formattedDate = formatter.format(now);
            var formatterMonth = DateFormat('MMM, yyyy');

            Map<String, String> users = {
              'name': textNameController.text.trim(),
              'email': textEmailController.text.trim(),
              'dob': textDateOfBirthController.text.trim(),
              'gender': dropDownValue.toString(),
              'age': age.toString(),
              'token': fcmToken,
              'date': formattedDate,
              'time': '${now.hour}:${now.minute}:${now.second}',
              'timeStamp': now.millisecondsSinceEpoch.toString(),
            };

            dbRef.child(user.uid).set(users).whenComplete(() {
              context.loaderOverlay.hide();
              Get.toNamed(Routes.personalDetailsScreen, arguments: [
                textNameController.text.trim(),
                textEmailController.text.trim(),
                textDateOfBirthController.text.trim(),
                textConfirmPasswordController.text.trim(),
                dropDownValue,
                user.uid,
                age,
                fcmToken,
              ]);
            });
            //context.loaderOverlay.hide();
          } else {
            printf('error-$result');
            context.loaderOverlay.hide();
            commonSnackBar(context, result.toString());
          }
        });
      } else {
        Utility().snackBarForInternetIssue();
      }
    });
  }

}
