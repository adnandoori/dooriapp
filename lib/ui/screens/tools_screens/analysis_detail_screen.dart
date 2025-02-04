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

class AnalysisDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor('#FfFfFf'),
        body: Column(
          children: [
            widgetAppbar(),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Inflammation of the nose and throat',
                    style: defaultTextStyle(
                        size: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                  Text(
                    'Also known as : Nasopharyngitis ',
                    style: defaultTextStyle(
                        size: 14.sp,
                        lineHeight: 1.6,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),

                  SizedBox(
                    height: 20.h,
                  ),

                  Text(
                    'You may experience : ',
                    style: defaultTextStyle(
                        size: 12.sp,
                        lineHeight: 1.6,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'What should you do?',
                    style: defaultTextStyle(
                        size: 12.sp,
                        lineHeight: 1.6,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'You might also have the following symptoms :',
                    style: defaultTextStyle(
                        size: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  //
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
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
              AppConstants.inDepthAnalysis,
              style: defaultTextStyle(size: 18.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}
