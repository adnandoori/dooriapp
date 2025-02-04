import 'dart:async';

import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:screenshot/screenshot.dart';

class StrokeCardiacGraphScreen extends StatefulWidget {
  List<MeasureResult> dooriReportList;

  StrokeCardiacGraphScreen({required this.dooriReportList, super.key});

  //StrokeCardiacGraphScreen({super.key});

  @override
  State<StrokeCardiacGraphScreen> createState() =>
      _StrokeCardiacGraphScreenState();
}

class _StrokeCardiacGraphScreenState extends State<StrokeCardiacGraphScreen> {
  List<MeasureResult> dooriReportList = [];

  final List<ChartData> chartData = [];

  ScreenshotController screenshotController = ScreenshotController();
  late DateTime dateTime;
  DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
  var resultFormatter = DateFormat('dd/MM');

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('--total----records--graph-->${widget.dooriReportList.length}');
      //setOrientation();
      widget.dooriReportList.reversed; // =widget.dooriReportList.reversed;

      for (int i = 0; i < widget.dooriReportList.length; i++)
      {
        String input = widget.dooriReportList[i].bloodPressure.toString();
        List values = input.split("/");

        try {
          dateTime = dateFormat.parse('${widget.dooriReportList[i].dateTime}');
        } catch (exe) {
          printf('exe---date-->$exe');
        }

        var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        //printf('------------------${resultFormatter.format(currentDate)}');

        String dd = resultFormatter.format(currentDate);
        //widget.dooriReportList[i].dateTime.toString().substring(0, 2);

        String tt = widget.dooriReportList[i].measureTime
            .toString(); //.substring(0, 4);

        String time = DateFormat.jm().format(DateFormat("mm:ss").parse(tt));

        String date = '$dd ${time.substring(0, 5)}';

        //printf('--date--->$date---time--->$time');

        //printf(DateFormat.jm().format(DateFormat("mm:ss").parse(time)));

        //printf('date--${widget.dooriReportList[i].dateTime.toString().substring(0,2)}');

        double s = double.parse(values[0].toString());
        double d = double.parse(values[1].toString());
        double hr = double.parse(widget.dooriReportList[i].heartRate.toString());
        double ox = double.parse(widget.dooriReportList[i].oxygen.toString());
        double hrv =
            double.parse(widget.dooriReportList[i].hrVariability.toString());

        //double pp = double.parse(widget.dooriReportList[i].hrVariability.toString());
        //double ap = double.parse(widget.dooriReportList[i].hrVariability.toString());

        chartData.add(ChartData(date, hr, ox, s, d, hrv,0));

        //printf('---graph-value--->${widget.dooriReportList[i].heartRate}');
      }
      setState(() {});

      // Timer(const Duration(seconds: 2), () async {
      //   screenshotController
      //       .capture(delay: const Duration(milliseconds: 10))
      //       .then((capturedImage) async {
      //     printf('captured--->$capturedImage');
      //
      //     Get.back(result: capturedImage);
      //   }).catchError((onError) {
      //     printf('error--->$onError');
      //   });
      // });

    });
  }

  void setOrientation() {
    SystemChrome.setPreferredOrientations([
      //DeviceOrientation.portraitUp,
      //DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screenshot(
        controller: screenshotController,
        child: SizedBox(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 2),
              child: Text('heart_rate'.tr,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0080FF))),
            ),
            Expanded(
                child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      crossesAt: 0,
                      labelStyle: const TextStyle(fontSize: 6),
                      labelRotation: 330,
                      labelIntersectAction: AxisLabelIntersectAction.none,
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                    ),
                    primaryYAxis: NumericAxis(
                      isVisible: true,
                      minimum: 40,
                      maximum: 100,
                      labelStyle: const TextStyle(fontSize: 8),
                    ),
                    legend: Legend(isVisible: false),
                    enableAxisAnimation: true,
                    //primaryXAxis: CategoryAxis(),
                    series: <CartesianSeries>[
                  LineSeries<ChartData, String>(
                      color: ColorConstants.chartColor,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        color: ColorConstants.chartColor,
                        borderColor: ColorConstants.iconColor,
                        shape: DataMarkerType.circle,
                        width: 5,
                        height: 5,
                      ),
                      dataLabelSettings: const DataLabelSettings(
                          textStyle:
                              TextStyle(fontSize: 9, color: Color(0xFF0080FF)),
                          showZeroValue: false,
                          isVisible: true),
                      dataSource: chartData.reversed.toList(),
                      xValueMapper: (ChartData data, _) => data.date,
                      yValueMapper: (ChartData data, _) => data.hr),
                ]
                )
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 2),
              child: Text('oxygen_level'.tr,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0080FF))),
            ),
            Expanded(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    crossesAt: 0,
                    labelStyle: const TextStyle(fontSize: 6),
                    labelRotation: 330,
                    labelIntersectAction: AxisLabelIntersectAction.none,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    labelStyle: const TextStyle(fontSize: 8),
                  ),
                  legend: Legend(isVisible: false),
                  enableAxisAnimation: true,
                  //primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    LineSeries<ChartData, String>(
                        color: ColorConstants.chartColor,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
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
                            isVisible: true),
                        dataSource: chartData.reversed.toList(),
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.ox),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 2),
              child: Text('blood_pressure'.tr,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0080FF))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 2),
              child: Text('systolic'.tr,
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0080FF))),
            ),
            Expanded(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    crossesAt: 0,
                    labelStyle: const TextStyle(fontSize: 6),
                    labelRotation: 330,
                    labelIntersectAction: AxisLabelIntersectAction.none,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    labelStyle: const TextStyle(fontSize: 8),
                  ),
                  legend: Legend(isVisible: false),
                  enableAxisAnimation: true,
                  //primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    LineSeries<ChartData, String>(
                        color: ColorConstants.chartColor,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
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
                            isVisible: true),
                        dataSource: chartData.reversed.toList(),
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.sys),
                    // LineSeries<ChartData, String>(
                    //     color: ColorConstants.colorForRed,
                    //     markerSettings: const MarkerSettings(
                    //       isVisible: true,
                    //       color: ColorConstants.colorForRed,
                    //       borderColor: ColorConstants.colorForRed,
                    //       shape: DataMarkerType.circle,
                    //       width: 5,
                    //       height: 5,
                    //     ),
                    //     dataLabelSettings: const DataLabelSettings(
                    //         offset: Offset(0, 10),
                    //         textStyle: TextStyle(
                    //             fontSize: 9, color: ColorConstants.colorForRed),
                    //         showZeroValue: true,
                    //         isVisible: true),
                    //     dataSource: chartData.reversed.toList(),
                    //     xValueMapper: (ChartData data, _) => data.date,
                    //     yValueMapper: (ChartData data, _) => data.dia),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 2),
              child: Text('diastolic'.tr,
                  style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.colorForRed)),
            ),
            Expanded(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    crossesAt: 0,
                    labelStyle: const TextStyle(fontSize: 6),
                    labelRotation: 330,
                    labelIntersectAction: AxisLabelIntersectAction.none,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    labelStyle: const TextStyle(fontSize: 8),
                  ),
                  legend: Legend(isVisible: false),
                  enableAxisAnimation: true,
                  //primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    LineSeries<ChartData, String>(
                        color: ColorConstants.colorForRed,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          color: ColorConstants.colorForRed,
                          borderColor: ColorConstants.colorForRed,
                          shape: DataMarkerType.circle,
                          width: 5,
                          height: 5,
                        ),
                        dataLabelSettings: const DataLabelSettings(
                            // offset: Offset(0, 10),
                            textStyle: TextStyle(
                                fontSize: 9, color: ColorConstants.colorForRed),
                            showZeroValue: true,
                            isVisible: true),
                        dataSource: chartData.reversed.toList(),
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.dia),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 2),
              child: Text('hr_variability'.tr,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0080FF))),
            ),
            Expanded(
              child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(
                    crossesAt: 0,
                    labelStyle: const TextStyle(fontSize: 6),
                    labelRotation: 330,
                    labelIntersectAction: AxisLabelIntersectAction.none,
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: true,
                    labelStyle: const TextStyle(fontSize: 8),
                  ),
                  legend: Legend(isVisible: false),
                  enableAxisAnimation: true,
                  //primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    LineSeries<ChartData, String>(
                        color: ColorConstants.chartColor,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
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
                            isVisible: true),
                        dataSource: chartData.reversed.toList(),
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.hrv),
                  ]),
            ),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.share),
        onPressed: () {
          screenshotController
              .capture(delay: const Duration(milliseconds: 10))
              .then((capturedImage) async {
            printf('captured--$capturedImage');

            Get.back(result: capturedImage);
            //Get.back(result: capturedImage);

            //showCapturedWidget(context, capturedImage!);
          }).catchError((onError) {
            printf('error--$onError');
          });
        },
      ),
    );
  }

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Captured widget screenshot"),
        ),
        body: Center(child: Image.memory(capturedImage)),
      ),
    );
  }

  Widget widgetSizeBox() {
    return SizedBox(
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(
            crossesAt: 0,
          ),
          primaryYAxis: NumericAxis(isVisible: true, minimum: 0, maximum: 200),
          legend: Legend(isVisible: false),
          enableAxisAnimation: true,
          //primaryXAxis: CategoryAxis(),
          series: <CartesianSeries>[
            LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.hr),
            LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.ox),
            LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.sys),
            LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.dia),
            LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.hrv),

            /*LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.pp),
            LineSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.date,
                yValueMapper: (ChartData data, _) => data.ap)*/
          ]),
    );
  }
}

class ChartData {
  ChartData(this.date, this.hr, this.ox, this.sys, this.dia, this.hrv,this.xValue);

  final String date;
  final double? hr;
  final double? ox;
  final double? sys;
  final double? dia;
  final double? hrv;
  final int? xValue;
//final double? pp;
//final double? ap;
}

class ChartDataModel {
  ChartDataModel(this.date,this.time, this.hr, this.ox, this.sys, this.dia, this.hrv,this.xValue);

  final String date;
  final String time;
  final double? hr;
  final double? ox;
  final double? sys;
  final double? dia;
  final double? hrv;
  final int? xValue;
//final double? pp;
//final double? ap;
}