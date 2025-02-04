import 'package:doori_mobileapp/controllers/scan_controller/scan_device_controller.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/dashboard_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class ScanDeviceScreen extends StatefulWidget {
  const ScanDeviceScreen({Key? key}) : super(key: key);

  @override
  State<ScanDeviceScreen> createState() => _ScanDeviceScreenState();
}

class _ScanDeviceScreenState extends State<ScanDeviceScreen> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double mWidth = MediaQuery.of(context).size.width;

    double top = (height * 50) / 100;
    double bottom = (height * 52) / 100;
    double centerMargin = (height * 48) / 100;

    printf('mwidth-$mWidth');
    printf('height-$height $top $bottom');

    return GetBuilder<ScanDeviceController>(
        init: ScanDeviceController(context),
        builder: (controller) {
          return Scaffold(
            backgroundColor: HexColor('#e3f7ff'),
            body: SingleChildScrollView(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: top, //350.h,
                          child: Stack(
                            children: [
                              Image.asset(
                                ImagePath.icBlueBackground,
                                height: 350.h,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 15.w, right: 15.w, bottom: 20.h),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40.w,
                                    ),
                                    Text(
                                      'setup_doori'.tr,
                                      style: TextStyle(
                                          fontSize: 25.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: 20.w, right: 20.w),
                                      //  width: 350.w,
                                      child: Text(
                                        'connect_to_doori'.tr,
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 18.h,
                                    ),
                                    Expanded(
                                        child: Container(
                                      margin: EdgeInsets.only(
                                          top: 10.h, bottom: 10.h),
                                      width: Get.width,
                                      child: Center(
                                        child: Image.asset(
                                          ImagePath.deviceIcon,
                                          width: 140.w,
                                          height: 140.w,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )),
                                    SizedBox(
                                      height: 18.h,
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: centerMargin),
                      child: Container(
                        height: bottom,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: HexColor('#50000000'), //Colors.black,
                              blurRadius: 10.0,
                            ),
                          ],
                        ),
                        child: Card(
                          margin: EdgeInsets.zero,
                          color: HexColor('#E3F7FE'),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          ) //BorderRadius.circular(8.0),
                              ),
                          //elevation: 15.0,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 18.w, right: 18.w, top: 4.h),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'devices_near_you'.tr,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.scanAgain();
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 5.h,
                                            bottom: 5.h,
                                            left: 5.w,
                                            right: 5.w),
                                        child: Text(
                                          'scan_again'.tr,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                controller.deviceList.isNotEmpty
                                    ? ListView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: controller.deviceList.length,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return widgetDeviceName(
                                              controller.deviceList[index],
                                              controller);
                                        },
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  controller.isScanning && controller.deviceList.isEmpty
                      ? Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              //color: Colors.white,
                            ),
                            margin: EdgeInsets.only(
                                top: 300.h, left: 30.w, right: 30.w),
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20.h, left: 20.w, right: 20.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        //Get.to(() => const DashboardScreen());
                                      },
                                      child: Text(
                                        "scanning".tr,
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            color: Colors.black,
                                            fontFamily: AppConstants.fontFamily,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.w,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CircularProgressIndicator(
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        SizedBox(
                                          width: 150.w,
                                          child: Text(
                                           'tap_doori_to_make_it'.tr,
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                fontFamily:
                                                    AppConstants.fontFamily,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  Widget widgetDeviceName(
      BluetoothDevice device, ScanDeviceController controller) {
    return InkWell(
      onTap: () {
        controller.stopScanning(3);
        controller.saveDevice(device);
      },
      child: Card(
        elevation: 2,
        child: Container(
          padding: EdgeInsets.only(left: 10.w, top: 12.h, bottom: 12.h),
          child: Text(
            device.name,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                fontSize: 18.sp),
          ),
        ),
      ),
    );
  }

  Widget widgetScanningDialog() {
    return Container(
      width: double.infinity,
      color: const Color.fromARGB(100, 22, 44, 33),
      child: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20.w, left: 20.w, right: 20.w),
          width: 300.w,
          height: 125.h,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.to(() =>  DashboardScreen());
                },
                child:  Text(
                  "scanning".tr,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  SizedBox(
                    width: 150.w,
                    child: const Text(
                      "Tap DOORI to make it discoverable",
                      style: TextStyle(
                          fontFamily: AppConstants.fontFamily,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
