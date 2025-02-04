import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class StartScanScreen extends StatelessWidget {
  const StartScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double mHeight = MediaQuery.of(context).size.height;
    double mWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SizedBox(
      height: Get.height,
      width: Get.width,
      child: Stack(
        children: [
          Image.asset(
            ImagePath.letsScan1,
            height: Get.height,
            width: Get.width,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: Column(
              children: [
                Expanded(
                    flex: 7,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 50.w,
                              ),
                              Text(
                                'lets_get_started'.tr,
                                style: TextStyle(
                                    fontSize: 23.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: 22.w, right: 22.w),
                                child: Text(
                                  'to_begin_your_health'.tr,
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 60.h),
                            height: 260.h,
                            //  mHeight < 700 ? 235.h : 240.h,
                            child: Image.asset(
                              ImagePath.letsScan6,
                              width: 230.h,
                              //  mHeight < 700 ? 210.w : 270.w,
                              fit: BoxFit.contain,
                            ),
                          ),
                        )
                        //mwidth-540.0
                        // height-1176.0
                      ],
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widgetButtonConnectToDevice(),
                            widgetButtonGetTheHealhable(),
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${'visit_our_blog'.tr} - ',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      printf('clicked_health_bytes');
                                      String url =
                                          "https://www.doori.co.in/healthbytes";

                                      final parseUrl = Uri.parse(url);
                                      if (!await launchUrl(parseUrl,
                                          mode:
                                              LaunchMode.externalApplication)) {
                                        throw Exception(
                                            'Could not launch $parseUrl');
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 3.h, bottom: 3.h, right: 3.w),
                                      child: Text(
                                        'healthbytes'.tr,
                                        style: defaultTextStyle(
                                          size: 12.sp,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget widgetButtonConnectToDevice() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0.0),
        elevation: 0,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.w),
        ),
      ),
      onPressed: () {
        Get.defaultDialog(
          barrierDismissible: false,
          title: "permission_required".tr,
          middleText: "permission_required_content".tr,
          radius: 5,
          confirm: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text('deny'.tr)),
              TextButton(
                  onPressed: () {
                    Get.back();
                    Get.offNamedUntil(Routes.scanDeviceScreen, (route) => true);
                  },
                  child: Text('allow'.tr))
            ],
          ),
        );
      },
      child: SizedBox(
        height: 45.h,
        width: Get.width,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.w)),
            color: HexColor('#2196F3'),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Center(
                child: Text(
                  'connect_to_device'.tr,
                  style: defaultTextStyle(
                      size: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              )),
        ),
      ),
    );
  }

  Widget widgetButtonGetTheHealhable() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0.0),
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.w),
          ),
        ),
        onPressed: () async {
          String url = "https://www.doori.co.in";

          final parseUrl = Uri.parse(url);
          if (!await launchUrl(parseUrl,
              mode: LaunchMode.externalApplication)) {
            throw Exception('Could not launch $parseUrl');
          }
        },
        child: SizedBox(
          height: 45.h,
          width: Get.width,
          child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.w)),
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: HexColor('#2196F3'),
                )),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Center(
                  child: Text(
                    'get_the_healthable'.tr,
                    style: defaultTextStyle(
                        size: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: HexColor('#2196F3')),
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
