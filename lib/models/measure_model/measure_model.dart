// To parse this JSON data, do
//
//     final measureModel = measureModelFromJson(jsonString);

import 'dart:convert';

MeasureResult measureModelFromJson(String str) =>
    MeasureResult.fromJson(json.decode(str));

String measureModelToJson(MeasureResult data) => json.encode(data.toJson());


class MeasureResult {
  MeasureResult(
      {this.id,
      this.deviceId,
      this.userId,
      this.heartRate,
      this.oxygen,
      this.temperature,
      this.bloodPressure,
      this.hrVariability,
      this.activity,
      this.bodyHealth,
      this.dateTime,
      this.monthYear,
      this.measureTime,
      this.isSync,
      this.reading,
      this.timeStamp,
      this.healthTips,
      this.eValues,
      this.lValues,
      this.pulsePressure,
      this.arterialPressure});

  int? id;
  String? deviceId;
  String? userId;
  String? heartRate;
  String? oxygen;
  String? temperature;
  String? bloodPressure;
  String? hrVariability;
  String? activity;
  String? bodyHealth;
  String? dateTime;
  String? monthYear;
  String? measureTime;
  String? isSync;
  String? reading;
  int? timeStamp;
  String? healthTips;
  List<String>? eValues;
  List<String>? lValues;
  String? pulsePressure;
  String? arterialPressure;



  factory MeasureResult.fromJson(Map<String, dynamic> json) => MeasureResult(
        id: json["id"] ?? 0,
        deviceId: json["deviceId"] ?? "0",
        userId: json["userId"] ?? "0",
        heartRate: json["heartRate"] ?? "0",
        oxygen: json["oxygen"] ?? "0",
        temperature: json["temperature"] ?? "0",
        bloodPressure: json["bloodPressure"] ?? "0",
        hrVariability: json["hrVariability"] ?? "0",
        activity: json["activity"] ?? "0",
        bodyHealth: json["bodyHealth"] ?? "0",
        measureTime: json["measureTime"] ?? "0",
        monthYear: json["monthYear"] ?? "0",
        dateTime: json["dateTime"] ?? "0",
        isSync: json["isSync"] ?? "false",
        reading: json["reading"] ?? "",
        timeStamp: json["timeStamp"] ?? 0,
        healthTips: json["healthTips"] ?? "",
        eValues:
            json["eValues"] == null ? [] : List<String>.from(json["eValues"]),
        lValues:
            json["lValues"] == null ? [] : List<String>.from(json["lValues"]),
        pulsePressure: json["pulsePressure"] ?? "0",
        arterialPressure: json["arterialPressure"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deviceId": deviceId,
        "userId": userId,
        "heartRate": heartRate,
        "oxygen": oxygen,
        "temperature": temperature,
        "bloodPressure": bloodPressure,
        "hrVariability": hrVariability,
        "activity": activity,
        "bodyHealth": bodyHealth,
        "measureTime": measureTime,
        "dateTime": dateTime,
        "monthYear": monthYear,
        "isSync": isSync,
        "reading": reading,
        "timeStamp": timeStamp,
        "healthTips": healthTips,
        "eValues": eValues,
        "lValues": lValues,
        "pulsePressure": pulsePressure,
        "arterialPressure": arterialPressure,
      };
}
