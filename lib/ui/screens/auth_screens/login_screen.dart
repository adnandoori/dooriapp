import 'package:doori_mobileapp/controllers/authentication_controllers/login_controller.dart';
import 'package:doori_mobileapp/localization/app_langauage_screen.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/forgot_password_screen.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/sign_up_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/dashboard_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';

import 'package:doori_mobileapp/utils/validator.dart';
import 'package:doori_mobileapp/widgets/button_widget.dart';
import 'package:doori_mobileapp/widgets/text_form_field.dart';
import 'package:doori_mobileapp/widgets/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(context),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: HexColor('#fcfbfa'),
            resizeToAvoidBottomInset: false,
            body: Form(
              key: _formKey,
              child: SizedBox(
                width: Get.width,
                height: Get.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 250.h,
                          width: Get.width,
                          child: Stack(
                            children: [
                              Image.asset(
                                ImagePath.icAuthBackground,
                                height: 250.h,
                                fit: BoxFit.fill,
                                width: Get.width,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 15.w, right: 15.w, bottom: 20.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'welcome'.tr,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: AppConstants.fontFamily,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      'provide_your_profile'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppConstants.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.only(top: 30.h, right: 10.w),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(AppLanguageScreen(
                                      routeName: 'login',
                                    ));
                                  },
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Image.asset(
                                      'assets/images/ic_language.png',
                                      height: 30.w,
                                      width: 30.w,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w, right: 15.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppTextField(
                                label: 'email'.tr,
                                hint: 'email'.tr,
                                keyboardType: TextInputType.emailAddress,
                                validators: emailValidator,
                                inputFormatters: [NoLeadingSpaceFormatter()],
                                controller: controller.textEmailController,

                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              AppTextField(
                                label: 'password'.tr,
                                hint: 'password'.tr,
                                obscureText: true,
                                inputFormatters: [NoLeadingSpaceFormatter()],
                                keyboardAction: TextInputAction.done,
                                controller: controller.textPasswordController,
                                validators: passwordValidator,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    _formKey.currentState?.reset();
                                    Get.to(() => const ForgotPasswordScreen());
                                  },
                                  child: Text(
                                    "forgot_password".tr,
                                    style: const TextStyle(
                                      fontFamily: AppConstants.fontFamily,
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        children: [
                          AppButton('login'.tr, height: 40.h, () {
                            if (_formKey.currentState!.validate())
                            {
                              controller.callUserLogin();
                              /*Get.to(() => const DashboardScreen());
                              controller.textPasswordController.text = "";
                              controller.textEmailController.text = "";*/
                            }
                          }),
                          SizedBox(
                            height: 15.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              _formKey.currentState?.reset();
                              Get.to(() => const SignUpScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'not_a_member'.tr,
                                  style: const TextStyle(
                                    fontFamily: AppConstants.fontFamily,
                                  ),
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  'sign_up_now'.tr,
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontFamily: AppConstants.fontFamily,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

