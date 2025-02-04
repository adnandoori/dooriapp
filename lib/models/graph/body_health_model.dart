import 'dart:convert';

BodyHealthModel measureModelFromJson(String str) =>
    BodyHealthModel.fromJson(json.decode(str));

String measureModelToJson(BodyHealthModel data) => json.encode(data.toJson());

class BodyHealthModel {
  BodyHealthModel(
      {this.userId,
      this.dateTime,
      this.monthYear,
      this.energyLevel,
      this.stressLevel,
      this.measureTime,
      this.timeStamp,
      this.isSync});

  String? userId;
  String? dateTime;
  String? monthYear;
  String? energyLevel;
  String? stressLevel;
  String? measureTime;
  String? isSync;
  int? timeStamp;

  factory BodyHealthModel.fromJson(Map<String, dynamic> json) =>
      BodyHealthModel(
        userId: json["userId"] ?? "0",
        dateTime: json["dateTime"] ?? "0",
        monthYear: json["monthYear"] ?? "0",
        measureTime: json["measureTime"] ?? "0",
        energyLevel: json["energyLevel"] ?? "0",
        stressLevel: json["stressLevel"] ?? "0",
        isSync: json["isSync"] ?? "false",
        timeStamp: json["timeStamp"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "dateTime": dateTime,
        "monthYear": monthYear,
        "measureTime": measureTime,
        "energyLevel": energyLevel,
        "stressLevel": stressLevel,
        "isSync": isSync,
        "timeStamp": timeStamp,
      };
}
