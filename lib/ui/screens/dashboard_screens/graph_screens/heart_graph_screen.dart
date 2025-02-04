import 'package:doori_mobileapp/controllers/dashboard_controllers/graph_controllers/heart_graph_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/activity_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:shimmer/shimmer.dart';

class HeartGraphScreen extends StatefulWidget {
  const HeartGraphScreen({super.key});

  @override
  State<HeartGraphScreen> createState() => _HeartGraphScreenState();
}

class _HeartGraphScreenState extends State<HeartGraphScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HeartGraphController>(
        init: HeartGraphController(context),
        builder: (controller) {
          return ColoredSafeArea(
            color: Colors.white,
            child: Scaffold(
                backgroundColor: HexColor('#EFEFEF'),
                appBar: commonAppbarWhiteColor(
                    title: controller.title, //AppConstants.heartRate,
                    onBack: () {
                      Get.back();
                    }),
                body: SingleChildScrollView(
                  child: SizedBox(
                    width: Get.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: controller.isLoading.value
                          ? widgetLoading(controller)
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          controller.title == 'heart_function'.tr
                              ? Material(
                              elevation: 1,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(8)),
                              child: Container(
                                width: Get.width,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8)),
                                  color: Colors.white,
                                ),
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: 18.h,
                                        left: 16.w,
                                        right: 16.w,
                                        bottom: 10.h),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        controller.measureUserList
                                            .isNotEmpty
                                            ? Container(
                                          child:
                                          widgetTipsForHeartFunction(
                                              controller),
                                        )
                                            : Container(
                                          margin:
                                          EdgeInsets.only(
                                              bottom: 10.h),
                                          width: Get.width,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Text(
                                                    'measure_your_vitals_to_get_useful_insight'
                                                        .tr,
                                                    style:
                                                    defaultTextStyle(
                                                      size: 15.sp,
                                                      color: ColorConstants
                                                          .textGreyColor,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600,
                                                    ),
                                                  )),
                                              InkWell(
                                                onTap:
                                                    () async {
                                                  printf(
                                                      "clicked measure");

                                                  final result =
                                                  await Get.toNamed(
                                                      Routes
                                                          .measureScreen);

                                                  if (result
                                                      .toString() ==
                                                      'save') {
                                                    Get.back(
                                                        result:
                                                        result);
                                                  } else if (result
                                                      .toString() ==
                                                      'exit') {
                                                    Get.back();
                                                  }
                                                  printf(
                                                      'result_graph-$result');
                                                  //Get.toNamed(Routes.measureScreen);
                                                },
                                                child:
                                                Container(
                                                  width: 84.w,
                                                  height: 32.h,
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(30.w)),
                                                    border:
                                                    Border
                                                        .all(
                                                      color: Colors
                                                          .blue,
                                                      width: 1,
                                                    ),
                                                    //color: HexColor('#E3F7FF'),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'measure'
                                                          .tr
                                                          .toUpperCase(),
                                                      style:
                                                      defaultTextStyle(
                                                        size: 11
                                                            .sp,
                                                        color: Colors
                                                            .blue,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ))
                              : controller.title == 'heart_health'.tr
                              ? Container(
                              child: controller
                                  .measureUserList.isNotEmpty
                                  ? Container()
                                  : Material(
                                  elevation: 1,
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Container(
                                    width: Get.width,
                                    decoration:
                                    const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              8)),
                                      color: Colors.white,
                                    ),
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(
                                            top: 18.h,
                                            left: 16.w,
                                            right: 16.w,
                                            bottom: 10.h),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          mainAxisSize:
                                          MainAxisSize
                                              .min,
                                          children: [
                                            controller
                                                .measureUserList
                                                .isNotEmpty
                                                ? Container()
                                                : Container(
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                  10.h),
                                              width: Get
                                                  .width,
                                              child:
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                        'measure_your_vitals_to_get_useful_insight'
                                                            .tr,
                                                        style:
                                                        defaultTextStyle(
                                                          size: 15.sp,
                                                          color: ColorConstants
                                                              .textGreyColor,
                                                          fontWeight: FontWeight
                                                              .w600,
                                                        ),
                                                      )),
                                                  InkWell(
                                                    onTap:
                                                        () async {
                                                      printf("clicked measure");

                                                      final result = await Get
                                                          .toNamed(
                                                          Routes.measureScreen);

                                                      if (result.toString() ==
                                                          'save') {
                                                        Get.back(
                                                            result: result);
                                                      } else
                                                      if (result.toString() ==
                                                          'exit') {
                                                        Get.back();
                                                      }
                                                      printf(
                                                          'result_graph-$result');
                                                      //Get.toNamed(Routes.measureScreen);
                                                    },
                                                    child:
                                                    Container(
                                                      width: 84.w,
                                                      height: 32.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                30.w)),
                                                        border: Border.all(
                                                          color: Colors.blue,
                                                          width: 1,
                                                        ),
                                                        //color: HexColor('#E3F7FF'),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'measure'.tr
                                                              .toUpperCase(),
                                                          style: defaultTextStyle(
                                                            size: 11.sp,
                                                            color: Colors.blue,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  )))
                              : controller.title == AppConstants.heartStrain
                              ? Container(
                              child: controller
                                  .measureUserList.isNotEmpty
                                  ? Container()
                                  : Material(
                                  elevation: 1,
                                  borderRadius:
                                  const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Container(
                                    width: Get.width,
                                    decoration:
                                    const BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(
                                          Radius.circular(
                                              8)),
                                      color: Colors.white,
                                    ),
                                    child: Container(
                                        margin:
                                        EdgeInsets.only(
                                            top: 18.h,
                                            left: 16.w,
                                            right: 16.w,
                                            bottom: 10.h),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .start,
                                          mainAxisSize:
                                          MainAxisSize
                                              .min,
                                          children: [
                                            controller
                                                .measureUserList
                                                .isNotEmpty
                                                ? Container()
                                                : Container(
                                              margin: EdgeInsets.only(
                                                  bottom:
                                                  10.h),
                                              width: Get
                                                  .width,
                                              child:
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Text(
                                                        'measure_your_vitals_to_get_useful_insight'
                                                            .tr,
                                                        style:
                                                        defaultTextStyle(
                                                          size: 15.sp,
                                                          color: ColorConstants
                                                              .textGreyColor,
                                                          fontWeight: FontWeight
                                                              .w600,
                                                        ),
                                                      )),
                                                  InkWell(
                                                    onTap:
                                                        () async {
                                                      printf("clicked measure");

                                                      final result = await Get
                                                          .toNamed(
                                                          Routes.measureScreen);

                                                      if (result.toString() ==
                                                          'save') {
                                                        Get.back(
                                                            result: result);
                                                      } else
                                                      if (result.toString() ==
                                                          'exit') {
                                                        Get.back();
                                                      }
                                                      printf(
                                                          'result_graph-$result');
                                                      //Get.toNamed(Routes.measureScreen);
                                                    },
                                                    child:
                                                    Container(
                                                      width: 84.w,
                                                      height: 32.h,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .all(
                                                            Radius.circular(
                                                                30.w)),
                                                        border: Border.all(
                                                          color: Colors.blue,
                                                          width: 1,
                                                        ),
                                                        //color: HexColor('#E3F7FF'),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'measure'.tr
                                                              .toUpperCase(),
                                                          style: defaultTextStyle(
                                                            size: 11.sp,
                                                            color: Colors.blue,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                  )))
                              : Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                EdgeInsets.only(left: 5.w),
                                child: Text(
                                    '${'last_measure_at'.tr} : ${controller
                                        .lastMeasured}',
                                    style: defaultTextStyle(
                                        size: 12.sp,
                                        fontWeight:
                                        FontWeight.w400,
                                        color: HexColor(
                                            '#787878'))),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Material(
                                elevation: 1,
                                borderRadius:
                                const BorderRadius.all(
                                    Radius.circular(8)),
                                child: Container(
                                  decoration:
                                  const BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(8)),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.all(
                                        15.0),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 2.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              overflow:
                                              TextOverflow
                                                  .ellipsis,
                                              controller.title,
                                              style: defaultTextStyle(
                                                  size: 13.sp,
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  color: Colors
                                                      .black),
                                            ),
                                            Text(
                                                controller
                                                    .value,
                                                style: defaultTextStyle(
                                                    size: 11.sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    color: HexColor(
                                                        '#787878'))),
                                            Text(
                                                controller
                                                    .valueMsg,
                                                overflow:
                                                TextOverflow
                                                    .ellipsis,
                                                style: defaultTextStyle(
                                                    size: 11.sp,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color: HexColor(
                                                        '#787878'))),
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
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w, top: 10.h),
                                child: Text('insight'.tr,
                                    style: defaultTextStyle(
                                        size: 14.sp,
                                        fontWeight:
                                        FontWeight.w400,
                                        color: HexColor(
                                            '#000000'))),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Material(
                                color: Colors.green,
                                elevation: 1,
                                borderRadius:
                                const BorderRadius.all(
                                    Radius.circular(8)),
                                child: Container(
                                    height: 162.h,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      const BorderRadius
                                          .all(
                                          Radius.circular(
                                              8)),
                                      color: controller
                                          .lastWeekResult >
                                          1
                                          ? ColorConstants
                                          .colorForGreen
                                          : ColorConstants
                                          .colorForRed,
                                    ),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment
                                              .topCenter,
                                          child: Material(
                                              elevation: 1,
                                              borderRadius:
                                              const BorderRadius
                                                  .all(
                                                  Radius.circular(
                                                      8)),
                                              child: Container(
                                                height: 130.h,
                                                decoration:
                                                const BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          8)),
                                                  color: Colors
                                                      .white,
                                                ),
                                                child:
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 16
                                                            .h,
                                                        left: 16
                                                            .w,
                                                        right: 16
                                                            .w,
                                                        bottom: 16
                                                            .h),
                                                    child:
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .start,
                                                          children: [
                                                            Expanded(
                                                                child: Row(
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      overflow: TextOverflow
                                                                          .ellipsis,
                                                                      controller
                                                                          .scoreTitle,
                                                                      style: defaultTextStyle(
                                                                          size: 15
                                                                              .sp,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color: Colors
                                                                              .black),
                                                                    ),
                                                                    Expanded(
                                                                      child: InkWell(
                                                                        onTap: () {
                                                                          printf(
                                                                              'show_average_dialog');
                                                                          bottomSheet(
                                                                              controller);
                                                                        },
                                                                        child: Padding(
                                                                          padding: EdgeInsets
                                                                              .only(
                                                                              right: 2
                                                                                  .w),
                                                                          child: Image
                                                                              .asset(
                                                                            'assets/images/ic_info.png',
                                                                            height: 16
                                                                                .w,
                                                                            width: 16
                                                                                .w,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                            SizedBox(
                                                                width: 100.w,
                                                                child: Align(
                                                                  alignment: Alignment
                                                                      .topRight,
                                                                  child: Text(
                                                                    '${controller
                                                                        .finalRestingScore}/100',
                                                                    style: defaultTextStyle(
                                                                        size: 15
                                                                            .sp,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 0
                                                                            .w,
                                                                        vertical: 2
                                                                            .h),
                                                                    height: 9.h,
                                                                    decoration: const BoxDecoration(
                                                                        borderRadius: BorderRadius
                                                                            .only(
                                                                            topLeft: Radius
                                                                                .circular(
                                                                                5),
                                                                            bottomLeft: Radius
                                                                                .circular(
                                                                                5)),
                                                                        color: ColorConstants
                                                                            .colorForRed //HexColor('#f8555a'),
                                                                    ),
                                                                  ),
                                                                  Image.asset(
                                                                    controller
                                                                        .pointer,
                                                                    //ImagePath.icHeartPointer,
                                                                    height: 20
                                                                        .w,
                                                                    width: 20.w,
                                                                    color: controller
                                                                        .red
                                                                        ? null
                                                                        : Colors
                                                                        .transparent,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                      margin: EdgeInsets
                                                                          .symmetric(
                                                                          horizontal: 0
                                                                              .w,
                                                                          vertical: 2
                                                                              .h),
                                                                      height: 9
                                                                          .h,
                                                                      color: ColorConstants
                                                                          .colorForOrange //HexColor('#ffa847'),
                                                                  ),
                                                                  Image.asset(
                                                                    controller
                                                                        .pointer,
                                                                    height: 20
                                                                        .w,
                                                                    width: 20.w,
                                                                    color: controller
                                                                        .orange
                                                                        ? null
                                                                        : Colors
                                                                        .transparent,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 0
                                                                            .w,
                                                                        vertical: 2
                                                                            .h),
                                                                    height: 9.h,
                                                                    color: ColorConstants
                                                                        .colorForYellow, //HexColor('#fae56e'),
                                                                  ),
                                                                  Image.asset(
                                                                    controller
                                                                        .pointer,
                                                                    height: 20
                                                                        .w,
                                                                    width: 20.w,
                                                                    color: controller
                                                                        .yellow
                                                                        ? null
                                                                        : Colors
                                                                        .transparent,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 0
                                                                            .w,
                                                                        vertical: 2
                                                                            .h),
                                                                    height: 9.h,
                                                                    color: ColorConstants
                                                                        .colorForLightGreen, //HexColor('#b0d683'),
                                                                  ),
                                                                  Image.asset(
                                                                    controller
                                                                        .pointer,
                                                                    height: 20
                                                                        .w,
                                                                    width: 20.w,
                                                                    color: controller
                                                                        .lightGreen
                                                                        ? null
                                                                        : Colors
                                                                        .transparent,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal: 0
                                                                            .w,
                                                                        vertical: 2
                                                                            .h),
                                                                    height: 9.h,
                                                                    decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius
                                                                          .only(
                                                                          topRight: Radius
                                                                              .circular(
                                                                              5),
                                                                          bottomRight: Radius
                                                                              .circular(
                                                                              5)),
                                                                      color: ColorConstants
                                                                          .colorForGreen, //HexColor('#f8555a'),
                                                                    ),
                                                                    //HexColor('#4fd286'),
                                                                  ),
                                                                  Image.asset(
                                                                    controller
                                                                        .pointer,
                                                                    height: 20
                                                                        .w,
                                                                    width: 20.w,
                                                                    color: controller
                                                                        .green
                                                                        ? null
                                                                        : Colors
                                                                        .transparent,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.h,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              controller
                                                                  .condition
                                                                  .toString(),
                                                              style: defaultTextStyle(
                                                                  size: 11.sp,
                                                                  fontWeight: FontWeight
                                                                      .w600,
                                                                  color: ColorConstants
                                                                      .textGreyColor),
                                                            ),
                                                            Text(
                                                              '',
                                                              //'${controller.lastWeekResult}% than last week',
                                                              style: defaultTextStyle(
                                                                  size: 11.sp,
                                                                  fontWeight: FontWeight
                                                                      .w300,
                                                                  color: ColorConstants
                                                                      .textGreyColor),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                              )),
                                        ),
                                        Align(
                                          alignment: Alignment
                                              .bottomLeft,
                                          child: Padding(
                                            padding:
                                            EdgeInsets.only(
                                                bottom: 8.h,
                                                left: 16.w),
                                            child: Text(
                                              '${controller
                                                  .lastWeekResult}% ${'than_last_week'
                                                  .tr}',
                                              style: defaultTextStyle(
                                                  size: 11.sp,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600,
                                                  color:
                                                  ColorConstants
                                                      .white),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      child: widgetAverage(
                                          title: controller
                                              .avgRestingTitle,
                                          value: controller
                                              .avgHeartRateScore
                                              .toString())),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                      child: widgetAverage(
                                          title: controller
                                              .maxRestingTitle,
                                          value: controller
                                              .maxRestingHr
                                              .toString())),
                                ],
                              ),
                              controller.title ==
                                  'blood_pressure'.tr
                                  ? Column(
                                mainAxisSize:
                                MainAxisSize.min,
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: widgetAverage(
                                              title:
                                              'avg_resting_dia'
                                                  .tr,
                                              value: controller
                                                  .avgHeartRateScoreForDia
                                                  .toString())),
                                      SizedBox(
                                        width: 8.w,
                                      ),
                                      Expanded(
                                          child: widgetAverage(
                                              title:
                                              'max_resting_dia'
                                                  .tr,
                                              value: controller
                                                  .maxRestingForDia
                                                  .toString())),
                                    ],
                                  ),
                                ],
                              )
                                  : Container(),
                              controller.title ==
                                  'heart_rate'.tr ||
                                  controller.title ==
                                      'oxygen_level'.tr
                                  ? Column(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Material(
                                      elevation: 1,
                                      borderRadius:
                                      const BorderRadius
                                          .all(
                                          Radius
                                              .circular(
                                              8)),
                                      child: Container(
                                        width: Get.width,
                                        decoration:
                                        const BoxDecoration(
                                          borderRadius: BorderRadius
                                              .all(Radius
                                              .circular(
                                              8)),
                                          color: Colors
                                              .white,
                                        ),
                                        child: Container(
                                            margin: EdgeInsets.only(
                                                top: 12.h,
                                                left:
                                                16.w,
                                                right:
                                                16.w,
                                                bottom:
                                                12.h),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              mainAxisSize:
                                              MainAxisSize
                                                  .min,
                                              children: [
                                                Text(
                                                  "today_goal"
                                                      .tr,
                                                  textAlign:
                                                  TextAlign.start,
                                                  style: defaultTextStyle(
                                                      size:
                                                      10.sp,
                                                      fontWeight: FontWeight
                                                          .w200,
                                                      color: HexColor(
                                                          '#787878')),
                                                ),
                                                SizedBox(
                                                  height:
                                                  6.h,
                                                ),
                                                Text(
                                                  controller
                                                      .todayGoalMessage,
                                                  textAlign:
                                                  TextAlign.start,
                                                  style: defaultTextStyle(
                                                      size:
                                                      14.sp,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      color: HexColor(
                                                          '#787878')),
                                                ),
                                                SizedBox(
                                                  height:
                                                  6.h,
                                                ),
                                                controller.averageBPM !=
                                                    0
                                                    ? Container(
                                                  child: controller.title ==
                                                      'heart_function'.tr
                                                      ? widgetTipsForHeartFunction(
                                                      controller)
                                                      : Container(),
                                                )
                                                    : Container(
                                                  //margin: EdgeInsets.only(bottom: 10.h),
                                                  width: Get.width,
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                            'measure_your_vitals_to_get_useful_insight'
                                                                .tr,
                                                            style: defaultTextStyle(
                                                              size: 15.sp,
                                                              color: ColorConstants
                                                                  .textGreyColor,
                                                              fontWeight: FontWeight
                                                                  .w600,
                                                            ),
                                                          )),
                                                      InkWell(
                                                        onTap: () async {
                                                          printf(
                                                              "clicked measure");

                                                          final result = await Get
                                                              .toNamed(Routes
                                                              .measureScreen);

                                                          if (result
                                                              .toString() ==
                                                              'save') {
                                                            Get.back(
                                                                result: result);
                                                          } else if (result
                                                              .toString() ==
                                                              'exit') {
                                                            Get.back();
                                                          }
                                                          printf(
                                                              'result_graph-$result');
                                                          //Get.toNamed(Routes.measureScreen);
                                                        },
                                                        child: Container(
                                                          width: 84.w,
                                                          height: 32.h,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    30.w)),
                                                            border: Border.all(
                                                              color: Colors
                                                                  .blue,
                                                              width: 1,
                                                            ),
                                                            //color: HexColor('#E3F7FF'),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'measure'.tr
                                                                  .toUpperCase(),
                                                              style: defaultTextStyle(
                                                                size: 11.sp,
                                                                color: Colors
                                                                    .blue,
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                // controller
                                                //         .yesterdayMeasure
                                                //         .isNotEmpty
                                                //     ? Text(
                                                //         controller.yesterdayMeasure,
                                                //         textAlign: TextAlign.start,
                                                //         style: defaultTextStyle(size: 14.sp, fontWeight: FontWeight.w600, color: HexColor('#787878')),
                                                //       )
                                                //     : Container(
                                                //         height: 15.h,
                                                //       )
                                              ],
                                            )),
                                      )),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              )
                                  : Padding(
                                padding: EdgeInsets.only(
                                    top: 10.h),
                                child: Material(
                                    elevation: 1,
                                    borderRadius:
                                    const BorderRadius
                                        .all(
                                        Radius
                                            .circular(
                                            8)),
                                    child: Container(
                                      width: Get.width,
                                      decoration:
                                      const BoxDecoration(
                                        borderRadius:
                                        BorderRadius
                                            .all(Radius
                                            .circular(
                                            8)),
                                        color:
                                        Colors.white,
                                      ),
                                      child: Container(
                                          margin: EdgeInsets
                                              .only(
                                              top: 12
                                                  .h,
                                              left: 16
                                                  .w,
                                              right: 16
                                                  .w,
                                              bottom:
                                              18.h),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            mainAxisSize:
                                            MainAxisSize
                                                .min,
                                            children: [
                                              Text(
                                                "Today's Goal",
                                                textAlign:
                                                TextAlign
                                                    .start,
                                                style: defaultTextStyle(
                                                    size: 10
                                                        .sp,
                                                    fontWeight: FontWeight
                                                        .w200,
                                                    color:
                                                    HexColor('#787878')),
                                              ),
                                              SizedBox(
                                                height:
                                                6.h,
                                              ),
                                              Text(
                                                controller
                                                    .todayGoalMessage,
                                                textAlign:
                                                TextAlign
                                                    .start,
                                                style: defaultTextStyle(
                                                    size: 14
                                                        .sp,
                                                    fontWeight: FontWeight
                                                        .w600,
                                                    color:
                                                    HexColor('#787878')),
                                              )
                                            ],
                                          )),
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(left: 5.w, top: 10.h),
                            child: Text('records'.tr,
                                style: defaultTextStyle(
                                    size: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: HexColor('#000000'))),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          cardWidgetGraph(controller),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          );
        });
  }

  Widget widgetLoading(HeartGraphController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: Get.width,
          height: 66.h,
          child: Material(
            elevation: 1,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                    Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Container(
                          height: 13.h,
                          width: 60.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: Container(
                        height: 11.h,
                        width: 56.w,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: Container(
                          height: 10.h,
                          width: 50.w,
                          color: Colors.white,
                        ),
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
        SizedBox(
          height: 10.h,
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          enabled: true,
          child: Padding(
              padding: EdgeInsets.only(left: 5.w, top: 15.h),
              child: Container(
                height: 10.h,
                width: 50.w,
                color: Colors.white,
              )),
        ),
        SizedBox(
          height: 15.h,
        ),
        Material(
          color: Colors.green,
          elevation: 1,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Container(
              height: 162.h,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  color: Colors.white),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Material(
                        elevation: 1,
                        borderRadius:
                        const BorderRadius.all(Radius.circular(8)),
                        child: Container(
                          height: 130.h,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.white,
                          ),
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: 16.h,
                                  left: 16.w,
                                  right: 16.w,
                                  bottom: 16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                Colors.grey.shade100,
                                                enabled: true,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.w, top: 4.h),
                                                    child: Container(
                                                      height: 14.h,
                                                      width: 80.w,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                Colors.grey.shade100,
                                                enabled: true,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w, right: 2.w),
                                                  child: Image.asset(
                                                    'assets/images/ic_info.png',
                                                    height: 16.w,
                                                    width: 16.w,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: SizedBox(
                                            width: 100.w,
                                            child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                  height: 12.h,
                                                  width: 60.w,
                                                  color: Colors.white,
                                                ))),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                    child: Container(
                                      height: 10.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              )),
                        )),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                          padding: EdgeInsets.only(bottom: 8.h, left: 16.w),
                          child: Container(
                            height: 11.h,
                            width: 80.w,
                            color: Colors.white,
                          )),
                    ),
                  )
                ],
              )),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          children: [
            Expanded(
              child: Material(
                elevation: 1,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                  height: 65.h,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 14.w,
                      top: 10.h,
                      bottom: 10.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
              width: 8.w,
            ),
            Expanded(
              child: Material(
                elevation: 1,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Container(
                  height: 65.h,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 14.w,
                      top: 10.h,
                      bottom: 10.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Material(
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
                        top: 12.h, left: 16.w, right: 16.w, bottom: 18.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                        SizedBox(
                          height: 6.h,
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: Container(
                            height: 12.h,
                            width: 80.w,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )),
              )),
        ),
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

  void bottomSheet(HeartGraphController controller) {
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
                      controller.labelMeasureLevel.toString(),
                      style: defaultTextStyle(
                        size: 14.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    controller.title == 'blood_pressure'.tr
                        ? widgetBloodPressureLevel(controller)
                        : controller.title == 'heart_function'.tr
                        ? Container()
                        : controller.title == 'pulse_pressure'.tr
                        ? widgetPulsePressureLevel(controller)
                        : controller.title == 'arterial_pressure'.tr
                        ? widgetArterialPressureLevel(controller)
                        : widgetLevel(controller),
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

  Widget cardWidgetGraph(HeartGraphController controller) {
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
                            Tab(
                              text: 'day'.tr,
                            ),
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
                                if (controller.tabController.index == 1) {
                                  controller.buttonPreviousWeekTab(
                                      controller.totalMeasureRecordList);
                                } else if (controller.tabController.index ==
                                    2) {
                                  controller.buttonPreviousMonthTab();
                                } else {
                                  controller.previousDayTabClick();
                                }
                              },
                              child: Image.asset(
                                ImagePath.icBackBtn,
                                height: 25.w,
                                width: 25.w,
                              ),
                            ),
                            InkWell(
                              onTap: controller.tabController.index == 0
                                  ? () async {
                                DateTime? pickedDate =
                                await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    // DateTime(DateTime.now()),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  String formattedDate =
                                  DateFormat('dd MMM, yyyy')
                                      .format(pickedDate);

                                  controller.displayDateText =
                                      formattedDate;
                                  printf(
                                      '---date--format--$formattedDate');
                                  controller.selectedDate();

                                  //controller.update();
                                }
                              }
                                  : null,
                              child: Text(
                                controller.tabController.index == 1
                                    ? controller.weekDate.toString()
                                    : controller.tabController.index == 2
                                    ? controller.displayMonthText.toString()
                                    : controller.displayDateText.toString(),
                                style: defaultTextStyle(
                                    size: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (controller.tabController.index == 1) {
                                  controller.buttonNextWeekTab(
                                      controller.totalMeasureRecordList);
                                } else if (controller.tabController.index ==
                                    2) {
                                  controller.buttonNextMonthTab();
                                } else {
                                  controller.nextDayTabClick();
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
                            controller.title == AppConstants.heartStrain ?
                            widgetDayForHeartStrain(controller) : widgetDay(
                                controller),
                            widgetWeek(controller),
                            widgetMonth(controller),
                          ],
                        ),
                      ),
                      controller.title == 'blood_pressure'.tr
                          ? Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: widgetTooltipForBloodPressure(),
                      )
                          : controller.title == 'heart_function'.tr ?
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: widgetTooltipForHeartFunction(),
                      )
                          : Container(),
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
        controller.title == 'heart_function'.tr
            ? Container()
            : Row(
          children: [
            Expanded(
                child: widgetAverage(
                    title: 'average'.tr,
                    value: controller.averageBPM.toString())),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                child: widgetAverage(
                    title: 'lowest'.tr,
                    value: controller.lowestBPM.toString())),
            SizedBox(
              width: 8.w,
            ),
            Expanded(
                child: widgetAverage(
                    title: 'highest'.tr,
                    value: controller.highestBPM.toString())),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget widgetAverage({title, value}) {
    return Padding(
      padding: EdgeInsets.only(left: 0.w, right: 0.w),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          height: 65.h,
          width: Get.width,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 14.w,
              top: 10.h,
              bottom: 10.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: defaultTextStyle(
                        size: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: HexColor('#787878'))),
                Text(value.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: defaultTextStyle(
                        size: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: HexColor('#787878'))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetDay(HeartGraphController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return controller.title == 'heart_function'.tr
        ? Container(
      padding: const EdgeInsets.only(right: 20, top: 20),
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 70.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'very_high'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          'high'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Center(
                      child: Text(
                        'normal'.tr,
                        style: defaultTextStyle(
                            size: 10.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Text(
                          'low'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(
                          'very_low'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
              child: Stack(
                children: [
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        crossesAt: 0,
                      ),
                      primaryYAxis: NumericAxis(
                          isVisible: false, minimum: 0, maximum: 80),
                      legend: Legend(isVisible: false),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      series: <
                          CartesianSeries<GraphModelForBloodPressure,
                              String>>[
                        SplineSeries<GraphModelForBloodPressure, String>(
                          enableTooltip: false,
                          color: ColorConstants.chartColor,
                          dataSource: controller.graphDayForBloodPressureList,
                          width: 5,
                          dataLabelSettings: const DataLabelSettings(
                              showZeroValue: false, isVisible: false),
                          markerSettings: const MarkerSettings(
                              borderWidth: 5,
                              color: ColorConstants.white,
                              isVisible: true,
                              height: 3,
                              width: 3,
                              borderColor: ColorConstants.iconColor,
                              shape: DataMarkerType.circle),
                          xValueMapper:
                              (GraphModelForBloodPressure sales, _) {
                            return sales.title;
                          },
                          yValueMapper:
                              (GraphModelForBloodPressure sales, _) {
                            double d = sales.v1;
                            if (d > 0 && d < 20) {
                              return -100;
                            } else if (d > 60) {
                              return 100;
                            } else {
                              return d; //sales.value;
                            }
                          },
                          //sales.v1,
                        ),
                      ]),
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        crossesAt: 0,
                      ),
                      primaryYAxis: NumericAxis(
                          isVisible: false, minimum: 0, maximum: 170),
                      legend: Legend(isVisible: false),
                      tooltipBehavior: TooltipBehavior(enable: false),
                      series: <
                          CartesianSeries<GraphModelForBloodPressure,
                              String>>[
                        SplineSeries<GraphModelForBloodPressure, String>(
                          color: ColorConstants.colorForRed,
                          dataSource: controller.graphDayForBloodPressureList,
                          width: 5,
                          dataLabelSettings: const DataLabelSettings(
                              showZeroValue: false, isVisible: false),
                          markerSettings: const MarkerSettings(
                              color: ColorConstants.white,
                              isVisible: true,
                              borderWidth: 5,
                              height: 3,
                              width: 3,
                              borderColor: ColorConstants.colorForRed,
                              shape: DataMarkerType.circle),
                          xValueMapper:
                              (GraphModelForBloodPressure sales, _) {
                            return sales.title;
                          },
                          yValueMapper:
                              (GraphModelForBloodPressure sales, _) {
                            double d = sales.v2;
                            if (d > 0 && d < 55) {
                              return -100;
                            } else if (d > 115) {
                              return 100;
                            } else {
                              return d; //sales.value;
                            }
                          },
                          //sales.v1,
                        ),
                      ])
                ],
              )),
        ],
      ),
    )
        : Container(
      padding: const EdgeInsets.all(10), // 20
      width: Get.width,
      child: controller.isBloodPressure
          ? SfCartesianChart(
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          legend: Legend(isVisible: false),
          tooltipBehavior: tooltipBehavior,
          series: <
              CartesianSeries<GraphModelForBloodPressure, String>>[
            SplineSeries<GraphModelForBloodPressure, String>(
              enableTooltip: false,
              color: ColorConstants.chartColor,
              dataSource: controller.graphDayForBloodPressureList,
              width: 5,
              dataLabelSettings: const DataLabelSettings(
                  showZeroValue: false, isVisible: true),
              markerSettings: const MarkerSettings(
                  color: ColorConstants.white,
                  isVisible: true,
                  borderWidth: 5,
                  height: 3,
                  width: 3,
                  borderColor: ColorConstants.iconColor,
                  shape: DataMarkerType.circle),
              xValueMapper: (GraphModelForBloodPressure sales, _) {
                return sales.title;
              },
              yValueMapper: (GraphModelForBloodPressure sales, _) =>
              sales.v1,
            ),
            SplineSeries<GraphModelForBloodPressure, String>(
              color: ColorConstants.colorForRed,
              dataSource: controller.graphDayForBloodPressureList,
              width: 5,
              dataLabelSettings: const DataLabelSettings(
                  showZeroValue: false, isVisible: true),
              markerSettings: const MarkerSettings(
                  color: ColorConstants.white,
                  isVisible: true,
                  borderWidth: 5,
                  height: 3,
                  width: 3,
                  borderColor: ColorConstants.colorForRed,
                  shape: DataMarkerType.circle),
              xValueMapper: (GraphModelForBloodPressure sales, _) {
                return sales.title;
              },
              yValueMapper: (GraphModelForBloodPressure sales, _) =>
              sales.v2,
            ),
          ])
          : SfCartesianChart(
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          legend: Legend(isVisible: false),
          tooltipBehavior: tooltipBehavior,
          series: <CartesianSeries<GraphModel, String>>[
            SplineSeries<GraphModel, String>(
              enableTooltip: false,
              color: ColorConstants.chartColor,
              dataSource: controller.graphDayList,
              width: 5,
              dataLabelSettings: const DataLabelSettings(
                  showZeroValue: true, isVisible: true),
              markerSettings: const MarkerSettings(
                  borderWidth: 5.0,
                  color: ColorConstants.white,
                  isVisible: true,
                  height: 3,
                  width: 3,
                  borderColor: ColorConstants.iconColor,
                  shape: DataMarkerType.circle),
              xValueMapper: (GraphModel sales, _) {
                return sales.title;
              },
              yValueMapper: (GraphModel sales, _) => sales.value,
            ),
          ]),
    );
  }

  Widget widgetDayForHeartStrain(HeartGraphController controller) {
    return Container(
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            majorGridLines: const MajorGridLines(width: 0),
          ),
          legend: Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<GraphModel, String>>[
            SplineSeries<GraphModel, String>(
              enableTooltip: false,
              color: ColorConstants.chartColor,
              dataSource: controller.graphDayListForHeartStrain,
              width: 5,
              dataLabelSettings: const DataLabelSettings(
                  showZeroValue: true, isVisible: true),
              markerSettings: const MarkerSettings(
                  borderWidth: 5.0,
                  color: ColorConstants.white,
                  isVisible: true,
                  height: 3,
                  width: 3,
                  borderColor: ColorConstants.iconColor,
                  shape: DataMarkerType.circle),
              xValueMapper: (GraphModel sales, _) {
                return sales.title;
              },
              yValueMapper: (GraphModel sales, _) => sales.value,
            ),
          ]),
    );
  }


  Widget widgetWeek(HeartGraphController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return controller.title == 'heart_function'.tr
        ? Container(
      padding: const EdgeInsets.only(right: 10, top: 20),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 70.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'very_high'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          'high'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Center(
                      child: Text(
                        'normal'.tr,
                        style: defaultTextStyle(
                            size: 10.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Text(
                          'low'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(
                          'very_low'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
              child: Stack(
                children: [
                  SfCartesianChart(
                      primaryXAxis:
                      CategoryAxis(isInversed: true, crossesAt: 0),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                        minimum: -100,
                        maximum: 100,
                      ),
                      legend: Legend(isVisible: false),
                      tooltipBehavior: tooltipBehavior,
                      series: <ColumnSeries<WeekModel, String>>[
                        ColumnSeries<WeekModel, String>(
                            enableTooltip: false,
                            color: ColorConstants.chartColor,
                            dataSource:
                            controller.listWeekData.reversed.toList(),
                            xValueMapper: (WeekModel sales, _) =>
                                DateFormat('dd-MMM-yyyy')
                                    .format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(sales.title)))
                                    .toString()
                                    .substring(0, 2),
                            yValueMapper: (WeekModel sales, _) {
                              if (sales.count > 0) {
                                double avg = sales.value / sales.count;
                                // printf('---week--avg--chart-color $avg');
                                if (avg > 0 && avg < 20) {
                                  return -100;
                                } else if (avg >= 20 && avg < 25) {
                                  return -80;
                                } else if (avg >= 25 && avg < 30) {
                                  return -60;
                                } else if (avg >= 30 && avg < 35) {
                                  return -40;
                                } else if (avg >= 35 && avg < 40) {
                                  return -20;
                                } else if (avg == 40) {
                                  return 0;
                                } else if (avg >= 40 && avg < 45) {
                                  return 20;
                                } else if (avg >= 45 && avg < 55) {
                                  return 40;
                                } else if (avg >= 55 && avg < 60) {
                                  return 60;
                                } else if (avg >= 60 && avg < 65) {
                                  return 80;
                                } else if (avg >= 65) {
                                  return 100;
                                } else {
                                  return avg.toInt(); //toPrecision(1);
                                }
                              } else {
                                return sales.value;
                              }
                            },
                            // Enable data label
                            dataLabelSettings:
                            const DataLabelSettings(isVisible: false)),
                        ColumnSeries<WeekModel, String>(
                            color: ColorConstants.colorForRed,
                            dataSource: controller
                                .listWeekDataForDiastolic.reversed
                                .toList(),
                            xValueMapper: (WeekModel sales, _) =>
                                DateFormat('dd-MMM-yyyy')
                                    .format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(sales.title)))
                                    .toString()
                                    .substring(0, 2),
                            //sales.title.substring(0, 2),
                            yValueMapper: (WeekModel sales, _) {
                              if (sales.count > 0) {
                                final date = DateFormat('dd-MMM-yyyy')
                                    .format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(sales.title)))
                                    .toString()
                                    .substring(0, 2);
                                printf(
                                    '---sales-value---${sales
                                        .value} - count - ${sales.count} ');
                                double avg = sales.value / sales.count;

                                printf(
                                    '---week--avg--red-color $date <-> $avg');
                                if (avg > 0 && avg < 55) {
                                  return -100;
                                } else if (avg >= 55 && avg < 65) {
                                  return -80;
                                } else if (avg >= 65 && avg < 70) {
                                  return -60;
                                } else if (avg >= 70 && avg < 77) {
                                  return -40;
                                } else if (avg >= 77 && avg < 85) {
                                  return -20;
                                } else if (avg == 85) {
                                  return 0;
                                } else if (avg >= 85 && avg < 93) {
                                  return 20;
                                } else if (avg >= 93 && avg < 100) {
                                  return 40;
                                } else if (avg >= 100 && avg < 105) {
                                  return 60;
                                } else if (avg >= 105 && avg < 115) {
                                  return 80;
                                } else if (avg >= 115) {
                                  return 100;
                                } else {
                                  return avg.toInt(); //toPrecision(1);
                                }
                              } else {
                                return sales.value;
                              }
                            },
                            // Enable data label
                            dataLabelSettings:
                            const DataLabelSettings(isVisible: false))
                      ]),
                ],
              )),
        ],
      ),
    )
        : Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 280.h,
      child: controller.isBloodPressure
          ? SfCartesianChart(
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
                xValueMapper: (WeekModel sales, _) =>
                    DateFormat('dd-MMM-yyyy')
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
                dataLabelSettings:
                const DataLabelSettings(isVisible: true)),
            ColumnSeries<WeekModel, String>(
                enableTooltip: false,
                color: ColorConstants.colorForRed,
                dataSource: controller.listWeekDataForDiastolic,
                xValueMapper: (WeekModel sales, _) =>
                    DateFormat('dd-MMM-yyyy')
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
                dataLabelSettings:
                const DataLabelSettings(isVisible: true))
          ])
          : SfCartesianChart(
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
                xValueMapper: (WeekModel sales, _) =>
                    DateFormat('dd-MMM-yyyy')
                        .format(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(sales.title)))
                        .toString()
                        .substring(0, 2),
                //sales.title.substring(0, 2),
                yValueMapper: (WeekModel sales, _)
                {
                  if (sales.count > 0) {
                    double avg = sales.value / sales.count;
                    return avg.toInt(); //.toPrecision(1);
                  } else {
                    return sales.value;
                  }
                },
                // Enable data label
                dataLabelSettings:
                const DataLabelSettings(isVisible: true))
          ]),
    );
  }

  Widget widgetMonth(HeartGraphController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return controller.title == 'heart_function'.tr
        ? Container(
      padding: const EdgeInsets.only(right: 20, top: 20),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 70.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          'very_high'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: Text(
                          'high'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Center(
                      child: Text(
                        'normal'.tr,
                        style: defaultTextStyle(
                            size: 10.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 15.h),
                        child: Text(
                          'low'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
                Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(
                          'very_low'.tr,
                          style: defaultTextStyle(
                              size: 10.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
              child: Stack(
                children: [
                  SfCartesianChart(
                      primaryXAxis:
                      CategoryAxis(isInversed: true, crossesAt: 0),
                      primaryYAxis: NumericAxis(
                        isVisible: false,
                        minimum: -100,
                        maximum: 100,
                      ),
                      legend: Legend(isVisible: false),
                      tooltipBehavior: tooltipBehavior,
                      series: <ColumnSeries<GraphModel, String>>[
                        ColumnSeries<GraphModel, String>(
                            enableTooltip: false,
                            color: ColorConstants.chartColor,
                            dataSource: controller.monthGraphPlot,
                            xValueMapper: (GraphModel sales, _) =>
                            sales.title,
                            yValueMapper: (GraphModel sales, _) {
                              double avg = sales.value;

                              if (avg > 0 && avg < 20) {
                                return -100;
                              } else if (avg >= 20 && avg < 25) {
                                return -80;
                              } else if (avg >= 25 && avg < 30) {
                                return -60;
                              } else if (avg >= 30 && avg < 35) {
                                return -40;
                              } else if (avg >= 35 && avg < 40) {
                                return -20;
                              } else if (avg == 40) {
                                return 0;
                              } else if (avg >= 40 && avg < 45) {
                                return 20;
                              } else if (avg >= 45 && avg < 55) {
                                return 40;
                              } else if (avg >= 55 && avg < 60) {
                                return 60;
                              } else if (avg >= 60 && avg < 65) {
                                return 80;
                              } else if (avg >= 65) {
                                return 100;
                              } else {
                                return avg.toInt(); //.toPrecision(1);
                              }

                              //return sales.value;
                            },
                            dataLabelSettings:
                            const DataLabelSettings(isVisible: false)),
                        ColumnSeries<GraphModel, String>(
                            color: Colors.redAccent,
                            //ColorConstants.lightRed,
                            dataSource: controller.monthGraphPlotForDiastolic,
                            xValueMapper: (GraphModel sales, _) =>
                            sales.title,
                            yValueMapper: (GraphModel sales, _) {
                              double avg = sales.value;

                              if (avg > 0 && avg < 55) {
                                return -100;
                              } else if (avg >= 55 && avg < 65) {
                                return -80;
                              } else if (avg >= 65 && avg < 70) {
                                return -60;
                              } else if (avg >= 70 && avg < 77) {
                                return -40;
                              } else if (avg >= 77 && avg < 85) {
                                return -20;
                              } else if (avg == 85) {
                                return 0;
                              } else if (avg >= 85 && avg < 93) {
                                return 20;
                              } else if (avg >= 93 && avg < 100) {
                                return 40;
                              } else if (avg >= 100 && avg < 105) {
                                return 60;
                              } else if (avg >= 105 && avg < 115) {
                                return 80;
                              } else if (avg >= 115) {
                                return 100;
                              } else {
                                return avg.toInt(); //.toPrecision(1);
                              }
                              //return sales.value;
                            },
                            dataLabelSettings:
                            const DataLabelSettings(isVisible: false))
                      ]),
                ],
              )),
        ],
      ),
    )
        : Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      height: 280.h,
      child: controller.isBloodPressure
          ? SfCartesianChart(
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
                dataLabelSettings:
                const DataLabelSettings(isVisible: true)),
            ColumnSeries<GraphModel, String>(
                enableTooltip: false,
                color: Colors.redAccent,
                //ColorConstants.lightRed,
                dataSource: controller.monthGraphPlotForDiastolic,
                xValueMapper: (GraphModel sales, _) => sales.title,
                yValueMapper: (GraphModel sales, _) => sales.value,
                dataLabelSettings:
                const DataLabelSettings(isVisible: true))
          ])
          : SfCartesianChart(
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
                dataLabelSettings:
                const DataLabelSettings(isVisible: true))
          ]),
    );
  }

  Widget widgetBloodPressureLevel(HeartGraphController controller) {
    return Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: Get.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 30.w,
                          width: 30.w,
                          color: Colors.transparent,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '',
                        style: defaultTextStyle(
                          size: 14.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 18.w,
                      ),
                      Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            '${'systolic'.tr}\n (${'mmHg'.tr})',
                            style: defaultTextStyle(
                              size: 13.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                      Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            '${'diastolic'.tr}\n (${'mmHg'.tr})',
                            style: defaultTextStyle(
                              size: 13.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ))
            ],
          ),
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForGreen,
          text: 'very_healthy'.tr,
          systolic: '118-122',
          diastolic: '78-82',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForLightGreen,
          text: 'healthy'.tr,
          systolic: '116-118\n&\n122-124',
          diastolic: '76-78\n&\n82-84',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForYellow,
          text: 'average'.tr,
          systolic: '114-116\n&\n124-126',
          diastolic: '74-76\n&\n84-86',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForOrange,
          text: 'unhealthy'.tr,
          systolic: '112-114\n&\n126-128',
          diastolic: '72-74\n&\n86-88',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForRed,
          text: 'very_unhealthy'.tr,
          systolic: '<112\n&\n>128',
          diastolic: '<72\n&\n>88',
        ),
      ],
    );
  }

  Widget widgetPulsePressureLevel(HeartGraphController controller) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: Get.width,
          //height: 60.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 30.w,
                          width: 30.w,
                          color: Colors.transparent,
                        ),
                      ),
                      SizedBox(width: 22.w),
                      Text(
                        '',
                        style: defaultTextStyle(
                          size: 14.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 18.w,
                      ),
                      Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            'low'.tr,
                            style: defaultTextStyle(
                              size: 13.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                      Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            'high'.tr,
                            style: defaultTextStyle(
                              size: 13.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ))
            ],
          ),
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForGreen,
          text: 'very_healthy'.tr,
          systolic: '35-45',
          diastolic: '',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForLightGreen,
          text: 'healthy'.tr,
          systolic: '30-35',
          diastolic: '45-50',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForYellow,
          text: 'average'.tr,
          systolic: '25-30',
          diastolic: '50-55',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForOrange,
          text: 'unhealthy'.tr,
          systolic: '20-25',
          diastolic: '55-60',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForRed,
          text: 'very_unhealthy'.tr,
          systolic: '<20',
          diastolic: '>60',
        ),
      ],
    );
  }

  Widget widgetArterialPressureLevel(HeartGraphController controller) {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          width: Get.width,
          //height: 60.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                          height: 30.w,
                          width: 30.w,
                          color: Colors.transparent,
                        ),
                      ),
                      SizedBox(width: 22.w),
                      Text(
                        '',
                        style: defaultTextStyle(
                          size: 14.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 18.w,
                      ),
                      Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            'low'.tr,
                            style: defaultTextStyle(
                              size: 13.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                      Expanded(
                          child: Text(
                            textAlign: TextAlign.center,
                            'high'.tr,
                            style: defaultTextStyle(
                              size: 13.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ))
            ],
          ),
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForGreen,
          text: 'very_healthy'.tr,
          systolic: '77-93',
          diastolic: '',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForLightGreen,
          text: 'healthy'.tr,
          systolic: '70-77',
          diastolic: '93-100',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForYellow,
          text: 'average'.tr,
          systolic: '65-70',
          diastolic: '100-105',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForOrange,
          text: 'unhealthy'.tr,
          systolic: '55-65',
          diastolic: '105-115',
        ),
        widgetMeasureLevelForBloodPressure(
          color: ColorConstants.colorForRed,
          text: 'very_unhealthy'.tr,
          systolic: '<55',
          diastolic: '>115',
        ),
      ],
    );
  }

  Widget widgetLevel(HeartGraphController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10.h,
        ),
        widgetMeasureLevels(
            color: ColorConstants.colorForGreen,
            text: 'very_healthy'.tr,
            value: controller.veryHealthy),
        widgetMeasureLevels(
            color: ColorConstants.colorForLightGreen,
            text: 'healthy'.tr,
            value: controller.healthy),
        widgetMeasureLevels(
            color: ColorConstants.colorForYellow,
            text: 'average'.tr,
            value: controller.average),
        widgetMeasureLevels(
            color: ColorConstants.colorForOrange,
            text: 'unhealthy'.tr,
            value: controller.unHealthy),
        widgetMeasureLevels(
            color: ColorConstants.colorForRed,
            text: 'very_unhealthy'.tr,
            value: controller.veryUnhealthy),
      ],
    );
  }

  Widget widgetMeasureLevelForBloodPressure({
    required Color color,
    required String text,
    required String systolic,
    required String diastolic,
  }) {
    return SizedBox(
      width: Get.width,
      height: 60.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      height: 29.w,
                      width: 29.w,
                      color: color,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    text,
                    style: defaultTextStyle(
                      size: 14.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )),
          Expanded(
              flex: 5,
              child: Row(
                children: [
                  SizedBox(
                    width: 24.w,
                  ),
                  Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        systolic,
                        style: defaultTextStyle(
                          size: 13.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        diastolic,
                        style: defaultTextStyle(
                          size: 13.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                ],
              ))
        ],
      ),
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
                  Text(
                    text,
                    style: defaultTextStyle(
                      size: 14.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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

  Widget widgetGraphDayDynamic(HeartGraphController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);

    return SingleChildScrollView(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    controller.previousDayTabClick();
                  },
                  child: Image.asset(
                    ImagePath.icBackBtn,
                    height: 30.w,
                    width: 30.w,
                  ),
                ),
                Text(
                  controller.displayDateText.toString(),
                  style: defaultTextStyle(
                      size: 16.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    controller.nextDayTabClick();
                  },
                  child: Image.asset(
                    ImagePath.icNextBtn,
                    height: 30.w,
                    width: 30.w,
                  ),
                ),
              ],
            ),
          ),
          Container(
            //
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: 280.h,
            child: controller.isBloodPressure
                ? SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                legend: Legend(isVisible: false),
                tooltipBehavior: tooltipBehavior,
                series: <CartesianSeries<GraphModel, String>>[
                  SplineSeries<GraphModel, String>(
                    color: ColorConstants.chartColor,
                    dataSource: controller.graphDayList,
                    width: 5,
                    dataLabelSettings: const DataLabelSettings(
                        showZeroValue: false, isVisible: true),
                    markerSettings: const MarkerSettings(
                        color: ColorConstants.white,
                        isVisible: true,
                        height: 10,
                        width: 10,
                        borderColor: ColorConstants.iconColor,
                        shape: DataMarkerType.circle),
                    xValueMapper: (GraphModel sales, _) {
                      var x = '';
                      printf(
                          'x_values-${sales.title} ${sales.title.length}');
                      if (sales.title.length > 7) {
                        x = sales.title
                            .substring(0, sales.title.length - 3);
                      } else if (sales.title.length == 7) {
                        x = sales.title
                            .substring(0, sales.title.length - 2);
                      } else {
                        x = sales.title;
                      }
                      return x;
                    },
                    //=> sales.title,
                    yValueMapper: (GraphModel sales, _) => sales.value,
                  ),
                  SplineSeries<GraphModel, String>(
                    color: ColorConstants.colorForRed,
                    dataSource: controller.graphDayListForDiastolic,
                    width: 5,
                    dataLabelSettings: const DataLabelSettings(
                        showZeroValue: false, isVisible: true),
                    markerSettings: const MarkerSettings(
                        color: ColorConstants.white,
                        isVisible: true,
                        height: 10,
                        width: 10,
                        borderColor: ColorConstants.colorForRed,
                        shape: DataMarkerType.circle),
                    xValueMapper: (GraphModel sales, _) {
                      var x = '';
                      printf(
                          'x_values-${sales.title} ${sales.title.length}');
                      if (sales.title.length > 7) {
                        x = sales.title
                            .substring(0, sales.title.length - 3);
                      } else if (sales.title.length == 7) {
                        x = sales.title
                            .substring(0, sales.title.length - 2);
                      } else {
                        x = sales.title;
                      }
                      return x;
                    },
                    //=> sales.title,
                    yValueMapper: (GraphModel sales, _) => sales.value,
                  ),
                ])
                : SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                legend: Legend(isVisible: false),
                tooltipBehavior: tooltipBehavior,
                series: <CartesianSeries<GraphModel, String>>[
                  SplineSeries<GraphModel, String>(
                    color: ColorConstants.chartColor,
                    dataSource: controller.graphDayList,
                    width: 5,
                    dataLabelSettings: const DataLabelSettings(
                        showZeroValue: false, isVisible: true),
                    markerSettings: const MarkerSettings(
                        color: ColorConstants.white,
                        isVisible: true,
                        height: 10,
                        width: 10,
                        borderColor: ColorConstants.iconColor,
                        shape: DataMarkerType.circle),
                    xValueMapper: (GraphModel sales, _) {
                      var x = '';
                      printf(
                          'x_values-${sales.title} ${sales.title.length}');
                      if (sales.title.length > 7) {
                        x = sales.title
                            .substring(0, sales.title.length - 3);
                      } else if (sales.title.length == 7) {
                        x = sales.title
                            .substring(0, sales.title.length - 2);
                      } else {
                        x = sales.title;
                      }
                      return x; //sales.title;
                    },
                    yValueMapper: (GraphModel sales, _) => sales.value,
                  ),
                ]),
          ),
          widgetDivider(height: 10.h, hexColor: '#F2F2F2'),
          controller.title == 'blood_pressure'.tr
              ? widgetTodayStatisticsForBloodPressure(controller)
              : widgetTodayStatistics(controller),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

  Widget widgetTodayStatistics(HeartGraphController controller) {
    var about = "(in bpm)";
    var pointer = ImagePath.icHeartPointer;
    if (controller.title == 'oxygen_level'.tr) {
      pointer = ImagePath.icPointerOxygen;
      about = "(in %)";
    } else if (controller.title == 'pulse_pressure'.tr) {
      pointer = ImagePath.icPointerPulse;
      about = "(in mmHg)";
    } else if (controller.title == 'arterial_pressure'.tr) {
      pointer = ImagePath.icPointerArterial;
      about = "(in mmHg)";
    } else if (controller.title == 'hr_variability'.tr) {
      pointer = ImagePath.icPointerHRV;
      about = "(in ms)";
    }

    return controller.title == 'heart_function'.tr
        ? Container(
        child: controller.averageBPM != 0
            ? Container()
            : SizedBox(
          height: 70.h,
          width: Get.width,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                    'measure_your_vitals_to_get_useful_insight'.tr,
                    style: defaultTextStyle(
                      size: 15.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              InkWell(
                onTap: () async {
                  printf("clicked measure");

                  final result =
                  await Get.toNamed(Routes.measureScreen);

                  if (result.toString() == 'save') {
                    Get.back(result: result);
                  } else if (result.toString() == 'exit') {
                    Get.back();
                  }
                  printf('result_graph-$result');
                  //Get.toNamed(Routes.measureScreen);
                },
                child: Container(
                  width: 84.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(30.w)),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                    color: HexColor('#E3F7FF'),
                  ),
                  child: Center(
                    child: Text(
                      'measure'.tr.toUpperCase(),
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
        ))
        : SizedBox(
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            controller.averageBPM != 0
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'average'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.averageBPM.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              about.toString(),
                              //'(in bpm)',
                              style: defaultTextStyle(
                                size: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'highest'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.highestBPM.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              '',
                              style: defaultTextStyle(
                                size: 12.sp,
                                //lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'lowest'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.lowestBPM.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              '',
                              style: defaultTextStyle(
                                size: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 2.h),
                              height: 10.h,
                              width: 23.w,
                              color: ColorConstants
                                  .colorForRed //HexColor('#f8555a'),
                          ),
                          Image.asset(
                            pointer,
                            //ImagePath.icHeartPointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.red
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 2.h),
                              height: 10.h,
                              width: 23.w,
                              color: ColorConstants
                                  .colorForOrange //HexColor('#ffa847'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.orange
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForYellow, //HexColor('#fae56e'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.yellow
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForLightGreen, //HexColor('#b0d683'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.lightGreen
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForGreen, //HexColor('#4fd286'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.green
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
                : SizedBox(
              height: 70.h,
              width: Get.width,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'measure_your_vitals_to_get_useful_insight'.tr,
                        style: defaultTextStyle(
                          size: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  InkWell(
                    onTap: () async {
                      printf("clicked measure");

                      final result =
                      await Get.toNamed(Routes.measureScreen);

                      if (result.toString() == 'save') {
                        Get.back(result: result);
                      } else if (result.toString() == 'exit') {
                        Get.back();
                      }
                      printf('result_graph-$result');
                      //Get.toNamed(Routes.measureScreen);
                    },
                    child: Container(
                      width: 84.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(30.w)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        color: HexColor('#E3F7FF'),
                      ),
                      child: Center(
                        child: Text(
                          'measure'.tr.toUpperCase(),
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
            controller.yesterdayMeasure.isNotEmpty
                ? Container(
              width: Get.height,
              margin: EdgeInsets.symmetric(
                  horizontal: 0.w, vertical: 15.h),
              decoration: BoxDecoration(
                borderRadius:
                const BorderRadius.all(Radius.circular(30)),
                color: HexColor('#E3F7FF'),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 14.h,
                      bottom: 14.h,
                      left: 18.w,
                      right: 18.w),
                  child: Text(
                    controller.yesterdayMeasure,
                    textAlign: TextAlign.left,
                    style: defaultTextStyle(
                        size: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: HexColor('#757575')),
                  ),
                ),
              ),
            )
                : Container(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetWeekStatistics(HeartGraphController controller) {
    var pointer = ImagePath.icHeartPointer;
    if (controller.title == 'oxygen_level'.tr) {
      pointer = ImagePath.icOxygenLevel;
    } else if (controller.title == 'pulse_pressure'.tr) {
      pointer = ImagePath.icPulsePointer;
    } else if (controller.title == 'arterial_pressure'.tr) {
      pointer = ImagePath.icArterialPointer;
    }

    return controller.title == 'heart_function'.tr
        ? Container(
        child: controller.averageBPMForWeek != 0
            ? SizedBox(
          height: 70.h,
          width: Get.width,
          child: Row(
            children: [
              Expanded(
                  child: Text(
                    'measure_your_vitals_to_get_useful_insight'.tr,
                    style: defaultTextStyle(
                      size: 15.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              InkWell(
                onTap: () async {
                  printf("clicked measure");

                  final result =
                  await Get.toNamed(Routes.measureScreen);

                  if (result.toString() == 'save') {
                    Get.back(result: result);
                  } else if (result.toString() == 'exit') {
                    Get.back();
                  }
                  printf('result_graph-$result');
                  //Get.toNamed(Routes.measureScreen);
                },
                child: Container(
                  width: 84.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.all(Radius.circular(30.w)),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                    color: HexColor('#E3F7FF'),
                  ),
                  child: Center(
                    child: Text(
                      'measure'.tr.toUpperCase(),
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
        )
            : Container())
        : SizedBox(
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            controller.averageBPMForWeek != 0
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'average'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.averageBPMForWeek.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              '(in bpm)',
                              style: defaultTextStyle(
                                size: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'highest'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.highestBPMForWeek.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              '',
                              style: defaultTextStyle(
                                size: 12.sp,
                                //lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'lowest'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.lowestBPMForWeek.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              '',
                              style: defaultTextStyle(
                                size: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 2.h),
                              height: 10.h,
                              width: 23.w,
                              color: ColorConstants
                                  .colorForRed //HexColor('#f8555a'),
                          ),
                          Image.asset(
                            pointer,
                            //ImagePath.icHeartPointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.red
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 2.h),
                              height: 10.h,
                              width: 23.w,
                              color: ColorConstants
                                  .colorForOrange //HexColor('#ffa847'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.orange
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForYellow, //HexColor('#fae56e'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.yellow
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForLightGreen, //HexColor('#b0d683'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.lightGreen
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForGreen, //HexColor('#4fd286'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.green
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
                : SizedBox(
              height: 70.h,
              width: Get.width,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'measure_your_vitals_to_get_useful_insight'.tr,
                        style: defaultTextStyle(
                          size: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  InkWell(
                    onTap: () async {
                      printf("clicked measure");

                      final result =
                      await Get.toNamed(Routes.measureScreen);

                      if (result.toString() == 'save') {
                        Get.back(result: result);
                      } else if (result.toString() == 'exit') {
                        Get.back();
                      }
                      printf('result_graph-$result');
                      //Get.toNamed(Routes.measureScreen);
                    },
                    child: Container(
                      width: 84.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(30.w)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        color: HexColor('#E3F7FF'),
                      ),
                      child: Center(
                        child: Text(
                          'measure'.tr.toUpperCase(),
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
            Container(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetMonthStatistics(HeartGraphController controller) {
    var pointer = ImagePath.icHeartPointer;
    if (controller.title == 'oxygen_level'.tr) {
      pointer = ImagePath.icOxygenLevel;
    } else if (controller.title == 'pulse_pressure'.tr) {
      pointer = ImagePath.icPulsePointer;
    } else if (controller.title == 'arterial_pressure'.tr) {
      pointer = ImagePath.icArterialPointer;
    }
    return controller.title == 'heart_function'.tr
        ? Container(
      child: controller.averageBPMForMonth != 0
          ? SizedBox(
        height: 70.h,
        width: Get.width,
        child: Row(
          children: [
            Expanded(
                child: Text(
                  'measure_your_vitals_to_get_useful_insight'.tr,
                  style: defaultTextStyle(
                    size: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            InkWell(
              onTap: () async {
                printf("clicked measure");

                final result =
                await Get.toNamed(Routes.measureScreen);

                if (result.toString() == 'save') {
                  Get.back(result: result);
                } else if (result.toString() == 'exit') {
                  Get.back();
                }
                printf('result_graph-$result');
                //Get.toNamed(Routes.measureScreen);
              },
              child: Container(
                width: 84.w,
                height: 32.h,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(30.w)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  color: HexColor('#E3F7FF'),
                ),
                child: Center(
                  child: Text(
                    'measure'.tr.toUpperCase(),
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
      )
          : Container(),
    )
        : SizedBox(
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            controller.averageBPMForMonth != 0
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'average'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.averageBPMForMonth.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              '(in bpm)',
                              style: defaultTextStyle(
                                size: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'highest'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.highestBPMForMonth.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              '',
                              style: defaultTextStyle(
                                size: 12.sp,
                                //lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'lowest'.tr,
                              style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              controller.lowestBPMForMonth.toString(),
                              style: defaultTextStyle(
                                size: 18.sp,
                                lineHeight: 1.3,
                                fontWeight: FontWeight.w700,
                                color: HexColor('#757575'),
                              ),
                            ),
                            Text(
                              '',
                              style: defaultTextStyle(
                                size: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: HexColor('#757575'),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 5.h),
                          width: 0.5.w,
                          height: 40.h,
                          color: Colors.grey,
                        ),
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 10.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 2.h),
                              height: 10.h,
                              width: 23.w,
                              color: ColorConstants
                                  .colorForRed //HexColor('#f8555a'),
                          ),
                          Image.asset(
                            pointer,
                            //ImagePath.icHeartPointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.red
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0.w, vertical: 2.h),
                              height: 10.h,
                              width: 23.w,
                              color: ColorConstants
                                  .colorForOrange //HexColor('#ffa847'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.orange
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForYellow, //HexColor('#fae56e'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.yellow
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForLightGreen, //HexColor('#b0d683'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.lightGreen
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 0.w, vertical: 2.h),
                            height: 10.h,
                            width: 23.w,
                            color: ColorConstants
                                .colorForGreen, //HexColor('#4fd286'),
                          ),
                          Image.asset(
                            pointer,
                            height: 20.w,
                            width: 20.w,
                            color: controller.green
                                ? null
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
                : SizedBox(
              height: 70.h,
              width: Get.width,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'measure_your_vitals_to_get_useful_insight'.tr,
                        style: defaultTextStyle(
                          size: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  InkWell(
                    onTap: () async {
                      printf("clicked measure");

                      final result =
                      await Get.toNamed(Routes.measureScreen);

                      if (result.toString() == 'save') {
                        Get.back(result: result);
                      } else if (result.toString() == 'exit') {
                        Get.back();
                      }
                      printf('result_graph-$result');
                      //Get.toNamed(Routes.measureScreen);
                    },
                    child: Container(
                      width: 84.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(30.w)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        color: HexColor('#E3F7FF'),
                      ),
                      child: Center(
                        child: Text(
                          'measure'.tr.toUpperCase(),
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
            Container(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetTodayStatisticsForBloodPressure(
      HeartGraphController controller) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.averageBPM != 0
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widgetTooltipForBloodPressure(),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'systolic'.tr,
                                          style: defaultTextStyle(
                                            size: 18.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w700,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          "(in mmHg)",
                                          style: defaultTextStyle(
                                            size: 13.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          '',
                                          style: defaultTextStyle(
                                            size: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'average'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.averageBPM.toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'highest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.highestBPM.toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      //lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'lowest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.lowestBPM.toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'diastolic'.tr,
                                          style: defaultTextStyle(
                                            size: 18.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w700,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          "(in mmHg)",
                                          style: defaultTextStyle(
                                            size: 13.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          '',
                                          style: defaultTextStyle(
                                            size: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'average'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.averageForDiastolic.toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'highest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.highestForDiastolic.toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      //lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'lowest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.lowestForDiastolic.toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 2.h),
                                  height: 15.h,
                                  color: ColorConstants
                                      .colorForRed //HexColor('#f8555a'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.red
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 2.h),
                                  height: 15.h,
                                  color: ColorConstants
                                      .colorForOrange //HexColor('#ffa847'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.orange
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForYellow, //HexColor('#fae56e'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.yellow
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForLightGreen, //HexColor('#b0d683'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.lightGreen
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForGreen, //HexColor('#4fd286'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.green
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            )
                : SizedBox(
              height: 70.h,
              width: Get.width,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'measure_your_vitals_to_get_useful_insight'.tr,
                        style: defaultTextStyle(
                          size: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  InkWell(
                    onTap: () async {
                      printf("clicked measure");
                      final result =
                      await Get.toNamed(Routes.measureScreen);

                      if (result.toString() == 'save') {
                        Get.back(result: result);
                      } else if (result.toString() == 'exit') {
                        Get.back();
                      }
                      printf('result_graph-$result');
                      //Get.toNamed(Routes.measureScreen);
                    },
                    child: Container(
                      width: 94.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        color: HexColor('#E3F7FF'),
                      ),
                      child: Center(
                        child: Text(
                          'measure'.tr.toUpperCase(),
                          style: defaultTextStyle(
                            size: 12.sp,
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
          ],
        ),
      ),
    );
  }

  Widget widgetTooltipForBloodPressure() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 5.w, left: 5.w),
                color: ColorConstants.chartColor,
                height: 10.h,
                width: 30.w,
              ),
              Expanded(
                child: Text(
                  'systolic'.tr,
                  style: defaultTextStyle(
                      size: 10.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 5.w, left: 5.w),
                color: ColorConstants.colorForRed,
                height: 10.h,
                width: 30.w,
              ),
              Expanded(
                child: Text(
                  'diastolic'.tr,
                  style: defaultTextStyle(
                      size: 10.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        /*SizedBox(
          height: 15.h,
        ),*/
      ],
    );
  }

  Widget widgetWeekStatisticsForBloodPressure(HeartGraphController controller) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.averageForWeekSystolic != 0
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widgetTooltipForBloodPressure(),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'systolic'.tr,
                                          style: defaultTextStyle(
                                            size: 18.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w700,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          "(in mmHg)",
                                          style: defaultTextStyle(
                                            size: 13.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          '',
                                          style: defaultTextStyle(
                                            size: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'average'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.averageForWeekSystolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'highest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.highestForWeekSystolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      //lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'lowest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.lowestForWeekSystolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'diastolic'.tr,
                                          style: defaultTextStyle(
                                            size: 18.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w700,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          "(in mmHg)",
                                          style: defaultTextStyle(
                                            size: 13.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          '',
                                          style: defaultTextStyle(
                                            size: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'average'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.averageForWeekDiastolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'highest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.highestForWeekDiastolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      //lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'lowest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.lowestForWeekDiastolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 2.h),
                                  height: 15.h,
                                  color: ColorConstants
                                      .colorForRed //HexColor('#f8555a'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.red
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 2.h),
                                  height: 15.h,
                                  color: ColorConstants
                                      .colorForOrange //HexColor('#ffa847'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.orange
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForYellow, //HexColor('#fae56e'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.yellow
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForLightGreen, //HexColor('#b0d683'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.lightGreen
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForGreen, //HexColor('#4fd286'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.green
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            )
                : SizedBox(
              height: 70.h,
              width: Get.width,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'measure_your_vitals_to_get_useful_insight'.tr,
                        style: defaultTextStyle(
                          size: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  InkWell(
                    onTap: () async {
                      printf("clicked measure");
                      final result =
                      await Get.toNamed(Routes.measureScreen);

                      if (result.toString() == 'save') {
                        Get.back(result: result);
                      } else if (result.toString() == 'exit') {
                        Get.back();
                      }
                      printf('result_graph-$result');
                      //Get.toNamed(Routes.measureScreen);
                    },
                    child: Container(
                      width: 94.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        color: HexColor('#E3F7FF'),
                      ),
                      child: Center(
                        child: Text(
                          'measure'.tr.toUpperCase(),
                          style: defaultTextStyle(
                            size: 12.sp,
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
          ],
        ),
      ),
    );
  }

  Widget widgetMonthStatisticsForBloodPressure(
      HeartGraphController controller) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.averageForMonthSystolic != 0
                ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widgetTooltipForBloodPressure(),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'systolic'.tr,
                                          style: defaultTextStyle(
                                            size: 18.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w700,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          "(in mmHg)",
                                          style: defaultTextStyle(
                                            size: 13.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          '',
                                          style: defaultTextStyle(
                                            size: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'average'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.averageForMonthSystolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'highest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.highestForMonthSystolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      //lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'lowest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.lowestForMonthSystolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          'diastolic'.tr,
                                          style: defaultTextStyle(
                                            size: 18.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w700,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          "(in mmHg)",
                                          style: defaultTextStyle(
                                            size: 13.sp,
                                            lineHeight: 1.3,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                        Text(
                                          '',
                                          style: defaultTextStyle(
                                            size: 12.sp,
                                            fontWeight: FontWeight.w500,
                                            color: HexColor('#757575'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'average'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.averageForMonthDiastolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'highest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.highestForMonthDiastolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      //lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 5.h),
                                width: 0.5.w,
                                height: 40.h,
                                color: Colors.grey,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'lowest'.tr,
                                    style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    controller.lowestForMonthDiastolic
                                        .toString(),
                                    style: defaultTextStyle(
                                      size: 18.sp,
                                      lineHeight: 1.3,
                                      fontWeight: FontWeight.w700,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                  Text(
                                    '',
                                    style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: HexColor('#757575'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 2.h),
                                  height: 15.h,
                                  color: ColorConstants
                                      .colorForRed //HexColor('#f8555a'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.red
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 0.w, vertical: 2.h),
                                  height: 15.h,
                                  color: ColorConstants
                                      .colorForOrange //HexColor('#ffa847'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.orange
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForYellow, //HexColor('#fae56e'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.yellow
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForLightGreen, //HexColor('#b0d683'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.lightGreen
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0.w, vertical: 2.h),
                                height: 15.h,
                                color: ColorConstants
                                    .colorForGreen, //HexColor('#4fd286'),
                              ),
                              Image.asset(
                                ImagePath.icBPPointer,
                                height: 20.w,
                                width: 20.w,
                                color: controller.green
                                    ? null
                                    : Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            )
                : SizedBox(
              height: 70.h,
              width: Get.width,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                        'measure_your_vitals_to_get_useful_insight'.tr,
                        style: defaultTextStyle(
                          size: 15.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  InkWell(
                    onTap: () async {
                      printf("clicked measure");
                      final result =
                      await Get.toNamed(Routes.measureScreen);

                      if (result.toString() == 'save') {
                        Get.back(result: result);
                      } else if (result.toString() == 'exit') {
                        Get.back();
                      }
                      printf('result_graph-$result');
                      //Get.toNamed(Routes.measureScreen);
                    },
                    child: Container(
                      width: 94.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(30)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                        color: HexColor('#E3F7FF'),
                      ),
                      child: Center(
                        child: Text(
                          'measure'.tr.toUpperCase(),
                          style: defaultTextStyle(
                            size: 12.sp,
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
          ],
        ),
      ),
    );
  }

  Widget widgetHealthTipsForWeek(HeartGraphController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 5.w, left: 10.w),
      child: Material(
        elevation: 3,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12.0),
          topLeft: Radius.circular(12.0),
        ), //all(Radius.circular(12)),
        child: InkWell(
          onTap: () {
            //Get.toNamed(Routes.healthTipsScreen);
          },
          child: Container(
            width: Get.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${'how_to_improve'.tr} ',
                    style: defaultTextStyle(
                        size: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '${'stroke_volume'.tr} :',
                    style: defaultTextStyle(
                        size: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: HexColor('#787878')),
                  ),
                  Text(
                    controller.strokeVolumeTip,
                    style: defaultTextStyle(
                        size: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: HexColor('#787878')),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '${'cardiac_output'.tr} :',
                    style: defaultTextStyle(
                        size: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: HexColor('#787878')),
                  ),
                  Text(
                    controller.cardiacVolumeTip,
                    style: defaultTextStyle(
                        size: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: HexColor('#787878')),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetTipsForHeartFunction(HeartGraphController controller) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5.h,
        ),
        Text(
          '${'how_to_improve'.tr} ',
          style: defaultTextStyle(
              size: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          '${'stroke_volume'.tr} :',
          style: defaultTextStyle(
              size: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        Text(
          controller.strokeVolumeTip,
          style: defaultTextStyle(
              size: 13.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black), //HexColor('#787878')
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          '${'cardiac_output'.tr} :',
          style: defaultTextStyle(
              size: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
        ),
        Text(
          controller.cardiacVolumeTip,
          style: defaultTextStyle(
              size: 13.sp, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ],
    );
  }

  Widget widgetTooltipForHeartFunction() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 5.w, left: 5.w),
                color: ColorConstants.colorForRed,
                height: 10.h,
                width: 30.w,
              ),
              Expanded(
                child: Text(
                  'stroke_volume'.tr,
                  style: defaultTextStyle(
                      size: 10.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: 5.w, left: 5.w),
                color: ColorConstants.chartColor,
                height: 10.h,
                width: 30.w,
              ),
              Expanded(
                child: Text(
                  'cardiac_output'.tr,
                  style: defaultTextStyle(
                      size: 10.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }


  Widget widgetHealthTipsForDay(HeartGraphController controller) {
    return controller.averageBPM > 0
        ? Padding(
      padding: EdgeInsets.only(right: 5.w, left: 10.w),
      child: Material(
        elevation: 3,
        borderRadius: const BorderRadius.all(
            Radius.circular(12.0)), //all(Radius.circular(12)),
        child: InkWell(
          onTap: () {
            //Get.toNamed(Routes.healthTipsScreen);
          },
          child: Container(
            width: Get.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${'how_to_improve'.tr} ',
                    style: defaultTextStyle(
                        size: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '${'stroke_volume'.tr} :',
                    style: defaultTextStyle(
                        size: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    controller.strokeVolumeTip,
                    style: defaultTextStyle(
                        size: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black), //HexColor('#787878')
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    '${'cardiac_output'.tr} :',
                    style: defaultTextStyle(
                        size: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    controller.cardiacVolumeTip,
                    style: defaultTextStyle(
                        size: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        : Container();
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

Widget widgetBody() {
  return Container();
  // return SingleChildScrollView(
  //   child: Screenshot(
  //     controller: screenshotController,
  //     child: SizedBox(
  //       width: Get.width,
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: [
  //           SizedBox(
  //             width: Get.width,
  //             height: 400.h,
  //             child: DefaultTabController(
  //               length: 3,
  //               child: Column(
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(
  //                         horizontal: 5.w, vertical: 10.h),
  //                     child: Row(
  //                       mainAxisAlignment:
  //                       MainAxisAlignment.spaceAround,
  //                       children: [
  //                         InkWell(
  //                           onTap: () {
  //                             if (controller.tabController.index ==
  //                                 1) {
  //                               controller.buttonPreviousWeekTab();
  //                             } else if (controller
  //                                 .tabController.index ==
  //                                 2) {
  //                               controller.buttonPreviousMonthTab();
  //                             } else {
  //                               controller.previousDayTabClick();
  //                             }
  //                           },
  //                           child: Image.asset(
  //                             ImagePath.icBackBtn,
  //                             height: 30.w,
  //                             width: 30.w,
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: controller.tabController.index ==
  //                               0
  //                               ? () async {
  //                             DateTime? pickedDate =
  //                             await showDatePicker(
  //                                 context: context,
  //                                 initialDate:
  //                                 DateTime.now(),
  //                                 // DateTime(DateTime.now()),
  //                                 firstDate:
  //                                 DateTime(1900),
  //                                 lastDate:
  //                                 DateTime(2100));
  //
  //                             if (pickedDate != null) {
  //                               String formattedDate =
  //                               DateFormat('dd MMM, yyyy')
  //                                   .format(pickedDate);
  //
  //                               controller.displayDateText =
  //                                   formattedDate;
  //                               printf(
  //                                   '---date--format--$formattedDate');
  //                               controller.selectedDate();
  //
  //                               //controller.update();
  //                             }
  //                           }
  //                               : null,
  //                           child: Text(
  //                             controller.tabController.index == 1
  //                                 ? controller.weekDate.toString()
  //                                 : controller.tabController
  //                                 .index ==
  //                                 2
  //                                 ? controller.displayMonthText
  //                                 .toString()
  //                                 : controller.displayDateText
  //                                 .toString(),
  //                             style: defaultTextStyle(
  //                                 size: 16.sp,
  //                                 color: Colors.grey,
  //                                 fontWeight: FontWeight.bold),
  //                           ),
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             if (controller.tabController.index ==
  //                                 1) {
  //                               controller.buttonNextWeekTab();
  //                             } else if (controller
  //                                 .tabController.index ==
  //                                 2) {
  //                               controller.buttonNextMonthTab();
  //                             } else {
  //                               controller.nextDayTabClick();
  //                             }
  //                           },
  //                           child: Image.asset(
  //                             ImagePath.icNextBtn,
  //                             height: 30.w,
  //                             width: 30.w,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding:
  //                     EdgeInsets.symmetric(horizontal: 15.w),
  //                     child: TabBar(
  //                       controller: controller.tabController,
  //                       unselectedLabelColor: Colors.grey,
  //                       labelColor: Colors.black,
  //                       unselectedLabelStyle: defaultTextStyle(
  //                           color: Colors.black,
  //                           size: 12.sp,
  //                           fontWeight: FontWeight.w600),
  //                       labelStyle: defaultTextStyle(
  //                           color: Colors.black,
  //                           size: 12.sp,
  //                           fontWeight: FontWeight.w600),
  //                       onTap: (index) {
  //                         controller.getSelectedTab(index);
  //                       },
  //                       tabs: [
  //                         Tab(text: 'day'.tr),
  //                         Tab(text: 'week'.tr),
  //                         Tab(text: 'month'.tr),
  //                       ],
  //                     ),
  //                   ),
  //                   Expanded(
  //                     child: TabBarView(
  //                       controller: controller.tabController,
  //                       children: [
  //                         widgetDay(controller),
  //                         widgetWeek(controller),
  //                         widgetMonth(controller),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           controller.title == 'heart_function'.tr
  //               ? Container(
  //             margin: EdgeInsets.only(
  //                 top: 8.h, left: 10.w, right: 10.w),
  //             width: Get.width,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.only(right: 10.w),
  //                   child: Row(
  //                     crossAxisAlignment:
  //                     CrossAxisAlignment.center,
  //                     mainAxisAlignment:
  //                     MainAxisAlignment.end,
  //                     children: [
  //                       Container(
  //                         margin: EdgeInsets.only(
  //                             right: 5.w, left: 5.w),
  //                         color: ColorConstants.chartColor,
  //                         height: 10.h,
  //                         width: 30.w,
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           'stroke_volume'.tr,
  //                           style: defaultTextStyle(
  //                               size: 10.sp,
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.w400),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 4.h,
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(right: 10.w),
  //                   child: Row(
  //                     crossAxisAlignment:
  //                     CrossAxisAlignment.center,
  //                     mainAxisAlignment:
  //                     MainAxisAlignment.end,
  //                     children: [
  //                       Container(
  //                         margin: EdgeInsets.only(
  //                             right: 5.w, left: 5.w),
  //                         color: ColorConstants.colorForRed,
  //                         height: 10.h,
  //                         width: 30.w,
  //                       ),
  //                       Expanded(
  //                         child: Text(
  //                           'cardiac_output'.tr,
  //                           style: defaultTextStyle(
  //                               size: 10.sp,
  //                               color: Colors.black,
  //                               fontWeight: FontWeight.w400),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 15.h,
  //                 ),
  //                 controller.title == 'heart_function'.tr
  //                     ? widgetHealthTipsForDay(controller)
  //                     : Container(),
  //                 SizedBox(
  //                   height: 24.h,
  //                 ),
  //                 widgetTodayStatistics(controller)
  //               ],
  //             ),
  //           )
  //               : SizedBox(
  //             width: Get.width,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               children: [
  //                 controller.title == 'blood_pressure'.tr
  //                     ? controller.tabController.index == 0
  //                     ? widgetTodayStatisticsForBloodPressure(
  //                     controller)
  //                     : controller.tabController.index ==
  //                     1
  //                     ? widgetWeekStatisticsForBloodPressure(
  //                     controller)
  //                     : widgetMonthStatisticsForBloodPressure(
  //                     controller)
  //                     : controller.tabController.index == 0
  //                     ? widgetTodayStatistics(controller)
  //                     : controller.tabController.index ==
  //                     1
  //                     ? widgetWeekStatistics(
  //                     controller)
  //                     : widgetMonthStatistics(
  //                     controller),
  //                 controller.title == 'heart_health'.tr
  //                     ? Container()
  //                     : Padding(
  //                   padding: EdgeInsets.symmetric(
  //                       horizontal: 15.w),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment:
  //                     CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         controller.labelMeasureLevel
  //                             .toString(),
  //                         style: defaultTextStyle(
  //                           size: 14.sp,
  //                           color: Colors.grey,
  //                           fontWeight: FontWeight.w400,
  //                         ),
  //                       ),
  //                       controller.title ==
  //                           'blood_pressure'.tr
  //                           ? widgetBloodPressureLevel(
  //                           controller)
  //                           : controller.title ==
  //                           'heart_function'.tr
  //                           ? Container()
  //                           : controller.title ==
  //                           'pulse_pressure'
  //                               .tr
  //                           ? widgetPulsePressureLevel(
  //                           controller)
  //                           : controller.title ==
  //                           'arterial_pressure'
  //                               .tr
  //                           ? widgetArterialPressureLevel(
  //                           controller)
  //                           : widgetLevel(
  //                           controller)
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ),
  // );
}
