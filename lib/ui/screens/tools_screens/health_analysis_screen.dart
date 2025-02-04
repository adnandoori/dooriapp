import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class HealthAnalysisScreen extends StatelessWidget {
  const HealthAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#FfFfFf'),
        body: Column(
          children: [
            widgetAppbar(),
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return widgetHealthAnalysis();
                  }),
            )
          ],
        ),
      ),
    );
  }
}

Widget widgetHealthAnalysis() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.inDepthAnalysisScreen);
        },
        child: Container(
          width: Get.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 15.h),
                      height: 5.h,
                      width: 100.w,
                      child: LinearProgressIndicator(
                        backgroundColor: HexColor('#10000000'),
                        value: 0.7,
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.h, bottom: 5.h, right: 20.w),
                      child: Text(
                        'Inflamination of the nose and throat',
                        textAlign: TextAlign.start,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: defaultTextStyle(
                            size: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 5.h, bottom: 5.h, right: 20.w),
                      child: Text(
                        'A Nosepharyngitis means specifically the swellingof the back partof the throat and of the nasal ch',
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: defaultTextStyle(
                            size: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                )),
                SizedBox(
                  width: 28.w,
                ),
                Image.asset(
                  ImagePath.icNextIcon,
                  height: 22.w,
                  width: 22.w,
                ),
                SizedBox(
                  width: 5.w,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetAppbar() {
  return Container(
    width: Get.width,
    color: ColorConstants.blueColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, left: 15.w),
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              AppConstants.yourHealthAnalysis,
              style: defaultTextStyle(size: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}
