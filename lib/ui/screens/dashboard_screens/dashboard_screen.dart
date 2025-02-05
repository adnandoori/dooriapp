import 'package:doori_mobileapp/controllers/dashboard_controllers/dashboard_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  //bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double h = Get.height;
    printf('------height-get--->$h');

    return GetBuilder<DashboardController>(
        init: DashboardController(context),
        builder: (controller) {
          return widgetSilverAppBar(
              controller); //widgetSilverAppBar(controller);
        });
  }
}

Widget widgetSilverAppBar(DashboardController controller) {
  double h = Get.height;
  printf('------height-get--->$h');
  return Scaffold(
    backgroundColor: HexColor('#128cf9'),
    body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: controller.measureList.length > 15 ? 270.h : 200.h,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                background: Stack(
              children: [
                Image.asset(
                  height: Get.height,
                  width: Get.width,
                  'assets/images/img_dashboard_new.png',
                  //ImagePath.bgImageDashboard,
                  fit: BoxFit.fill,
                ),
                widgetTopHeader(controller),
              ],
            )),
            actions: [
              Padding(
                padding: EdgeInsets.only(left: 14.w),
                child: Image.asset(
                  ImagePath.logoName,
                  height: 100.w,
                  width: 100.w,
                ),
              ),
              Expanded(child: Container()),
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.accountScreen,
                      arguments: [controller.userModel]);
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 14.w),
                  child: Image.asset(
                    ImagePath.icUserProfile,
                    height: 30.w,
                    width: 30.w,
                  ),
                ),
              ),
            ],
          ),
        ];
      },
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: HexColor('#F5f5f5'),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 15.w, right: 15.w, bottom: 0.h, top: 20.h),
          child: DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TabBar(
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
                        padding: EdgeInsets.only(right: 5.w, left: 10.w),
                        child: Material(
                          elevation:
                              controller.tabController.index == 0 ? 0 : 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              color: controller.tabController.index == 0
                                  ? ColorConstants.textColor
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'my_vitals'.tr,
                                style: defaultTextStyle(
                                    fontWeight: FontWeight.bold,
                                    size: 12.sp,
                                    color: controller.tabController.index == 0
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
                        padding: EdgeInsets.only(left: 5.w, right: 10.w),
                        child: Material(
                          elevation:
                              controller.tabController.index == 1 ? 0 : 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              color: controller.tabController.index == 1
                                  ? ColorConstants.textColor
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'insight'.tr.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: defaultTextStyle(
                                    fontWeight: FontWeight.bold,
                                    size: 12.sp,
                                    color: controller.tabController.index == 1
                                        ? Colors.white
                                        : ColorConstants.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      controller.isLoading.value
                          ? widgetLoadingForMyVitals()
                          : SingleChildScrollView(
                              child: widgetMyVitals(controller)),
                      controller.isLoading.value
                          ? widgetLoadingForInsights()
                          : SingleChildScrollView(
                              child: widgetInsights(controller)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetNormalScroll(DashboardController controller) {
  return Scaffold(
    body: Stack(
      clipBehavior: Clip.none,
      children: [
        Image.asset(
          height: Get.height,
          width: Get.width,
          ImagePath.bgImageDashboard,
          fit: BoxFit.fill,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImagePath.logoName,
                        height: 100.w,
                        width: 100.w,
                      ),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.accountScreen,
                                  arguments: [controller.userModel]);
                            },
                            child: Image.asset(
                              ImagePath.icUserProfile,
                              height: 30.w,
                              width: 30.w,
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 60.h,
                                width: Get.width,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Text(
                                            'welcome_back'.tr,
                                            style: defaultTextStyle(
                                              size: 12.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Text(
                                            controller.username.toTitleCase(),
                                            style: defaultTextStyle(
                                                size: 18.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                        onTap: () {
                                          controller.buttonMeasure();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 2.w),
                                          height: 30.h,
                                          width: 100.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30)),
                                            color: HexColor(
                                                '#E3F7FF'), //ColorConstants.textColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'measure'.tr,
                                              style: defaultTextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  size: 12.sp,
                                                  color:
                                                      ColorConstants.textColor),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.h),
                              controller.measureList.length > 15
                                  ? widgetAIScore(controller)
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.h),
                          height: Get.height,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            color: HexColor('#F5f5f5'),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 15.w,
                                right: 15.w,
                                bottom: 0.h,
                                top: 20.h),
                            child: DefaultTabController(
                              length: 2,
                              child: Column(
                                children: [
                                  TabBar(
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
                                            elevation: controller
                                                        .tabController.index ==
                                                    0
                                                ? 0
                                                : 1,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30)),
                                            child: Container(
                                              height: 35.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(30)),
                                                color: controller.tabController
                                                            .index ==
                                                        0
                                                    ? ColorConstants.textColor
                                                    : Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'my_vitals'.tr,
                                                  style: defaultTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                            elevation: controller
                                                        .tabController.index ==
                                                    1
                                                ? 0
                                                : 1,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(30)),
                                            child: Container(
                                              height: 35.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(30)),
                                                color: controller.tabController
                                                            .index ==
                                                        1
                                                    ? ColorConstants.textColor
                                                    : Colors.white,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'insight'.tr.toUpperCase(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: defaultTextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      size: 12.sp,
                                                      color: controller
                                                                  .tabController
                                                                  .index ==
                                                              1
                                                          ? Colors.white
                                                          : ColorConstants
                                                              .black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  //widgetTabs(controller),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: controller.tabController,
                                      children: [
                                        controller.isLoading.value
                                            ? widgetLoadingForMyVitals()
                                            : SingleChildScrollView(
                                                child:
                                                    widgetMyVitals(controller)),
                                        controller.isLoading.value
                                            ? widgetLoadingForInsights()
                                            : SingleChildScrollView(
                                                child:
                                                    widgetInsights(controller)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ],
    ),
  );
}

Widget widgetScaffold(controller) {
  double h = Get.height;
  printf('------height-get--->$h');
  return Scaffold(
      body: Stack(
    clipBehavior: Clip.none,
    children: [
      Image.asset(
        height: Get.height,
        width: Get.width,
        ImagePath.bgImageDashboard,
        fit: BoxFit.fill,
      ),
      widgetTopHeader(controller),
      Container(
        //margin: EdgeInsets.only(top: h < 650 ? 310.h : 300.h),
        margin: controller.measureList.length > 15
            ? EdgeInsets.only(top: h < 650 ? 310.h : 300.h)
            : EdgeInsets.only(top: h < 650 ? 230.h : 220.h),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: HexColor('#F5f5f5'),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 15.w, right: 15.w, bottom: 0.h, top: 20.h),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
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
                        padding: EdgeInsets.only(right: 5.w, left: 10.w),
                        child: Material(
                          elevation:
                              controller.tabController.index == 0 ? 0 : 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              color: controller.tabController.index == 0
                                  ? ColorConstants.textColor
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'my_vitals'.tr,
                                style: defaultTextStyle(
                                    fontWeight: FontWeight.bold,
                                    size: 12.sp,
                                    color: controller.tabController.index == 0
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
                        padding: EdgeInsets.only(left: 5.w, right: 10.w),
                        child: Material(
                          elevation:
                              controller.tabController.index == 1 ? 0 : 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          child: Container(
                            height: 35.h,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              color: controller.tabController.index == 1
                                  ? ColorConstants.textColor
                                  : Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                'insight'.tr.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                style: defaultTextStyle(
                                    fontWeight: FontWeight.bold,
                                    size: 12.sp,
                                    color: controller.tabController.index == 1
                                        ? Colors.white
                                        : ColorConstants.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                //widgetTabs(controller),
                SizedBox(
                  height: 15.h,
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      controller.isLoading.value
                          ? widgetLoadingForMyVitals()
                          : SingleChildScrollView(
                              child: widgetMyVitals(controller)),
                      controller.isLoading.value
                          ? widgetLoadingForInsights()
                          : SingleChildScrollView(
                              child: widgetInsights(controller)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ));
}

Widget widgetLoadingForMyVitals() {
  return SizedBox(
    height: Get.height,
    width: Get.width,
    child: Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Material(
                          elevation: 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Image.asset(
                                          ImagePath.icHeartRate,
                                          height: 32.w,
                                          width: 32.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
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
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 10.h,
                                          width: 80.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Expanded(
                        child: Material(
                          elevation: 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Image.asset(
                                          ImagePath.icHeartRate,
                                          height: 32.w,
                                          width: 32.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
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
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 10.h,
                                          width: 80.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Material(
                          elevation: 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Image.asset(
                                          ImagePath.icHeartRate,
                                          height: 32.w,
                                          width: 32.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
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
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 10.h,
                                          width: 80.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Expanded(
                        child: Material(
                          elevation: 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Image.asset(
                                          ImagePath.icHeartRate,
                                          height: 32.w,
                                          width: 32.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
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
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 10.h,
                                          width: 80.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: Material(
                          elevation: 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Image.asset(
                                          ImagePath.icHeartRate,
                                          height: 32.w,
                                          width: 32.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
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
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 10.h,
                                          width: 80.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Expanded(
                        child: Material(
                          elevation: 1,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Image.asset(
                                          ImagePath.icHeartRate,
                                          height: 32.w,
                                          width: 32.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
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
                                          color: Colors.white,
                                          height: 12.h,
                                          width: 80.w,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          color: Colors.white,
                                          height: 10.h,
                                          width: 80.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    height: 60.h,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: Image.asset(
                              ImagePath.icActivity,
                              height: 30.w,
                              width: 30.w,
                            ),
                          ),
                          Expanded(
                              child: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: Container(
                                  color: Colors.white,
                                  child: Text(
                                    'activity'.tr,
                                    style: defaultTextStyle(
                                        size: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                            ],
                          )),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: Image.asset(
                              ImagePath.icNextBtn,
                              height: 18.w,
                              width: 18.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                ],
              ),
            ))
          ],
        ),
      ],
    ),
  );
}

Widget widgetLoadingForInsights() {
  return SizedBox(
    height: Get.height,
    width: Get.width,
    child: Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 95.h,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              enabled: true,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 8.h, left: 15.w),
                                  child: Text(
                                    'visualise'.tr,
                                    style: defaultTextStyle(
                                        size: 14.sp,
                                        lineHeight: 1.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              enabled: true,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 15.w, bottom: 8.h),
                                  child: Text(
                                    'no_trendind_data_found'.tr,
                                    style: defaultTextStyle(
                                        size: 13.sp,
                                        lineHeight: 1.5,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 15.w, top: 0.h),
                                child: SizedBox(
                                    width: 65.w,
                                    height: 70.h,
                                    child: SizedBox(
                                      width: 65.w,
                                      height: 70.h,
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Stack(
                                          children: [
                                            Image.asset(
                                              'assets/images/heart/normal_heart.png',
                                              width: 65.w,
                                              height: 70.h,
                                            ),
                                            Image.asset(
                                              'assets/images/heart/normal_heart.png',
                                              width: 65.w,
                                              height: 70.h,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w, left: 10.w),
                    child: Material(
                      elevation: 3,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                    child: Text(
                                      'health_tips'.tr,
                                      style: defaultTextStyle(
                                          size: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                    child: Image.asset(
                                      ImagePath.icNextBtn,
                                      height: 18.w,
                                      width: 18.w,
                                      //color: Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                    child: Image.asset(
                                      ImagePath.icHRV,
                                      height: 26.w,
                                      width: 26.w,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                      child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                    child: Container(
                                      height: 20.h,
                                      color: Colors.white,
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w, left: 10.w),
                    child: Material(
                      elevation: 3,
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 10.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 5.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                enabled: true,
                                                child: Image.asset(
                                                  ImagePath.icHeartHealth,
                                                  height: 26.w,
                                                  width: 26.w,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                enabled: true,
                                                child: Text(
                                                  'heart_health'.tr,
                                                  style: defaultTextStyle(
                                                      size: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ],
                                          )),
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey.shade300,
                                            highlightColor:
                                                Colors.grey.shade100,
                                            enabled: true,
                                            child: Container(
                                              height: 12.h,
                                              width: 50.w,
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 15.h),
                                          height: 8.h,
                                          color: Colors.white,
                                          width: Get.width,
                                        ),
                                      )
                                    ],
                                  )),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Image.asset(
                                    ImagePath.icNextBtn,
                                    height: 18.w,
                                    width: 18.w,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ))
          ],
        ),
      ],
    ),
  );
}

Widget widgetLoadingForAIScore() {
  return Container(
    height: 80.h,
    width: Get.width,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white, //ColorConstants.colorForRed,
    ),
    child: InkWell(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: Container(
              height: 80.h,
              width: 90.w,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: ColorConstants.colorForRed,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: Text(
                        '30',
                        style: defaultTextStyle(
                            size: 30.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: Text(
                        'out of 100',
                        style: defaultTextStyle(
                            size: 10.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: Text(
                    'Wellness Score',
                    style: defaultTextStyle(
                        color: Colors.black,
                        size: 14.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: Text(
                    'Title',
                    style: defaultTextStyle(
                        color: Colors.black,
                        size: 10.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  enabled: true,
                  child: Text(
                    "${AppConstants.concernLevel}: 'Low",
                    style: defaultTextStyle(
                        color: ColorConstants.colorGreyColorForAI,
                        size: 9.sp,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          )),
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: Image.asset(
                ImagePath.icNextBtn,
                height: 18.w,
                width: 18.w,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget widgetMyVitalsItem(
    String icon, String title, String value, String value2, String result) {
  return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          color: Colors.transparent, //ColorConstants.textColor,
        ),
        width: Get.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: 10.w, top: 16.h),
                child: Image.asset(
                  ImagePath.icNextBtn,
                  height: 18.w,
                  width: 18.w,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.h, left: 15.w, bottom: 12.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  icon.isNotEmpty
                      ? Image.asset(
                          icon, //ImagePath.icHeartRate,
                          height: 32.w,
                          width: 32.w,
                        )
                      : SizedBox(
                          height: 32.w,
                          width: 32.w,
                        ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    title, //AppConstants.heartRate,
                    style: defaultTextStyle(
                        size: 11.sp,
                        lineHeight: 1.3,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: defaultTextStyle(
                            lineHeight: 1.4,
                            size: 15.sp, //17
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1.h),
                          child: Text(
                            value2,
                            style: defaultTextStyle(
                                lineHeight: 1.4,
                                size: 11.sp, //13
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    result, //AppConstants.average,
                    style: defaultTextStyle(
                        size: 11.sp,
                        lineHeight: 1.3,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ],
              ),
            )
          ],
        ),
      ));
}

Widget widgetTopHeader(DashboardController controller) {
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 112.h,
          ),
          SizedBox(
            height: 60.h,
            width: Get.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'welcome_back'.tr,
                        style: defaultTextStyle(
                          size: 12.sp,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(
                        controller.username.toTitleCase(),
                        style: defaultTextStyle(
                            size: 18.sp, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      controller.buttonMeasure();
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 2.w),
                      height: 30.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        color: HexColor('#E3F7FF'), //ColorConstants.textColor,
                      ),
                      child: Center(
                        child: Text(
                          'measure'.tr,
                          style: defaultTextStyle(
                              fontWeight: FontWeight.bold,
                              size: 12.sp,
                              color: ColorConstants.textColor),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h),
          controller.isWellnessScore ? widgetAIScore(controller) : Container(),
        ],
      ),
    ),
  );
}

Widget widgetAIScore(DashboardController controller) {
  return Container(
    height: 80.h,
    width: Get.width,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white, //ColorConstants.colorForRed,
    ),
    child: InkWell(
      onTap: () {
        printf('----clicked---prediction--');
        //Get.toNamed(Routes.predictionAIScreen);
        controller.navigateToPredictionAI(
            controller.userId, controller.measureList);
        //controller.getLast15ReadingsForPredictionAI(
        //  userId: controller.userId, measureList: controller.measureList);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 80.h,
            width: 90.w,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: controller.color ?? ColorConstants.colorForRed,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    controller.wellnessScore.toString(),
                    style: defaultTextStyle(
                        size: 30.sp, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'out of 100',
                    style: defaultTextStyle(
                        size: 10.sp, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness Score',
                  style: defaultTextStyle(
                      color: Colors.black,
                      size: 14.sp,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  controller.wellnessTitle.toString(),
                  style: defaultTextStyle(
                      color: Colors.black,
                      size: 10.sp,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${AppConstants.concernLevel}: ${controller.wellnessConcernLevel}",
                  style: defaultTextStyle(
                      color: ColorConstants.colorGreyColorForAI,
                      size: 9.sp,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )),
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Image.asset(
              ImagePath.icNextBtn,
              height: 18.w,
              width: 18.w,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget widgetTabs(DashboardController controller) {
  return Row(
    children: [
      Expanded(
          child: Padding(
        padding: EdgeInsets.only(right: 5.w, left: 10.w),
        child: Material(
          elevation: controller.isMyVitals ? 0 : 1,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: InkWell(
            onTap: () {
              printf('clicked_my_vitals');
              controller.tabSelectionMyVitals();
            },
            child: Container(
              height: 35.h,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: controller.isMyVitals
                    ? ColorConstants.textColor
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  'my_vitasl'.tr,
                  style: defaultTextStyle(
                      fontWeight: FontWeight.bold,
                      size: 12.sp,
                      color: controller.isMyVitals
                          ? ColorConstants.white
                          : Colors.black),
                ),
              ),
            ),
          ),
        ),
      )),
      Expanded(
          child: Padding(
        padding: EdgeInsets.only(left: 5.w, right: 10.w),
        child: Material(
          elevation: controller.isInsights ? 0 : 1,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: InkWell(
            onTap: () {
              controller.tabSelectionInsights();
            },
            child: Container(
              height: 35.h,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                color: controller.isInsights
                    ? ColorConstants.textColor
                    : Colors.white,
              ),
              child: Center(
                child: Text(
                  'insight'.tr.toUpperCase(),
                  style: defaultTextStyle(
                      fontWeight: FontWeight.bold,
                      size: 12.sp,
                      color: controller.isInsights
                          ? Colors.white
                          : ColorConstants.black),
                ),
              ),
            ),
          ),
        ),
      )),
    ],
  );
}

Widget widgetMyVitals(DashboardController controller) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      controller.lastHeartRateValue.isNotEmpty
          ? Row(
              children: [
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  '${'last_measure_at'.tr} : ',
                  style: defaultTextStyle(
                      size: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Text(
                  controller.lastHeartRateValue,
                  style: defaultTextStyle(
                      size: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Expanded(child: Container()),
              ],
            )
          : Container(),
      Row(
        children: [
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.only(left: 10.w, right: 5.w, top: 5.h, bottom: 5.h),
            child: InkWell(
              onTap: () {
                Utility.isConnected().then((isConnected) {
                  if (isConnected) {
                    controller.buttonGraph('heart_rate'.tr, controller.userId,
                        value: '${controller.heartRate} ${'bpm'.tr}',
                        levelMsg: controller.hrState.toString(),
                        lastMeasured: controller.lastHeartRateValue,
                        totalRecords: controller.measureList);
                  } else {
                    Utility().snackBarForInternetIssue();
                  }
                });
              },
              child: widgetMyVitalsItem(
                  ImagePath.icHeartRate,
                  'heart_rate'.tr,
                  controller.heartRate.toString(),
                  'bpm'.tr,
                  controller.hrState.toString()),
            ),
          )),
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.only(left: 5.w, right: 10.w, top: 5.h, bottom: 5.h),
            child: InkWell(
              onTap: () {
                Utility.isConnected().then((isConnected) {
                  if (isConnected) {
                    controller.buttonGraph('oxygen_level'.tr, controller.userId,
                        value: '${controller.oxygen} ${'%'}',
                        levelMsg: controller.oxygenState.toString(),
                        lastMeasured: controller.lastHeartRateValue,
                        totalRecords: controller.measureList);
                  } else {
                    Utility().snackBarForInternetIssue();
                  }
                });
              },
              child: widgetMyVitalsItem(
                  ImagePath.icOxygenLevel,
                  'oxygen_level'.tr,
                  controller.oxygen.toString(),
                  '%',
                  controller.oxygenState.toString()),
            ),
          ))
        ],
      ),
      Row(
        children: [
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.only(left: 10.w, right: 5.w, top: 5.h, bottom: 5.h),
            child: InkWell(
              onTap: () {
                Utility.isConnected().then((isConnected) {
                  if (isConnected) {
                    controller.buttonGraph(
                        'blood_pressure'.tr, controller.userId,
                        value: '${controller.bloodPressure} ${'mmHg'.tr}',
                        levelMsg: controller.bpState.toString(),
                        lastMeasured: controller.lastHeartRateValue,
                        totalRecords: controller.measureList);
                  } else {
                    Utility().snackBarForInternetIssue();
                  }
                });
              },
              child: widgetMyVitalsItem(
                  ImagePath.icBloodPressure,
                  'blood_pressure'.tr,
                  controller.bloodPressure.toString(),
                  'mmHg'.tr,
                  controller.bpState.toString()),
            ),
          )),
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.only(left: 5.w, right: 10.w, top: 5.h, bottom: 5.h),
            child: InkWell(
              onTap: () {
                Utility.isConnected().then((isConnected) {
                  if (isConnected) {
                    controller.buttonGraph(
                        'hr_variability'.tr, controller.userId,
                        value: '${controller.hrVariability} ${'ms'.tr}',
                        levelMsg: controller.hrvState.toString(),
                        lastMeasured: controller.lastHeartRateValue,
                        totalRecords: controller.measureList);
                  } else {
                    Utility().snackBarForInternetIssue();
                  }
                });
              },
              child: widgetMyVitalsItem(
                  ImagePath.icHRV,
                  'hr_variability'.tr,
                  controller.hrVariability.toString(),
                  'ms'.tr,
                  controller.hrvState.toString()),
            ),
          ))
        ],
      ),
      Row(
        children: [
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.only(left: 10.w, right: 5.w, top: 5.h, bottom: 5.h),
            child: InkWell(
              onTap: () {
                Utility.isConnected().then((isConnected) {
                  if (isConnected) {
                    controller.buttonGraph(
                        'pulse_pressure'.tr, controller.userId,
                        value: '${controller.pulsePressure} ${'mmHg'.tr}',
                        levelMsg: controller.pulseMessage,
                        lastMeasured: controller.lastHeartRateValue,
                        totalRecords: controller.measureList);
                  } else {
                    Utility().snackBarForInternetIssue();
                  }
                });
              },
              child: widgetMyVitalsItem(ImagePath.icStroke, 'pulse_pressure'.tr,
                  controller.pulsePressure, 'mmHg'.tr, controller.pulseMessage),
            ),
          )),
          Expanded(
              child: Padding(
            padding:
                EdgeInsets.only(left: 5.w, right: 10.w, top: 5.h, bottom: 5.h),
            child: InkWell(
              onTap: () {
                Utility.isConnected().then((isConnected) {
                  if (isConnected) {
                    controller.buttonGraph(
                        'arterial_pressure'.tr, controller.userId,
                        value: '${controller.arterialPressure} ${'mmHg'.tr}',
                        levelMsg: controller.arterialMessage,
                        lastMeasured: controller.lastHeartRateValue,
                        totalRecords: controller.measureList);
                  } else {
                    Utility().snackBarForInternetIssue();
                  }
                });
              },
              child: widgetMyVitalsItem(
                  ImagePath.icCardiac,
                  'arterial_pressure'.tr,
                  controller.arterialPressure,
                  'mmHg'.tr,
                  controller.arterialMessage),
            ),
          ))
        ],
      ),
      SizedBox(
        height: 10.h,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Material(
          elevation: 3,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: InkWell(
            onTap: () {
              Utility.isConnected().then((isConnected) {
                if (isConnected) {
                  Get.toNamed(Routes.activityScreen,
                      arguments: [controller.userId, controller.measureList]);
                } else {
                  Utility().snackBarForInternetIssue();
                }
              });
            },
            child: Container(
              height: 60.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: ColorConstants.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      ImagePath.icActivity,
                      height: 30.w,
                      width: 30.w,
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          'activity'.tr,
                          style: defaultTextStyle(
                              size: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          controller.activity.toString().toLowerCase().tr,
                          style: defaultTextStyle(
                              size: 16.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    )),
                    Image.asset(
                      ImagePath.icNextBtn,
                      height: 18.w,
                      width: 18.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
      controller.measureList.length > 15
          ? InkWell(
              onTap: () async {
                controller.checkStoragePermission(controller.measureList);
              },
              child: Container(
                width: 110.w,
                height: 42.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(28.w)),
                  border: Border.all(
                    color: Colors.blue,
                    width: 1,
                  ),
                  color: Colors.transparent, //HexColor('#E3F7FF'),
                ),
                child: Center(
                  child: Text(
                    'view_report'.tr,
                    style: defaultTextStyle(
                      size: 13.sp,
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          : Container(),
      SizedBox(
        height: 20.h,
      ),
    ],
  );
}

Widget widgetInsights(DashboardController controller) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      controller.lastHeartRateValue.isNotEmpty
          ? Row(
              children: [
                SizedBox(
                  width: 16.w,
                ),
                Text(
                  '${'last_updated_at'.tr} : ',
                  style: defaultTextStyle(
                      size: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Text(
                  controller.lastHeartRateValue,
                  style: defaultTextStyle(
                      size: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Expanded(child: Container()),
              ],
            )
          : Container(),
      SizedBox(
        height: 10.h,
      ),
      widgetVisualiseNew(controller),
      SizedBox(
        height: 15.h,
      ),
      widgetHealthTips(controller),
      SizedBox(
        height: 15.h,
      ),
      widgetHeartHealth(controller),
      SizedBox(
        height: 15.h,
      ),
      widgetStrokeAndCardiac(controller),
      SizedBox(
        height: 15.h,
      ),
      widgetHeartStrain(controller),
      SizedBox(
        height: 15.h,
      ),
      Padding(
        padding: EdgeInsets.only(right: 5.w, left: 10.w),
        child: Material(
          elevation: 3,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: InkWell(
            onTap: () {
              // controller.buttonGraphForEnergyStressLevel(
              //     'mood', controller.userId,
              //     totalBodyHealthRecords: controller.totalBodyHealthRecordList,
              //     totalAllRecords: controller.measureList);
            },
            child: Container(
              height: 60.h,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: ColorConstants.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'mood'.tr,
                      style: defaultTextStyle(
                          size: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Image.asset(
                      controller.moodIcon.toString(),
                      height: 31.w,
                      width: 32.w,
                    ),
                    Text(
                      controller.mood.toString(),
                      style: defaultTextStyle(
                          size: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      SizedBox(
        height: 15.h,
      ),
      widgetStressAndEnergyLevel(controller),
      SizedBox(
        height: 15.h,
      ),
      widgetBodyMassIndex(controller),
      SizedBox(
        height: 20.h,
      ),
    ],
  );
}

Widget widgetVisualise(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.visualiseScreen);
        },
        child: Container(
          height: 95.h,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 85.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 7.h),
                            child: Text(
                              'visualise'.tr,
                              style: defaultTextStyle(
                                  size: 14.sp,
                                  lineHeight: 1.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          Text(
                            '${controller.averageHeartRate} ${controller.avg7days} ${'bpm'.tr.toUpperCase()}',
                            style: defaultTextStyle(
                                size: 13.sp,
                                lineHeight: 1.5,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    )),
                    SizedBox(
                      width: 15.w,
                    ),
                    SizedBox(
                        width: 75.w,
                        height: 85.h,
                        child: GifView.asset(
                          'assets/gif/heart.gif',
                          width: 75.w,
                          height: 85.h,
                          frameRate: 30, // default is 15 FPS
                        ))
                  ],
                ),
                SizedBox(
                  height: 0.h,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetVisualiseNew(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () async {
          Utility.isConnected().then((isConnected) async {
            if (isConnected) {
              /*final result =
              await Get.toNamed(Routes.visualiseScreen, arguments: [
                controller.systolicAverage.roundToDouble(),
                controller.diastolicAverage.roundToDouble(),
              ]);*/

              if (controller.isLast14DaysValue) {
                final result =
                    await Get.toNamed(Routes.visualiseScreen, arguments: [
                  controller.systolicAverage.roundToDouble(),
                  controller.diastolicAverage.roundToDouble(),
                ]);

                if (result.toString() == 'save') {
                  controller.callInit();
                }
              } else {
                final result =
                    await Get.toNamed(Routes.visualiseScreen, arguments: [
                  0.0,
                  0.0,
                ]);

                if (result.toString() == 'save') {
                  // controller.getMeasureRecord();
                  controller.callInit();
                }
              }
            } else {
              Utility().snackBarForInternetIssue();
            }
          });
        },
        child: Container(
            height: 95.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h, left: 15.w),
                    child: Text(
                      'visualise'.tr,
                      style: defaultTextStyle(
                          size: 14.sp,
                          lineHeight: 1.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.w, bottom: 8.h),
                    child: Text(
                      !controller.isLast14DaysValue
                          ? 'no_trendind_data_found'.tr
                          : '${controller.averageHeartRate} ${controller.avg7days} ${'bpm'.tr.toUpperCase()}',
                      style: defaultTextStyle(
                          size: 13.sp,
                          lineHeight: 1.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.w, top: 0.h),
                    child: SizedBox(
                        width: 65.w,
                        height: 70.h,
                        child: controller
                                .isLast14DaysValue //controller.gifSpeed > 0
                            ? GifView.asset(
                                'assets/gif/heart1.gif',
                                width: 65.w,
                                height: 70.h,
                                frameRate:
                                    controller.gifSpeed, // default is 15 FPS
                              )
                            : SizedBox(
                                width: 65.w,
                                height: 70.h,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/heart/normal_heart.png',
                                      width: 65.w,
                                      height: 70.h,
                                    ),
                                    Image.asset(
                                      'assets/images/heart/normal_heart.png',
                                      width: 65.w,
                                      height: 70.h,
                                      color: Colors.black.withOpacity(0.3),
                                    )
                                  ],
                                ),
                              )),
                  ),
                )
              ],
            )),
      ),
    ),
  );
}

Widget widgetStrokeAndCardiac(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {
          printf('---clicked---heart-function-');
          Utility.isConnected().then((isConnected) {
            if (isConnected) {
              controller.buttonGraph('heart_function'.tr, controller.userId,
                  value: '${controller.heartRate} ${'bpm'.tr}',
                  levelMsg: controller.hrState.toString(),
                  lastMeasured: controller.lastHeartRateValue,
                  totalRecords: controller.measureList);
            } else {
              Utility().snackBarForInternetIssue();
            }
          });
        },
        child: Container(
            //height: 130.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15.w),
                        child: Text(
                          'heart_function'.tr,
                          style: defaultTextStyle(
                              size: 14.sp,
                              lineHeight: 1.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Image.asset(
                      ImagePath.icNextBtn,
                      height: 18.w,
                      width: 18.w,
                      //color: Colors.transparent,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        widgetGaugeForStoke(
                          double.parse(controller.pulsePressure)
                              .roundToDouble(),
                          controller.strokeMsg,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          'stroke_volume'.tr,
                          style: defaultTextStyle(
                              size: 13.sp,
                              lineHeight: 1.2,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    )),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        widgetGaugeForCardiac(
                          double.parse(controller.arterialPressure)
                              .roundToDouble(),
                          controller.cardiacMsg,
                        ),
                        /*InkWell(
                          onTap: ()
                          {
                            printf('---clicked---cardiac');
                            Utility.isConnected().then((isConnected) {
                              if (isConnected)
                              {
                                controller.buttonGraph(
                                  'heart_function'.tr,
                                  controller.userId,
                                );
                              } else {
                                Utility().snackBarForInternetIssue();
                              }
                            });
                          },
                          child: widgetGaugeForCardiac(
                            double.parse(controller.arterialPressure)
                                .roundToDouble(),
                            controller.cardiacMsg,
                          ),
                        ),*/
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          'cardiac_output'.tr,
                          style: defaultTextStyle(
                              size: 13.sp,
                              lineHeight: 1.2,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ],
                    )),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            )),
      ),
    ),
  );
}

Widget widgetGaugeForStoke(double value, String msg) {
  printf(
      '-------------widgetGaugeForStoke----value------------>$value----------msg-->$msg');
  List<GaugeSegment> segments = <GaugeSegment>[
    const GaugeSegment(
      color: Color(0xFFf8555a),
      from: 0,
      to: 30.0,
      cornerRadius: Radius.zero,
    ),
    const GaugeSegment(
      color: Color(0xFF4fd286),
      from: 30,
      to: 50.0,
      cornerRadius: Radius.zero,
    ),
    const GaugeSegment(
      color: Color(0xFFf8555a),
      from: 50.0,
      to: 80.0,
      cornerRadius: Radius.zero,
    ),
  ];

  return Center(
    child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
        width: 75.w,
        height: 75.w,
        child: Stack(
          children: [
            AnimatedRadialGauge(
              radius: 60,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.elasticOut,
              value: value,
              axis: GaugeAxis(
                min: 0,
                max: 80,
                degrees: 260,
                pointer: const GaugePointer.needle(
                  width: 20,
                  height: 20,
                  borderRadius: 10,
                  color: Color(0xFF787878),
                  position: GaugePointerPosition.surface(
                    offset: Offset(0, 2 * 0.6),
                  ),
                  border: GaugePointerBorder(
                    color: Colors.white,
                    width: 10 * 0.125,
                  ),
                ),
                progressBar: null,
                transformer: const GaugeAxisTransformer.colorFadeIn(
                  interval: Interval(0.0, 0.3),
                  background: Color(0xFFD9DEEB),
                ),
                style: const GaugeAxisStyle(
                  thickness: 6,
                  background: Colors.transparent,
                  segmentSpacing: 0,
                  blendColors: false,
                  cornerRadius:
                      Radius.circular(0), // _controller.segmentsRadius),
                ),
                segments: segments
                    .map((e) =>
                        e.copyWith(cornerRadius: const Radius.circular(0)))
                    .toList(),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Text(
                  msg,
                  style: defaultTextStyle(
                      size: 10.sp,
                      lineHeight: 0.1,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
              ),
            )
          ],
        )),
  );
}

Widget widgetGaugeForCardiac(double value, String msg) {
  List<GaugeSegment> segments = <GaugeSegment>[
    const GaugeSegment(
      color: Color(0xFFf8555a),
      from: 0,
      to: 70.0,
      cornerRadius: Radius.zero,
    ),
    const GaugeSegment(
      color: Color(0xFF4fd286),
      from: 70,
      to: 100.0,
      cornerRadius: Radius.zero,
    ),
    const GaugeSegment(
      color: Color(0xFFf8555a),
      from: 100.0,
      to: 170.0,
      cornerRadius: Radius.zero,
    ),
  ];

  return Center(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      width: 75.w,
      height: 75.w,
      child: Stack(
        children: [
          AnimatedRadialGauge(
            radius: 60,
            duration: const Duration(milliseconds: 2000),
            curve: Curves.elasticOut,
            value: value,
            axis: GaugeAxis(
              min: 0,
              max: 170,
              degrees: 260,
              pointer: const GaugePointer.needle(
                width: 20,
                height: 20,
                borderRadius: 10,
                color: Color(0xFF787878),
                position: GaugePointerPosition.surface(
                  offset: Offset(0, 2 * 0.6),
                ),
                border: GaugePointerBorder(
                  color: Colors.white,
                  width: 10 * 0.125,
                ),
              ),
              progressBar: null,
              transformer: const GaugeAxisTransformer.colorFadeIn(
                interval: Interval(0.0, 0.3),
                background: Color(0xFFD9DEEB),
              ),
              style: const GaugeAxisStyle(
                thickness: 6,
                background: Colors.transparent,
                segmentSpacing: 0,
                blendColors: false,
                cornerRadius:
                    Radius.circular(0), // _controller.segmentsRadius),
              ),
              segments: segments
                  .map(
                      (e) => e.copyWith(cornerRadius: const Radius.circular(0)))
                  .toList(),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Text(
                msg,
                style: defaultTextStyle(
                    size: 10.sp,
                    lineHeight: 0.1,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Widget widgetHealthTips(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {
          Utility.isConnected().then((isConnected) {
            if (isConnected) {
              Get.toNamed(Routes.healthTipsScreen,
                  arguments: [controller.userId, controller.measureList]);
            } else {
              Utility().snackBarForInternetIssue();
            }
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'health_tips'.tr,
                      style: defaultTextStyle(
                          size: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Image.asset(
                      ImagePath.icNextBtn,
                      height: 18.w,
                      width: 18.w,
                      //color: Colors.transparent,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      ImagePath.icHRV,
                      height: 26.w,
                      width: 26.w,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: Text(
                        controller.newHealthTips.toCapitalized(),
                        style: defaultTextStyle(
                            size: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetHeartHealth(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {
          Utility.isConnected().then((isConnected) {
            if (isConnected) {
              controller.buttonGraph('heart_health'.tr, controller.userId,
                  value: '${controller.heartRate} ${'bpm'.tr}',
                  levelMsg: controller.hrState.toString(),
                  lastMeasured: controller.lastHeartRateValue,
                  totalRecords: controller.measureList);
            } else {
              Utility().snackBarForInternetIssue();
            }
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Image.asset(
                                  ImagePath.icHeartHealth,
                                  height: 26.w,
                                  width: 26.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  'heart_health'.tr,
                                  style: defaultTextStyle(
                                      size: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            )),
                            Text(
                              controller.heartHealthValue,
                              style: defaultTextStyle(
                                  size: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 15.h),
                          height: 8.h,
                          child: LinearProgressIndicator(
                            backgroundColor: HexColor('#10000000'),
                            value: controller.progressValue,
                            color: Colors.red,
                          ),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 15.w,
                    ),
                    Image.asset(
                      ImagePath.icNextBtn,
                      height: 18.w,
                      width: 18.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetHeartRhythm(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'heart_rhythm'.tr,
                          style: defaultTextStyle(
                              size: 14.sp,
                              lineHeight: 1.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        controller.isLast14DaysHeartRhythm
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    controller.heartRhythmTitle.toString(),
                                    style: defaultTextStyle(
                                        size: 18.sp,
                                        lineHeight: 1.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    controller.heartRhythmStatus.toString(),
                                    style: defaultTextStyle(
                                        size: 12.sp,
                                        lineHeight: 1.5,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black),
                                  ),
                                ],
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 15.h),
                                child: Text(
                                  'no_trendind_data_found'.tr,
                                  style: defaultTextStyle(
                                      size: 13.sp,
                                      lineHeight: 1.5,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black),
                                ),
                              ),
                      ],
                    )),
                    SizedBox(
                      width: 15.w,
                    ),
                    Image.asset(
                      ImagePath.icNextBtn,
                      height: 18.w,
                      width: 18.w,
                      color: Colors.transparent,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetStressAndEnergyLevel(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {
          Utility.isConnected().then((isConnected) {
            if (isConnected) {
              controller.buttonGraphForEnergyStressLevel(
                  'body_health'.tr, controller.userId,
                  totalBodyHealthRecords: controller.totalBodyHealthRecordList,
                  totalAllRecords: controller.measureList);
              //controller.buttonGraph(AppConstants.heartHealth);
            } else {
              Utility().snackBarForInternetIssue();
            }
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'body_health'.tr,
                            style: defaultTextStyle(
                                size: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                        Image.asset(
                          ImagePath.icNextBtn,
                          height: 18.w,
                          width: 18.w,
                          //color: Colors.transparent,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Image.asset(
                                  ImagePath.icEnergyLevel,
                                  height: 26.w,
                                  width: 26.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  'energy'.tr,
                                  style: defaultTextStyle(
                                      size: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            )),
                            Text(
                              controller.energyLevel != 0
                                  ? controller.energyLevelMsg
                                  : "",
                              style: defaultTextStyle(
                                  size: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: HexColor('#787878')),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),
                        controller.energyLevel != 0
                            ? Container(
                                margin: EdgeInsets.only(top: 10.h, left: 35.w),
                                height: 8.h,
                                child: LinearProgressIndicator(
                                  backgroundColor: HexColor('#5052BEF5'),
                                  value: controller.energyLevelProgress,
                                  color: HexColor('#52BEF5'),
                                ))
                            : Container(
                                margin: EdgeInsets.only(left: 35.w),
                                child: Text(
                                  'no_readings_today'.tr,
                                  style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: HexColor('#787878')),
                                ),
                              ),
                        SizedBox(
                          height: 5.h,
                        ),
                        controller.energyLevel != 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${controller.energyLevel}/100',
                                    style: defaultTextStyle(
                                        size: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: HexColor('#787878')),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    )),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Image.asset(
                                  ImagePath.icStressLevel,
                                  height: 26.w,
                                  width: 26.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  'stress'.tr,
                                  style: defaultTextStyle(
                                      size: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                              ],
                            )),
                            Text(
                              controller.stressLevel != 0
                                  ? controller.stressLevelMsg
                                  : "",
                              style: defaultTextStyle(
                                  size: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: HexColor('#787878')),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                          ],
                        ),
                        controller.stressLevel != 0
                            ? Container(
                                margin: EdgeInsets.only(top: 10.h, left: 35.w),
                                height: 8.h,
                                child: LinearProgressIndicator(
                                  backgroundColor: HexColor('#50FFA800'),
                                  value: controller.stressLevelProgress,
                                  color: HexColor('#FFA800'),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(left: 35.w),
                                child: Text(
                                  'no_readings_today'.tr,
                                  style: defaultTextStyle(
                                      size: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: HexColor('#787878')),
                                ),
                              ),
                        SizedBox(
                          height: 5.h,
                        ),
                        controller.stressLevel != 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${controller.stressLevel}/100',
                                    style: defaultTextStyle(
                                        size: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: HexColor('#787878')),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    )),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetBodyMassIndex(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {
          Utility.isConnected().then((isConnected) {
            if (isConnected) {
              Get.toNamed(Routes.bmiDetailScreen,
                  arguments: [controller.userHeight, controller.userWeight]);
            } else {
              Utility().snackBarForInternetIssue();
            }
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Text(
                                  'bmi'.tr,
                                  style: defaultTextStyle(
                                      size: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Text(
                                    '(${'body_mass_index'.tr})',
                                    maxLines: 1,
                                    style: defaultTextStyle(
                                        size: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color: HexColor('#787878')),
                                  ),
                                )
                              ],
                            )),
                            Text(
                              controller.bmiMessage,
                              style: defaultTextStyle(
                                  size: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: HexColor('#787878')),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15.h),
                            height: 9.h,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                    color: HexColor('#F8555A'),
                                  ),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#FFA847'),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#FAE56E'),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#4FD286'),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#B0D683'),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#FAE56E'),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#FFA847'),
                                )),
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                    color: HexColor('#F8555A'),
                                  ),
                                )),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          child: Row(
                            children: [
                              Expanded(
                                  child: controller.isSevereThinness
                                      ? widgetBMIPointer(
                                          controller.bmiValue.toString())
                                      : Container()),
                              Expanded(
                                  child: controller.isModerateThinness
                                      ? widgetBMIPointer(
                                          controller.bmiValue.toString())
                                      : Container()),
                              Expanded(
                                  child: controller.isMildThinness
                                      ? widgetBMIPointer(
                                          controller.bmiValue.toString())
                                      : Container()),
                              Expanded(
                                  child: controller.isNormalThinness
                                      ? widgetBMIPointer(
                                          controller.bmiValue.toString())
                                      : Container()),
                              Expanded(
                                  child: controller.isOverWeightThinness
                                      ? widgetBMIPointer(
                                          controller.bmiValue.toString())
                                      : Container()),
                              Expanded(
                                  child: controller.isObeseClass
                                      ? widgetBMIPointer(
                                          controller.bmiValue.toString())
                                      : Container()),
                              Expanded(
                                  child: controller.isObeseClass2
                                      ? widgetBMIPointer(
                                          controller.bmiValue.toString())
                                      : Container()),
                              Expanded(
                                  child: controller.isObeseClass3
                                      ? widgetBMIPointer(
                                          controller.bmiValue.toString())
                                      : Container()),
                            ],
                          ),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 5.w,
                    ),
                    Image.asset(
                      ImagePath.icNextBtn,
                      height: 18.w,
                      width: 18.w,
                      //color: Colors.transparent,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetHeartStrain(DashboardController controller) {
  return Padding(
    padding: EdgeInsets.only(right: 5.w, left: 10.w),
    child: Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: InkWell(
        onTap: () {
          Utility.isConnected().then((isConnected) {
            if (isConnected) {
              controller.buttonGraph(
                  AppConstants.heartStrain, controller.userId,
                  value: '${controller.heartRate} ${'bpm'.tr}',
                  levelMsg: controller.hrState.toString(),
                  lastMeasured: controller.lastHeartRateValue,
                  totalRecords: controller.measureList);
            } else {
              Utility().snackBarForInternetIssue();
            }
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Padding(
            padding:
                EdgeInsets.only(left: 15.w, right: 12, top: 10.h, bottom: 10.h),
            //symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppConstants.heartStrain,
                                style: defaultTextStyle(
                                    size: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            Image.asset(
                              ImagePath.icNextBtn,
                              height: 18.w,
                              width: 18.w,
                              //color: Colors.transparent,
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15.h),
                            height: 9.h,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      bottomLeft: Radius.circular(5),
                                    ),
                                    color: HexColor(
                                        '#4FD286'), //HexColor('#F8555A'),
                                  ),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#B0D683'),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#FAE56E'),
                                )),
                                Expanded(
                                    child: Container(
                                  color: HexColor('#FFA847'),
                                )),
                                Expanded(
                                    child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(5),
                                      bottomRight: Radius.circular(5),
                                    ),
                                    color: HexColor(
                                        '#F8555A'), //HexColor('#F8555A'),
                                  ),
                                )),
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.only(top: 2.h),
                          child: Row(
                            children: [
                              Expanded(
                                  child: controller.heartStrain >= 0 &&
                                          controller.heartStrain < 20
                                      ? widgetHeartStrainPointer(
                                          controller.heartStrain)
                                      : Container()),
                              Expanded(
                                  child: controller.heartStrain >= 20 &&
                                          controller.heartStrain < 40
                                      ? widgetHeartStrainPointer(
                                          controller.heartStrain)
                                      : Container()),
                              Expanded(
                                  child: controller.heartStrain >= 40 &&
                                          controller.heartStrain < 60
                                      ? widgetHeartStrainPointer(
                                          controller.heartStrain)
                                      : Container()),
                              Expanded(
                                  child: controller.heartStrain >= 60 &&
                                          controller.heartStrain < 80
                                      ? widgetHeartStrainPointer(
                                          controller.heartStrain)
                                      : Container()),
                              Expanded(
                                  child: controller.heartStrain >= 80 &&
                                          controller.heartStrain <= 100
                                      ? widgetHeartStrainPointer(
                                          controller.heartStrain)
                                      : Container()),
                            ],
                          ),
                        )
                      ],
                    )),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget widgetBMIPointer(pointerValue) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/ic_bmi_pointer.png',
        height: 7.w,
        width: 7.w,
      ),
      SizedBox(
        height: 3.h,
      ),
      Text(
        pointerValue,
        style: defaultTextStyle(
            size: 12.sp,
            fontWeight: FontWeight.w500,
            color: HexColor('#787878')),
      ),
    ],
  );
}

Widget widgetHeartStrainPointer(pointerValue) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/ic_bmi_pointer.png',
        height: 7.w,
        width: 7.w,
      ),
      SizedBox(
        height: 3.h,
      ),
      Text(
        '$pointerValue%',
        style: defaultTextStyle(
            size: 12.sp,
            fontWeight: FontWeight.w500,
            color: HexColor('#787878')),
      ),
    ],
  );
}
