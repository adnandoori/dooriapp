import 'dart:io';

import 'package:doori_mobileapp/controllers/dashboard_controllers/dashboard_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/measure_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MeasureScreen extends StatelessWidget {
  const MeasureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeasureController>(
        init: MeasureController(context),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, top: 30.h),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        ImagePath.icBackBtn,
                        height: 30.w,
                        width: 30.w,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60.h,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'select_mode'.tr,
                          // 'select_the_vitals_you_want_to_measure'.tr,
                          textAlign: TextAlign.center,
                          style: defaultTextStyle(
                              size: 14.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ListView(
                        shrinkWrap: true,
                        children: [
                          widgetMeasurementName(
                              'vital_test'.tr, controller.isVitalTest, () {
                            if (controller.isVitalTest == false) {
                              controller.isVitalTest = true;

                              controller.isRealTimeTracking = false;
                              controller.isDeepSenseTest = false;
                              controller.txtEstimatedTime =
                                  'estimated_time_for_measurement_60_seconds'
                                      .tr;
                            }
                            controller.update();
                          }),
                          // widgetMeasurementName(
                          //     'Deep sense test'.tr, controller.isDeepSenseTest,
                          //     () {
                          //   if (controller.isDeepSenseTest == false) {
                          //     controller.isDeepSenseTest = true;
                          //     controller.isVitalTest = false;
                          //     controller.isRealTimeTracking = false;
                          //     controller.txtEstimatedTime =
                          //         'Estimated time for measurement 30 second';
                          //   }
                          //   controller.update();
                          // }),
                        ],
                      )
                    ],
                  )),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      controller.txtEstimatedTime.toString(),
                      textAlign: TextAlign.center,
                      style: defaultTextStyle(
                          size: 12.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.h, vertical: 25.h),
                    child: commonButton(
                        title: 'start'.tr.toUpperCase(),
                        onTap: () async {
                          controller.startMeasure();
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }
}

Widget widgetMeasurementName(String name, bool isSelected, VoidCallback onTap) {
  return Container(
    width: Get.width,
    margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      color: HexColor('#EFEFEF'),
    ),
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Row(
          children: [
            isSelected
                ? Image.asset(
                    ImagePath.icBlueTick,
                    height: 24.w,
                    width: 24.w,
                  )
                : SizedBox(
                    height: 24.w,
                    width: 24.w,
                  ),
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: Text(
                name.toString(),
                style: defaultTextStyle(
                    color: Colors.black,
                    size: 12.sp,
                    fontWeight: FontWeight.w400),
              ),
            ))
          ],
        ),
      ),
    ),
  );
}

Widget widgetMeasurement(
    MeasureModel data, MeasureController controller, int index) {
  return Container(
    width: Get.width,
    margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      color: HexColor('#EFEFEF'),
    ),
    child: InkWell(
      onTap: () {
        controller.tabSelection(index);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Row(
          children: [
            data.isSelected
                ? Image.asset(
                    ImagePath.icBlueTick,
                    height: 24.w,
                    width: 24.w,
                  )
                : SizedBox(
                    height: 24.w,
                    width: 24.w,
                  ),
            Expanded(
                child: Align(
              alignment: Alignment.center,
              child: Text(
                data.title.toString(),
                style: defaultTextStyle(
                    color: Colors.black,
                    size: 12.sp,
                    fontWeight: FontWeight.w400),
              ),
            ))
          ],
        ),
      ),
    ),
  );
}
