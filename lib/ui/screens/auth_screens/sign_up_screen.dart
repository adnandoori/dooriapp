import 'package:doori_mobileapp/controllers/authentication_controllers/sign_up_controller.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/login_screen.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/terms_condition_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:doori_mobileapp/utils/style.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:doori_mobileapp/utils/validator.dart';
import 'package:doori_mobileapp/widgets/button_widget.dart';
import 'package:doori_mobileapp/widgets/text_form_field.dart';
import 'package:doori_mobileapp/widgets/validations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double scrollValue = 0.0;
  double topHeaderHeight = 250.h;

  double opacity = 1.0;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (context.mounted) {
        scrollValue = scrollController.offset;
        printf('scroll-${scrollController.offset}');
        /*if (scrollValue > 10) {
              opacity = 0;
            } else {
              opacity = 1;
            }*/
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return GetBuilder<SignUpController>(
      init: SignUpController(context),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            printf('keyboard_dismissed');
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: HexColor('#fcfbfa'),
            body: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: scrollValue > 10 ? 180.h : 250.h,
                    width: Get.width,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: Get.width,
                          child: Image.asset(
                            ImagePath.icAuthBackground,
                            height: scrollValue > 10 ? 180.h : 250.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 15.w,
                                right: 15.w,
                                top: scrollValue > 10 ? 30.h : 0),
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
                                AnimatedOpacity(
                                  opacity: scrollValue > 15 ? 0 : 1, //opacity,
                                  duration: const Duration(seconds: 1),
                                  child: Text(
                                    'provide_your_profile'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppConstants.fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              top: 25.h,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppTextField(
                                    validators: nameValidator,
                                    controller: controller.textNameController,
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter()
                                    ],
                                    label: 'name'.tr,
                                    hint: 'name'.tr,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 150.w,
                                        child: AppTextField(
                                          label: 'date_of_birth'.tr,
                                          keyboardType: TextInputType.phone,
                                          readOnly: true,
                                          validators: dateOfBirthValidator,
                                          hint: 'date_of_birth'.tr,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime(
                                                        DateTime.now().year -
                                                            18),
                                                    firstDate: DateTime(1901),
                                                    lastDate: DateTime(2100));

                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              printf(formattedDate);
                                              setState(() {
                                                controller
                                                    .textDateOfBirthController
                                                    .text = formattedDate;
                                                DateTime selectedDate =
                                                    DateTime(
                                                        pickedDate.year,
                                                        pickedDate.month,
                                                        pickedDate.day);

                                                DateTime todayDate =
                                                    DateTime.now();

                                                controller.age = todayDate.year - selectedDate.year;
                                              });
                                            }
                                          },
                                          maxLength: 11,
                                          inputFormatters: [
                                            NoLeadingSpaceFormatter()
                                          ],
                                          controller: controller
                                              .textDateOfBirthController,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        width: 160.w,
                                        padding: EdgeInsets.only(
                                            left: 10.w, right: 10.w),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1.w),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: controller.dropDownValue,
                                            onChanged: (value) {
                                              setState(() {
                                                controller.dropDownValue =
                                                    value;
                                              });
                                            },
                                            underline: Container(),
                                            isExpanded: true,
                                            items: [
                                              "male".tr,
                                              "female".tr,
                                              "other".tr
                                            ].map<DropdownMenuItem<String>>(
                                                  (String value) =>
                                                      DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: textMedium.copyWith(
                                                          color: Colors.grey,
                                                          fontSize: 15.sp,
                                                          fontFamily:
                                                              AppConstants
                                                                  .fontFamily),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  AppTextField(
                                    validators: emailValidator,
                                    label: 'email'.tr,
                                    hint: 'email'.tr,
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter()
                                    ],
                                    keyboardType: TextInputType.emailAddress,
                                    controller: controller.textEmailController,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  AppTextField(
                                    validators: passwordValidator,
                                    label: 'password'.tr,
                                    hint: 'password'.tr,
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter()
                                    ],
                                    controller:
                                        controller.textPasswordController,
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  AppTextField(
                                    validators: (val) {
                                      if (controller
                                              .textConfirmPasswordController
                                              .text ==
                                          "") {
                                        return "please_enter_confirm_password"
                                            .tr;
                                      }
                                      if (val !=
                                          controller
                                              .textPasswordController.text) {
                                        return 'confirm_password_not_matching'
                                            .tr;
                                      }

                                      return null;
                                    },
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter()
                                    ],
                                    label: 'confirm_password'.tr,
                                    hint: 'confirm_password'.tr,
                                    keyboardAction: TextInputAction.done,
                                    controller: controller
                                        .textConfirmPasswordController,
                                    obscureText: true,
                                    onSubmit: (_) {
                                      printf('submitted');
                                      scrollController.animateTo(0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.fastOutSlowIn);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 5.h),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.isChecked,
                                  onChanged: (v) {
                                    controller.isChecked = v!;
                                    controller.update();
                                  },
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                ),
                                Expanded(
                                  child:
                                      //Text('I accept the terms and conditions'),
                                      Text.rich(TextSpan(
                                          text: 'i_accept_the'.tr,
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: HexColor('#626262'),
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ),
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: "terms_and_conditions".tr,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Get.to(TermsConditionScreen(
                                                    'http://www.doori.co.in/t&c'));
                                              }),
                                      ])),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                            ),
                            child: Column(
                              children: [
                                AppButton('continue'.tr, height: 40.h, () {
                                  if (_formKey.currentState!.validate())
                                  {
                                    if (controller.age >= 18)
                                    {
                                      if (controller.isChecked)
                                      {
                                        controller.callUserRegister();
                                      } else {
                                        Utility().snackBarError(
                                            'please_accept_terms_and_condition'
                                                .tr);
                                      }
                                    } else {
                                      Utility().snackBarError(
                                          'please_select_proper_date'.tr);
                                    }
                                  }
                                }),
                                SizedBox(
                                  height: 13.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const LoginScreen());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'already_registered'.tr,
                                        style: const TextStyle(
                                          fontFamily: AppConstants.fontFamily,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        'sign_in'.tr,
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
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

extension DateTimeX on DateTime {
  bool isUnderage() =>
      (DateTime(DateTime.now().year, month, day).isAfter(DateTime.now())
          ? DateTime.now().year - year - 1
          : DateTime.now().year - year) <
      18;
}

/*
body: SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: scrollValue > 10 ? 180.h : 250.h,
                    width: Get.width,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: Get.width,
                          child: Image.asset(
                            ImagePath.icAuthBackground,
                            height: scrollValue > 10 ? 180.h : 250.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 15.w,
                                right: 15.w,
                                top: scrollValue > 10 ? 30.h : 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppConstants.welcomeToDoori,
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
                                AnimatedOpacity(
                                  opacity: scrollValue > 25 ? 0 : 1, //opacity,
                                  duration: const Duration(seconds: 1),
                                  child: Text(
                                    AppConstants.welcomeSubText,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppConstants.fontFamily,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              top: 25.h,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppTextField(
                                    validators: nameValidator,
                                    controller: controller.textNameController,
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter()
                                    ],
                                    label: AppConstants.name,
                                    hint: AppConstants.name,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 150.w,
                                        child: AppTextField(
                                          label: AppConstants.dateOfBirth,
                                          keyboardType: TextInputType.phone,
                                          readOnly: true,
                                          validators: dateOfBirthValidator,
                                          hint: AppConstants.dateOfBirth,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime(
                                                        DateTime.now().year -
                                                            18),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2100));

                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(pickedDate);
                                              printf(formattedDate);
                                              setState(() {
                                                controller
                                                    .textDateOfBirthController
                                                    .text = formattedDate;
                                                DateTime selectedDate =
                                                    DateTime(
                                                        pickedDate.year,
                                                        pickedDate.month,
                                                        pickedDate.day);

                                                DateTime todayDate =
                                                    DateTime.now();

                                                controller.age =
                                                    todayDate.year -
                                                        selectedDate.year;
                                              });
                                            }
                                          },
                                          maxLength: 11,
                                          inputFormatters: [
                                            NoLeadingSpaceFormatter()
                                          ],
                                          controller: controller
                                              .textDateOfBirthController,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        width: 160.w,
                                        padding: EdgeInsets.only(
                                            left: 10.w, right: 10.w),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                width: 1.w),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: controller.dropDownValue,
                                            onChanged: (value) {
                                              setState(() {
                                                controller.dropDownValue =
                                                    value;
                                              });
                                            },
                                            underline: Container(),
                                            isExpanded: true,
                                            items: ["Male", "Female", "Other"]
                                                .map<DropdownMenuItem<String>>(
                                                  (String value) =>
                                                      DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: textMedium.copyWith(
                                                          color: Colors.grey,
                                                          fontSize: 15.sp,
                                                          fontFamily:
                                                              AppConstants
                                                                  .fontFamily),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  AppTextField(
                                    validators: emailValidator,
                                    label: AppConstants.email,
                                    hint: AppConstants.email,
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter()
                                    ],
                                    keyboardType: TextInputType.emailAddress,
                                    controller: controller.textEmailController,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  AppTextField(
                                    validators: passwordValidator,
                                    label: AppConstants.password,
                                    hint: AppConstants.password,
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter()
                                    ],
                                    controller:
                                        controller.textPasswordController,
                                    obscureText: true,
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  AppTextField(
                                    validators: (val) {
                                      if (controller
                                              .textConfirmPasswordController
                                              .text ==
                                          "") {
                                        return 'Please enter confirm password';
                                      }
                                      if (val !=
                                          controller
                                              .textPasswordController.text) {
                                        return 'Confirm password not matching';
                                      }

                                      return null;
                                    },
                                    inputFormatters: [
                                      NoLeadingSpaceFormatter()
                                    ],
                                    label: AppConstants.confirmPassword,
                                    hint: AppConstants.confirmPassword,
                                    keyboardAction: TextInputAction.done,
                                    controller: controller
                                        .textConfirmPasswordController,
                                    obscureText: true,
                                    onSubmit: (_) {
                                      printf('submitted');
                                      scrollController.animateTo(0,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.fastOutSlowIn);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.w, vertical: 5.h),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.isChecked,
                                  onChanged: (v) {
                                    controller.isChecked = v!;
                                    controller.update();
                                  },
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                ),
                                Expanded(
                                  child:
                                      //Text('I accept the terms and conditions'),
                                      Text.rich(TextSpan(
                                          text: 'I accept the ',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: HexColor('#626262'),
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                          ),
                                          children: <TextSpan>[
                                        TextSpan(
                                            text: "terms and conditions",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                              fontStyle: FontStyle.normal,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                Get.to(TermsConditionScreen(
                                                    'http://www.doori.co.in/t&c'));
                                              }),
                                      ])),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                            ),
                            child: Column(
                              children: [
                                AppButton(AppConstants.continueText,
                                    height: 40.h, () {
                                  if (_formKey.currentState!.validate()) {
                                    if (controller.age >= 18) {
                                      if (controller.isChecked) {
                                        controller.callUserRegister();
                                      } else {
                                        Utility().snackBarError(
                                            'Please accept terms and condition');
                                      }
                                    } else {
                                      Utility().snackBarError(
                                          'Please select proper date');
                                    }
                                  }
                                }),
                                SizedBox(
                                  height: 13.h,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => const LoginScreen());
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text(
                                        AppConstants.alreadyRegister,
                                        style: TextStyle(
                                          fontFamily: AppConstants.fontFamily,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        AppConstants.signIn,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: AppConstants.fontFamily,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
 */
