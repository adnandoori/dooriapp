import 'package:doori_mobileapp/controllers/measure_controllers/measure_result_reading_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class ResultReadingsScreen extends StatelessWidget {
  const ResultReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    var b = h > 1050 ? h * 0.25 : h * 0.17;

    return GetBuilder<MeasureResultReadingController>(
        init: MeasureResultReadingController(context),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SizedBox(
                height: h, //Get.height,
                width: w, //Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //   child: Padding(
                        //     padding: EdgeInsets.only(left: 10.w, top: 40.h),
                        //     child: InkWell(
                        //       onTap: () {
                        //         Get.back(result: 'back');
                        //       },
                        //       child: Image.asset(
                        //         ImagePath.icBackBtn,
                        //         height: 30.w,
                        //         width: 30.w,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 70.h,),
                        Text(
                          'your_readings'.tr,
                          textAlign: TextAlign.center,
                          style: defaultTextStyle(
                              size: 22.sp,
                              color: ColorConstants.textColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        widgetBodyHealth(controller),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 22.w, vertical: 10.h),
                          child: Material(
                            elevation: 3,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: Container(
                              width: Get.width,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  widgetYourReading(
                                      ImagePath.icHeartRate,
                                      'heart_rate'.tr,
                                      controller.heartRate.toString(),
                                      'bpm'.tr),
                                  widgetYourReading(
                                      ImagePath.icOxygenLevel,
                                      'oxygen_level'.tr,
                                      controller.oxygen.toString(),
                                      '%'),
                                  widgetYourReading(
                                      ImagePath.icBloodPressure,
                                      'blood_pressure'.tr,
                                      controller.bloodPressure.toString(),
                                      'mmHg'.tr),
                                  widgetYourReading(
                                      ImagePath.icHRV,
                                      'hr_variability'.tr,
                                      controller.hrVariability.toString(),
                                      'ms'.tr),
                                  widgetYourReading(
                                      ImagePath.icStroke,
                                      'pulse_pressure'.tr,
                                      controller.pulsePressure.toString(),
                                      'mmHg'.tr),
                                  widgetYourReading(
                                      ImagePath.icCardiac,
                                      'arterial_pressure'.tr,
                                      controller.arterialPressure.toString(),
                                      'mmHg'.tr),
                                  widgetYourReading(
                                      ImagePath.icActivity,
                                      'activity'.tr,
                                      controller.activity.toString(),
                                      ''),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                    SizedBox(
                      width: Get.width,
                      height: b, //124.h,
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white,
                            child: WaveWidget(
                              config: CustomConfig(
                                colors: [
                                  Colors.blue.withOpacity(0.5),
                                  Colors.blue.withOpacity(0.7),
                                  Colors.blue.withOpacity(0.4),
                                  //the more colors here, the more wave will be
                                ],
                                durations: [4000, 5000, 7000],
                                heightPercentages: [0.01, 0.05, 0.03],
                                blur: const MaskFilter.blur(BlurStyle.solid, 5),
                              ),

                              waveAmplitude: 0.00,
                              //depth of curves
                              waveFrequency: 3,
                              //number of curves in waves
                              backgroundColor: Colors.transparent,
                              //background colors
                              size: const Size(
                                double.infinity,
                                double.infinity,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 15.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      height: 37.h,
                                      child: commonButton(
                                          title: 'retry'.tr,
                                          onTap: () {
                                            controller.buttonRetry();
                                          },
                                          bgColor: Colors.white,
                                          textColor: ColorConstants.textColor),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      height: 37.h,
                                      child: commonButton(
                                          title: 'save'.tr,
                                          onTap: () {
                                            controller.buttonSave();
                                          },
                                          bgColor: Colors.white,
                                          textColor: ColorConstants.textColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Widget widgetYourReading(
    String icon, String title, String value, String valueTwo) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    child: Row(
      children: [
        Image.asset(
          icon,
          height: 22.w,
          width: 22.w,
        ),
        SizedBox(
          width: 5.w,
        ),
        Text(
          title,
          style: defaultTextStyle(
              size: 14.sp,
              lineHeight: 1.3,
              fontWeight: FontWeight.w500,
              color: Colors.black),
        ),
        Expanded(
          child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: defaultTextStyle(
                        size: 16.sp,
                        lineHeight: 1.3,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    valueTwo,
                    style: defaultTextStyle(
                        size: 15.sp,
                        lineHeight: 1.3,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              )),
        ),
      ],
    ),
  );
}

Widget widgetBodyHealth(MeasureResultReadingController controller) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 18.w, top: 12.h, bottom: 12.h, right: 5.w),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        'total_heart_health'.tr,
                        style: defaultTextStyle(
                            color: Colors.grey,
                            size: 14.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        controller.totalBodyHealth.toString(),
                        style: defaultTextStyle(
                            color: HexColor('#90000000'),
                            //Color(0xFF000000),
                            size: 28.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 70.w,
                    height: 65.w,
                    child: CircularPercentIndicator(
                      radius: 26.h,
                      lineWidth: 7.w,
                      percent: controller.progressValue,
                      progressColor: ColorConstants.blueColor,
                    ),
                  )
                ],
              ),
            )),
      ),
    ),
  );
}
