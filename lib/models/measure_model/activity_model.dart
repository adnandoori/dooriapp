import 'dart:convert';

ActivityModel measureModelFromJson(String str) =>
    ActivityModel.fromJson(json.decode(str));

class ActivityModel {
  ActivityModel(
      {this.deviceId,
      this.userId,
      this.activity,
      this.bodyHealth,
      this.dateTime,
      this.measureTime,
      this.isSync,
      this.reading});

  String? deviceId;
  String? userId;
  String? activity;
  String? bodyHealth;
  String? dateTime;
  String? measureTime;
  String? isSync;
  String? reading;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
      deviceId: json["deviceId"] ?? "0",
      userId: json["userId"] ?? "0",
      activity: json["activity"] ?? "0",
      bodyHealth: json["bodyHealth"] ?? "0",
      measureTime: json["time"] ?? "0",
      dateTime: json["date"] ?? "0",
      isSync: json["isSync"] ?? "false",
      reading: json["reading"] ?? "");
}
