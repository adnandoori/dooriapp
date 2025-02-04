import 'package:doori_mobileapp/controllers/dashboard_controllers/bmi_detail_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/graph_controllers/heart_graph_controller.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/activity_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/dashboard_screen.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BMIDetailScreen extends StatelessWidget {
  const BMIDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BMIDetailController>(
        init: BMIDetailController(),
        builder: (controller) {
          return ColoredSafeArea(
              color: HexColor('#EFEFEF'),
              child: Scaffold(
                backgroundColor: HexColor('#EFEFEF'),
                appBar: commonAppbarWhiteColor(
                    title: 'BODY MASS INDEX',
                    onBack: () {
                      Get.back();
                    }),
                body: SingleChildScrollView(
                  child: SizedBox(
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: controller.isLoading.value
                          ? widgetLoading()
                          : Column(
                              children: [
                                Material(
                                  elevation: 1,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'bmi'.tr,
                                                    style: defaultTextStyle(
                                                        size: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    '(${'body_mass_index'.tr})',
                                                    style: defaultTextStyle(
                                                        size: 9.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: ColorConstants
                                                            .textGreyColor),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                  controller.bmiValue
                                                      .toString(),
                                                  style: defaultTextStyle(
                                                      size: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          HexColor('#787878'))),
                                              Text(
                                                  controller.bmiMessage
                                                      .toString(),
                                                  style: defaultTextStyle(
                                                      size: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color:
                                                          HexColor('#787878'))),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Material(
                                    elevation: 1,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: Container(
                                      height: 130.h,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 16.h,
                                              left: 16.w,
                                              right: 16.w,
                                              bottom: 16.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                      child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'bmi_score'.tr,
                                                        style: defaultTextStyle(
                                                            size: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          bottomSheet(
                                                              controller);
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.w,
                                                                  right: 2.w),
                                                          child: Image.asset(
                                                            'assets/images/ic_info.png',
                                                            height: 16.w,
                                                            width: 16.w,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                  SizedBox(
                                                      width: 100.w,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Text(
                                                          '${controller.bmiScore}/100',
                                                          style: defaultTextStyle(
                                                              size: 15.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: ColorConstants
                                                                  .textGreyColor),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      top: 15.h),
                                                  height: 9.h,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                          color: HexColor(
                                                              '#F8555A'),
                                                        ),
                                                      )),
                                                      Expanded(
                                                          child: Container(
                                                        color:
                                                            HexColor('#FFA847'),
                                                      )),
                                                      Expanded(
                                                          child: Container(
                                                        color:
                                                            HexColor('#FAE56E'),
                                                      )),
                                                      Expanded(
                                                          child: Container(
                                                        color:
                                                            HexColor('#4FD286'),
                                                      )),
                                                      Expanded(
                                                          child: Container(
                                                        color:
                                                            HexColor('#B0D683'),
                                                      )),
                                                      Expanded(
                                                          child: Container(
                                                        color:
                                                            HexColor('#FAE56E'),
                                                      )),
                                                      Expanded(
                                                          child: Container(
                                                        color:
                                                            HexColor('#FFA847'),
                                                      )),
                                                      Expanded(
                                                          child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                          color: HexColor(
                                                              '#F8555A'),
                                                        ),
                                                      )),
                                                    ],
                                                  )),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 2.h),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: controller
                                                                .isSevereThinness
                                                            ? widgetBMIPointer(
                                                                controller
                                                                    .bmiValue
                                                                    .toString())
                                                            : Container()),
                                                    Expanded(
                                                        child: controller
                                                                .isModerateThinness
                                                            ? widgetBMIPointer(
                                                                controller
                                                                    .bmiValue
                                                                    .toString())
                                                            : Container()),
                                                    Expanded(
                                                        child: controller
                                                                .isMildThinness
                                                            ? widgetBMIPointer(
                                                                controller
                                                                    .bmiValue
                                                                    .toString())
                                                            : Container()),
                                                    Expanded(
                                                        child: controller
                                                                .isNormalThinness
                                                            ? widgetBMIPointer(
                                                                controller
                                                                    .bmiValue
                                                                    .toString())
                                                            : Container()),
                                                    Expanded(
                                                        child: controller
                                                                .isOverWeightThinness
                                                            ? widgetBMIPointer(
                                                                controller
                                                                    .bmiValue
                                                                    .toString())
                                                            : Container()),
                                                    Expanded(
                                                        child: controller
                                                                .isObeseClass
                                                            ? widgetBMIPointer(
                                                                controller
                                                                    .bmiValue
                                                                    .toString())
                                                            : Container()),
                                                    Expanded(
                                                        child: controller
                                                                .isObeseClass2
                                                            ? widgetBMIPointer(
                                                                controller
                                                                    .bmiValue
                                                                    .toString())
                                                            : Container()),
                                                    Expanded(
                                                        child: controller
                                                                .isObeseClass3
                                                            ? widgetBMIPointer(
                                                                controller
                                                                    .bmiValue
                                                                    .toString())
                                                            : Container()),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                               '${'condition'.tr} : ${controller.bmiCondition}',
                                                maxLines: 1,
                                                style: defaultTextStyle(
                                                    size: 11.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorConstants
                                                        .textGreyColor),
                                              ),
                                            ],
                                          )),
                                    )),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  width: Get.width,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: widgetAverage(
                                              title:
                                                  '${'height'.tr}(${'in_cms'.tr})',
                                              value: controller.height,
                                              onTap: () {
                                                controller
                                                    .callNavigateToProfileScreen();
                                              })),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                          child: widgetAverage(
                                              title:
                                                  '${'weight'.tr}(${'in_kgs'.tr})',
                                              value: controller.weight,
                                              onTap: () {
                                                controller
                                                    .callNavigateToProfileScreen();
                                              })),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Material(
                                    elevation: 1,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    child: Container(
                                      height: 85.h,
                                      width: Get.width,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        color: Colors.white,
                                      ),
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: 16.h,
                                              left: 16.w,
                                              right: 16.w,
                                              bottom: 18.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'tips_to_improve_bmi'.tr, //Tips to improve BMI
                                                style: defaultTextStyle(
                                                    size: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorConstants
                                                        .textGreyColor),
                                              ),
                                              Text(
                                                controller.tipsForBmi,
                                                style: defaultTextStyle(
                                                    size: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: ColorConstants
                                                        .textGreyColor),
                                              ),
                                            ],
                                          )),
                                    )),
                                SizedBox(
                                  height: 10.h,
                                ),
                                //cardWidgetGraph(controller),
                                // SizedBox(
                                //   height: 10.h,
                                // ),
                              ],
                            ),
                    ),
                  ),
                ),
              ));
        });
  }

  Widget widgetLoading() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Material(
          elevation: 1,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: Text(
                              'bmi'.tr,
                              style: defaultTextStyle(
                                  size: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: Text(
                              '(${'body_mass_index'.tr})',
                              style: defaultTextStyle(
                                  size: 9.sp,
                                  fontWeight: FontWeight.w400,
                                  color: ColorConstants.textGreyColor),
                            ),
                          ),
                        ],
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Container(
                          height: 10.h,
                          width: 50.w,
                          color: Colors.white,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Container(
                          height: 11.h,
                          width: 50.w,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Material(
            elevation: 1,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Container(
              height: 130.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
              child: Container(
                  margin: EdgeInsets.only(
                      top: 16.h, left: 16.w, right: 16.w, bottom: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: Text(
                                  'bmi_score'.tr,
                                  style: defaultTextStyle(
                                      size: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.w, right: 2.w),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Image.asset(
                                    'assets/images/ic_info.png',
                                    height: 16.w,
                                    width: 16.w,
                                  ),
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                              width: 100.w,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    height: 12.h,
                                    width: 50.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                        ],
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Container(
                          height: 10.h,
                          width: Get.width,
                          color: Colors.white,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Text(
                          '${'condition'.tr} : ',
                          style: defaultTextStyle(
                              size: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.textGreyColor),
                        ),
                      ),
                    ],
                  )),
            )),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: Get.width,
          child: Row(
            children: [
              Expanded(
                child: Material(
                  elevation: 1,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 75.h,
                    width: Get.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 14.w, top: 10.h, bottom: 10.h, right: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: Container(
                                  height: 10.h,
                                  width: 50.w,
                                  color: Colors.white,
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: const Center(
                                  child: Icon(
                                    size: 15,
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: Container(
                              height: 14.h,
                              width: 60.w,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Material(
                  elevation: 1,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    height: 75.h,
                    width: Get.width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 14.w, top: 10.h, bottom: 10.h, right: 10.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: Container(
                                  height: 10.h,
                                  width: 50.w,
                                  color: Colors.white,
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: const Center(
                                  child: Icon(
                                    size: 15,
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: Container(
                              height: 14.h,
                              width: 60.w,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Material(
            elevation: 1,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Container(
              height: 85.h,
              width: Get.width,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
              child: Container(
                  margin: EdgeInsets.only(
                      top: 16.h, left: 16.w, right: 16.w, bottom: 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Text(
                          'tips_to_improve_bmi'.tr,
                          style: defaultTextStyle(
                              size: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.textGreyColor),
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Container(
                          height: 12.h,
                          width: Get.width,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )),
            )),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: Get.width,
          height: 300.h,
          child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: Material(
                elevation: 1,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                  width: Get.width,
                  height: 100.0,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  void bottomSheet(BMIDetailController controller) {
    Get.bottomSheet(
      Material(
        elevation: 1,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        //.all(Radius.circular(8)),
        child: Container(
          // height: 700.h,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(8), topLeft: Radius.circular(8)),
            //.all(Radius.circular(8)),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'about_bmi_levels'.tr,
                      style: defaultTextStyle(
                        size: 14.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    widgetLevel(controller),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetLevel(BMIDetailController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10.h,
        ),
        // #ff807d , #ffc77f ,#fcfc7d, #7fdefd, #96e77e , last-> #fd807d

        //4FD286 B0D683 FAE56E FFA847 F8555A

        widgetMeasureLevels(
            color: HexColor('#F8555A'),
            text: 'severe_thinness'.tr,
            value: '<16'),
        widgetMeasureLevels(
            color: HexColor('#FFA847'),
            text: 'moderate_thinness'.tr,
            value: '16-17'),
        widgetMeasureLevels(
            color: HexColor('#FAE56E'),
            text: 'mild_thinness'.tr,
            value: '17-18.5'),
        widgetMeasureLevels(
            color: HexColor('#4FD286'), text: 'normal'.tr, value: '18.5-25'),
        widgetMeasureLevels(
            color: HexColor('#B0D683'), text: 'over_weight'.tr, value: '25-30'),
        widgetMeasureLevels(
            color: HexColor('#FAE56E'),
            text: 'obese_class1'.tr,
            value: '30-35'),
        widgetMeasureLevels(
            color: HexColor('#FFA847'),
            text: 'obese_class2'.tr,
            value: '35-40'),
        widgetMeasureLevels(
            color: HexColor('#F8555A'), text: 'obese_class3'.tr, value: '>40'),
      ],
    );
  }

  Widget widgetMeasureLevels(
      {required Color color, required String text, required String value}) {
    return SizedBox(
      width: Get.width,
      height: 45.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 6,
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      height: 30.w,
                      width: 30.w,
                      color: color,
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: defaultTextStyle(
                      size: 14.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),),
                ],
              )),
          Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Text(
                  value,
                  style: defaultTextStyle(
                    size: 14.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget cardWidgetGraph(BMIDetailController controller) {
    //TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return Column(
      children: [
        Material(
          elevation: 1,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Container(
            width: Get.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
            ),
            child: Container(
              margin: EdgeInsets.only(
                  top: 10.h, left: 0.w, right: 0.w, bottom: 10.h),
              child: SizedBox(
                width: Get.width,
                height: 400.h,
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.w),
                        child: TabBar(
                          controller: controller.tabController,
                          unselectedLabelColor: Colors.grey,
                          labelColor: Colors.black,
                          unselectedLabelStyle: defaultTextStyle(
                              color: Colors.black,
                              size: 12.sp,
                              fontWeight: FontWeight.w600),
                          labelStyle: defaultTextStyle(
                              color: Colors.black,
                              size: 12.sp,
                              fontWeight: FontWeight.w600),
                          onTap: (index) {
                            controller.getSelectedTab(index);
                          },
                          tabs: [
                            Tab(text: 'week'.tr),
                            Tab(text: 'month'.tr),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                if (controller.tabController.index == 0) {
                                  controller.buttonPreviousWeekTab();
                                } else {
                                  controller.buttonPreviousMonthTab();
                                }
                              },
                              child: Image.asset(
                                ImagePath.icBackBtn,
                                height: 25.w,
                                width: 25.w,
                              ),
                            ),
                            Text(
                              controller.tabController.index == 0
                                  ? controller.weekDate.toString()
                                  : controller.displayMonthText.toString(),
                              style: defaultTextStyle(
                                  size: 14.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            InkWell(
                              onTap: () {
                                if (controller.tabController.index == 0) {
                                  controller.buttonNextWeekTab();
                                } else {
                                  controller.buttonNextMonthTab();
                                }
                              },
                              child: Image.asset(
                                ImagePath.icNextBtn,
                                height: 25.w,
                                width: 25.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 0.h,
                        color: Colors.orange,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: controller.tabController,
                          children: [
                            widgetWeek(controller),
                            widgetMonth(controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget widgetWeek(BMIDetailController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        legend: Legend(isVisible: false),
        tooltipBehavior: tooltipBehavior,
        series: <ColumnSeries<WeekModel, String>>[
          ColumnSeries<WeekModel, String>(
              enableTooltip: false,
              color: ColorConstants.chartColor,
              dataSource: controller.listWeekData,
              xValueMapper: (WeekModel sales, _) => DateFormat('dd-MMM-yyyy')
                  .format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(sales.title)))
                  .toString()
                  .substring(0, 2),
              //sales.title.substring(0, 2),
              yValueMapper: (WeekModel sales, _) {
                if (sales.count > 0) {
                  double avg = sales.value / sales.count;
                  return avg.toInt(); //.toPrecision(1);
                } else {
                  return sales.value;
                }
              },
              // Enable data label
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ]);
  }

  Widget widgetMonth(BMIDetailController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return SfCartesianChart(
        primaryXAxis: CategoryAxis(
          majorGridLines: const MajorGridLines(width: 0),
        ),
        legend: Legend(isVisible: false),
        tooltipBehavior: tooltipBehavior,
        series: <ColumnSeries<GraphModel, String>>[
          ColumnSeries<GraphModel, String>(
              enableTooltip: false,
              color: ColorConstants.chartColor,
              dataSource: controller.monthGraphPlot,
              xValueMapper: (GraphModel sales, _) => sales.title,
              yValueMapper: (GraphModel sales, _) => sales.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true))
        ]);
  }

  Widget widgetAverage({title, value, onTap}) {
    return Padding(
      padding: EdgeInsets.only(left: 0.w, right: 0.w),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          height: 75.h,
          width: Get.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 14.w, top: 10.h, bottom: 10.h, right: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(
                        title.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: defaultTextStyle(
                            size: 11.sp,
                            fontWeight: FontWeight.w300,
                            color: HexColor('#787878'))),),
                    InkWell(
                      onTap: onTap,
                      child: const Center(
                        child: Icon(
                          size: 15,
                          Icons.edit,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(value.toString(),
                    style: defaultTextStyle(
                        size: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: HexColor('#787878'))),
            // 497059
              ],
            ),
          ),
        ),
      ),
    );
  }
}
