import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10.w, top: 15.h),
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
              SizedBox(
                height: 60.h,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppConstants.selectTheToolYouWantToUse,
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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: HexColor('#E3F7FF'),
                ),
                child: InkWell(
                  onTap: () {
                    //  Get.toNamed(Routes.meditationTestScreen);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePath.icMeditation,
                          height: 50.w,
                          width: 50.w,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'GUIDED\n MEDITATION',
                              textAlign: TextAlign.end,
                              style: defaultTextStyle(
                                  size: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.textColor),
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: HexColor('#E3F7FF'),
                ),
                child: InkWell(
                  onTap: () {
                    //  Get.toNamed(Routes.symptomCheckerScreen);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePath.icSymptom,
                          height: 50.w,
                          width: 50.w,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SYMPTOM\n CHECKER',
                              textAlign: TextAlign.end,
                              style: defaultTextStyle(
                                  size: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstants.textColor),
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                  color: HexColor('#E3F7FF'),
                ),
                child: InkWell(
                  onTap: () {
                    //  Get.toNamed(Routes.healthAnalysisScreen);
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
                    child: Row(
                      children: [
                        Image.asset(
                          ImagePath.icDiet,
                          height: 50.w,
                          width: 50.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'DIET\n ANALYSER',
                                textAlign: TextAlign.end,
                                style: defaultTextStyle(
                                    size: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.textColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
