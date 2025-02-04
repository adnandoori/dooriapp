import 'dart:convert';
import 'dart:math';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/graph_controllers/heart_graph_controller.dart';

import 'package:collection/collection.dart';
import 'package:doori_mobileapp/helper/database_helper.dart';
import 'package:doori_mobileapp/models/graph/body_health_model.dart';
import 'package:doori_mobileapp/models/graph/week_of_month_model.dart';
import 'package:doori_mobileapp/models/measure_model/health_tips_model.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EnergyStressLevelController extends BaseController
    with GetSingleTickerProviderStateMixin {
  BuildContext context;

  EnergyStressLevelController(this.context);

  var yesterdayDate = DateTime.now().subtract(const Duration(days: 1));
  var todayDate = DateTime.now();
  var formatter = DateFormat('dd MMM, yyyy');
  var formatterDate = DateFormat('dd MMM, yyyy');
  var displayDateText = '';

  //int nextDay = 0;

  var currentWeek = DateTime.now();
  var formatterWeek = DateFormat('dd MMM, yyyy');
  var displayWeekText = '';

  List<MeasureResult> measureUserList = [];

  List<MeasureResult> weeklyMeasureList = [];
  var resultFormatter = DateFormat('dd-MMM-yyyy');

  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");

  var userId = '';

  DateTime today = DateTime.now().toUtc();

  DatabaseReference dbMeasure =
      FirebaseDatabase.instance.ref().child(AppConstants.tableMeasure);

  DatabaseReference dbBodyHealth =
      FirebaseDatabase.instance.ref().child(AppConstants.tableBodyHealth);

  double averageBPM = 0;
  double highestBPM = 0;
  double lowestBPM = 0;

  double averageForDiastolic = 0;
  double highestForDiastolic = 0;
  double lowestForDiastolic = 0;

  double averageForWeekSystolic = 0;
  double highestForWeekSystolic = 0;
  double lowestForWeekSystolic = 0;

  double averageForWeekDiastolic = 0;
  double highestForWeekDiastolic = 0;
  double lowestForWeekDiastolic = 0;

  List<GraphModelForBloodPressure> graphDayForBloodPressureList = [];

  List<GraphModel> graphDayList = [];
  List<GraphModel> graphDayListForDiastolic = [];

  List<GraphModel> graphWeekListForSystolic = [];
  List<GraphModel> graphWeekListForDiastolic = [];

  //
  List<DateTime> weekList = [];

  var weekDate = '';
  List<MeasureResult> weekMeasureList = [];
  List<MeasureResult> finalMeasureWeekList = [];

  List<GraphModel> weekNumbers = [];
  List<GraphModel> weekNumberReversed = [];

  List<String> weekDateList = [];
  List<WeekModel> listWeekData = [];

  //
  List<WeekModel> listWeekDataForDiastolic = [];
  bool isBloodPressure = false;

  double averageBPMForWeek = 0;
  double highestBPMForWeek = 0;
  double lowestBPMForWeek = 0;

  double averageBPMForMonth = 0;
  double highestBPMForMonth = 0;
  double lowestBPMForMonth = 0;

  double averageForMonthSystolic = 0;
  double highestForMonthSystolic = 0;
  double lowestForMonthSystolic = 0;

  double averageForMonthDiastolic = 0;
  double highestForMonthDiastolic = 0;
  double lowestForMonthDiastolic = 0;

  //Month graph vars
  var currentMonth = DateTime.now();
  var formatterMonth = DateFormat(' MMM, yyyy');
  var displayMonthText = '';
  List<MeasureResult> monthMeasureList = [];
  List<WeekOfMonthModel> weekOfMonth = [];

  List<WeekOfMonthModel> weekOfMonthForDiastolic = [];

  List<GraphModel> monthGraphPlot = [];
  List<GraphModel> monthGraphPlotForDiastolic = [];

  bool red = false, // poor
      orange = false, // Below average
      yellow = false, // average
      lightGreen = false, // healthy
      green = false; // excellent, athlete

  bool redForWeek = false, // poor
      orangeForWeek = false, // Below average
      yellowForWeek = false, // average
      lightGreenForWeek = false, // healthy
      greenForWeek = false; // excellent, athlete

  final dbHelper = DatabaseHelper.instance;

  var title = 'heart_rate'.tr;
  var arguments = Get.arguments;
  var heartRateYesterday = 'heart_rate_not_measured_yesterday'.tr;
  var oxygenLevelYesterday = 'oxygen_level_not_measured_yesterday'.tr;
  var hrVariableYesterday = 'hr_variability_not_measured_yesterday'.tr;
  var bloodPressureYesterday = 'blood_pressure_not_measured_yesterday'.tr;

  var yesterdayMeasure = '';

  var labelMeasureLevel = '';
  var veryHealthy = '';
  var healthy = '';
  var average = '';
  var unHealthy = '';
  var veryUnhealthy = '';

  int selectedTab = 0;

  late TabController tabController = TabController(length: 1, vsync: this);

  List<CausesTips> energyLevelTips = [];
  String energyTip = '';

  List<CausesTips> stressLevelTips = [];
  String stressTip = '';

  bool isImproveHealth = true;
  bool isImproveHealthForWeek = false;
  bool isImproveHealthForMonth = true;

  late BodyHealthModel bodyHealthModel;

  List<MeasureResult> totalMeasureRecordList = [];
  List<BodyHealthModel> totalBodyHealthRecordList = [];

  String mood = 'excited'.tr;
  String moodIcon = ImagePath.icEmojiHappy;

  List<GraphModel> graphDayListForMood = [];

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_heart_graph');

      tabController.addListener(() {
        selectedTab = tabController.index;
        printf('tabIndexGraph-${tabController.index}');
        update();
      });

      displayDateText = formatter.format(todayDate);
      displayWeekText = formatterWeek.format(currentWeek);
      displayMonthText = formatterMonth.format(currentMonth);
      today = DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
      var todayDateTemp =
          DateTime(todayDate.year, todayDate.month, todayDate.day);

      if (arguments != null) {
        title = arguments[0];
        userId = arguments[1];

        printf("--from---->$title");

        try {
          totalBodyHealthRecordList = arguments[2];
          totalMeasureRecordList = arguments[3];

          printf('--userId->$userId-->${totalBodyHealthRecordList.length}');

          if (title == 'mood') {
            printf('--get--mood--records--here');
            getMoodForFirstTime(
                resultFormatter.format(todayDateTemp), totalMeasureRecordList);
          } else {
            getBodyHealthForOneTime(resultFormatter.format(todayDateTemp),
                totalBodyHealthRecordList);
          }
        } catch (e) {
          printf('exe-207-->$e');
        }

        // Utility.isConnected().then((value) {
        //   if (value) {
        //     User user = AuthenticationHelper().user;
        //     userId = user.uid;
        //     printf('userUId-${user.uid}');
        //
        //     //getBodyHealthForSelectedDate(resultFormatter.format(todayDateTemp));
        //
        //     getBodyHealthForOneTime(resultFormatter.format(todayDateTemp));
        //
        //     //getCurrentWeek(today);
        //     //getMonthData(currentMonth);
        //
        //     // getEnergyTips().whenComplete(() {
        //     //   getStressLevelTips();
        //     // });
        //
        //     printf('internet_online');
        //   } else {
        //     printf('internet_offline');
        //   }
        // });
      } else {
        printf('null_arguments');
      }
    });
  }

  void getBodyState(double hr, double sys) {
    //double sys = 0.0;
    //double hr = hrValue;

    printf('---hr--->$hr---bp-->$sys');

    // if (bp.length > 4)
    // {
    //   String v = bp.substring(0, 3);
    //   try {
    //     sys = double.parse(v);
    //   } catch (e) {
    //     printf('exe-$e');
    //   }
    //
    //   //printf('sys-$sys');
    // }

    if (sys > 0) {
      if (sys <= 123 && sys >= 117) {
        if (hr <= 62) {
          mood = 'calm'.tr;
          moodIcon = 'assets/images/calmicon.png';
          // stressLevelProgress = 0;
        }
        if (hr <= 65 && hr > 62) {
          mood = 'peaceful'.tr;
          moodIcon = 'assets/images/peacefulicon.png';
          // stressLevelProgress = 0.10;
        }
        if (hr <= 68 && hr > 65) {
          mood = "relaxed".tr;
          moodIcon = 'assets/images/relaxedicon.png';
          // stressLevelProgress = 0.20;
        }
        if (hr <= 72 && hr > 68) {
          mood = "pleased".tr;
          moodIcon = 'assets/images/pleasedicon.png';
          // stressLevelProgress = 0.30;
        }
        if (hr <= 75 && hr > 72) {
          mood = "happy".tr;
          moodIcon = 'assets/images/happyicon.png';
          //  stressLevelProgress = 0.40;
        }
        if (hr > 75) {
          mood = "excited".tr;
          moodIcon = 'assets/images/excitedicon.png';
          //  stressLevelProgress = 0.40;
        }
      }
      if (sys > 123) {
        if (hr <= 72) {
          mood = "nervous".tr;
          moodIcon = 'assets/images/nervousicon.png';
          // stressLevelProgress = 0.40;
        }
        if (hr <= 75 && hr > 72) {
          mood = "angry".tr;
          moodIcon = 'assets/images/angryicon.png';
          //  stressLevelProgress = 0.80;
        }
        if (hr > 75) {
          mood = "annoyed".tr;
          moodIcon = 'assets/images/annoyedicon.png';
          //   stressLevelProgress = 0.100;
        }
      }
      if (sys < 117) {
        if (hr <= 62) {
          mood = "sleepy".tr;
          moodIcon = 'assets/images/sleepyicon.png';
          //  stressLevelProgress = 0.40;
        }
        if (hr <= 65 && hr > 62) {
          mood = "bored".tr;
          moodIcon = 'assets/images/boredicon.png';
          //   stressLevelProgress = 0.70;
        }
        if (hr > 65) {
          mood = "sad".tr;
          moodIcon = 'assets/images/sadicon.png';
          //  stressLevelProgress = 0.90;
        }
      }
    }

    printf('----start----mood-----emojis----->$sys--->$mood');
  }

  Future<void> getMoodForFirstTime(
      date, List<MeasureResult> totalAllRecords) async {
    printf('todayDate-$date');
    graphDayList.clear();
    graphDayForBloodPressureList.clear();
    graphDayListForDiastolic.clear();
    measureUserList.clear();
    isLoading.value = true;
    if (totalAllRecords.isNotEmpty) {
      totalAllRecords.forEach((activityModel) {
        if (activityModel.dateTime.toString() == date.toString()) {
          measureUserList.add(activityModel);
        }
        update();
      });

      printf('measureList-${measureUserList.length}');

      for (int i = 0; i < measureUserList.length; i++) {
        String input = measureUserList[i].bloodPressure.toString();
        List values = input.split("/");

        double s = double.parse(values[0].toString());
        double d = double.parse(values[1].toString());

        double hr = double.parse(measureUserList[i].heartRate.toString());

        late DateTime dateTime;
        DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
        DateFormat dateFormatTime = DateFormat("h:mm");

        try {
          dateTime = dateFormat.parse(
              '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
        } catch (exe) {
          printf('exe-$exe');
        }

        var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        printf('-----------$s $d-------${dateFormatTime.format(currentDate)}');

        graphDayList.add(GraphModel(
            dateFormatTime.format(currentDate).toString(),
            s.roundToDouble()));
        //
        // graphDayListForDiastolic.add(GraphModel(
        //     dateFormatTime.format(currentDate).toString(),
        //     d.roundToDouble()));
        //
        // totalHeart = totalHeart + s.toInt();
        //
        // totalDiastolic = totalDiastolic + d.toInt();
        //
        // graphDayForBloodPressureList.add(GraphModelForBloodPressure(
        //     dateFormatTime.format(currentDate).toString(),
        //     s.roundToDouble(),
        //     d.roundToDouble()));

        getBodyState(hr,s);

      }

      printf('------checkDate-->$date--> ${resultFormatter.format(today)}');

      isLoading.value = false;

      update();
    } else {
      printf('no_children_exists_for_today');
    }
  }

  ///-----------------------------------------
  /// locally data fetch ///

  Future<void> getBodyHealthForOneTime(
      date, List<BodyHealthModel> totalBodyHealthRecordList) async {
    printf('todayDate-$date');
    graphDayList.clear();
    graphDayForBloodPressureList.clear();
    graphDayListForDiastolic.clear();
    measureUserList.clear();

    Get.context!.loaderOverlay.show();
    //DataSnapshot snapshot = await dbBodyHealth.child(userId).get();

    printf('-total--body-health-->${totalBodyHealthRecordList.length}');

    if (totalBodyHealthRecordList.isNotEmpty) {
      totalBodyHealthRecordList.forEach((bodyHealthModel) {
        //printf('--stress--energy-->${bodyHealthModel.dateTime}-->${bodyHealthModel.measureTime}-->${bodyHealthModel.stressLevel}-->${bodyHealthModel.energyLevel}');
        // final data = Map<String, dynamic>.from(element.value as Map);
        // BodyHealthModel bodyHealthModel = BodyHealthModel.fromJson(data);
        // printf('--date--->${bodyHealthModel.dateTime}---->${date.toString()}');

        if (bodyHealthModel.dateTime == date.toString()) {
          if (bodyHealthModel.measureTime != '0') {
            late DateTime dateTime;

            DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
            DateFormat dateFormatTime = DateFormat("h:mm");

            try {
              dateTime = dateFormat.parse(
                  '${bodyHealthModel.dateTime} ${bodyHealthModel.measureTime}');
            } catch (exe) {
              printf('exe-$exe');
            }

            var currentDate = DateTime(dateTime.year, dateTime.month,
                dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

            graphDayForBloodPressureList.add(GraphModelForBloodPressure(
                dateFormatTime.format(currentDate).toString(),
                double.parse(bodyHealthModel.energyLevel.toString()),
                double.parse(bodyHealthModel.stressLevel.toString())));
          } else {
            printf('else__measure__time--->${bodyHealthModel.measureTime}');
          }
        }
      });

      if (graphDayForBloodPressureList.isNotEmpty) {
        printf(
            '---last--value---energy-->${graphDayForBloodPressureList.last.v1}--->${graphDayForBloodPressureList.last.v2}');
        if (graphDayForBloodPressureList.last.v1 < 70) {
          getEnergyTips();
        } else {
          energyTip = 'energy_level_is_up_to_the_mark'.tr;
          printf('---no need to show tips for energy');
        }

        if (graphDayForBloodPressureList.last.v2 > 30) {
          getStressLevelTips();
        } else {
          stressTip = 'your_stress_levels_are_within_good_limits'.tr;
          printf('---no need to show tips for stress');
        }
      }

      Get.context!.loaderOverlay.hide();

      update();
    } else {
      printf('no_records_found_for_locally');
      Get.context!.loaderOverlay.hide();
    }
  }

  ///----------------------------------------

  Future<void> getBodyHealthForSelectedDate(date) async {
    printf('todayDate-$date');
    graphDayList.clear();
    graphDayForBloodPressureList.clear();
    graphDayListForDiastolic.clear();

    Get.context!.loaderOverlay.show();
    DataSnapshot snapshot = await dbBodyHealth.child(userId).get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        BodyHealthModel bodyHealthModel = BodyHealthModel.fromJson(data);
        printf('--date--->${bodyHealthModel.dateTime}---->${date.toString()}');

        if (bodyHealthModel.dateTime == date.toString()) {
          if (bodyHealthModel.measureTime != '0') {
            late DateTime dateTime;

            DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
            DateFormat dateFormatTime = DateFormat("h:mm");

            try {
              dateTime = dateFormat.parse(
                  '${bodyHealthModel.dateTime} ${bodyHealthModel.measureTime}');
            } catch (exe) {
              printf('exe-$exe');
            }

            var currentDate = DateTime(dateTime.year, dateTime.month,
                dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

            graphDayForBloodPressureList.add(GraphModelForBloodPressure(
                //bodyHealthModel.measureTime.toString(),
                dateFormatTime.format(currentDate).toString(),
                double.parse(bodyHealthModel.energyLevel.toString()),
                double.parse(bodyHealthModel.stressLevel.toString())));
          } else {
            printf('else__measure__time--->${bodyHealthModel.measureTime}');
          }
        }
      });

      if (graphDayForBloodPressureList.isNotEmpty) {
        printf(
            '---last--value---energy-->${graphDayForBloodPressureList.last.v1}--->${graphDayForBloodPressureList.last.v2}');
        if (graphDayForBloodPressureList.last.v1 < 70) {
          getEnergyTips();
        } else {
          energyTip = 'energy_level_is_up_to_the_mark'.tr;
          printf('---no need to show tips for energy');
        }

        if (graphDayForBloodPressureList.last.v2 > 30) {
          getStressLevelTips();
        } else {
          stressTip = 'your_stress_levels_are_within_good_limits'.tr;
          printf('---no need to show tips for stress');
        }
      }

      int totalEnergy = 0;
      int totalHeart = 0;
      double stressLevelProgress = 0;
      double stressLevel = 0;

      /*printf('measureList-${measureUserList.length}');

      for (int i = 0; i < measureUserList.length; i++) {
        if (title == 'body_health'.tr) {
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
                '${measureUserList[i].dateTime} ${measureUserList[i]
                    .measureTime}');
          } catch (exe) {
            printf('exe---date--272->$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              el.roundToDouble()));

          totalHeart = totalHeart + el.toInt();
          totalEnergy = totalEnergy + el.toInt();

          try {
            stressLevel =
                stressLevel + getStressLevel(hr, sys, stressLevelProgress);
          } catch (e) {
            printf('exe-stress-294-${e.toString()}');
          }
          printf(
              'body--health--hrv--->$el---$totalHeart---energy--->$totalEnergy---e-value-->$stressLevel');
        }

        update();
      }*/

      /*if (measureUserList.isNotEmpty)
      {
        int avgEnergy = 0;
        if (measureUserList.isNotEmpty) {
          double avg = totalHeart / measureUserList.length;
          avgEnergy = avg.roundToDouble().toInt();
        } else {
          avgEnergy = 0;
        }

        double el = avgEnergy * 0.5;

        printf('total---day---$el --$avgEnergy');

        double totalStress = 0;
        totalStress = stressLevel * 100 / measureUserList.length;

        printf('---energy--level--$el---stress--level--$totalStress');

        if (el < 70) {
          getEnergyTips();
        } else {
          energyTip = 'energy_level_is_up_to_the_mark'.tr;
          printf('---no need to show tips for energy');
        }

        if (totalStress > 30)
        {
          getStressLevelTips();
        } else {
          stressTip = 'your_stress_levels_are_within_good_limits'.tr;
          printf('---no need to show tips for stress');
        }

        graphDayForBloodPressureList.add(GraphModelForBloodPressure(
            graphDayList.last.title.toString(),
            el.toPrecision(1),
            totalStress.toPrecision(1)));
      } else {
        printf('--no--record----found');
      }*/

      Get.context!.loaderOverlay.hide();

      update();
    } else {
      printf('no_children_exists_for_today');
    }
  }

  Future<void> getWeekData(
      {required int startDate, required int endDate}) async {
    printf('-----------call_week-$startDate $endDate $userId------------');

    weekMeasureList.clear();
    Get.context!.loaderOverlay.show();

    final ref = dbMeasure
        .child(userId)
        .orderByChild('timeStamp')
        .startAt(startDate)
        .endAt(endDate);

    ref.once().then((value) {
      if (value.snapshot.exists) {
        value.snapshot.children.forEach((element) {
          final data = Map<String, dynamic>.from(element.value as Map);
          MeasureResult measureModel = MeasureResult.fromJson(data);
          weekMeasureList.add(measureModel);
          update();
        });
      }

      if (weekMeasureList.isNotEmpty) {
        double stressLevelProgress = 0;
        double stressLevel = 0;

        weekMeasureList.forEach((e) {
          var dateTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(e.timeStamp.toString()));

          if (weekDateList.contains(resultFormatter.format(dateTime))) {
            if (listWeekData.isNotEmpty) {
              int index = listWeekData.indexWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              double energy = 0.0;
              int countEnergy = 0;

              double stress = 0.0;
              int countStress = 0;

              if (title == 'body_health'.tr) {
                double el = double.parse(e.hrVariability.toString());

                energy = listWeekData[index].value + el;
                countEnergy = listWeekData[index].count;

                String input = e.bloodPressure.toString();
                List values = input.split("/");

                double sys = double.parse(values[0].toString());
                double hr = double.parse(e.heartRate.toString());

                try {
                  stressLevel = getStressLevel(hr, sys, stressLevelProgress);
                } catch (e) {
                  printf('exe-stress-week-w294-${e.toString()}');
                }

                //printf('---weekk---$stressLevel');
                stress = listWeekDataForDiastolic[index].value + stressLevel;
                countStress = listWeekDataForDiastolic[index].count;
              }

              listWeekData.removeWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              listWeekDataForDiastolic.removeWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              listWeekData.add(
                  WeekModel(e.timeStamp.toString(), energy, countEnergy + 1));

              listWeekDataForDiastolic.add(
                  WeekModel(e.timeStamp.toString(), stress, countStress + 1));
            }
          }
        });
      } else {
        printf('---------------else-------------------check----');

        printf('no_record_found $weekDate');
        update();
      }
      Get.context!.loaderOverlay.hide();
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

  void getCurrentWeek(DateTime dateTime) {
    DateTime dt;
    for (int i = 0; i < 8; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekNumbers.add(GraphModel(DateFormat('dd').format(dt), 33));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      listWeekDataForDiastolic
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));

      weekList.add(dt);

      //  printf('weekListDate-${DateFormat('dd-MMM-yyyy HH:mm:ss').format(dt)} - ${dt.millisecondsSinceEpoch}');
    }
    weekNumberReversed = weekNumbers.reversed.toList();

    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(today)}';

    var endTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(today.millisecondsSinceEpoch);
    var startTimeStamp = DateTime.fromMillisecondsSinceEpoch(
        weekList.last.millisecondsSinceEpoch);

    getWeekData(
        startDate: startTimeStamp.millisecondsSinceEpoch,
        endDate: endTimeStamp.millisecondsSinceEpoch);

    update();
  }

  void getMonthData(selectedMonth) {
    printf('--call----month--data---');
    weekOfMonth = [];
    monthMeasureList = [];
    monthGraphPlot = [];
    weekOfMonthForDiastolic = [];
    monthGraphPlotForDiastolic = [];
    update();

    selectedMonth ??= DateTime.now();

    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month,
        selectedMonth.day, 0, 0, 0, 0, 0);

    DateTime firstDateOfMonth = findFirstDateOfTheMonth(selectedMonth);
    DateTime lastDateOfMonth = findLastDateOfTheMonth(selectedMonth);

    firstDateOfMonth = DateTime(firstDateOfMonth.year, firstDateOfMonth.month,
        firstDateOfMonth.day, 0, 0, 0, 0, 0);

    lastDateOfMonth = DateTime(lastDateOfMonth.year, lastDateOfMonth.month,
        lastDateOfMonth.day, 0, 0, 0, 0, 0);

    printf('Total Days in Month : ${lastDateOfMonth.day}');

    prepareWeeksOfMonthData(firstDateOfMonth, lastDateOfMonth);

    ///Fetching from Firebase
    final ref = dbMeasure
        .child(userId)
        .orderByChild('timeStamp')
        .startAt(firstDateOfMonth.millisecondsSinceEpoch)
        .endAt(lastDateOfMonth.millisecondsSinceEpoch);

    ref.once().then((value) {
      if (value.snapshot.exists) {
        printf('Retrieved Records-${value.snapshot.children.length}');
        value.snapshot.children.forEach((element) {
          final data = Map<String, dynamic>.from(element.value as Map);
          MeasureResult measureModel = MeasureResult.fromJson(data);
          //printf('Retrieved Records-${measureModel.dateTime} / ${measureModel.timeStamp} / ${element.key}');
          monthMeasureList.add(measureModel);
          update();
        });

        monthMeasureList
            .sort((a, b) => a.timeStamp ?? 0.compareTo(b.timeStamp ?? 0));

        double stressLevel = 0;
        double stressLevelProgress = 0;

        var groupByDate = groupBy(monthMeasureList, (obj) => obj.dateTime);
        groupByDate.forEach((date, list) {
          int sumHearRate = 0;
          int sumDiastolic = 0;
          list.forEach((listItem) {
            if (title == 'body_health'.tr) {
              double el = double.parse(listItem.hrVariability.toString());

              double s = el; //double.parse(listItem.pulsePressure.toString());

              String input = listItem.bloodPressure.toString();
              List values = input.split("/");

              double sys = double.parse(values[0].toString());
              double hr = double.parse(listItem.heartRate.toString());

              // printf('---month--hr-$hr---sys--$sys---');
              try {
                stressLevel = getStressLevel(hr, sys, stressLevelProgress);
              } catch (e) {
                printf('exe-stress-month-585-${e.toString()}');
              }

              // printf('---month--stress--$stressLevel---');

              double d = stressLevel;
              //double.parse(listItem.arterialPressure.toString());

              double hrt = s;
              sumHearRate = sumHearRate + hrt.toInt();

              double dd = d * 100;
              sumDiastolic = sumDiastolic + dd.toInt();
            }
          });

          double avgHrt = sumHearRate / list.length;

          double avhDiastolic = sumDiastolic / list.length;

          DateTime recordDate =
              DateTime.fromMillisecondsSinceEpoch(list.first.timeStamp!);

          var filterData = weekOfMonth
              .where((itemFound) => isBetweenDate(
                  recordDate, itemFound.weekStartDate!, itemFound.weekEndDate!))
              .toList();

          var filterDataForDiastolic = weekOfMonthForDiastolic
              .where((itemFound) => isBetweenDate(
                  recordDate, itemFound.weekStartDate!, itemFound.weekEndDate!))
              .toList();

          for (int i = 0; i < filterData.length; i++) {
            filterData[i].avgMeasure = avgHrt;
          }

          for (int i = 0; i < filterDataForDiastolic.length; i++) {
            filterDataForDiastolic[i].avgMeasure = avhDiastolic;
          }
        });

        double totalHeart = 0;
        double totalDiastolic = 0;

        for (int i = 0; i < weekOfMonth.length; i++) {
          var round = weekOfMonth[i].avgMeasure ?? 0;
          monthGraphPlot[i].value = round.roundToDouble();

          var value = monthGraphPlot[i].value;
          totalHeart = totalHeart + monthGraphPlot[i].value;

          if (value > highestBPMForMonth) {
            highestBPMForMonth = value;
          }

          if (value < lowestBPMForMonth) {
            lowestBPMForMonth = value;
          }
        }

        double avg = totalHeart / weekOfMonth.length;
        averageBPMForMonth = avg.roundToDouble(); //

        try {
          averageForMonthSystolic = averageBPMForMonth;
          highestForMonthSystolic = highestBPMForMonth;
          lowestForMonthSystolic = lowestBPMForMonth;
        } catch (e) {
          printf('exe-month-$e');
        }

        //printf('Month-----avg-->$averageForMonthSystolic-----high-->$highestForMonthSystolic-----low-->$lowestForMonthSystolic');

        for (int i = 0; i < weekOfMonthForDiastolic.length; i++) {
          var value = weekOfMonthForDiastolic[i].avgMeasure ?? 0;

          if (value > highestForMonthDiastolic) {
            highestForMonthDiastolic = value;
          }

          if (value < lowestForMonthDiastolic) {
            lowestForMonthDiastolic = value;
          }

          //printf('value-----${weekOfMonthForDiastolic[i].avgMeasure}');

          totalDiastolic = totalDiastolic + value;

          var round = weekOfMonthForDiastolic[i].avgMeasure ?? 0;
          monthGraphPlotForDiastolic[i].value = round.roundToDouble();
        }

        double avgForDiastolic = totalDiastolic / weekOfMonth.length;

        try {
          averageForMonthDiastolic = avgForDiastolic.roundToDouble();
        } catch (e) {
          printf('exe-month-$e');
        }

        update();
      } else {
        printf('month_records_not_found');
        averageBPMForMonth = 0;
        update();
      }
    });
  }

  Future getEnergyTips() async {
    printf('--call--energy-tips');
    final String response =
        await rootBundle.loadString('assets/tips/energy_tips.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();
    energyTip = list[random.nextInt(list.length)]['Tips'];
    printf('--random--energy--tip--$energyTip');
    update();

    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.energyTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     energyLevelTips.add(causeModel);
    //   });
    // }
    //
    // CausesTips health = energyLevelTips[random.nextInt(energyLevelTips.length)];
    // energyTip = health.tip.toString();
    // printf('--random--energy--tip--$energyTip');
    // update();
  }

  Future getStressLevelTips() async {
    printf('--call--stress-tips');
    final String response =
        await rootBundle.loadString('assets/tips/stress_level.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();
    stressTip = list[random.nextInt(list.length)]['Tips'];
    printf('--random--stress-level--tip--$stressTip');
    update();

    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.stressLevelTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     stressLevelTips.add(causeModel);
    //   });
    // }
    //
    // CausesTips health = stressLevelTips[random.nextInt(stressLevelTips.length)];
    // stressTip = health.tip.toString();
    // printf('--random--stress-level--tip--$stressTip');
    // update();
  }

  ///Return FIRST DAY OF THE MONTH
  ///
  ///
  ///
  DateTime findFirstDateOfTheMonth(DateTime dateTime) {
    DateTime firstDayOfMonth = DateTime(dateTime.year, dateTime.month, 1);
    return firstDayOfMonth;
  }

  /// Return  LAST DAY OF THE MONTH
  ///
  ///
  DateTime findLastDateOfTheMonth(DateTime dateTime) {
    DateTime lastDayOfMonth = DateTime(dateTime.year, dateTime.month + 1, 0);
    return lastDayOfMonth;
  }

  /// @author : Yagna Joshi
  void prepareWeeksOfMonthData(DateTime firstDate, DateTime lastDate) {
    DateTime weekLastDate = DateTime(firstDate.year, firstDate.month,
        firstDate.day + (7 - firstDate.weekday), 0, 0, 0, 0, 0);

    if (weekLastDate.isBefore(lastDate)) {
      weekOfMonth.add(WeekOfMonthModel(
          month: firstDate.month,
          weekOfYear: weekNumber(firstDate),
          weekStartDate: firstDate,
          weekEndDate: weekLastDate,
          avgMeasure: 0));

      weekOfMonthForDiastolic.add(WeekOfMonthModel(
          month: firstDate.month,
          weekOfYear: weekNumber(firstDate),
          weekStartDate: firstDate,
          weekEndDate: weekLastDate,
          avgMeasure: 0));

      printf(
          "Adding New Week :${weekOfMonth.last.weekOfYear} ${weekOfMonth.last.weekStartDate} to ${weekOfMonth.last.weekEndDate}");

      DateTime nextWeekFirstDate = DateTime(firstDate.year, firstDate.month,
          firstDate.day + (7 - firstDate.weekday) + 1, 0, 0, 0, 0, 0);

      if (nextWeekFirstDate.isBefore(lastDate) ||
          nextWeekFirstDate.isAtSameMomentAs(lastDate)) {
        prepareWeeksOfMonthData(nextWeekFirstDate, lastDate);
      } else {
        printf("Forbidden DateTime $nextWeekFirstDate");
      }
    } else {
      weekOfMonth.add(WeekOfMonthModel(
          month: firstDate.month,
          weekOfYear: weekNumber(firstDate),
          weekStartDate: firstDate,
          weekEndDate: lastDate));

      weekOfMonthForDiastolic.add(WeekOfMonthModel(
          month: firstDate.month,
          weekOfYear: weekNumber(firstDate),
          weekStartDate: firstDate,
          weekEndDate: lastDate));

      printf(
          "Adding New Week :${weekOfMonth.last.weekOfYear} ${weekOfMonth.last.weekStartDate} to ${weekOfMonth.last.weekEndDate}");
    }
    monthGraphPlot = [];
    monthGraphPlotForDiastolic = [];
    weekOfMonth.forEach((element) {
      monthGraphPlot.add(GraphModel('Week${element.weekOfYear}', 0));
    });
    weekOfMonthForDiastolic.forEach((element) {
      monthGraphPlotForDiastolic
          .add(GraphModel('Week${element.weekOfYear}', 0));
    });
    update();
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  isBetweenDate(DateTime recordDate, DateTime dateTime1, DateTime dateTime2) {
    if (recordDate.isAtSameMomentAs(dateTime1)) {
      return true;
    } else if (recordDate.isAtSameMomentAs(dateTime2)) {
      return true;
    } else if (recordDate.isAfter(dateTime1) &&
        recordDate.isBefore(dateTime2)) {
      return true;
    } else {
      return false;
    }
  }

  void getPreviousWeekData(DateTime dateTime) {
    weekList.clear();
    weekNumbers.clear();
    weekDateList.clear();
    listWeekData.clear();
    listWeekDataForDiastolic.clear();
    update();

    DateTime dt;
    for (int i = 0; i < 8; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekNumbers.add(GraphModel(DateFormat('dd').format(dt), 33.0 + i));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));

      weekNumbers.reversed;
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      listWeekDataForDiastolic
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      weekList.add(date);
    }

    weekNumberReversed = weekNumbers.reversed.toList();
    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(weekList.first)}';
    printf('weekDate->$weekDate');

    Utility.isConnected().then((value) {
      if (value) {
        getWeekData(
            startDate: weekList.last.millisecondsSinceEpoch,
            endDate: weekList.first.millisecondsSinceEpoch);

        printf('online_prev_week');
      } else {
        printf('offline_prev_week');
      }
    });

    update();
  }

  void getNextWeekData(DateTime dateTime) {
    weekList.clear();
    weekNumbers.clear();
    weekDateList.clear();
    listWeekData.clear();
    listWeekDataForDiastolic.clear();
    update();

    DateTime dt;
    for (int i = 0; i < 8; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekNumbers.add(GraphModel(DateFormat('dd').format(dt), 33.0 - i));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));
//      listWeekData.add(WeekModel(DateFormat('dd-MMM-yyyy').format(dt), 0.0, 0));
      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));

      weekNumbers.reversed;
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      listWeekDataForDiastolic
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      weekList.add(date);
    }

    weekNumberReversed = weekNumbers.reversed.toList();
    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(weekList.first)}';

    printf('weekDateNext->$weekDate');

    Utility.isConnected().then((value) {
      if (value) {
        getWeekData(
            startDate: weekList.last.millisecondsSinceEpoch,
            endDate: weekList.first.millisecondsSinceEpoch);

        printf('online_next_week');
      } else {
        printf('offline_next_week');
      }
    });
    update();
  }

  void getSelectedTab(index) {
    selectedTab = index;
    update();
  }

  void selectedDate() {
    late DateTime dateTime;
    try {
      dateTime = formatter.parse(displayDateText);
    } catch (exe) {
      printf('exe-$exe');
    }
    var prevDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    displayDateText = formatter.format(prevDate);

    printf('selected---date----$displayDateText----');

    // Utility.isConnected().then((value)
    // {
    //   if (value) {
    //     getBodyHealthForSelectedDate(resultFormatter.format(prevDate));
    //     printf('online_selected_date');
    //   } else {
    //     //getTodayDataOffline(resultFormatter.format(prevDate));
    //     printf('offline_selected_date');
    //   }
    // });

    getBodyHealthForOneTime(
        resultFormatter.format(prevDate), totalBodyHealthRecordList);

    printf('dateTime-$displayDateText');
    update();
  }

  void previousDayTabClick() {
    late DateTime dateTime;
    try {
      dateTime = formatter.parse(displayDateText);
    } catch (exe) {
      printf('exe-$exe');
    }
    var prevDate = DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
    displayDateText = formatter.format(prevDate);

    /*Utility.isConnected().then((value) {
      if (value) {
        getBodyHealthForSelectedDate(resultFormatter.format(prevDate));
        printf('online_prev_day');
      } else {
        //getTodayDataOffline(resultFormatter.format(prevDate));
        printf('offline_prev_day');
      }
    });*/
    getBodyHealthForOneTime(
        resultFormatter.format(prevDate), totalBodyHealthRecordList);
    printf('dateTime-$displayDateText');
    update();
  }

  void nextDayTabClick() {
    //nextDay = nextDay + 1;
    late DateTime dateTime;

    try {
      dateTime = formatter.parse(displayDateText);
    } catch (exe) {
      printf('exe-$exe');
    }

    if (formatter.format(todayDate) == displayDateText) {
      printf('Oops...next_day..');
    } else {
      var nextDate = DateTime(dateTime.year, dateTime.month, dateTime.day + 1);
      displayDateText = formatter.format(nextDate);

      /*Utility.isConnected().then((value) {
        if (value) {
          getBodyHealthForSelectedDate(resultFormatter.format(nextDate));
          printf('online_next_day');
        } else {
          //getTodayDataOffline(resultFormatter.format(nextDate));
          printf('offline_next_day');
        }
      });*/
      getBodyHealthForOneTime(
          resultFormatter.format(nextDate), totalBodyHealthRecordList);
    }

    printf('dateTime-$displayDateText');
    update();
  }

  void buttonPreviousWeekTab() {
    late DateTime dateTime;

    try {
      dateTime = formatterWeek.parse(displayWeekText);
    } catch (exe) {
      printf('exe-$exe');
    }

    var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day - 7);
    displayWeekText = formatterWeek.format(currentDate);
    printf('datePreviousWeek-$displayWeekText');
    if (weekList.isNotEmpty) {
      getPreviousWeekData(weekList.last);
    }
    update();
  }

  void buttonNextWeekTab() {
    late DateTime dateTime;

    try {
      dateTime = formatterWeek.parse(displayWeekText);
    } catch (exe) {
      printf('exe-display-week-$exe');
    }

    if (displayWeekText == displayDateText) {
      printf('Oops...next_week..$displayWeekText');
    } else {
      var currentDate =
          DateTime(dateTime.year, dateTime.month, dateTime.day + 7);
      displayWeekText = formatterWeek.format(currentDate);
      printf('dateTimeWeek-$displayWeekText');
      getNextWeekData(currentDate);
    }

    update();
  }

  void buttonPreviousMonthTab() {
    late DateTime dateTime;

    try {
      dateTime = formatterMonth.parse(displayMonthText);
    } catch (exe) {
      printf('exe-$exe');
    }

    var currentDate = DateTime(dateTime.year, dateTime.month - 1, dateTime.day);
    displayMonthText = formatterMonth.format(currentDate);
    printf('dateTimeMonth-$displayMonthText');

    Utility.isConnected().then((value) {
      if (value) {
        getMonthData(currentDate);
        printf('online_prev_month');
      } else {
        //getMonthDataOffline(currentDate);
        printf('offline_next_month');
      }
    });

    update();
  }

  void buttonNextMonthTab() {
    late DateTime dateTime;
    try {
      dateTime = formatterMonth.parse(displayMonthText);
    } catch (exe) {
      printf('exe-$exe');
    }

    if (todayDate.month == dateTime.month) {
      return;
    }
    var currentDate = DateTime(dateTime.year, dateTime.month + 1, dateTime.day);
    displayMonthText = formatterMonth.format(currentDate);
    printf('dateTimeNextMonth-$displayMonthText');

    Utility.isConnected().then((value) {
      if (value) {
        getMonthData(currentDate);
        printf('online_next_month');
      } else {
        //getMonthDataOffline(currentDate);
        printf('offline_next_month');
      }
    });

    update();
  }
}
