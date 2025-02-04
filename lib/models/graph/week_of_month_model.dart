// To parse this JSON data, do
//
//     final measureModel = measureModelFromJson(jsonString);

import 'dart:convert';

import 'package:doori_mobileapp/controllers/dashboard_controllers/measure_controller.dart';

class WeekOfMonthModel {
  WeekOfMonthModel({
    this.month,
    this.weekOfYear,
    this.weekStartDate,
    this.weekEndDate,
    this.avgMeasure
  });

  int? month;
  int? weekOfYear;
  DateTime? weekStartDate;
  DateTime? weekEndDate;
  double? avgMeasure;
}
