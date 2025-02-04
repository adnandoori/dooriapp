import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NoDataFound extends StatelessWidget {
  String label = '';
  VoidCallback onClick;

  NoDataFound({super.key, required this.label, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: defaultTextStyle(
                    size: 20.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Image.asset(
                  'assets/images/ic_no_record.png',
                  width: 200.w,
                  height: 200.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    textAlign: TextAlign.center,
                    'to_get_insightful_details_about_your_health_keep_measuring_regularly'.tr,
                    style: defaultTextStyle(
                      size: 15.sp,
                      lineHeight: 1.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                InkWell(
                  onTap: onClick,
                  child: Container(
                    width: 96.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.w)),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                      color: HexColor('#E3F7FF'),
                    ),
                    child: Center(
                      child: Text(
                        'measure'.tr,
                        style: defaultTextStyle(
                          size: 11.sp,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
