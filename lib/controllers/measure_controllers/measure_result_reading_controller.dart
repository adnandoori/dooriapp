import 'dart:convert';
import 'dart:math';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/graph_controllers/heart_graph_controller.dart';
import 'package:doori_mobileapp/helper/database_helper.dart';
import 'package:doori_mobileapp/models/graph/body_health_model.dart';
import 'package:doori_mobileapp/models/measure_model/health_tips_model.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:workmanager/workmanager.dart';

class MeasureResultReadingController extends BaseController {
  BuildContext context;

  MeasureResultReadingController(this.context);

  DatabaseReference dbHealthTips =
      FirebaseDatabase.instance.ref().child(AppConstants.tableHealthTips);
  var healthTips = 'Your health is in good shape';
  var isNonVegetarian = 'No';
  List<HealthTips> listNonVegTips = [];
  List<HealthTips> listVegTips = [];

  DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child(AppConstants.tableMeasure);

  var arguments = Get.arguments;

  var activity = 'working'.tr;
  var heartRate = '0',
      oxygen = '0',
      bloodPressure = '0',
      temperature = '0',
      hrVariability = '0';

  double progressValue = 0.0;
  int totalCoins = 1;
  var totalBodyHealth = '0';

  late MeasureResult measureModel;
  late BodyHealthModel bodyHealthModel;

  final dbHelper = DatabaseHelper.instance;

  int hrPoints = 0, oxPoints = 0, sPoints = 0, dPoints = 0;

  var pulsePressure = '0';
  var arterialPressure = '0';

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('<--------init_measure_result_reading-------->');

      if (arguments != null) {
        measureModel = arguments[0];

        activity = measureModel.activity.toString();
        heartRate = measureModel.heartRate.toString();
        oxygen = measureModel.oxygen.toString();
        temperature = measureModel.temperature.toString();
        bloodPressure = measureModel.bloodPressure.toString();
        hrVariability = measureModel.hrVariability.toString();

        //getRandomTips(double.parse(heartRate));

        getPulsePressure(bp: bloodPressure);

        getBodyHealthValue(double.parse(heartRate.toString()),
            double.parse(oxygen.toString()), measureModel.reading.toString());

        update();
      } else {
        printf('null_arguments');
      }
    });
  }

  void getBodyHealthValue(double hr, double oxygenLevel, String input) {
    String S = input.substring(input.indexOf(r'$') + r'$'.length,
        input.indexOf('D', input.indexOf(r'$') + r'$'.length));

    String D = "";
    if (input.contains("V")) {
      D = input.substring(input.indexOf('D') + 'D'.length,
          input.indexOf('V', input.indexOf('D') + 'D'.length));
    } else {
      D = input.substring(input.indexOf('D') + 'D'.length,
          input.indexOf('T', input.indexOf('D') + 'D'.length));
    }

    /* String D = input.substring(input.indexOf('D') + 'D'.length,
        input.indexOf('V', input.indexOf('D') + 'D'.length));*/

    double bloodPressure = double.parse(S);
    double d = double.parse(D);

    int factor = 0;

    if (hr >= 49 + factor && hr <= 55 + factor) {
      hrPoints = 100;
    }

    if (hr >= 56 + factor && hr <= 61 + factor) {
      hrPoints = 100;
    }

    if (hr >= 62 + factor && hr <= 65 + factor) {
      hrPoints = 80;
    }

    if (hr >= 66 + factor && hr <= 69 + factor) {
      hrPoints = 80;
    }

    if (hr >= 70 + factor && hr <= 73 + factor) {
      hrPoints = 60;
    }

    if (hr >= 74 + factor && hr <= 81 + factor) {
      hrPoints = 40;
    }

    if (hr >= 82 + factor) {
      hrPoints = 20;
    }

    if (oxygenLevel > 97) {
      oxPoints = 100;
    }

    if (oxygenLevel >= 96 && oxygenLevel <= 97) {
      oxPoints = 80;
    }

    if (oxygenLevel >= 95 && oxygenLevel < 96) {
      oxPoints = 60;
    }

    if (oxygenLevel >= 94 && oxygenLevel < 95) {
      oxPoints = 40;
    }

    if (oxygenLevel < 94) {
      oxPoints = 20;
    }
//
    if (bloodPressure > 118 && bloodPressure < 122)
    {
      sPoints = 100;
    }

    if (bloodPressure > 116 && bloodPressure <= 118) {
      sPoints = 80;
    }

    if (bloodPressure >= 122 && bloodPressure < 124) {
      sPoints = 80;
    }

    if (bloodPressure > 114 && bloodPressure <= 116) {
      sPoints = 60;
    }

    if (bloodPressure >= 124 && bloodPressure < 126) {
      sPoints = 60;
    }

    if (bloodPressure > 112 && bloodPressure <= 114) {
      sPoints = 40;
    }

    if (bloodPressure >= 126 && bloodPressure < 128) {
      sPoints = 40;
    }

    if (bloodPressure >= 128) {
      sPoints = 20;
    }

    if (bloodPressure <= 112) {
      sPoints = 20;
    }

    //

    if (d > 78 && d < 82) {
      dPoints = 100;
    }

    if (d > 76 && d <= 78) {
      dPoints = 80;
    }

    if (d >= 82 && d < 84) {
      dPoints = 80;
    }

    if (d > 74 && d <= 76) {
      dPoints = 60;
    }
    if (d >= 84 && d < 86) {
      dPoints = 60;
    }

    if (d > 72 && d <= 74) {
      dPoints = 40;
    }

    if (d >= 86 && d < 88) {
      dPoints = 40;
    }

    if (d <= 72) {
      dPoints = 20;
    }
    if (d >= 88) {
      dPoints = 20;
    }

    int bh = hrPoints + oxPoints + sPoints + dPoints;

    printf('points-$hrPoints $oxPoints $sPoints $dPoints');

    final total = bh / 4;

    int v = total.toInt();
    progressValue = total / 100;
    totalBodyHealth = '$v/100';

    getRandomTips(total);

    update();
  }

  Future<void> buttonSave() async {
    printf('<----buttonSave--save_and_back_home------>');
    var now = DateTime.now();
    var formatter = DateFormat('dd-MMM-yyyy');
    String formattedDate = formatter.format(now);
    //printf('insertDate-$formattedDate');

    var formatterMonth = DateFormat('MMM, yyyy');
    measureModel.dateTime = formattedDate;
    measureModel.monthYear = formatterMonth.format(now);
    measureModel.measureTime = '${now.hour}:${now.minute}:${now.second}';
    measureModel.bodyHealth = totalBodyHealth;
    now = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
    measureModel.timeStamp = now.millisecondsSinceEpoch;
    measureModel.healthTips = healthTips;
    measureModel.pulsePressure = pulsePressure;
    measureModel.arterialPressure = arterialPressure;

    printf('<--measureJson---request--->${measureModel.toJson()}');

    Utility.isConnected().then((value) async {
      if (value) {
        try {
          measureModel.isSync = AppConstants.isTrue;
          context.loaderOverlay.show();
          dbRef.ref
              .child(measureModel.userId.toString())
              .push()
              .set(measureModel.toJson())
              .whenComplete(() async {
            printf('---record inserted..online');
            context.loaderOverlay.hide();

            getBodyHealthValueForSelectedDate(
                    userId: measureModel.userId.toString(),
                    dateTime: measureModel.dateTime.toString(),
                    monthYear: measureModel.monthYear.toString(),
                    isSync: measureModel.isSync.toString(),
                    timeStamp: measureModel.timeStamp,
                    measureTime: measureModel.measureTime.toString())
                .whenComplete(() async {
              printf('<---body--health---completed---->');

              try {
                final id = await dbHelper.insert(measureModel);
                printf('<----insertDate----->$formattedDate $id');
                Get.back(result: 'save');
              } catch (e) {
                printf('exe-$e');
                throw Exception("DB_Insert_Failed");
              }
            });
          }).onError((error, stackTrace) async => {
                    registerSyncWorkerThread(),
                    if (error == "DB_Insert_Failed")
                      {
                        printf(
                            'saved locally. Failed to sent record on Firebase DB'),
                        measureModel.isSync = AppConstants.isTrue,
                        await dbHelper.insert(measureModel),
                        printf('insertDate-$formattedDate'),
                        Get.back(result: 'saved')
                      }
                    else
                      {
                        measureModel.isSync = AppConstants.isFalse,
                        await dbHelper.insert(measureModel),
                        printf('<----insertDate----312-->$formattedDate'),
                        Get.back(result: 'saved'),
                      }
                  });
        } catch (e) {
          printf('exe---result--reading--350$e');
        }
      } else {
        registerSyncWorkerThread();
        measureModel.isSync = AppConstants.isFalse;
        final id = await dbHelper.insert(measureModel);
        printf('<------------insertDateOffline--->$formattedDate $id');

        Utility.setIsOfflineRecord(true);
        try {
          Utility.setLastMeasureRecord(jsonEncode(measureModel));
        } catch (e) {
          printf('exe-stored-last-record----406-->${e.toString()}');
        }

        Get.back(result: 'save');
      }
    });

  }

  Future<void> getBodyHealthValueForSelectedDate(
      {userId, dateTime, monthYear, isSync, timeStamp, measureTime}) async {
    printf(
        '--body--health---data--$dateTime--->$monthYear-->$isSync-->$timeStamp');

    DateTime today = DateTime.now().toUtc();
    var todayDate = DateTime.now();
    today = DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
    var date = DateTime(todayDate.year, todayDate.month, todayDate.day);

    List<GraphModel> graphDayList = [];

    List<MeasureResult> measureUserList = [];

    Get.context!.loaderOverlay.show();
    DatabaseReference dbMeasure =
        FirebaseDatabase.instance.ref().child(AppConstants.tableMeasure);
    DataSnapshot snapshot = await dbMeasure.child(userId).get();

    var resultFormatter = DateFormat('dd-MMM-yyyy');

    String dt = resultFormatter.format(date).toString();

    printf(
        'call----get--body--health---data--->todayDate--->$dt--->userId-->$userId');
    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        // printf('---today--body---health---${activityModel.dateTime}');
        if (activityModel.dateTime.toString() == dt) {
          measureUserList.add(activityModel);
        }
        update();
      });

      int totalEnergy = 0;
      int totalHeart = 0;
      double stressLevelProgress = 0;
      double stressLevel = 0;

      // printf('---body---health---measureList-${measureUserList.length}');

      for (int i = 0; i < measureUserList.length; i++) {
        double el = double.parse(measureUserList[i].hrVariability.toString());

        String input = measureUserList[i].bloodPressure.toString();
        String heartRate = measureUserList[i].heartRate.toString();
        List values = input.split("/");

        double sys = double.parse(values[0].toString());
        double hr = double.parse(heartRate.toString());

        late DateTime dateTime;
        DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
        DateFormat dateFormatTime = DateFormat("h:mm");

        try {
          dateTime = dateFormat.parse(
              '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
        } catch (exe) {
          printf('exe---date--272->$exe');
        }

        var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        printf('------------------${dateFormatTime.format(currentDate)}');

        graphDayList.add(GraphModel(
            dateFormatTime.format(currentDate).toString(), el.roundToDouble()));

        totalHeart = totalHeart + el.toInt();
        totalEnergy = totalEnergy + el.toInt();

        try {
          stressLevel =
              stressLevel + getStressLevel(hr, sys, stressLevelProgress);
        } catch (e) {
          printf('exe-stress-294-${e.toString()}');
        }

        //printf('body--health--hrv--->$el---$totalHeart---energy--->$totalEnergy---e-value-->$stressLevel');

        update();
      }

      if (measureUserList.isNotEmpty) {
        int avgEnergy = 0;
        if (measureUserList.isNotEmpty) {
          double avg = totalHeart / measureUserList.length;
          avgEnergy = avg.roundToDouble().toInt();
        } else {
          avgEnergy = 0;
        }

        double el = avgEnergy * 0.5;

        //printf('total---day---$el --$avgEnergy');

        double totalStress = 0;
        totalStress = stressLevel * 100 / measureUserList.length;

        totalStress = totalStress.toPrecision(1);

        printf(
            '---energy--level--$el---stress--level--$totalStress----time-->${graphDayList.last.title.toString()}');

        bodyHealthModel = BodyHealthModel(
            userId: userId.toString(),
            timeStamp: timeStamp,
            monthYear: monthYear,
            dateTime: dateTime,
            isSync: isSync,
            measureTime: measureTime,
            energyLevel: el.toString(),
            stressLevel: totalStress.toString());

        await FirebaseDatabase.instance
            .ref()
            .child(AppConstants.tableBodyHealth)
            .ref
            .child(userId)
            .push()
            .set(bodyHealthModel.toJson())
            .whenComplete(() {
          printf('body-health-added');
        });

        //  ---energy--level--113.5---stress--level--40.0----time-->3:52
      } else {
        printf('--no--record----found---for---body---health');
      }

      Get.context!.loaderOverlay.hide();

      update();
    } else {
      printf('no_children_exists_for_today');
    }
  }

  void callAddBodyHealthData({userId, bodyHealthModel}) {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child(AppConstants.tableBodyHealth);

    dbRef.ref
        .child(userId)
        .push()
        .set(bodyHealthModel.toJson())
        .whenComplete(() {
      printf('body-health-added');
    });
  }

  double getStressLevel(hr, sys, stressLevelProgress) {
    if (sys > 0) {
      if (sys <= 123 && sys >= 117) {
        if (hr <= 62) {
          stressLevelProgress = 0.0;
        }
        if (hr <= 65 && hr > 62) {
          stressLevelProgress = 0.10;
        }
        if (hr <= 68 && hr > 65) {
          stressLevelProgress = 0.20;
        }
        if (hr <= 72 && hr > 68) {
          stressLevelProgress = 0.30;
        }
        if (hr <= 75 && hr > 72) {
          stressLevelProgress = 0.40;
        }
        if (hr > 75) {
          stressLevelProgress = 0.40;
        }
      }
      if (sys > 123) {
        if (hr <= 72) {
          stressLevelProgress = 0.40;
        }
        if (hr <= 75 && hr > 72) {
          stressLevelProgress = 0.80;
        }
        if (hr > 75) {
          stressLevelProgress = 0.100;
        }
      }
      if (sys < 117) {
        if (hr <= 62) {
          stressLevelProgress = 0.40;
        }
        if (hr <= 65 && hr > 62) {
          stressLevelProgress = 0.70;
        }
        if (hr > 65) {
          stressLevelProgress = 0.90;
        }
      }
    }
    return stressLevelProgress;
  }

  void buttonRetry() {
    printf('save_and_back_home');
    Get.back(result: 'retry');
  }

  @override
  void onClose() {
    printf('close_measure_result_reading');
    super.onClose();
  }

  registerSyncWorkerThread() {
    Workmanager().cancelAll().then((value) => {
          Workmanager().registerOneOffTask(
              "online_sync", "Offline mode initiated Sync With Firebase Task",
              constraints: Constraints(
                  networkType: NetworkType.connected,
                  requiresBatteryNotLow: true,
                  requiresCharging: false,
                  requiresDeviceIdle: false,
                  requiresStorageNotLow: false)),
          printf(
              'SYNC_REGISTERED - Doori on Internet Available Sync worker thread registered')
        });
  }

  Future<void> getRandomTips(double heartValue) async {
    printf('heartValue-getTips$heartValue');
    final random = Random();

    Utility.getUserDetails().then((value) {
      if (value != null) {
        try {
          isNonVegetarian = value.nonVegetarian.toString();
          printf('userIsNonVegetarian- $isNonVegetarian');
        } catch (exe) {
          printf('exe-user_detail$exe');
        }
        update();
      }
    });

    if (isNonVegetarian == 'No') {
      /*listVegTips.clear();
      DataSnapshot snapshot =
          await dbHealthTips.child(AppConstants.tableVegTips).get();
      if (snapshot.exists) {
        snapshot.children.forEach((element) {
          final data = Map<String, dynamic>.from(element.value as Map);
          HealthTips healthModel = HealthTips.fromJson(data);
          listVegTips.add(healthModel);
          update();
        });
      }*/

      if (heartValue < 90) {
        String health = AppConstants.vegTips[random.nextInt(AppConstants.vegTips
            .length)]; //listVegTips[random.nextInt(listVegTips.length)];
        healthTips = health.toString();
        printf('tipsVeg-$healthTips');
        update();
      }
    } else {
      /*listNonVegTips.clear();
      DataSnapshot snapshot =
          await dbHealthTips.child(AppConstants.tableNonVegTips).get();
      if (snapshot.exists) {
        snapshot.children.forEach((element) {
          final data = Map<String, dynamic>.from(element.value as Map);
          HealthTips healthModel = HealthTips.fromJson(data);
          listNonVegTips.add(healthModel);
          update();
        });
      }*/
      if (heartValue < 90) {
        String health = AppConstants
            .nonVegTips[random.nextInt(AppConstants.nonVegTips.length)];
        //HealthTips health = listNonVegTips[random.nextInt(listNonVegTips.length)];
        healthTips = health.toString();
        printf('tipsNonVeg-$healthTips');
        update();
      }
    }
  }

  void getPulsePressure({required String bp}) {
    printf('blood pressure---$bp');

    String sys = bp.substring(0, bp.indexOf('/'));
    String dys = bp.substring(bp.indexOf('/') + '/'.length, bp.length);

    printf('-----------systolic---$sys-----diastolic-----$dys');

    double pulse =
        double.parse(sys).roundToDouble() - double.parse(dys).roundToDouble();

    pulsePressure = pulse.toString();

    try {
      getArterialPressure(dys: double.parse(dys).roundToDouble(), pulse: pulse);
    } catch (e) {
      printf('exe-pulse-$e');
    }

    printf('bp-sys-dys-pulse--$sys--$dys---$pulse');
    update();
  }

  void getArterialPressure({required double dys, required double pulse}) {
    printf('arterial pressure---$dys---$pulse');

    double map = dys + (1 / 3 * pulse).toInt();

    printf('----map--value--$map');

    arterialPressure = map.toString();

    update();
  }
}
