import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SymptomCheckerScreen extends StatelessWidget {
  const SymptomCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstants.blueColor,
        appBar: commonAppbar(onBack: () {
          Get.back();
        }),
        body: Column(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppConstants.areYouFeelingIll,
                  style: defaultTextStyle(
                    size: 22.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
                  child: Text(
                    AppConstants.enterYourSymptom,
                    textAlign: TextAlign.center,
                    style: defaultTextStyle(
                      size: 14.sp,
                      lineHeight: 1.3,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
              child: commonButton(
                  title: AppConstants.addSymptoms.toUpperCase(),
                  onTap: () {
                    Get.toNamed(Routes.addSymptomScreen);
                  },
                  bgColor: const Color(0xFFFFFFFF),
                  textColor: ColorConstants.blueColor),
            )
          ],
        ),
      ),
    );
  }
}
