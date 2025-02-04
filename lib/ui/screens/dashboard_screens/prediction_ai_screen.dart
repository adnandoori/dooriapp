import 'package:doori_mobileapp/controllers/dashboard_controllers/prediction_ai_controller.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/graph_screens/stroke_cardiac_graph_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:ui' as ui;

class PredictionAIScreen extends StatelessWidget {
  const PredictionAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PredictionAIController>(
        init: PredictionAIController(context),
        builder: (controller) {
          return Scaffold(
              backgroundColor: HexColor('#f5f5f5'),
              body: Column(
                children: [
                  widgetAppBar(controller),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widgetWellnessScore(controller),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10.h),
                          child: Column(
                            children: [
                              widgetGraph(controller,
                                  title: AppConstants.heartRate,
                                  content: controller.heartRateContent,
                                  type: 'HR'),
                              widgetGraph(controller,
                                  title: AppConstants.hrVariability,
                                  content: controller.hrvContent,
                                  type: 'HRV'),
                              widgetGraph(controller,
                                  title: 'Systolic blood pressure',
                                  content: controller.sysContent,
                                  type: 'SYS'),
                              widgetGraph(controller,
                                  title: 'Diastolic blood pressure',
                                  content: controller.dysContent,
                                  type: 'DYS'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
                ],
              ));
        });
  }

  Widget widgetWellnessScore(PredictionAIController controller) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: controller.color ??
            controller
                .colorForVeryHigh, //HexColor(controller.color.toString()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppConstants.wellnessScore,
                style: defaultTextStyle(
                    size: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                controller.wellnessScore,
                style: defaultTextStyle(
                    size: 40.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '${AppConstants.outOf} 100',
                style: defaultTextStyle(
                    size: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  controller.title,
                  textAlign: TextAlign.center,
                  style: defaultTextStyle(
                      size: 18.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  controller.content,
                  textAlign: TextAlign.center,
                  style: defaultTextStyle(
                      size: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25.h, bottom: 30.h),
                    height: 30.h,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: HexColor('#D9D9D9'), //ColorConstants.textColor,
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 12.w, right: 12.w, top: 6.h, bottom: 6.h),
                        child: Text(
                          "${AppConstants.concernLevel}: ${controller.concernLevel}",
                          style: defaultTextStyle(
                              fontWeight: FontWeight.w400,
                              size: 12.sp,
                              color: ColorConstants.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget widgetGraph(PredictionAIController controller,
      {String? title, String? content, String? type}) {
    var icon = ImagePath.icHeartRate;

    int startEndAvg = 0;
    int endAvg = 0;
    int avg = 0;

    // hr - 60-75 // sys - 118 -122 ,dys- 78-82, hrv- 100,200

    if (type == 'HR') {
      icon = ImagePath.icHeartRate;
      avg = controller.avgHR;
      startEndAvg = 60; //controller.avgHR;
      endAvg = 75;
    } else if (type == 'HRV') {
      icon = ImagePath.icHRV;
      avg = controller.avgHRV;
      startEndAvg = 100; //controller.avgHRV;
      endAvg = 200;
    } else if (type == 'SYS') {
      avg = controller.avgSystolic;
      icon = ImagePath.icBloodPressure;
      startEndAvg = 118; //controller.avgSystolic;
      endAvg = 122;
    } else if (type == 'DYS') {
      avg = controller.avgDia;
      icon = ImagePath.icBloodPressure;
      startEndAvg = 78; //controller.avgDia;
      endAvg = 82;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: 300.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Colors.white, //ColorConstants.textColor,
            ),
            width: Get.width,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10.w),
                        height: 24,
                        width: 24,
                        child: Image.asset(
                          icon,
                          height: 24,
                          width: 24,
                        ),
                      ),
                      Text(
                        title.toString(),
                        style: defaultTextStyle(
                            fontWeight: FontWeight.w600,
                            size: 16.sp,
                            color: ColorConstants.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    content.toString(),
                    style: defaultTextStyle(
                        fontWeight: FontWeight.w400,
                        size: 12.sp,
                        color: ColorConstants.black),
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Expanded(
                      child: SizedBox(
                    height: 150.h,
                    child: SfCartesianChart(
                        trackballBehavior: TrackballBehavior(
                          enable: true,
                          markerSettings: const TrackballMarkerSettings(
                              height: 0,
                              width: 0,
                              markerVisibility: TrackballVisibilityMode.hidden,
                              borderColor: Colors.black,
                              borderWidth: 0,
                              color: Colors.transparent),
                          tooltipDisplayMode:
                              TrackballDisplayMode.floatAllPoints,
                          activationMode: ActivationMode.singleTap,
                          tooltipSettings: const InteractiveTooltip(
                            color: Colors.black,
                          ),
                          builder: (context, trackballDetails) {
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                //width: 100,
                                height: 70,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                ),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(trackballDetails.point!.y.toString(),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 20)),
                                    Text(
                                        controller
                                            .chartData[
                                                trackballDetails.pointIndex!]
                                            .date,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        tooltipBehavior: TooltipBehavior(
                          enable: false,
                        ),
                        plotAreaBorderWidth: 0,
                        primaryXAxis: CategoryAxis(
                          labelStyle:
                              const TextStyle(color: Colors.transparent),
                          isVisible: false,
                          axisLine: const AxisLine(color: Colors.red),
                        ),
                        primaryYAxis: NumericAxis(
                          axisLine: const AxisLine(color: Colors.transparent),
                          plotBands: <PlotBand>[
                            PlotBand(
                                horizontalTextAlignment: TextAnchor.start,
                                start: startEndAvg,
                                end: endAvg,
                                opacity: 0.1,
                                color: const Color(0xFF4FD286),
                                dashArray: const <double>[4, 5]),
                            PlotBand(
                              shouldRenderAboveSeries: true,
                              text: 'Avg : $avg',
                              textStyle:
                                  const TextStyle(color: Color(0xFF0080FF)),
                              isVisible: true,
                              borderColor: const Color(0xFF0080FF),
                              borderWidth: 2,
                              horizontalTextAlignment: TextAnchor.start,
                              start: avg,
                              end: avg,
                            ),
                          ],
                          isVisible: true,
                          labelStyle: const TextStyle(
                              fontSize: 8, color: Color(0xFF929395)),
                        ),
                        legend: Legend(isVisible: false),
                        enableAxisAnimation: true,
                        series: <CartesianSeries>[
                          SplineSeries<ChartData, String>(
                            width: 4,
                            color: ColorConstants.chartColor,
                            markerSettings: const MarkerSettings(
                              isVisible: false,
                              color: ColorConstants.chartColor,
                              borderColor: ColorConstants.iconColor,
                              shape: DataMarkerType.circle,
                              width: 5,
                              height: 5,
                            ),
                            dataLabelSettings: const DataLabelSettings(
                                textStyle: TextStyle(
                                    fontSize: 9, color: Color(0xFF0080FF)),
                                showZeroValue: false,
                                isVisible: false),
                            dataSource: controller.chartData.reversed.toList(),
                            xValueMapper: (ChartData data, _) =>
                                data.xValue.toString(),
                            yValueMapper: (ChartData data, _) => type == 'HR'
                                ? data.hr
                                : type == 'HRV'
                                    ? data.hrv
                                    : type == 'SYS'
                                        ? data.sys
                                        : type == 'DYS'
                                            ? data.dia
                                            : data.hr,
                            // onCreateShader: (ShaderDetails details)
                            // {
                            //   return ui.Gradient.linear(details.rect.bottomLeft,
                            //       details.rect.bottomRight, const <Color>[
                            //         Color.fromRGBO(116, 182, 194, 1),
                            //         Color.fromRGBO(75, 189, 138, 1),
                            //         Color.fromRGBO(75, 189, 138, 1),
                            //         Color.fromRGBO(255, 186, 83, 1),
                            //         Color.fromRGBO(255, 186, 83, 1),
                            //         Color.fromRGBO(194, 110, 21, 1),
                            //         Color.fromRGBO(194, 110, 21, 1),
                            //         Color.fromRGBO(116, 182, 194, 1),
                            //       ],
                            //       <double>[
                            //         0.5,
                            //         0.5,
                            //         0.4,
                            //         0.4,
                            //         0.7,
                            //         0.7,
                            //         0.1,
                            //         0.1
                            //       ]);
                            // },

                            // pointColorMapper: (ChartData data, _)
                            // {
                            //   if (type == 'HR')
                            //   {
                            //     if (data.hr! < 66)
                            //     {
                            //       return const Color(0xFF4fd286);
                            //     } else if (data.hr! >= 65 && data.hr! < 75) {
                            //       return const Color(
                            //           0xFFb0d683); // medium values
                            //     } else if (data.hr! >= 75 && data.hr! < 82) {
                            //       return const Color(
                            //           0xFFfae56e); // medium values
                            //     } else if (data.hr! >= 82 && data.hr! < 90) {
                            //       return const Color(
                            //           0xFFffa847); // medium values
                            //     } else if (data.hr! >= 92) {
                            //       return const Color(0xFFf8555a); // low values
                            //     }
                            //   } else if (type == 'HRV') {
                            //     if (data.hrv! >= 150) {
                            //       return const Color(0xFF4fd286);
                            //     } else if (data.hrv! >= 100 &&
                            //         data.hrv! < 150) {
                            //       return const Color(
                            //           0xFFb0d683); // medium values
                            //     } else if (data.hrv! >= 50 && data.hrv! < 100) {
                            //       return const Color(
                            //           0xFFfae56e); // medium values
                            //     } else if (data.hrv! >= 30 && data.hrv! < 50) {
                            //       return const Color(
                            //           0xFFffa847); // medium values
                            //     } else if (data.hrv! < 30)
                            //     {
                            //       return const Color(0xFFf8555a); // low values
                            //     }
                            //   } else if (type == 'SYS') {
                            //     if (data.sys! >= 118 && data.sys! < 122) {
                            //       return const Color(0xFF4fd286);
                            //     } else if (data.sys! >= 116 &&
                            //             data.sys! < 118 ||
                            //         data.sys! >= 122 && data.sys! < 124) {
                            //       return const Color(
                            //           0xFFb0d683); // medium values
                            //     } else if (data.sys! >= 114 &&
                            //             data.sys! < 116 ||
                            //         data.sys! >= 124 && data.sys! < 126) {
                            //       return const Color(
                            //           0xFFfae56e); // medium values
                            //     } else if (data.sys! >= 112 &&
                            //             data.sys! < 114 ||
                            //         data.sys! >= 126 && data.sys! < 128) {
                            //       return const Color(
                            //           0xFFffa847); // medium values
                            //     } else if (data.sys! < 112 || data.sys! > 128) {
                            //       return const Color(0xFFf8555a); // low values
                            //     }
                            //   } else if (type == 'DYS') {
                            //     if (data.dia! >= 78 && data.dia! < 82) {
                            //       return const Color(0xFF4fd286);
                            //     } else if (data.dia! >= 76 && data.dia! < 78 ||
                            //         data.dia! >= 82 && data.dia! < 84) {
                            //       return const Color(
                            //           0xFFb0d683); // medium values
                            //     } else if (data.dia! >= 74 && data.dia! < 76 ||
                            //         data.dia! >= 84 && data.dia! < 86) {
                            //       return const Color(
                            //           0xFFfae56e); // medium values
                            //     } else if (data.dia! >= 72 && data.dia! < 74 ||
                            //         data.dia! >= 86 && data.dia! < 88) {
                            //       return const Color(
                            //           0xFFffa847); // medium values
                            //     } else if (data.dia! < 72 || data.dia! > 88) {
                            //       return const Color(0xFFf8555a); // low values
                            //     }
                            //   } else {
                            //     return Colors.red;
                            //   }
                            // },
                          ),
                        ]),
                  )),
                  Text(
                    'Last 15 Readings',
                    style: defaultTextStyle(
                        fontWeight: FontWeight.w600,
                        size: 10.sp,
                        color: ColorConstants.black),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget widgetAppBar(PredictionAIController controller) {
    return Container(
      width: Get.width,
      height: 66.h,
      color: controller.color ?? ColorConstants.colorForRed,
      child: Padding(
        padding: EdgeInsets.only(
          left: 15.w,
          top: 10.h,
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset(
                ImagePath.icBackBtn,
                height: 25.w,
                width: 25.w,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              AppConstants.predictionAI.toUpperCase(),
              style: defaultTextStyle(size: 16.sp, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  commonAppbar({VoidCallback? onBack, String title = ''}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(60.h),
      child: Container(
        width: Get.width,
        height: 60.h,
        color: ColorConstants.blueColor,
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.w,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: onBack,
                child: Image.asset(
                  ImagePath.icBackBtn,
                  height: 25.w,
                  width: 25.w,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                title.toUpperCase(),
                style:
                    defaultTextStyle(size: 16.sp, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}
