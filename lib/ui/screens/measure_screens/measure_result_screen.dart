import 'package:doori_mobileapp/controllers/dashboard_controllers/measure_controller.dart';
import 'package:doori_mobileapp/controllers/measure_controllers/measure_result_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class MeasureResultScreen extends StatelessWidget {
  const MeasureResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeasureResultController>(
        init: MeasureResultController(context),
        builder: (controller) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                children: [
                  SizedBox(
                      width: Get.width,
                      height: 200.h,
                      child: Stack(
                        children: [
                          Transform.scale(
                            scale: -1,
                            child: Container(
                              color: Colors.white,
                              child: WaveWidget(
                                config: CustomConfig(
                                  colors: [
                                    Colors.blue.withOpacity(0.4),
                                    Colors.blue.withOpacity(0.7),
                                    Colors.blue.withOpacity(0.3),
                                  ],
                                  durations: [4000, 5000, 7000],
                                  heightPercentages: [0.01, 0.05, 0.03],
                                  blur:
                                      const MaskFilter.blur(BlurStyle.solid, 5),
                                ),
                                waveAmplitude: 0.00,
                                waveFrequency: 3,
                                backgroundColor: Colors.white,
                                size: const Size(
                                  double.infinity,
                                  double.infinity,
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(left: 10.w, top: 40.h),
                          //   child: InkWell(
                          //     onTap: () {
                          //       Get.back(result: 'back');
                          //     },
                          //     child: Image.asset(
                          //       ImagePath.icBackBtn,
                          //       height: 30.w,
                          //       width: 30.w,
                          //     ),
                          //   ),
                          // ),
                        ],
                      )),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'measurement_complete'.tr,
                          textAlign: TextAlign.center,
                          style: defaultTextStyle(
                              color: ColorConstants.textColor,
                              size: 22.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'what_were_you_doing_before'.tr,
                          textAlign: TextAlign.center,
                          style: defaultTextStyle(
                              color: Colors.black,
                              size: 15.sp,
                              lineHeight: 1.3,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        widgetList('sleeping'.tr, () {
                          controller.measureComplete('sleeping'.tr);
                        }),
                        widgetList('sitting'.tr, () {
                          controller.measureComplete('sitting'.tr);
                        }),
                        widgetList('working'.tr, () {
                          controller.measureComplete('working'.tr);
                        }),
                        widgetList('studying'.tr, () {
                          controller.measureComplete('studying'.tr);
                        }),
                        widgetList('walking'.tr, () {
                          controller.measureComplete('walking'.tr);
                        }),
                        widgetList('running'.tr, () {
                          controller.measureComplete('running'.tr);
                        }),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          );
        });
  }
}

Widget widgetList(String title, VoidCallback voidCallback) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
    height: 40.h,
    child: commonButton(
        title: title,
        onTap: voidCallback,
        textColor: ColorConstants.textColor,
        bgColor: Colors.white),
  );
}
