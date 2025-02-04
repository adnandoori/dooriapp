import 'package:doori_mobileapp/controllers/dashboard_controllers/graph_controllers/energy_stress_level_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/graph_controllers/heart_graph_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/activity_screen.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EnergyStressLevelScreen extends StatefulWidget {
  const EnergyStressLevelScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return EnergyStressLevelState();
  }
}

class EnergyStressLevelState extends State<EnergyStressLevelScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EnergyStressLevelController>(
        init: EnergyStressLevelController(context),
        builder: (controller) {
          return ColoredSafeArea(
            color: ColorConstants.white,
            child: Scaffold(
              appBar: commonAppbarWhiteColor(
                  title: controller.title, //AppConstants.heartRate,
                  onBack: () {
                    Get.back();
                  }),
              body: SingleChildScrollView(
                child: SizedBox(
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Material(
                            elevation: 1,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            child: Container(
                              width: Get.width,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: Colors.white,
                              ),
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: 18.h,
                                      left: 16.w,
                                      right: 16.w,
                                      bottom: 12.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      controller.graphDayForBloodPressureList
                                              .isNotEmpty
                                          ? Container(
                                              child: widgetBodyHealthTipsForDay(
                                                  controller),
                                            )
                                          : Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 10.h),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )),
                                                  InkWell(
                                                    onTap: () async {
                                                      printf("clicked measure");

                                                      final result = await Get
                                                          .toNamed(Routes
                                                              .measureScreen);

                                                      if (result.toString() ==
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
                                                        borderRadius:
                                                            BorderRadius.all(
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
                                                          'measure'
                                                              .tr
                                                              .toUpperCase(),
                                                          style:
                                                              defaultTextStyle(
                                                            size: 11.sp,
                                                            color: Colors.blue,
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
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        cardWidgetGraph(controller),
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
        });
  }

  Widget cardWidgetGraph(EnergyStressLevelController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return Material(
      elevation: 1,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        width: Get.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        child: Container(
          margin:
              EdgeInsets.only(top: 10.h, left: 0.w, right: 0.w, bottom: 10.h),
          child: SizedBox(
            width: Get.width,
            height: 400.h,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [

                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller.tabController.index == 1) {
                              controller.buttonPreviousWeekTab();
                            } else if (controller.tabController.index == 2) {
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
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      // DateTime(DateTime.now()),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100));

                                  if (pickedDate != null) {
                                    String formattedDate =
                                        DateFormat('dd MMM, yyyy')
                                            .format(pickedDate);

                                    controller.displayDateText = formattedDate;
                                    printf('---date--format--$formattedDate');
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
                                size: 16.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (controller.tabController.index == 1) {
                              controller.buttonNextWeekTab();
                            } else if (controller.tabController.index == 2) {
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
                  Expanded(
                    child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        widgetDay(controller),
                        //widgetWeek(controller),
                        //widgetMonth(controller),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: widgetTooltipForBodyHealth(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget widgetTooltipForBodyHealth() {
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
                  'energy'.tr,
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
                color: HexColor('#FFA800'),
                height: 10.h,
                width: 30.w,
              ),
              Expanded(
                child: Text(
                  'stress'.tr,
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

  Widget widgetAverage({title, value}) {
    return Padding(
      padding: EdgeInsets.only(left: 0.w, right: 0.w),
      child: Material(
        elevation: 1,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          height: 65,
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
                    style: defaultTextStyle(
                        size: 11.sp,
                        fontWeight: FontWeight.w300,
                        color: HexColor('#787878'))),
                Text(value.toString(),
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

  Widget widgetDay(EnergyStressLevelController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return Container(
      padding: const EdgeInsets.only(right: 20, top: 20),
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 5.w,
          ),
          Expanded(
              child: Stack(
            children: [
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    crossesAt: 0,
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    //minimum: 0, maximum: 100
                  ),
                  legend: Legend(isVisible: false),
                  tooltipBehavior: tooltipBehavior,
                  series: <CartesianSeries<GraphModelForBloodPressure, String>>[
                    SplineSeries<GraphModelForBloodPressure, String>(
                      enableTooltip: false,
                      color: ColorConstants.chartColor,
                      dataSource: controller.graphDayForBloodPressureList,
                      width: 5,
                      dataLabelSettings: const DataLabelSettings(
                          showZeroValue: true, isVisible: true),
                      markerSettings: const MarkerSettings(
                          color: ColorConstants.white,
                          isVisible: true,
                          height: 10,
                          width: 10,
                          borderColor: ColorConstants.iconColor,
                          shape: DataMarkerType.circle),
                      xValueMapper: (GraphModelForBloodPressure sales, _) {
                        return sales.title;
                      },
                      yValueMapper: (GraphModelForBloodPressure sales, _) {
                        return sales.v1.toInt();
                      },
                    ),
                    SplineSeries<GraphModelForBloodPressure, String>(
                      enableTooltip: false,
                      color: HexColor('#FFA800'),
                      //ColorConstants.lightRed,
                      dataSource: controller.graphDayForBloodPressureList,
                      width: 5,
                      dataLabelSettings: const DataLabelSettings(
                          showZeroValue: true, isVisible: true),
                      markerSettings: MarkerSettings(
                          color: ColorConstants.white,
                          isVisible: true,
                          height: 10,
                          width: 10,
                          borderColor: HexColor('#FFA800'),
                          //ColorConstants.lightRed,
                          shape: DataMarkerType.circle),
                      xValueMapper: (GraphModelForBloodPressure sales, _) {
                        return sales.title;
                      },
                      yValueMapper: (GraphModelForBloodPressure sales, _) {
                        //printf('---value--stress---${sales.v2}');
                        return sales.v2.toInt();
                      },
                      //sales.v1,
                    ),
                  ]),
            ],
          )),
        ],
      ),
    );
  }

  Widget widgetWeek(EnergyStressLevelController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return Container(
      padding: const EdgeInsets.only(right: 20, top: 20),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          Expanded(
              child: Stack(
            children: [
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    isInversed: true,
                    crossesAt: 0,
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    minimum: 0,
                    maximum: 100,
                  ),
                  legend: Legend(isVisible: false),
                  tooltipBehavior: tooltipBehavior,
                  series: <ColumnSeries<WeekModel, String>>[
                    ColumnSeries<WeekModel, String>(
                        enableTooltip: false,
                        color: ColorConstants.chartColor,
                        dataSource: controller.listWeekData.reversed.toList(),
                        xValueMapper: (WeekModel sales, _) =>
                            DateFormat('dd-MMM-yyyy')
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(sales.title)))
                                .toString()
                                .substring(0, 2),
                        yValueMapper: (WeekModel sales, _) {
                          try {
                            double avgEnergy = sales.value / sales.count;
                            double el = avgEnergy * 0.5;
                            return el.toInt();
                          } catch (e) {
                            return 0;
                          }
                        },
                        // Enable data label
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: false)),
                    ColumnSeries<WeekModel, String>(
                        enableTooltip: false,
                        color: ColorConstants.colorForRed,
                        dataSource: controller.listWeekDataForDiastolic.reversed
                            .toList(),
                        xValueMapper: (WeekModel sales, _) =>
                            DateFormat('dd-MMM-yyyy')
                                .format(DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(sales.title)))
                                .toString()
                                .substring(0, 2),
                        //sales.title.substring(0, 2),
                        yValueMapper: (WeekModel sales, _) {
                          // final dt = DateFormat('dd-MMM-yyyy')
                          //     .format(DateTime.fromMillisecondsSinceEpoch(
                          //         int.parse(sales.title)))
                          //     .toString()
                          //     .substring(0, 2);

                          double stress = sales.value * 100 / sales.count;

                          if (stress.toString() == 'NaN') {
                            return 0;
                          } else {
                            return stress.toInt();
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
    );
  }

  Widget widgetMonth(EnergyStressLevelController controller) {
    TooltipBehavior tooltipBehavior = TooltipBehavior(enable: true);
    return Container(
      padding: const EdgeInsets.only(right: 20, top: 20),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          Expanded(
              child: Stack(
            children: [
              SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    isInversed: true,
                    crossesAt: 0,
                    majorGridLines: const MajorGridLines(width: 0),
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    minimum: 0,
                    maximum: 100,
                  ),
                  legend: Legend(isVisible: false),
                  tooltipBehavior: tooltipBehavior,
                  series: <ColumnSeries<GraphModel, String>>[
                    ColumnSeries<GraphModel, String>(
                        enableTooltip: false,
                        color: ColorConstants.chartColor,
                        dataSource: controller.monthGraphPlot,
                        xValueMapper: (GraphModel sales, _) => sales.title,
                        yValueMapper: (GraphModel sales, _) {
                          double avg = sales.value * 0.5;

                          return avg;
                        },
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: false)),
                    ColumnSeries<GraphModel, String>(
                        enableTooltip: false,
                        color: Colors.redAccent,
                        //ColorConstants.lightRed,
                        dataSource: controller.monthGraphPlotForDiastolic,
                        xValueMapper: (GraphModel sales, _) => sales.title,
                        yValueMapper: (GraphModel sales, _) {
                          double avg = sales.value;
                          //printf('--month---$avg---${sales.value}');
                          return avg;
                        },
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: false))
                  ]),
            ],
          )),
        ],
      ),
    );
  }

  Widget widgetBodyHealthTipsForDay(EnergyStressLevelController controller) {
    return Padding(
      padding: EdgeInsets.only(right: 5.w, left: 10.w),
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
                size: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            '${'energy'.tr} :',
            style: defaultTextStyle(
                size: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            controller.energyTip,
            style: defaultTextStyle(
                size: 13.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black), //HexColor('#787878')
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            '${'stress'.tr} :',
            style: defaultTextStyle(
                size: 14.sp, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Text(
            controller.stressTip,
            style: defaultTextStyle(
                size: 13.sp, fontWeight: FontWeight.w400, color: Colors.black),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
  }

  Widget widgetSingleChildScroll(EnergyStressLevelController controller) {
    return SingleChildScrollView(
      child: SizedBox(
        width: Get.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width,
              height: 400.h,
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              if (controller.tabController.index == 1) {
                                controller.buttonPreviousWeekTab();
                              } else if (controller.tabController.index == 2) {
                                controller.buttonPreviousMonthTab();
                              } else {
                                controller.previousDayTabClick();
                              }
                            },
                            child: Image.asset(
                              ImagePath.icBackBtn,
                              height: 30.w,
                              width: 30.w,
                            ),
                          ),
                          InkWell(
                            onTap: controller.tabController.index == 0
                                ? () async {
                                    DateTime? pickedDate = await showDatePicker(
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
                                      printf('---date--format--$formattedDate');
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
                                  size: 16.sp,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (controller.tabController.index == 1) {
                                controller.buttonNextWeekTab();
                              } else if (controller.tabController.index == 2) {
                                controller.buttonNextMonthTab();
                              } else {
                                controller.nextDayTabClick();
                              }
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
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
                          Tab(text: 'day'.tr),
                          Tab(text: 'week'.tr),
                          Tab(text: 'month'.tr),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          widgetDay(controller),
                          widgetWeek(controller),
                          widgetMonth(controller),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8.h, left: 10.w, right: 10.w),
              width: Get.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5.w, left: 5.w),
                          color: ColorConstants.chartColor,
                          height: 10.h,
                          width: 30.w,
                        ),
                        Expanded(
                          child: Text(
                            'energy'.tr,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 5.w, left: 5.w),
                          color: ColorConstants.colorForRed,
                          height: 10.h,
                          width: 30.w,
                        ),
                        Expanded(
                          child: Text(
                            'stress'.tr,
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
                    height: 15.h,
                  ),
                  controller.measureUserList.isNotEmpty
                      ? widgetBodyHealthTipsForDay(controller)
                      : Container(),
                  SizedBox(
                    height: 24.h,
                  ),
                  controller.measureUserList.isNotEmpty
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
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
