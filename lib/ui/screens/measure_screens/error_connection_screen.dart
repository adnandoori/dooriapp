import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class ErrorConnectionScreen extends StatelessWidget {
  const ErrorConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor('#F5f5f5'),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Measurement failed',
                            textAlign: TextAlign.center,
                            style: defaultTextStyle(
                                size: 23.sp,
                                color: HexColor('#FF7F00'),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Text(
                            'The reasons for an error in measurement could be several like:',
                            textAlign: TextAlign.center,
                            style: defaultTextStyle(
                                size: 15.sp,
                                color: HexColor('#000000'),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: Text(
                            '1) The finger was not placed on the device properly',
                            textAlign: TextAlign.start,
                            style: defaultTextStyle(
                                size: 13.sp,
                                color: HexColor('#000000'),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            '2) The finger was held against the sensor with a lot of pressure',
                            textAlign: TextAlign.start,
                            style: defaultTextStyle(
                                size: 13.sp,
                                color: HexColor('#000000'),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            '3) The user was not at rest',
                            textAlign: TextAlign.start,
                            style: defaultTextStyle(
                                size: 13.sp,
                                color: HexColor('#000000'),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(top: 180.h),
                    child: WaveWidget(
                      config: CustomConfig(
                        colors: [
                          const Color(0xFFFF7F00).withOpacity(0.5),
                          const Color(0xFFFF7F00).withOpacity(0.7),
                          const Color(0xFFFF7F00).withOpacity(0.4),
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
                  ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        height: 37.h,
                        child: commonButton(
                            title: AppConstants.retry,
                            onTap: () {
                              Get.back(result: 'back');
                            },
                            bgColor: Colors.white,
                            textColor: ColorConstants.textColor),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        height: 37.h,
                        child: commonButton(
                            title: AppConstants.exit,
                            onTap: () {
                              Get.back(result: 'exit');
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
      ),
    );
  }
}
