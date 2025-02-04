import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MeditationTestScreen extends StatelessWidget {
  const MeditationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: commonAppbar(
              title: AppConstants.meditationTest.toUpperCase(),
              onBack: () {
                Get.back();
              }),
          body: SingleChildScrollView(
            child: Column(
              children: [
                widgetConnectDevice(),
                widgetDivider(height: 1.h, hexColor: '#BDBDBD'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text(
                    AppConstants.previousResults,
                    style: defaultTextStyle(
                        size: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    widgetPrevious(),
                    widgetPrevious(),
                    widgetPrevious()
                  ],
                )
              ],
            ),
          )),
    );
  }
}

Widget widgetPrevious() {
  return SizedBox(
      width: Get.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '13/01/2022 04:20:57',
                      style: defaultTextStyle(
                        size: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: HexColor('#757575'),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.relaxed,
                              style: defaultTextStyle(
                                size: 12.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              ' 0.00 %',
                              style: defaultTextStyle(
                                size: 12.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          width: 1.w,
                          height: 35.h,
                          color: Colors.grey,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.neutral,
                              style: defaultTextStyle(
                                size: 12.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              ' 33.33 %',
                              style: defaultTextStyle(
                                size: 12.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          width: 1.w,
                          height: 35.h,
                          color: Colors.grey,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppConstants.focused,
                              style: defaultTextStyle(
                                size: 12.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              ' 66.67 %',
                              style: defaultTextStyle(
                                size: 12.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )),
                SizedBox(
                  width: 70.w,
                  height: 65.w,
                  child: CircularPercentIndicator(
                    radius: 26.h,
                    lineWidth: 7.w,
                    percent: 0.7,
                    center: Text(
                      "6",
                      style: defaultTextStyle(
                          size: 30.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                    progressColor: ColorConstants.blueColor,
                  ),
                )
              ],
            ),
          ),
          widgetDivider(height: 1.h, hexColor: '#BDBDBD'),
        ],
      ));
}

Widget widgetConnectDevice() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
    child: Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Container(
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: HexColor('#FFFFFF'),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.h,
              ),
              Text(
                AppConstants.evaluateYourMeditation,
                style: defaultTextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    size: 16.sp),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                child: Text(
                  AppConstants.tapOnTheThreeDots,
                  textAlign: TextAlign.center,
                  style: defaultTextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      size: 14.sp),
                ),
              ),
              Image.asset(
                ImagePath.icMeditation,
                height: 70.w,
                width: 70.w,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                child: commonButton(
                    title: AppConstants.connectToDevice.toUpperCase(),
                    onTap: () {}),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
