import 'package:doori_mobileapp/controllers/dashboard_controllers/visualise_controller.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/components/data_not_found_widget.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/activity_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';

class VisualiseScreen extends StatelessWidget {
  const VisualiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VisualiseController>(
        init: VisualiseController(),
        builder: (controller) {
          return ColoredSafeArea(
            color: ColorConstants.blueColor,
            child: Scaffold(
                backgroundColor: HexColor('#F5F5F5'),
                appBar: commonAppbar(
                    onBack: () {
                      Get.back();
                    },
                    title: 'visualise'.tr.toUpperCase()),
                body: controller.systolic == 0
                    ? NoDataFound(
                        label: 'no_trendind_data_found'.tr,
                        onClick: () {
                          controller.callNavigateToMeasure();
                        },
                      )
                    : SizedBox(
                        width: Get.width,
                        height: Get.height,
                        child: DefaultTabController(
                          length: 1, // 2
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                /*TabBar(
                                  controller: controller.tabController,
                                  indicatorColor: Colors.transparent,
                                  dividerColor: Colors.transparent,
                                  unselectedLabelColor: Colors.grey,
                                  labelColor: Colors.black,
                                  indicatorPadding: EdgeInsets.zero,
                                  labelPadding: EdgeInsets.zero,
                                  unselectedLabelStyle: defaultTextStyle(
                                      color: Colors.black,
                                      size: 12.sp,
                                      fontWeight: FontWeight.w600),
                                  labelStyle: defaultTextStyle(
                                      color: Colors.black,
                                      size: 12.sp,
                                      fontWeight: FontWeight.w600),
                                  tabs: [
                                    Tab(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 5.w, left: 10.w),
                                        child: Material(
                                          elevation:
                                              controller.tabController.index ==
                                                      0
                                                  ? 0
                                                  : 1,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16)),
                                          child: Container(
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16)),
                                              color: controller.tabController
                                                          .index ==
                                                      0
                                                  ? ColorConstants.textColor
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'current'.tr,
                                                style: defaultTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    size: 12.sp,
                                                    color: controller
                                                                .tabController
                                                                .index ==
                                                            0
                                                        ? ColorConstants.white
                                                        : Colors.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.w, right: 10.w),
                                        child: Material(
                                          elevation:
                                              controller.tabController.index ==
                                                      1
                                                  ? 0
                                                  : 1,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(16)),
                                          child: Container(
                                            height: 40.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16)),
                                              color: controller.tabController
                                                          .index ==
                                                      1
                                                  ? ColorConstants.textColor
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                'predicted'.tr,
                                                style: defaultTextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    size: 12.sp,
                                                    color: controller
                                                                .tabController
                                                                .index ==
                                                            1
                                                        ? Colors.white
                                                        : ColorConstants.black),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),*/
                                SizedBox(
                                  height: 15.h,
                                ),
                                Expanded(
                                    child: TabBarView(
                                  controller: controller.tabController,
                                  children: [
                                    SingleChildScrollView(
                                      child: SizedBox(
                                        width: Get.width,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            widgetFirst(controller),
                                            widgetSecond(controller),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    /*SingleChildScrollView(
                                      child: SizedBox(
                                        width: Get.width,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 5.h,
                                            ),
                                            widgetFirstForPredicted(controller),
                                            widgetSecondForPredicted(
                                                controller),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),*/
                                  ],
                                ))
                              ],
                            ),
                          ),
                        ),
                      )),
          );
        });
  }

  Widget widgetFirst(VisualiseController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 5.w, left: 10.w),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 363.h,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                width: Get.width,
                height: 270.h,
                child: controller.isNormal
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        child: GifView.asset(
                          'assets/gif/normal_heart.gif',
                          frameRate: 15, // default is 15 FPS
                        ),
                      )
                    : Container(
                        //color: Colors.red,
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/images/heart/h5.png',
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH1 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h1.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH2 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h2.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH3 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h3.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH4 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h4.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH6 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h6.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/images/heart/h7.png',
                                color: const Color(0xff70000000),
                              ),
                            ),
                            /*Align(
                        alignment: Alignment.topCenter,
                        child: AnimatedOpacity(
                          opacity: controller.normalHeartGif ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 600),
                          child: Image.asset(
                            'assets/images/heart/h8.png',
                          ),
                        ),
                      ),*/
                          ],
                        ),
                      ),
              ),
              Expanded(
                  child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'avg_systole'.tr,
                          style: defaultTextStyle(
                              size: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: HexColor('#787878')),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          controller.systolic.toString(),
                          style: defaultTextStyle(
                              size: 26.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'avg_diastole'.tr,
                          style: defaultTextStyle(
                              size: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: HexColor('#787878')),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          controller.diastolic.toString(),
                          style: defaultTextStyle(
                              size: 26.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    )),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetSecond(VisualiseController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 5.w, left: 10.w, top: 10.h),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
            width: Get.width,
            //height: 363.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'current_state'.tr,
                    style: defaultTextStyle(
                        size: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    controller.currentState.toString(),
                    style: defaultTextStyle(
                        size: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  controller.isNormal
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              'other_symptoms'.tr,
                              style: defaultTextStyle(
                                  size: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              controller.symptomTip,
                              style: defaultTextStyle(
                                  size: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              'health_tips'.tr,
                              style: defaultTextStyle(
                                  size: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              controller.visualiseTip,
                              style: defaultTextStyle(
                                  size: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              'probable_causes'.tr,
                              style: defaultTextStyle(
                                  size: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              controller.causesTip,
                              style: defaultTextStyle(
                                  size: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ],
                        )
                ],
              ),
            )),
      ),
    );
  }

  Widget widgetFirstForPredicted(VisualiseController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 5.w, left: 10.w),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 363.h,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              SizedBox(
                width: Get.width,
                height: 270.h,
                child: controller.isNormal
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        child: GifView.asset(
                          'assets/gif/normal_heart.gif',
                          frameRate: 15, // default is 15 FPS
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(vertical: 20.h),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/images/heart/h5.png',
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH1 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h1.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH2 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h2.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH3 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h3.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH4 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h4.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: AnimatedOpacity(
                                opacity: controller.gifH6 ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 600),
                                child: Image.asset(
                                  'assets/images/heart/h6.png',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'assets/images/heart/h7.png',
                                color: const Color(0xff70000000),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              Expanded(
                  child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'avg_systole'.tr,
                          style: defaultTextStyle(
                              size: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: HexColor('#787878')),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          controller.systolic.toString(),
                          style: defaultTextStyle(
                              size: 26.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'avg_diastole'.tr,
                          style: defaultTextStyle(
                              size: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: HexColor('#787878')),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          controller.diastolic.toString(),
                          style: defaultTextStyle(
                              size: 26.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    )),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetSecondForPredicted(VisualiseController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 5.w, left: 10.w, top: 10.h),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
            width: Get.width,
            //height: 363.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'current_state'.tr,
                    style: defaultTextStyle(
                        size: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    controller.currentState.toString(),
                    style: defaultTextStyle(
                        size: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  controller.isNormal
                      ? Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              'other_symptoms'.tr,
                              style: defaultTextStyle(
                                  size: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              controller.symptomTip,
                              style: defaultTextStyle(
                                  size: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              'health_tips'.tr,
                              style: defaultTextStyle(
                                  size: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              controller.visualiseTip,
                              style: defaultTextStyle(
                                  size: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              'probable_causes'.tr,
                              style: defaultTextStyle(
                                  size: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              controller.causesTip,
                              style: defaultTextStyle(
                                  size: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ],
                        )
                ],
              ),
            )),
      ),
    );
  }
}
