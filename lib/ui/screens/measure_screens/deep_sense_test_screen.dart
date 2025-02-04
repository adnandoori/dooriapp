import 'package:doori_mobileapp/controllers/measure_controllers/deep_sense_test_controller.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/measure_screens/start_measure_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class DeepSenseTestScreen extends StatelessWidget {
  const DeepSenseTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DeepSenseTestController>(
        init: DeepSenseTestController(context),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    Transform.scale(
                      scale: -1,
                      child: Container(
                        color: Colors.white,
                        child: WaveWidget(
                          config: CustomConfig(
                            colors: [
                              controller.state ==
                                          BluetoothConnectionState.connected &&
                                      controller.isFingerDetected
                                  ? const Color(0xFF0080FF).withOpacity(0.4)
                                  : Colors.orange.withOpacity(0.5),
                              controller.state ==
                                          BluetoothConnectionState.connected &&
                                      controller.isFingerDetected
                                  ? const Color(0xFF0080FF).withOpacity(0.7)
                                  : Colors.orange.withOpacity(0.5),
                              controller.state ==
                                          BluetoothConnectionState.connected &&
                                      controller.isFingerDetected
                                  ? const Color(0xFF0080FF).withOpacity(0.3)
                                  : Colors.orange.withOpacity(0.5),
                            ],
                            durations: [8000, 12000, 15000],
                            //[4000, 5000, 7000],
                            heightPercentages: [0.03, 0.07, 0.05],
                            //[0.01, 0.05, 0.03],
                            blur: const MaskFilter.blur(BlurStyle.solid, 5),
                          ),
                          waveAmplitude: 0.0,
                          waveFrequency: 3,
                          backgroundColor: Colors.white,
                          size: const Size(
                            double.infinity,
                            double.infinity,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.w, top: 40.h),
                      child: InkWell(
                        onTap: () {
                          controller.stopAndGoBack();
                        },
                        child: Image.asset(
                          ImagePath.icBackBtn,
                          height: 30.w,
                          width: 30.w,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        controller.title.toString(),
                        style: defaultTextStyle(
                            size: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    //(!controller.isFingerDetected || controller.state == BluetoothDeviceState.connecting)
                    (!controller.isDeviceConnected)
                        ? widgetProgressLoderDialog(controller)
                        : Container(),

                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          margin: EdgeInsets.only(top: 100.h),
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 5,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              controller.remainingSeconds.toString(),
                              textAlign: TextAlign.center,
                              style: defaultTextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  size: 22.sp),
                            ),
                          )),
                    )
                  ],
                )),
                SizedBox(
                  height: Get.height * 40 / 100,
                  width: Get.width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 35.w, vertical: 50.h),
                          child: Text(
                            controller.content.toString(),
                            textAlign: TextAlign.center,
                            style: defaultTextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                size: 16.sp),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25.w, vertical: 20.h),
                          child: commonButton(
                              title: 'stop'.tr.toUpperCase(),
                              onTap: () {
                                controller.stopAndGoBack();
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

Widget widgetProgressLoderDialog(DeepSenseTestController controller) {
  return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.only(top: 250.h, left: 20.w, right: 20.w),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(top: 20.w, left: 20.w, right: 20.w),
                  width: 300.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Text(
                          (controller.state ==
                                  BluetoothConnectionState.connected)
                              ? controller.dialogTitle["init"]!
                              : (controller.state ==
                                      BluetoothConnectionState.connecting
                                  ? controller.dialogTitle["connecting"]!
                                  : "connecting".tr), // "loading".tr),
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: AppConstants.fontFamily,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 20.w,
                      ),
                      Container(
                        width: Get.width,
                        margin: EdgeInsets.only(bottom: 5.h, top: 5.h),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 30.w,
                                height: 30.w,
                                child: const CircularProgressIndicator()),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                                child: Text(
                              (controller.state ==
                                      BluetoothConnectionState.connected)
                                  ? controller.dialogMsg["init"]!
                                  : controller.dialogMsg["scanning"]!,
                              //'Tap device to connect',
                              style: defaultTextStyle(
                                size: 14.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.w,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
}

Widget widgetWave() {
  return SizedBox(
    height: Get.height,
    width: double.infinity,
    child: Card(
      elevation: 12.0,
      margin: const EdgeInsets.only(right: 10, left: 10, bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      child: WaveWidget(
        config: CustomConfig(
          gradients: [
            [HexColor('#0080ff'), HexColor('#5eb2f6')],
            [HexColor('#0080ff'), HexColor('#5eb2f6')],
            [HexColor('#0080ff'), HexColor('#5eb2f6')],
            [HexColor('#0080ff'), HexColor('#5eb2f6')],
          ],
          durations: [35000, 19440, 10800, 6000],
          heightPercentages: [0.20, 0.23, 0.25, 0.30],
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),
        backgroundColor: ColorConstants.blueColor,
        size: const Size(double.infinity, double.infinity),
        waveAmplitude: 0,
      ),
    ),
  );
}
