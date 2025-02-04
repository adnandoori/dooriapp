import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/models/authentication_model/user_model.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:doori_mobileapp/widgets/alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

class AccountController extends BaseController {
  BuildContext context;

  AccountController(this.context);

  var arguments = Get.arguments;

  late UserModel userModel;

  var username = '';
  var version = 'v 0.0';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_account');
      getCurrentVersion();
      if (arguments != null) {
        try {
          userModel = arguments[0];

          /*if (userModel.name.toString().isNotEmpty) {
          username =
              "${userModel.name.toString()[0].toUpperCase()}${userModel.name.toString().substring(1).toLowerCase()}";
        }*/

          username = userModel.name.toString();
          username.toTitleCase();

          printf('userModel-${userModel.name.toString()}');
          update();
        } catch (e) {
          printf('exe--55-->${e.toString()}');
        }
      } else {
        printf('null_arguments');
      }
    });
  }

  void getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = 'v ${packageInfo.version}.${packageInfo.buildNumber} ';
    printf('version-$version ${packageInfo.buildNumber}');
    update();
  }

  void callLogout() {
    context.loaderOverlay.show();

    AuthenticationHelper().signOut().whenComplete(() {
      printf('Logout');
      Get.back();
      Utility().snackBarSuccess('successfully_logged_out'.tr);
      Utility.setIsUserLoggedIn(false);
      Utility.setUserId('');
      Utility().setUserRecordList([]);
      Utility().setUserBodyHealthRecordList([]);
      Get.deleteAll();
      Get.offNamedUntil(Routes.loginScreen, (route) => false);
      context.loaderOverlay.hide();
    });
  }

  Future<void> share() async {
    await Share.share(
        'Doori \n\nHey please download the app to ensure vigilance in this time of pandemic. \n\nhttp://www.doori.co.in');
  }

  deleteAccount() {
    var width = Get.size.width;
    return AlertDialog(
      title: const Text('Welcome'),
      // To display the title it is optional
      content: const Text('Doori'),

      actions: [
        MaterialButton(
          textColor: Colors.black,
          onPressed: () {},
          child: const Text('CANCEL'),
        ),
        MaterialButton(
          textColor: Colors.black,
          onPressed: () {},
          child: const Text('CONFIRM'),
        ),
      ],
    );
  }

  @override
  void onClose() {
    printf('close_account');
    super.onClose();
  }
}
