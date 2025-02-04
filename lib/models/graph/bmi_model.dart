import 'dart:convert';

BMIModel measureModelFromJson(String str) =>
    BMIModel.fromJson(json.decode(str));

String measureModelToJson(BMIModel data) => json.encode(data.toJson());

class BMIModel {
  BMIModel(
      {this.userId,
      this.username,
      this.dateTime,
      this.monthYear,
      this.measureTime,
      this.timeStamp,
      this.isSync,
      this.dob,
      this.height,
      this.weight});

  String? userId;
  String? username;
  String? dateTime;
  String? monthYear;
  String? measureTime;
  String? isSync;
  int? timeStamp;
  String? dob;
  String? height;
  String? weight;

  factory BMIModel.fromJson(Map<String, dynamic> json) => BMIModel(
        userId: json["userId"] ?? "0",
        username: json["username"] ?? "0",
        dateTime: json["dateTime"] ?? "0",
        monthYear: json["monthYear"] ?? "0",
        measureTime: json["measureTime"] ?? "0",
        isSync: json["isSync"] ?? "false",
        timeStamp: json["timeStamp"] ?? 0,
        dob: json["dob"] ?? "0",
        height: json["height"] ?? "0",
        weight: json["weight"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "username": username,
        "dateTime": dateTime,
        "monthYear": monthYear,
        "measureTime": measureTime,
        "isSync": isSync,
        "timeStamp": timeStamp,
        "dob": dob,
        "height": height,
        "weight": weight,
      };
}
