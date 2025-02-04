import 'package:doori_mobileapp/controllers/authentication_controllers/account_controller.dart';
import 'package:doori_mobileapp/localization/app_langauage_screen.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/scan_device_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:doori_mobileapp/utils/utility.dart';

import 'package:doori_mobileapp/widgets/account_widget.dart';
import 'package:doori_mobileapp/widgets/alert_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<String> titleList = [
    'profile_details'.tr,
    'share_app_with_friends'.tr,
    'customer_support'.tr,
    'about_doori'.tr,
    'choose_language'.tr
  ];

  List<String> imageList = [
    ImagePath.icProfileDetails,
    ImagePath.icShareIcon,
    ImagePath.icCustomerSupport,
    ImagePath.icAboutDoori,
    ImagePath.icLanguage
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      init: AccountController(context),
      builder: (controller) {
        return Scaffold(
            backgroundColor: HexColor('#F5f5f5'),
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  color: Colors.redAccent,
                  height: 220.h,
                  width: Get.width,
                  child: Stack(
                    children: [
                      Image.asset(
                        ImagePath.bgImageDashboard,
                        height: 220.h,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              printf('call_profile_icon');
                            },
                            child: Center(
                              child: Image.asset(
                                ImagePath.icUserProfile,
                                height: 75.w,
                                width: 75.w,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            controller.username.toTitleCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.w, top: 42.h),
                            child: Image.asset(
                              ImagePath.icBackButton,
                              width: 25.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 235.h),
                  child: SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: HexColor('#F5f5f5'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 12.w, right: 12.w),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0.5,
                              child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                height: 120.h,
                                width: Get.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'connect_to_another_device'.tr,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => const ScanDeviceScreen());
                                      },
                                      child: Container(
                                        width: 115.w,
                                        height: 38.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.w)),
                                          border: Border.all(
                                            color: Colors.blue,
                                            width: 2,
                                          ),
                                          color: Colors
                                              .transparent, //HexColor('#E3F7FF'),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'connect'.tr.toUpperCase(),
                                            style: defaultTextStyle(
                                              size: 13.sp,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Image.asset(
                                    //     height: 38.h,
                                    //     'assets/images/ic_btn_connect.png'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            width: Get.width,
                            margin: EdgeInsets.symmetric(horizontal: 12.w),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  //Get.to(TermsConditionScreen('http://www.doori.co.in/t&c'));
                                  onTap: () async {
                                    if (titleList[index] ==
                                        'profile_details'.tr) {
                                      Get.toNamed(Routes.myProfileScreen);
                                    } else if (titleList[index] ==
                                        'about_doori'.tr) {
                                      printf('clicked_about');
                                      String url = "https://www.doori.co.in";

                                      final parseUrl = Uri.parse(url);
                                      if (!await launchUrl(parseUrl,
                                          mode:
                                              LaunchMode.externalApplication)) {
                                        throw Exception(
                                            'Could not launch $parseUrl');
                                      }
                                    } else if (titleList[index] ==
                                        'customer_support'.tr) {
                                      // Get.to(AboutScreen(
                                      //     'https://www.doori.co.in/support',
                                      //     AppConstants.customerSupport));

                                      String email = Uri.encodeComponent(
                                          "Support@doori.co.in");
                                      String subject = Uri.encodeComponent(
                                          "Request for Customer support");
                                      String body = Uri.encodeComponent(
                                          "Hi! I'm Flutter Developer");
                                      printf(subject); //output: Hello%20Flutter
                                      Uri mail = Uri.parse(
                                          "mailto:$email?subject=$subject");
                                      if (await launchUrl(mail)) {
                                        //email app opened
                                        printf('email_app_open');
                                      } else {
                                        //email app is not opened
                                        printf('email_app_not_found');
                                      }
                                    } else if (titleList[index] ==
                                        'share_app_with_friends'.tr) {
                                      controller.share();
                                    } else if (titleList[index] ==
                                        'choose_language'.tr) {
                                      Get.to(AppLanguageScreen(
                                        routeName: 'account',
                                      ));
                                      //Get.toNamed(Routes.appLanguagesScreen);
                                    }
                                    /*else if (titleList[index] == AppConstants.deactivateAccount) {
                                    printf('deleted account');
                                    controller.deleteAccount();
                                  }*/
                                  },
                                  child: AccountWidget(
                                    title: titleList[index],
                                    image: imageList[index],
                                  ),
                                );
                              },
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: titleList.length,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.w, right: 12.w),
                            child: InkWell(
                              onTap: () {
                                Alerts.showAlertWithCancelAction(
                                  context,
                                  okTitle: 'ok'.tr,
                                  cancelTitle: 'cancel'.tr,
                                  () async {
                                    //Get.back();
                                    controller.callLogout();
                                  },
                                  alertTitle: 'log_out'.tr,
                                  alertMessage:
                                      "are_you_sure_you_want_to_logout".tr,
                                );
                              },
                              child: AccountWidget(
                                title: 'log_out'.tr,
                                image: ImagePath.icLogout,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 12.w, right: 12.w),
                            child: InkWell(
                              onTap: () {
                                //controller.deleteAccount();
                                printf('click deleted');
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                          'your_account_data_will_be'.tr,
                                          style: defaultTextStyle(
                                            size: 14.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        actions: [
                                          MaterialButton(
                                            textColor: ColorConstants.blueColor,
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child:
                                                Text('cancel'.tr.toUpperCase()),
                                          ),
                                          MaterialButton(
                                            textColor: ColorConstants.blueColor,
                                            onPressed: () {
                                              Get.back();
                                              //AuthenticationHelper().deActivateAccount();
                                            },
                                            child: Text(
                                                'confirm'.tr.toUpperCase()),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: AccountWidget(
                                title: 'deactivate_account'.tr,
                                image: ImagePath.icDeactivateAccount,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                controller.version.toString(),
                                style: defaultTextStyle(
                                  size: 14.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}
