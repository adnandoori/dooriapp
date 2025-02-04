import 'package:doori_mobileapp/controllers/authentication_controllers/personal_details_controller.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/scan_device_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:doori_mobileapp/utils/validator.dart';
import 'package:doori_mobileapp/widgets/button_widget.dart';
import 'package:doori_mobileapp/widgets/text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonalDetailsController>(
      init: PersonalDetailsController(context),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 250.h,
                            width: MediaQuery.of(context).size.width,
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
                                    Center(
                                      child: Image.asset(
                                        ImagePath.icUserProfile,
                                        height: 75.w,
                                        width: 75.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    const Text(
                                      AppConstants.enterPersonalDetails,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: AppConstants.fontFamily,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  AppConstants.personalDetailsSubText,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 150.w,
                                      child: AppTextField(
                                        label: AppConstants.heightInCms,
                                        hint: AppConstants.heightInCms,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        validators: heightValidator,
                                        controller: controller.heightController,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 150.w,
                                      child: AppTextField(
                                        label: AppConstants.weightInKgs,
                                        hint: AppConstants.weightInKgs,
                                        keyboardAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        validators: weightValidator,
                                        controller: controller.wightController,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                const Text(
                                  AppConstants.counsumeNonVeg,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 100.w,
                                      child: RadioListTile(
                                        title: const Text(AppConstants.yes),
                                        contentPadding: const EdgeInsets.all(0),
                                        value: "Yes",
                                        groupValue: controller.isSelected,
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              controller.isSelected =
                                                  value.toString();
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100.w,
                                      child: RadioListTile(
                                        title: const Text(AppConstants.no),
                                        value: "No",
                                        contentPadding: const EdgeInsets.all(0),
                                        groupValue: controller.isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            controller.isSelected =
                                                value.toString();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: 40.h, left: 20.w, right: 20.w),
                        child: AppButton(AppConstants.next, () {
                          if (_formKey.currentState!.validate()) {
                            if (controller.isSelected != "") {
                              controller.callAddUser();
                            } else {
                              commonSnackBar(
                                  context, AppConstants.selectAnyOne);
                            }
                          }
                        }, height: 40.h),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
