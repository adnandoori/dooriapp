import 'dart:convert';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';

class ForgotPasswordController extends BaseController {
  BuildContext context;

  ForgotPasswordController(this.context);

  TextEditingController textEmailController = TextEditingController();

  FocusNode focusNodeEmail = FocusNode();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_forgot');
    });
  }

  @override
  void onClose() {
    printf('close_login');
    super.onClose();
  }

  getPassword() {
    Utility.isConnected().then((value) {
      if (value) {
        context.loaderOverlay.show();
        AuthenticationHelper()
            .forgotPassword(
          email: textEmailController.text.trim(),
        )
            .then((result) {
          context.loaderOverlay.hide();
          printf('forgot-$result');
          if (result.toString() == 'null') {
            Utility().snackBarSuccess("reset_password_link_has_been_sent.".tr);
            Get.back();
          } else {
            printf('else');
            Utility().snackBarError(result.toString());
            update();
          }
        });
      } else {
        Utility().snackBarForInternetIssue();
      }
    });
  }
}
