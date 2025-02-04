import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/helper/database_helper.dart';
import 'package:doori_mobileapp/models/graph/week_of_month_model.dart';
import 'package:doori_mobileapp/models/measure_model/health_tips_model.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class HeartGraphController extends BaseController
    with GetSingleTickerProviderStateMixin {
  BuildContext context;

  HeartGraphController(this.context);

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

  List<GraphModel> graphDayListForHeartStrain = [];

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

  late TabController tabController = TabController(length: 3, vsync: this);

  List<CausesTips> strokeVolumeTips = [];
  String strokeVolumeTip = '';

  List<CausesTips> cardiacVolumeTips = [];
  String cardiacVolumeTip = '';

  bool isImproveHealth = true;
  bool isImproveHealthForWeek = false;
  bool isImproveHealthForMonth = true;
  var pointer = ImagePath.icHeartPointer;

  var value = '0';
  var valueMsg = 'average'.tr;
  var lastMeasured = '';

  var condition = '';

  double totalHeartScore = 0, totalLastWeekScore = 0;
  double totalHeartScoreForDia = 0, totalLastWeekScoreForDia = 0;

  double finalRestingScore = 0, maxRestingHr = 0, avgHeartRateScore = 0;

  double avgRestingForDia = 0,
      maxRestingForDia = 0,
      avgHeartRateScoreForDia = 0;

  double totalHrScore = 0, lastWeekHrScore = 0, lastWeekResult = 0;
  double totalDiaScore = 0, lastWeekDiaScore = 0, lastWeekResultForDia = 0;

  List<double> lastWeekRecords = [];
  List<double> totalSittingRecords = [];

  double totalAllTimeValue = 0;
  List<double> totalAllTimeRecords = [];

  double totalAllTimeValueForDia = 0;
  List<double> totalAllTimeRecordsForDia = [];

  List<double> lastWeekRecordForDia = [];
  List<double> totalSittingRecordForDia = [];

  var scoreTitle = 'heart_rate_score'.tr;
  var avgRestingTitle = 'avg_resting_hr'.tr;
  var maxRestingTitle = 'max_resting_hr'.tr;

  double avgForAllTimeRecords = 0, avgForAllTimeRecordsForDia = 0;

  var todayGoalMessage = '';

  List<MeasureResult> totalMeasureRecordList = [];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('<-----------------init_heart_graph------------------>');

      //isLoading.value = true;
      //update();

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

      // printf("todayMillisecond-${today.millisecondsSinceEpoch}");

      if (arguments != null) {
        title = arguments[0];
        userId = arguments[1];

        try {
          value = arguments[2];
          valueMsg = arguments[3];
          lastMeasured = arguments[4];
          totalMeasureRecordList = arguments[5];

          printf('---graph--value---$value---$valueMsg---$lastMeasured');
          printf('--userId->$userId-->${totalMeasureRecordList.length}');
        } catch (e) {
          printf('exe-246-->$e');
        }

        callInit(title);

        if (totalMeasureRecordList.isNotEmpty)
        {
          getHeartRateScoreFirstTime(totalMeasureRecordList)
              .whenComplete(() {});

          getHeartRateValueForYesterdayForFirstTime(
              resultFormatter.format(yesterdayDate), totalMeasureRecordList);

          getHeartRateValueForSelectedDateForFirstTime(
              resultFormatter.format(todayDateTemp), totalMeasureRecordList);
          //
          getCurrentWeekForFirstTime(today, totalMeasureRecordList);
           getMonthDataForFirstTime(currentMonth, totalMeasureRecordList);
        } else {
          printf('--need--to--fetch--online--');
        }

        /*Utility.isConnected().then((value) {
          if (value) {
            User user = AuthenticationHelper().user;
            userId = user.uid;
            printf('userUId-${user.uid}');

            getHeartRateScore().whenComplete(() {
            getHeartRateValueForYesterday(
                resultFormatter.format(yesterdayDate));

            getHeartRateValueForSelectedDate(
                resultFormatter.format(todayDateTemp));

            getCurrentWeek(today);
            getMonthData(currentMonth);
            });

            printf('internet_online');
          } else {
            printf('internet_offline');
            getLastUserId();
          }
        });*/
      } else {
        printf('null_arguments');
      }
    });
  }

  @override
  void onClose() {
    printf('------------------close_heart_graph-------------------');
    //changeSystemColor(Colors.transparent);
    super.onClose();
  }

  void getSelectedTab(index) {
    selectedTab = index;
    update();
  }

  ///-----------------first time record fetch
  Future<void> getHeartRateScoreFirstTime(
      List<MeasureResult> totalAllRecords) async {
    List<MeasureResult> totalRecords = [];

    if (totalAllRecords.isNotEmpty) {
      totalAllRecords.forEach((activityModel) {
        totalRecords.add(activityModel);

        if (title == 'heart_rate'.tr)
        {
          if (activityModel.activity.toString().toLowerCase().tr ==
                  'sitting'.tr ||
              activityModel.activity.toString().toLowerCase().tr ==
                  'sleeping'.tr) {
            totalHeartScore = totalHeartScore +
                double.parse(activityModel.heartRate.toString());

            totalSittingRecords
                .add(double.parse(activityModel.heartRate.toString()));
          }

          totalAllTimeValue = totalAllTimeValue +
              double.parse(activityModel.heartRate.toString());
          totalAllTimeRecords
              .add(double.parse(activityModel.heartRate.toString()));
        } else if (title == 'oxygen_level'.tr) {
          scoreTitle = 'oxygen_level_score'.tr; //Oxygen Level Score
          avgRestingTitle = 'avg_resting_spo2'.tr;
          maxRestingTitle = 'max_resting_spo2'.tr;

          if (activityModel.activity.toString().toLowerCase().tr ==
                  'sitting'.tr ||
              activityModel.activity.toString().toLowerCase().tr ==
                  'sleeping'.tr) {
            totalHeartScore =
                totalHeartScore + double.parse(activityModel.oxygen.toString());
            totalSittingRecords
                .add(double.parse(activityModel.oxygen.toString()));
          }
          totalAllTimeValue =
              totalAllTimeValue + double.parse(activityModel.oxygen.toString());
          totalAllTimeRecords
              .add(double.parse(activityModel.oxygen.toString()));
        } else if (title == 'hr_variability'.tr) {
          scoreTitle = 'hr_variability_score'.tr;
          avgRestingTitle = 'avg_resting_hrv'.tr;
          maxRestingTitle = 'max_resting_hrv'.tr;

          if (activityModel.activity.toString().toLowerCase().tr ==
                  'sitting'.tr ||
              activityModel.activity.toString().toLowerCase().tr ==
                  'sleeping'.tr) {
            if (activityModel.hrVariability!.isNotEmpty) {
              try {
                totalHeartScore = totalHeartScore +
                    double.parse(activityModel.hrVariability.toString());
                totalSittingRecords
                    .add(double.parse(activityModel.hrVariability.toString()));
              } catch (e) {
                printf('exe---371>$e');
              }
            }
          }

          if (activityModel.hrVariability!.isNotEmpty) {
            try {
              totalAllTimeValue = totalAllTimeValue +
                  double.parse(activityModel.hrVariability.toString());
              totalAllTimeRecords
                  .add(double.parse(activityModel.hrVariability.toString()));
            } catch (e) {
              printf('exe----388-->$e');
            }
          }

          //double hrv = double.parse(activityModel.hrVariability.toString());
        } else if (title == 'pulse_pressure'.tr) {
          scoreTitle = 'pulse_pressure_score'.tr;
          avgRestingTitle = 'avg_resting_pp'.tr;
          maxRestingTitle = 'max_resting_pp'.tr;

          if (activityModel.activity.toString().toLowerCase().tr ==
                  'sitting'.tr ||
              activityModel.activity.toString().toLowerCase().tr ==
                  'sleeping'.tr) {
            if (activityModel.pulsePressure.toString() == '0') {
            } else {
              totalHeartScore = totalHeartScore +
                  double.parse(activityModel.pulsePressure.toString());
              totalSittingRecords
                  .add(double.parse(activityModel.pulsePressure.toString()));
            }
          }

          if (activityModel.pulsePressure.toString() == '0') {
          } else {
            totalAllTimeValue = totalAllTimeValue +
                double.parse(activityModel.pulsePressure.toString());
            totalAllTimeRecords
                .add(double.parse(activityModel.pulsePressure.toString()));
          }
        } else if (title == 'arterial_pressure'.tr) {
          scoreTitle = 'arterial_pressure_score'.tr;
          avgRestingTitle = 'avg_resting_ap'.tr;
          maxRestingTitle = 'max_resting_ap'.tr;

          if (activityModel.activity.toString().toLowerCase().tr ==
                  'sitting'.tr ||
              activityModel.activity.toString().toLowerCase().tr ==
                  'sleeping'.tr) {
            if (activityModel.arterialPressure.toString() == '0') {
            } else {
              totalHeartScore = totalHeartScore +
                  double.parse(activityModel.arterialPressure.toString());
              totalSittingRecords
                  .add(double.parse(activityModel.arterialPressure.toString()));
            }
          }

          if (activityModel.arterialPressure.toString() == '0') {
          } else {
            totalAllTimeValue = totalAllTimeValue +
                double.parse(activityModel.arterialPressure.toString());
            totalAllTimeRecords
                .add(double.parse(activityModel.arterialPressure.toString()));
          }
        } else if (title == 'blood_pressure'.tr) {
          scoreTitle = 'blood_pressure_score'.tr;
          avgRestingTitle = 'avg_resting_sys'.tr;
          maxRestingTitle = 'max_resting_sys'.tr;

          String input = activityModel.bloodPressure.toString();
          List values = input.split("/");

          double s = double.parse(values[0].toString());
          double d = double.parse(values[1].toString());

          if (activityModel.activity.toString().toLowerCase().tr ==
                  'sitting'.tr ||
              activityModel.activity.toString().toLowerCase().tr ==
                  'sleeping'.tr) {
            totalHeartScore = totalHeartScore + s;
            totalSittingRecords.add(s);

            totalHeartScoreForDia = totalHeartScoreForDia + d;
            totalSittingRecordForDia.add(d);
          }

          totalAllTimeValue = totalAllTimeValue + s;
          totalAllTimeRecords.add(s);

          totalAllTimeValueForDia = totalAllTimeValueForDia + d;
          totalAllTimeRecordsForDia.add(d);
        }

        update();
      });

      printf('--total--records---->${totalAllTimeRecords.length}');
    } else {
      isLoading.value = false;
      printf('no_heart_rate_score_found');
    }
    isLoading.value = false;

    if (totalSittingRecords.isNotEmpty) {
      double restingHrForDia = 0;
      double restingHr = 0;
      double avg = totalHeartScore / totalSittingRecords.length;

      avgForAllTimeRecords = totalAllTimeValue / totalAllTimeRecords.length;

      avgForAllTimeRecordsForDia =
          totalAllTimeValueForDia / totalAllTimeRecordsForDia.length;

      avgForAllTimeRecords = avgForAllTimeRecords.toPrecision(1);
      try {
        avgForAllTimeRecordsForDia = avgForAllTimeRecordsForDia.toPrecision(1);
      } catch (e) {
        printf('exe-524-->${e.toString()}');
      }

      avgHeartRateScore = avg.toPrecision(1);

      if (title == 'heart_rate'.tr) {
        double hr = 0;
        restingHr = 100 - (avg - 65) * 1.82;

        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore >= 85) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'tachycardia'.tr}';
        } else if (avgHeartRateScore < 60) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'bradycardia'.tr}';
        } else if (avgHeartRateScore >= 60 && avgHeartRateScore < 85) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        } else {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        }

        hr = avgForAllTimeRecords - 3;

        printf('--all-time--hr-->$avgForAllTimeRecords');
        todayGoalMessage =
            '${'your_average_heart_rate_is'.tr} $avgForAllTimeRecords ${'try_maintaining_an_average_heart_rate_of'.tr} $hr';

        /*double a = avg.roundToDouble() - 3;
        printf('today_average-$avg');
        if (title == 'heart_rate'.tr) {
          if (avg < 65) {
            yesterdayMeasure = "your_heart_rate_is_up_to_the_mark".tr;
          } else {
            yesterdayMeasure =
            "${'your_average_heart_rate_yesterday_was'.tr} ${avg.roundToDouble()}, ${'try_maintaining_a_heart_rate_of'.tr} $a ${'today'.tr}. ";
          }
          printf('yesterday_measure_at-$avg');
        } else if (title == 'oxygen_level'.tr) {
          printf('yesterday_oxygen-$avg');

          if (avg <= 97) {
            double o = avg.roundToDouble() + 1;
            yesterdayMeasure =
            " ${'your_average_oxygen_level_yesterday_was'.tr} ${avg.roundToDouble()} %, ${'try_maintaining_an_average_of'.tr} $o % ${'today'.tr}.";
          } else {
            yesterdayMeasure = " ${'your_oxygen_level_is_up_to_the_mark'.tr} ";
          }
        }*/
      } else if (title == 'oxygen_level'.tr) {
        double ox = 0;
        if (avg <= 96) {
          restingHr = 80 - ((96 - avg) * 6.66);
        } else if (avg > 96) {
          restingHr = 80 + ((avg - 96) * 6.66);
        } else if (avg > 99) {
          restingHr = 100;
        }
        printf('--all-time--oxygen-->$avgForAllTimeRecords');
        // for condition
        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore > 0 && avgHeartRateScore < 94) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'severe_hypoxia'.tr}';
        } else if (avgHeartRateScore >= 94 && avgHeartRateScore < 96) {
          condition = '${'condition'.tr} : ${'signs_of'.tr} ${'hypoxia'.tr}';
        } else if (avgHeartRateScore >= 96) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        }

        if (avgForAllTimeRecords <= 97) {
          ox = avgForAllTimeRecords + 1;

          todayGoalMessage =
              '${'your_average_oxygen_level_is'.tr} $avgForAllTimeRecords ${'try_maintaining_an_oxygen_level_of'.tr} $ox';
        } else {
          todayGoalMessage = 'your_oxygen_level_is_up_to_the_mark'.tr;
        }
      } else if (title == 'hr_variability'.tr) {
        double hrv = 0;
        if (avg > 120) {
          restingHr = 100;
        } else if (avg < 120) {
          restingHr = 100 - ((120 - avg) * 0.83);
          avg = avg.toPrecision(1);
          hrv = avgForAllTimeRecords + 40;
        }

        todayGoalMessage =
            '${'your_average_hrv_is'.tr} $avgForAllTimeRecords, ${'try_maintaining_an_average_hrv_for'.tr} $hrv';

        // for condition
        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        printf('------------max----hr----resting------>$maxRestingHr');

        if (avgHeartRateScore >= 100) {
          condition = '${'condition'.tr} : ${'well_regulated'.tr}';
        } else if (avgHeartRateScore >= 50 && avgHeartRateScore < 100) {
          condition = '${'condition'.tr} : ${'average_variability'.tr}';
        } else if (avgHeartRateScore > 0 && avgHeartRateScore < 50) {
          condition = '${'condition'.tr} : ${'reduced_variability'.tr}';
        }
      } else if (title == 'pulse_pressure'.tr) {
        double pp = 0;
        avg = avg.toPrecision(1);
        if (avg == 40) {
          restingHr = 100;
        } else if (avg < 40) {
          restingHr = 100 - ((40 - avg) * 2.5);
          pp = avgForAllTimeRecords + 2;
        } else if (avg > 40) {
          restingHr = 100 - ((avg - 40) * 2.5);
          pp = avgForAllTimeRecords - 2;
        }

        todayGoalMessage =
            '${'your_average_pulse_pressure_is'.tr} $avgForAllTimeRecords ${'try_maintaining_an_average_pulse_pressure_of'.tr} $pp';

        // for condition
        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore > 48) {
          condition = '${'condition'.tr} : ${'wide_pulse_pressure'.tr}';
        } else if (avgHeartRateScore >= 32 && avgHeartRateScore <= 48) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        } else if (avgHeartRateScore > 0 && avgHeartRateScore < 32) {
          condition = '${'condition'.tr} : ${'narrow_pulse_pressure'.tr}';
        }
      } else if (title == 'arterial_pressure'.tr) {
        double ap = 0;
        avg = avg.toPrecision(1);
        if (avg == 85) {
          restingHr = 100;
        } else if (avg < 85) {
          restingHr = 100 - ((85 - avg) * 1.66);
          ap = avgForAllTimeRecords + 2;
        } else if (avg > 85) {
          restingHr = 100 - ((avg - 85) * 1.66);
          ap = avgForAllTimeRecords - 2;
        }
        todayGoalMessage =
            '${'your_average_arterial_pressure_is'.tr} $avgForAllTimeRecords ${'try_maintaining_an_average_arterial_pressure_of'.tr} $ap';

        // for condition
        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore > 100) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'increased_heart_function'.tr}';
        } else if (avgHeartRateScore >= 70 && avgHeartRateScore <= 100) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        } else if (avgHeartRateScore > 0 && avgHeartRateScore < 70) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'decreased_heart_function'.tr}';
        }
      } else if (title == 'blood_pressure'.tr) {
        double bpSys = 0, bpDia = 0;

        if (avg > 120) {
          restingHr = 100 - ((avg - 120) * 1.6);
          bpSys = avgForAllTimeRecords - 3;
        } else if (avg < 120) {
          restingHr = 100 - ((120 - avg) * 3.2);
          bpSys = avgForAllTimeRecords + 3;
        } else if (avg == 120) {
          restingHr = 100;
        } else if (avg == 122 || avg == 121 || avg == 119 || avg == 120) {
          bpSys = 120;
        }

        // for condition sys

        if (avg >= 115 && avg < 118) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'mild_hypotension'.tr}';
        } else if (avg >= 110 && avg < 115) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'moderate_hypotension'.tr}';
        } else if (avg >= 118 && avg < 122) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        } else if (avg >= 122 && avg < 128) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'elevated_blood_pressure'.tr}';
        } else if (avg >= 128 && avg < 140) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'hypertension'.tr}';
        } else if (avg >= 140) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'severe_hypertension'.tr}';
        } else if (avg > 0 && avg < 110) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'severe_hypertension'.tr}';
        }

        double avgDia = totalHeartScoreForDia / totalSittingRecordForDia.length;

        avgHeartRateScoreForDia = avgDia.toPrecision(1);

        printf('-----average--dia--->$avgDia-----average---sys-->$avg');

        if (avgDia > 80) {
          restingHrForDia = 100 - ((avgDia - 80) * 5);
          bpDia = avgForAllTimeRecordsForDia - 3;
        } else if (avgDia < 80) {
          restingHrForDia = 100 - ((80 - avgDia) * 5);
          bpDia = avgForAllTimeRecordsForDia + 3;
        } else if (avgDia == 78 ||
            avgDia == 79 ||
            avgDia == 81 ||
            avgDia == 82) {
          bpDia = 80;
        }

        if (avg >= 118 && avg < 122) {
          todayGoalMessage = 'your_blood_pressure_is_well_maintained'.tr;
        } else if (avg >= 122 && avg < 124) {
          todayGoalMessage = 'your_blood_pressure_is_well_maintained'.tr;
        } else if (avg >= 116 && avg < 118 && avg >= 114) {
          todayGoalMessage = 'your_blood_pressure_is_well_maintained'.tr;
        } else {
          todayGoalMessage =
              '${'your_average_bp_is'.tr} $avgForAllTimeRecords/$avgForAllTimeRecordsForDia, ${'try_maintaining_an_average_bp'.tr} ${bpSys.toPrecision(1)}/${bpDia.toPrecision(1)}';
        }
      }

      if (title == 'blood_pressure'.tr) {
        totalHrScore = restingHr;

        finalRestingScore =
            (restingHr.toPrecision(1) + restingHrForDia.toPrecision(1)) / 2;

        finalRestingScore = finalRestingScore.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        totalSittingRecordForDia.sort();
        maxRestingForDia = totalSittingRecordForDia.last.toPrecision(1);
      }
    } else {
      printf('no_sitting_record_found');
    }
  }

  Future<void> getHeartRateValueForYesterdayForFirstTime(
      date, List<MeasureResult> totalAllRecords) async {
    printf('yesterdayDate-$date');
    List<GraphModel> graphDayList = [];
    List<MeasureResult> measureUserList = [];

    isLoading.value = true;

    if (totalAllRecords.isNotEmpty) {
      totalAllRecords.forEach((activityModel) {
        if (activityModel.dateTime.toString() == date.toString()) {
          measureUserList.add(activityModel);
        }
        update();
      });

      int totalHeart = 0;
      // int totalDiastolic = 0;

      for (int i = 0; i < measureUserList.length; i++) {
        if (title == 'heart_rate'.tr) {
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].heartRate.toString())));

          totalHeart =
              totalHeart + int.parse(measureUserList[i].heartRate.toString());
        } else if (title == 'oxygen_level'.tr) {
          printf('oxygen_level');
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].oxygen.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].oxygen.toString()).toInt();
        } else if (title == 'hr_variability'.tr) {
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].hrVariability.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].hrVariability.toString()).toInt();
        } else if (title == 'blood_pressure'.tr) {
          printf('bloodPressureYesterday');
        }

        update();
      }

      if (measureUserList.isNotEmpty) {
        double avg = totalHeart / measureUserList.length;
        printf('today_average-$avg');
        avg = avgHeartRateScore;

        double a = 0;

        if (title == 'heart_rate'.tr) {
          // avg

          printf('today_all_time_average-$avg');
          // if (avg < 65) {
          //   yesterdayMeasure = "your_heart_rate_is_up_to_the_mark".tr;
          // } else {
          //   a = avgForAllTimeRecords - 3;
          //   yesterdayMeasure =
          //       "${'your_average_heart_rate_yesterday_was'.tr} $avgForAllTimeRecords, ${'try_maintaining_a_heart_rate_of'.tr} $a ${'today'.tr}. ";
          // }
          printf('yesterday_measure_at-$avg');
        } else if (title == 'oxygen_level'.tr) {
          printf('yesterday_oxygen-$avg');

          // if (avg <= 97) {
          //   double o = avgForAllTimeRecords + 1;
          //   yesterdayMeasure =
          //       " ${'your_average_oxygen_level_yesterday_was'.tr} $avgForAllTimeRecords %, ${'try_maintaining_an_average_of'.tr} $o % ${'today'.tr}.";
          // } else {
          //   yesterdayMeasure = " ${'your_oxygen_level_is_up_to_the_mark'.tr} ";
          // }
        } else if (title == 'hr_variability'.tr) {
          printf('yesterday_hr_v');
        } else {
          printf('yesterday_bp');
        }
      } else {
        printf('not_measure_yesterday');
        yesterdayMeasure = '';
      }
      isLoading.value = false;

      update();
    } else {
      printf('no_children_exists_for_yesterday');
    }
  }

  Future<void> getHeartRateValueForSelectedDateForFirstTime(
      date, List<MeasureResult> totalAllRecords) async {
    printf('--------todayDate----->$date');
    graphDayList.clear();
    graphDayListForHeartStrain.clear();
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

      int totalHeart = 0;
      int totalDiastolic = 0;

      printf('measureList-----${measureUserList.length}');

      for (int i = 0; i < measureUserList.length; i++) {
        if (title == 'heart_rate'.tr)
        {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].heartRate.toString())));

          totalHeart =
              totalHeart + int.parse(measureUserList[i].heartRate.toString());
          printf(
              'heart_rate-$totalHeart ->${measureUserList.length.toString()} ');
        }
        else if (title == 'oxygen_level'.tr) {
          printf('oxygen_level');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].oxygen.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].oxygen.toString()).toInt();
        } else if (title == 'hr_variability'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].hrVariability.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].hrVariability.toString()).toInt();
        } else if (title == 'pulse_pressure'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].pulsePressure.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].pulsePressure.toString()).toInt();
        } else if (title == 'arterial_pressure'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].arterialPressure.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].arterialPressure.toString())
                  .toInt();
        } else if (title == 'blood_pressure'.tr) {
          String input = measureUserList[i].bloodPressure.toString();
          List values = input.split("/");

          double s = double.parse(values[0].toString());
          double d = double.parse(values[1].toString());

          printf('----day--bp2-$s $d');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble()));

          graphDayListForDiastolic.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              d.roundToDouble()));

          totalHeart = totalHeart + s.toInt();

          totalDiastolic = totalDiastolic + d.toInt();

          graphDayForBloodPressureList.add(GraphModelForBloodPressure(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble(),
              d.roundToDouble()));
        } else if (title == 'heart_health'.tr)
        {
          String input = measureUserList[i].bodyHealth.toString();
          List values = input.split("/");
          double s = double.parse(values[0].toString());

          printf('heartHealth------>$s');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          //('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble()));

          totalHeart = totalHeart + s.toInt();
        } else if (title == AppConstants.heartStrain)
        {
          // String input = measureUserList[i].bodyHealth.toString();
          // List values = input.split("/");
          //double s = 0; //double.parse(values[0].toString());
          //
          printf('--------HeartStrain------>');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe----date--->$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          //('------$s------------${dateFormatTime.format(currentDate)}');

          double  s = calculateHeartStrain(
                  hrv: double.parse(measureUserList[i].hrVariability.toString()),
                  bloodPressure: measureUserList[i].bloodPressure.toString());

          printf(
              '--------final-------strain------>$s---->${dateFormatTime.format(currentDate).toString()}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble()));

          graphDayListForHeartStrain.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble()));

          totalHeart = totalHeart + s.toInt();


        } else if (title == 'heart_function'.tr) {
          double s = double.parse(measureUserList[i].pulsePressure.toString());
          double d =
              double.parse(measureUserList[i].arterialPressure.toString());

          printf('----day--pulse--->$s<---->arterial--->$d<---');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe---date--1490->$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble()));

          graphDayListForDiastolic.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              d.roundToDouble()));

          totalHeart = totalHeart + s.toInt();

          totalDiastolic = totalDiastolic + d.toInt();

          graphDayForBloodPressureList.add(GraphModelForBloodPressure(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble(),
              d.roundToDouble()));
        }

        update();
      }

      printf('<-------checkDate--------->$date - ${resultFormatter.format(today)}');

      printf('---------total-------->${graphDayList.length}');

      try {
        GraphModel max = graphDayList.reduce(
            (value, element) => value.value > element.value ? value : element);
        GraphModel min = graphDayList.reduce(
            (value, element) => value.value < element.value ? value : element);

        lowestBPM = min.value;
        highestBPM = max.value;

        printf('---lowest--->$lowestBPM<----highest--->$highestBPM');
      } catch (e) {
        printf('exe----->1533-->$e');
      }

      if (measureUserList.isNotEmpty) {
        double avg = totalHeart / measureUserList.length;
        averageBPM = avg.roundToDouble();

        printf('totalAverage--->$averageBPM');

        if (graphDayListForDiastolic.isNotEmpty) {
          printf('iff_blood_pressure');
          double avg = totalDiastolic / measureUserList.length;
          averageForDiastolic = avg.roundToDouble();

          graphDayListForDiastolic.sort((a, b) => a.value.compareTo(b.value));
          lowestForDiastolic = graphDayListForDiastolic.first.value;
          highestForDiastolic = graphDayListForDiastolic.last.value;
        }

        printf('------totalAverage->$averageBPM<---->$averageForDiastolic<---');

        if (averageBPM >= 35 && averageBPM <= 45) {
          //isImproveHealth = false;
          strokeVolumeTip = "your_stroke_volume_is_in_the_healthy_range".tr;
        } else {

          getStrokeVolumeTips();
          printf('----else----stroke--tip');
        }

        if (averageForDiastolic >= 77 && averageForDiastolic <= 93) {
          cardiacVolumeTip = "your_cardiac_output_is_in_the_healthy_range".tr;
        } else {
          printf('----else----cardiac--tip');
          getCardiacVolumeTips();
        }

        if (isBloodPressure) {
          printf('averageForBloodPressure');
        } else {
          printf('averageForHeart');
          getAverageForDay(averageBPM.toDouble());
        }
      } else {
        averageBPM = 0;
        highestBPM = 0;
        lowestBPM = 0;
        if (isBloodPressure) {
          // getAverageForBloodPressure(averageBPM.toDouble(), avgSys: averageBPM.toDouble(), avgDia: averageForDiastolic);
        } else {
          getAverageForDay(averageBPM.toDouble());
        }
      }
      isLoading.value = false;

      update();
    } else {
      printf('no_children_exists_for_today');
    }
  }

  double calculateHeartStrain(
      {required double hrv, required String bloodPressure}) {
    List<String> parts = bloodPressure.split('/');
    int sysBP = int.parse(parts[0]);
    int diaBP = int.parse(parts[1]);

    if (hrv > 100) {
      hrv = 100;
    }

    if (sysBP > 130) {
      sysBP = 130;
    }
    if (sysBP < 110) {
      sysBP = 110;
    }

    if (diaBP > 90) {
      diaBP = 90;
    }

    if (diaBP < 70) {
      diaBP = 70;
    }

    //printf('<----calculateHeartStrain-------hrv->$hrv---sys->$sysBP--dia->$diaBP');

    const int hrvNormal = 100;
    const int bpSystolicNormal = 120;
    const int bpDiastolicNormal = 80;
    double strain = 0.0;

    // Calculate HRV-based strain (lower HRV increases strain)

    strain += (hrvNormal - hrv).abs(); // Max 50% strain from HRV

    // Calculate BP-based strain (higher BP increases strain)

    strain += (sysBP - bpSystolicNormal).abs() * 10;

    strain += (diaBP - bpDiastolicNormal).abs() * 10;

    // Cap the strain percentage at 100%
    if (strain >= 300) {
      strain = 300;
    }

    return strain / 3;
  }

  void getCurrentWeekForFirstTime(DateTime dateTime, List<MeasureResult> totalAllRecords) {
    weekNumbers.clear();
    weekDateList.clear();
    listWeekData.clear();
    listWeekDataForDiastolic.clear();
    weekList.clear();
    DateTime dt;
    for (int i = 0; i < 8; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekNumbers.add(GraphModel(DateFormat('dd').format(dt), 33));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      listWeekDataForDiastolic
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));

      weekList.add(dt);

      //printf('weekListDate-${DateFormat('dd-MMM-yyyy HH:mm:ss').format(dt)} - ${dt.millisecondsSinceEpoch}');
    }
    weekNumberReversed = weekNumbers.reversed.toList();

    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(today)}';

    DateTime endDt = DateTime.now().subtract(const Duration(days: 0));
    DateTime startDt = DateTime.now().subtract(const Duration(days: 7));

    printf('-->${DateFormat('dd-MMM-yyyy').format(startDt)}--->'
        '${DateFormat('dd-MMM-yyyy').format(endDt)}');

    weekMeasureList = totalAllRecords
        .where((item) =>
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isAfter(startDt) &&
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isBefore(endDt))
        .toList();

    if (weekMeasureList.isNotEmpty) {
      getWeekDataForOneTime(weekMeasureList);
    }

    isLoading.value = false;

    update();
  }

  void getWeekDataForOneTime(weekMeasureList)
  {
    if (weekMeasureList.isNotEmpty)
    {
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

            double hr = 0.0;
            int count = 0;

            double d = 0.0;
            int countD = 0;

            if (title == 'heart_rate'.tr)
            {
              hr = listWeekData[index].value +
                  double.parse(e.heartRate.toString());
              count = listWeekData[index].count;

              if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                totalLastWeekScore =
                    totalLastWeekScore + double.parse(e.heartRate.toString());
                lastWeekRecords.add(double.parse(e.heartRate.toString()));
              }
            } else if (title == 'oxygen_level'.tr) {
              hr =
                  listWeekData[index].value + double.parse(e.oxygen.toString());
              count = listWeekData[index].count;

              if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                totalLastWeekScore =
                    totalLastWeekScore + double.parse(e.oxygen.toString());
                lastWeekRecords.add(double.parse(e.oxygen.toString()));
              }
            } else if (title == 'hr_variability'.tr) {
              hr = listWeekData[index].value +
                  double.parse(e.hrVariability.toString());
              count = listWeekData[index].count;

              if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                totalLastWeekScore = totalLastWeekScore +
                    double.parse(e.hrVariability.toString());
                lastWeekRecords.add(double.parse(e.hrVariability.toString()));
              }
            } else if (title == 'pulse_pressure'.tr) {
              hr = listWeekData[index].value +
                  double.parse(e.pulsePressure.toString());
              count = listWeekData[index].count;

              if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                totalLastWeekScore = totalLastWeekScore +
                    double.parse(e.pulsePressure.toString());
                lastWeekRecords.add(double.parse(e.pulsePressure.toString()));
              }
            } else if (title == 'arterial_pressure'.tr) {
              hr = listWeekData[index].value +
                  double.parse(e.arterialPressure.toString());
              count = listWeekData[index].count;

              if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                totalLastWeekScore = totalLastWeekScore +
                    double.parse(e.arterialPressure.toString());
                lastWeekRecords
                    .add(double.parse(e.arterialPressure.toString()));
              }
            } else if (title == 'blood_pressure'.tr) {
              String input = e.bloodPressure.toString();
              List values = input.split("/");

              double s = double.parse(values[0].toString());
              double dd = double.parse(values[1].toString());

              if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                totalLastWeekScore = totalLastWeekScore + s;
                lastWeekRecords.add(s);

                totalLastWeekScoreForDia = totalLastWeekScoreForDia + dd;
                lastWeekRecordForDia.add(dd);
              }

              hr = listWeekData[index].value + s;
              count = listWeekData[index].count;

              d = listWeekDataForDiastolic[index].value + dd;
              countD = listWeekDataForDiastolic[index].count;
            } else if (title == 'heart_function'.tr) {
              hr = listWeekData[index].value +
                  double.parse(e.pulsePressure.toString());
              count = listWeekData[index].count;

              d = listWeekDataForDiastolic[index].value +
                  double.parse(e.arterialPressure.toString());
              countD = listWeekDataForDiastolic[index].count;
            } else if (title == 'heart_health'.tr) {
              String input = e.bodyHealth.toString();
              List values = input.split("/");
              double s = double.parse(values[0].toString());

              hr = listWeekData[index].value + s;
              count = listWeekData[index].count;
            } else if (title == AppConstants.heartStrain) {
              String input = e.bodyHealth.toString();
              List values = input.split("/");

              //double s = double.parse(values[0].toString());

              int s = calculateHeartStrain(
                      hrv: double.parse(e.hrVariability.toString()),
                      bloodPressure: e.bloodPressure.toString())
                  .toInt();

              hr = listWeekData[index].value + s;
              count = listWeekData[index].count;
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

            listWeekData.add(WeekModel(e.timeStamp.toString(), hr, count + 1));

            listWeekDataForDiastolic
                .add(WeekModel(e.timeStamp.toString(), d, countD + 1));
          }
          listWeekData.sort((a, b) => a.title.compareTo(b.title));
          listWeekDataForDiastolic.sort((a, b) => a.title.compareTo(b.title));
        }
      });

      double lastWeekScoreHr = 0, lastWeekScoreHrForDia = 0;
      double totalValueForDia = 0;
      double totalValue = totalHeartScore - totalLastWeekScore;

      int totalAvg = totalSittingRecords.length - lastWeekRecords.length;

      double totalAvgHr = totalValue / totalAvg;


      if (title == 'heart_rate'.tr) {
        lastWeekScoreHr = 100 - (totalAvgHr - 65) * 1.82;
      } else if (title == 'oxygen_level'.tr) {
        if (totalAvgHr <= 96) {
          lastWeekScoreHr = 80 - ((96 - totalAvgHr) * 6.66);
        } else if (totalAvgHr > 96) {
          lastWeekScoreHr = 80 + ((totalAvgHr - 96) * 6.66);
        } else if (totalAvgHr > 99) {
          lastWeekScoreHr = 100;
        }
      } else if (title == 'hr_variability'.tr) {
        if (totalAvgHr > 120) {
          lastWeekScoreHr = 100;
        } else if (totalAvgHr < 120) {
          lastWeekScoreHr = 100 - ((120 - totalAvgHr) * 0.83);
        }
      } else if (title == 'pulse_pressure'.tr) {
        if (totalAvgHr == 40) {
          lastWeekScoreHr = 100;
        } else if (totalAvgHr < 40) {
          lastWeekScoreHr = 100 - ((40 - totalAvgHr) * 2.5);
        } else if (totalAvgHr > 40) {
          lastWeekScoreHr = 100 - ((totalAvgHr - 40) * 2.5);
        }
      } else if (title == 'arterial_pressure'.tr) {
        if (totalAvgHr == 85) {
          lastWeekScoreHr = 100;
        } else if (totalAvgHr < 85) {
          lastWeekScoreHr = 100 - ((85 - totalAvgHr) * 1.66);
        } else if (totalAvgHr > 85) {
          lastWeekScoreHr = 100 - ((totalAvgHr - 85) * 1.66);
        }
      } else if (title == 'blood_pressure'.tr) {
        if (totalAvgHr > 120) {
          lastWeekScoreHr = 100 - ((totalAvgHr - 120) * 1.6);
        } else if (totalAvgHr < 120) {
          lastWeekScoreHr = 100 - ((120 - totalAvgHr) * 3.2);
        }

        totalValueForDia = totalHeartScoreForDia - totalLastWeekScoreForDia;

        int totalAvgForDia =
            totalSittingRecordForDia.length - lastWeekRecordForDia.length;

        double totalAvgHrForDia = totalValueForDia / totalAvgForDia;

        printf('-----average--dia--->$totalAvgHrForDia');

        if (totalAvgHrForDia > 80) {
          lastWeekScoreHrForDia = 100 - ((totalAvgHrForDia - 80) * 5);
        } else if (totalAvgHrForDia < 80) {
          lastWeekScoreHrForDia = 100 - ((80 - totalAvgHrForDia) * 5);
        }

        double fc = totalDiaScore - lastWeekScoreHrForDia;

        double a = (fc / lastWeekScoreHrForDia) * 100;

        try {
          lastWeekResultForDia = a.toPrecision(2);
        } catch (e) {
          printf('exe-1417->$e');
        }

        //printf('---final--calculation--for--dia-->$fc<---->$a---->$lastWeekResultForDia');
        //printf('---total---hr--score--for--dia-$lastWeekScoreHrForDia--');

        getAverageForBloodPressure(avgHeartRateScore,
            avgSys: avgHeartRateScore, avgDia: avgHeartRateScoreForDia);
      }

      try {
        double fc = totalHrScore - lastWeekScoreHr;

        double a = (fc / lastWeekScoreHr) * 100;

        lastWeekResult = a.toPrecision(2);
        printf('---final--calculation---->$fc<---->$a---->$lastWeekResult');
        printf('---total---hr--score---$lastWeekScoreHr--');
      } catch (e) {
        printf('exe-1315---${e.toString()}');
      }

      double totalHeart = 0;
      int count = 0;

      double totalSystolic = 0;
      int countSystolic = 0;

      for (int i = 0; i < listWeekData.length; i++) {
        totalHeart = totalHeart + listWeekData[i].value;
        count = count + listWeekData[i].count;
      }

      double avg = totalHeart / count;
      averageBPMForWeek = avg.roundToDouble();

      printf('average--for--week---$averageBPMForWeek');
      averageForWeekSystolic = averageBPMForWeek;

      List<double> tempList = [];
      for (var i = 0; i < listWeekData.length; i++) {
        var value = listWeekData[i].value / listWeekData[i].count;
        if (value.toString() != 'NaN') {
          tempList.add(value);
        }
      }

      try {
        tempList.sort((a, b) => a.compareTo(b));
      } catch (e) {
        printf('exe----1474-->$e');
      }

      lowestBPMForWeek = tempList.first.roundToDouble();
      highestBPMForWeek = tempList.last.roundToDouble();

      highestForWeekSystolic = highestBPMForWeek;
      lowestForWeekSystolic = lowestBPMForWeek;

      List<double> tempListSystolic = [];
      for (int i = 0; i < listWeekDataForDiastolic.length; i++) {
        totalSystolic = totalSystolic + listWeekDataForDiastolic[i].value;
        countSystolic = countSystolic + listWeekDataForDiastolic[i].count;

        var value = listWeekDataForDiastolic[i].value;

        tempListSystolic.add(value);
      }

      tempListSystolic.sort((a, b) => a.compareTo(b));
      lowestForWeekDiastolic = tempListSystolic.first;
      highestForWeekDiastolic = tempListSystolic.last;

      double avgSystolic = totalSystolic / countSystolic;
      averageForWeekDiastolic = avgSystolic.roundToDouble();
    } else {
      printf('---------------else-------------------check----');
      listWeekData = listWeekData.reversed.toList();
      if (title == 'blood_pressure'.tr) {
        listWeekDataForDiastolic = listWeekDataForDiastolic.reversed.toList();
      }

      printf('no_record_found $weekDate');
      update();
    }
  }

  void getPreviousWeekDataForOneTime(
      DateTime dateTime, List<MeasureResult> totalAllRecords) {
    weekMeasureList.clear();
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
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      listWeekDataForDiastolic
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      weekList.add(date);

      //printf('weekListDate-${DateFormat('dd-MMM-yyyy HH:mm:ss').format(dt)} - ${dt.millisecondsSinceEpoch}');
    }
    weekNumberReversed = weekNumbers.reversed.toList();
    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(weekList.first)}';

    printf('weekDate->$weekDate');

    DateTime endDt = DateTime.fromMillisecondsSinceEpoch(
            weekList.last.millisecondsSinceEpoch)
        .subtract(const Duration(days: 1));
    DateTime startDt = DateTime.fromMillisecondsSinceEpoch(
            weekList.first.millisecondsSinceEpoch)
        .add(const Duration(days: 1));

    printf('start-->${DateFormat('dd-MMM-yyyy').format(endDt)}--->'
        '${DateFormat('dd-MMM-yyyy').format(startDt)}');

    weekMeasureList = totalAllRecords
        .where((item) =>
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isAfter(endDt) &&
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isBefore(startDt))
        .toList();

    getWeekDataForOneTime(weekMeasureList);
    isLoading.value = false;

    update();
  }

  void getNextWeekDataForOneTime(DateTime dateTime, List<MeasureResult> totalAllRecords) {
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

    // printf(
    //     'startPrev-${resultFormatter.format(weekList.last)} timeStamp ${weekList.last.millisecondsSinceEpoch}');
    // printf(
    //     'endPrev-${resultFormatter.format(weekList.first)} timeSTamp ${today.millisecondsSinceEpoch}');

    printf('weekDateNext->$weekDate');

    DateTime endDt = DateTime.fromMillisecondsSinceEpoch(
            weekList.last.millisecondsSinceEpoch)
        .subtract(const Duration(days: 1));
    DateTime startDt = DateTime.fromMillisecondsSinceEpoch(
            weekList.first.millisecondsSinceEpoch)
        .add(const Duration(days: 1));

    printf('start-->${DateFormat('dd-MMM-yyyy').format(endDt)}--->'
        '${DateFormat('dd-MMM-yyyy').format(startDt)}');

    weekMeasureList = totalAllRecords
        .where((item) =>
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isAfter(endDt) &&
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isBefore(startDt))
        .toList();

    getWeekDataForOneTime(weekMeasureList);

    update();
  }

  void getMonthDataForFirstTime(
      selectedMonth, List<MeasureResult> totalAllRecords) {
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

    printf('Total Days in Month first-time : ${lastDateOfMonth.day}');

    prepareWeeksOfMonthData(firstDateOfMonth, lastDateOfMonth);

    ///Fetching from Firebase

    // firstDateOfMonth.millisecondsSinceEpoch

    DateTime endDt = DateTime.fromMillisecondsSinceEpoch(
            lastDateOfMonth.millisecondsSinceEpoch)
        .add(const Duration(days: 1));
    DateTime startDt = DateTime.fromMillisecondsSinceEpoch(
            firstDateOfMonth.millisecondsSinceEpoch)
        .subtract(const Duration(days: 1));

    printf('start-month->${DateFormat('dd-MMM-yyyy').format(startDt)}--->'
        '${DateFormat('dd-MMM-yyyy').format(endDt)}');

    monthMeasureList = totalAllRecords
        .where((item) =>
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isAfter(startDt) &&
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isBefore(endDt))
        .toList();

    printf("--total--month-->${monthMeasureList.length}");
    // final ref = dbMeasure
    //    .child(userId)
    //    .orderByChild('timeStamp')
    //    .startAt(firstDateOfMonth.millisecondsSinceEpoch)
    //    .endAt(lastDateOfMonth.millisecondsSinceEpoch);

    if (monthMeasureList.isNotEmpty) {
      monthMeasureList
          .sort((a, b) => a.timeStamp ?? 0.compareTo(b.timeStamp ?? 0));

      var groupByDate = groupBy(monthMeasureList, (obj) => obj.dateTime);
      groupByDate.forEach((date, list) {
        int sumHearRate = 0;
        int sumDiastolic = 0;
        list.forEach((listItem) {
          if (title == 'heart_rate'.tr) {
            int hrt = int.parse(listItem.heartRate == null
                ? "0"
                : (listItem.heartRate!.isNotEmpty ? listItem.heartRate! : "0"));
            sumHearRate = sumHearRate + hrt;
          } else if (title == 'oxygen_level'.tr) {
            double hrt = double.parse(listItem.oxygen == null
                ? "0"
                : (listItem.oxygen!.isNotEmpty ? listItem.oxygen! : "0"));
            sumHearRate = sumHearRate + hrt.toInt();
          } else if (title == 'hr_variability'.tr) {
            double hrt = double.parse(listItem.hrVariability == null
                ? "0"
                : (listItem.hrVariability!.isNotEmpty
                    ? listItem.hrVariability!
                    : "0"));
            sumHearRate = sumHearRate + hrt.toInt();
          } else if (title == 'pulse_pressure'.tr) {
            double hrt = double.parse(listItem.pulsePressure == null
                ? "0"
                : (listItem.pulsePressure!.isNotEmpty
                    ? listItem.pulsePressure!
                    : "0"));
            sumHearRate = sumHearRate + hrt.toInt();
          } else if (title == 'arterial_pressure'.tr) {
            double hrt = double.parse(listItem.arterialPressure == null
                ? "0"
                : (listItem.arterialPressure!.isNotEmpty
                    ? listItem.arterialPressure!
                    : "0"));
            sumHearRate = sumHearRate + hrt.toInt();
          } else if (title == 'blood_pressure'.tr) {
            String input = listItem.bloodPressure.toString();
            List values = input.split("/");

            double s = double.parse(values[0].toString());
            double d = double.parse(values[1].toString());

            double hrt = s;
            sumHearRate = sumHearRate + hrt.toInt();

            double dd = d;
            sumDiastolic = sumDiastolic + dd.toInt();
          } else if (title == 'heart_health'.tr)
          {
            String input = listItem.bloodPressure.toString();
            List values = input.split("/");
            double s = double.parse(values[0].toString());

            double hrt = s;
            sumHearRate = sumHearRate + hrt.toInt();
          }
          else if (title == AppConstants.heartStrain)
          {
            String input = listItem.bloodPressure.toString();
            List values = input.split("/");
            //double s = double.parse(values[0].toString());

            int s = calculateHeartStrain(
                hrv: double.parse(listItem.hrVariability.toString()),
                bloodPressure: input.toString())
                .toInt();

            int hrt = s;
            sumHearRate = sumHearRate + hrt.toInt();
          }
          else if (title == 'heart_function'.tr) {
            double s = double.parse(listItem.pulsePressure.toString());
            double d = double.parse(listItem.arterialPressure.toString());

            double hrt = s;
            sumHearRate = sumHearRate + hrt.toInt();

            double dd = d;
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

      printf(
          'Month-----avg-->$averageForMonthSystolic-----high-->$highestForMonthSystolic-----low-->$lowestForMonthSystolic');

      for (int i = 0; i < weekOfMonthForDiastolic.length; i++) {
        var value = weekOfMonthForDiastolic[i].avgMeasure ?? 0;

        if (value > highestForMonthDiastolic) {
          highestForMonthDiastolic = value;
        }

        if (value < lowestForMonthDiastolic) {
          lowestForMonthDiastolic = value;
        }

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
  }

  //----------------------------------------------------------------------------
  ///-----------------
  Future<void> getHeartRateScore() async {
    List<MeasureResult> totalRecords = [];

    //isLoading.value = true;
    // Get.context!.loaderOverlay.show();

    DataSnapshot snapshot = await dbMeasure.child(userId).get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        totalRecords.add(activityModel);

        if (title == 'heart_rate'.tr) {
          if (activityModel.activity.toString() == 'sitting'.tr ||
              activityModel.activity.toString() == 'sleeping'.tr) {
            totalHeartScore = totalHeartScore +
                double.parse(activityModel.heartRate.toString());
            totalSittingRecords
                .add(double.parse(activityModel.heartRate.toString()));
          }

          totalAllTimeValue = totalAllTimeValue +
              double.parse(activityModel.heartRate.toString());
          totalAllTimeRecords
              .add(double.parse(activityModel.heartRate.toString()));
        } else if (title == 'oxygen_level'.tr) {
          scoreTitle = 'oxygen_level_score'.tr; //Oxygen Level Score
          avgRestingTitle = 'avg_resting_spo2'.tr;
          maxRestingTitle = 'max_resting_spo2'.tr;

          if (activityModel.activity.toString() == 'sitting'.tr ||
              activityModel.activity.toString() == 'sleeping'.tr) {
            totalHeartScore =
                totalHeartScore + double.parse(activityModel.oxygen.toString());
            totalSittingRecords
                .add(double.parse(activityModel.oxygen.toString()));
          }
          totalAllTimeValue =
              totalAllTimeValue + double.parse(activityModel.oxygen.toString());
          totalAllTimeRecords
              .add(double.parse(activityModel.oxygen.toString()));
        } else if (title == 'hr_variability'.tr) {
          scoreTitle = 'hr_variability_score'.tr;
          avgRestingTitle = 'avg_resting_hrv'.tr;
          maxRestingTitle = 'max_resting_hrv'.tr;

          if (activityModel.activity.toString() == 'sitting'.tr ||
              activityModel.activity.toString() == 'sleeping'.tr) {
            totalHeartScore = totalHeartScore +
                double.parse(activityModel.hrVariability.toString());
            totalSittingRecords
                .add(double.parse(activityModel.hrVariability.toString()));
          }

          totalAllTimeValue = totalAllTimeValue +
              double.parse(activityModel.hrVariability.toString());
          totalAllTimeRecords
              .add(double.parse(activityModel.hrVariability.toString()));
        } else if (title == 'pulse_pressure'.tr) {
          scoreTitle = 'pulse_pressure_score'.tr;
          avgRestingTitle = 'avg_resting_pp'.tr;
          maxRestingTitle = 'max_resting_pp'.tr;

          if (activityModel.activity.toString() == 'sitting'.tr ||
              activityModel.activity.toString() == 'sleeping'.tr) {
            if (activityModel.pulsePressure.toString() == '0') {
              //double v = double.parse(activityModel.pulsePressure.toString());
              //printf('----zero---$v-----date --->${activityModel.dateTime}');
            } else {
              totalHeartScore = totalHeartScore +
                  double.parse(activityModel.pulsePressure.toString());
              totalSittingRecords
                  .add(double.parse(activityModel.pulsePressure.toString()));
            }
          }

          if (activityModel.pulsePressure.toString() == '0') {
            //double v = double.parse(activityModel.pulsePressure.toString());
            //printf('----zero---$v-----date --->${activityModel.dateTime}');
          } else {
            totalAllTimeValue = totalAllTimeValue +
                double.parse(activityModel.pulsePressure.toString());
            totalAllTimeRecords
                .add(double.parse(activityModel.pulsePressure.toString()));
          }
        } else if (title == 'arterial_pressure'.tr) {
          scoreTitle = 'arterial_pressure_score'.tr;
          avgRestingTitle = 'avg_resting_ap'.tr;
          maxRestingTitle = 'max_resting_ap'.tr;

          if (activityModel.activity.toString() == 'sitting'.tr ||
              activityModel.activity.toString() == 'sleeping'.tr) {
            if (activityModel.arterialPressure.toString() == '0') {
            } else {
              totalHeartScore = totalHeartScore +
                  double.parse(activityModel.arterialPressure.toString());
              totalSittingRecords
                  .add(double.parse(activityModel.arterialPressure.toString()));
            }
          }

          if (activityModel.arterialPressure.toString() == '0') {
          } else {
            totalAllTimeValue = totalAllTimeValue +
                double.parse(activityModel.arterialPressure.toString());
            totalAllTimeRecords
                .add(double.parse(activityModel.arterialPressure.toString()));
          }
        } else if (title == 'blood_pressure'.tr) {
          scoreTitle = 'blood_pressure_score'.tr;
          avgRestingTitle = 'avg_resting_sys'.tr;
          maxRestingTitle = 'max_resting_sys'.tr;

          String input = activityModel.bloodPressure.toString();
          List values = input.split("/");

          double s = double.parse(values[0].toString());
          double d = double.parse(values[1].toString());

          if (activityModel.activity.toString() == 'sitting'.tr ||
              activityModel.activity.toString() == 'sleeping'.tr) {
            totalHeartScore = totalHeartScore + s;
            totalSittingRecords.add(s);

            totalHeartScoreForDia = totalHeartScoreForDia + d;
            totalSittingRecordForDia.add(d);
          }

          totalAllTimeValue = totalAllTimeValue + s;
          totalAllTimeRecords.add(s);

          totalAllTimeValueForDia = totalAllTimeValueForDia + d;
          totalAllTimeRecordsForDia.add(d);
        }

        update();
      });

      printf('--total--records---->${totalAllTimeRecords.length}');
    } else {
      isLoading.value = false;
      // Get.context!.loaderOverlay.hide();
      printf('no_heart_rate_score_found');
    }
    isLoading.value = false;
    //Get.context!.loaderOverlay.hide();

    if (totalSittingRecords.isNotEmpty) {
      double restingHrForDia = 0;
      double restingHr = 0;
      double avg = totalHeartScore / totalSittingRecords.length;

      avgForAllTimeRecords = totalAllTimeValue / totalAllTimeRecords.length;

      avgForAllTimeRecordsForDia =
          totalAllTimeValueForDia / totalAllTimeRecordsForDia.length;

      avgForAllTimeRecords = avgForAllTimeRecords.toPrecision(1);
      try {
        avgForAllTimeRecordsForDia = avgForAllTimeRecordsForDia.toPrecision(1);
      } catch (e) {
        printf('exe-524-->${e.toString()}');
      }

      // printf(
      //     '----total---all--time--->${totalAllTimeRecords.length}---sitting----all--time-->${totalSittingRecords.length}');
      // printf(
      //     '-----average----->$avg----->all--time--->$avgForAllTimeRecords----for--dia--->$avgForAllTimeRecordsForDia');

      avgHeartRateScore = avg.toPrecision(1);

      if (title == 'heart_rate'.tr) {
        restingHr = 100 - (avg - 65) * 1.82;

        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore >= 85) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'tachycardia'.tr}';
        } else if (avgHeartRateScore < 60) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'bradycardia'.tr}';
        } else if (avgHeartRateScore >= 60 && avgHeartRateScore < 85) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        } else {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        }
      } else if (title == 'oxygen_level'.tr) {
        if (avg <= 96) {
          restingHr = 80 - ((96 - avg) * 6.66);
        } else if (avg > 96) {
          restingHr = 80 + ((avg - 96) * 6.66);
        } else if (avg > 99) {
          restingHr = 100;
        }

        // for condition
        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore > 0 && avgHeartRateScore < 94) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'severe_hypoxia'.tr}';
        } else if (avgHeartRateScore >= 94 && avgHeartRateScore < 96) {
          condition = '${'condition'.tr} : ${'signs_of'.tr} ${'hypoxia'.tr}';
        } else if (avgHeartRateScore >= 96) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        }
      } else if (title == 'hr_variability'.tr) {
        double hrv = 0;
        if (avg > 120) {
          restingHr = 100;
        } else if (avg < 120) {
          restingHr = 100 - ((120 - avg) * 0.83);
          avg = avg.toPrecision(1);
          hrv = avgForAllTimeRecords + 40;
        }

        todayGoalMessage =
            '${'your_average_hrv_is'.tr} $avgForAllTimeRecords, ${'try_maintaining_an_average_hrv_for'.tr} $hrv';

        // for condition
        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore >= 100) {
          condition = '${'condition'.tr} : ${'well_regulated'.tr}';
        } else if (avgHeartRateScore >= 50 && avgHeartRateScore < 100) {
          condition = '${'condition'.tr} : ${'average_variability'.tr}';
        } else if (avgHeartRateScore > 0 && avgHeartRateScore < 50) {
          condition = '${'condition'.tr} : ${'reduced_variability'.tr}';
        }
      } else if (title == 'pulse_pressure'.tr) {
        double pp = 0;
        avg = avg.toPrecision(1);
        if (avg == 40) {
          restingHr = 100;
        } else if (avg < 40) {
          restingHr = 100 - ((40 - avg) * 2.5);
          pp = avgForAllTimeRecords + 2;
        } else if (avg > 40) {
          restingHr = 100 - ((avg - 40) * 2.5);
          pp = avgForAllTimeRecords - 2;
        }

        todayGoalMessage =
            '${'your_average_pulse_pressure_is'.tr} $avgForAllTimeRecords ${'try_maintaining_an_average_pulse_pressure_of'.tr} $pp';

        // for condition
        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore > 48) {
          condition = '${'condition'.tr} : ${'wide_pulse_pressure'.tr}';
        } else if (avgHeartRateScore >= 32 && avgHeartRateScore <= 48) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        } else if (avgHeartRateScore > 0 && avgHeartRateScore < 32) {
          condition = '${'condition'.tr} : ${'narrow_pulse_pressure'.tr}';
        }
      } else if (title == 'arterial_pressure'.tr) {
        double ap = 0;
        avg = avg.toPrecision(1);
        if (avg == 85) {
          restingHr = 100;
        } else if (avg < 85) {
          restingHr = 100 - ((85 - avg) * 1.66);
          ap = avgForAllTimeRecords + 2;
        } else if (avg > 85) {
          restingHr = 100 - ((avg - 85) * 1.66);
          ap = avgForAllTimeRecords - 2;
        }
        todayGoalMessage =
            '${'your_average_arterial_pressure_is'.tr} $avgForAllTimeRecords ${'try_maintaining_an_average_arterial_pressure_of'.tr} $ap';

        // for condition
        totalHrScore = restingHr;
        finalRestingScore = restingHr.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        if (avgHeartRateScore > 100) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'increased_heart_function'.tr}';
        } else if (avgHeartRateScore >= 70 && avgHeartRateScore <= 100) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        } else if (avgHeartRateScore > 0 && avgHeartRateScore < 70) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'decreased_heart_function'.tr}';
        }
      } else if (title == 'blood_pressure'.tr) {
        double bpSys = 0, bpDia = 0;

        if (avg > 120) {
          restingHr = 100 - ((avg - 120) * 1.6);
          bpSys = avgForAllTimeRecords - 3;
        } else if (avg < 120) {
          restingHr = 100 - ((120 - avg) * 3.2);
          bpSys = avgForAllTimeRecords + 3;
        } else if (avg == 120) {
          restingHr = 100;
        } else if (avg == 122 || avg == 121 || avg == 119 || avg == 120) {
          bpSys = 120;
        }

        // for condition sys

        if (avg >= 115 && avg < 118) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'mild_hypotension'.tr}';
        } else if (avg >= 110 && avg < 115) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'moderate_hypotension'.tr}';
        } else if (avg >= 118 && avg < 122) {
          condition = '${'condition'.tr} : ${'normal'.tr}';
        } else if (avg >= 122 && avg < 128) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'elevated_blood_pressure'.tr}';
        } else if (avg >= 128 && avg < 140) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'hypertension'.tr}';
        } else if (avg >= 140) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'severe_hypertension'.tr}';
        } else if (avg > 0 && avg < 110) {
          condition =
              '${'condition'.tr} : ${'signs_of'.tr} ${'severe_hypertension'.tr}';
        }

        double avgDia = totalHeartScoreForDia / totalSittingRecordForDia.length;

        avgHeartRateScoreForDia = avgDia.toPrecision(1);

        printf('-----average--dia--->$avgDia-----average---sys-->$avg');

        if (avgDia > 80) {
          restingHrForDia = 100 - ((avgDia - 80) * 5);
          bpDia = avgForAllTimeRecordsForDia - 3;
        } else if (avgDia < 80) {
          restingHrForDia = 100 - ((80 - avgDia) * 5);
          bpDia = avgForAllTimeRecordsForDia + 3;
        } else if (avgDia == 78 ||
            avgDia == 79 ||
            avgDia == 81 ||
            avgDia == 82) {
          bpDia = 80;
        }
        //printf('-----score--for--sys--->$restingHr----dia--->$restingHrForDia');

        if (avg >= 118 && avg < 122) {
          todayGoalMessage = 'your_blood_pressure_is_well_maintained'.tr;
        } else if (avg >= 122 && avg < 124) {
          todayGoalMessage = 'your_blood_pressure_is_well_maintained'.tr;
        } else if (avg >= 116 && avg < 118 && avg >= 114) {
          todayGoalMessage = 'your_blood_pressure_is_well_maintained'.tr;
        } else {
          todayGoalMessage =
              '${'your_average_bp_is'.tr} $avgForAllTimeRecords/$avgForAllTimeRecordsForDia, ${'try_maintaining_an_average_bp'.tr} ${bpSys.toPrecision(1)}/${bpDia.toPrecision(1)}';
        }
      }

      if (title == 'blood_pressure'.tr) {
        totalHrScore = restingHr;

        finalRestingScore =
            (restingHr.toPrecision(1) + restingHrForDia.toPrecision(1)) / 2;

        finalRestingScore = finalRestingScore.toPrecision(1);

        totalSittingRecords.sort();
        maxRestingHr = totalSittingRecords.last.toPrecision(1);

        totalSittingRecordForDia.sort();
        maxRestingForDia = totalSittingRecordForDia.last.toPrecision(1);
      }

      // printf(
      //     '---final---avg--resting---${avg.roundToDouble()}---avgScore-->$avgHeartRateScore');
      // printf(
      //     '---total--heart-rate--$totalHeartScore---avg-->$finalRestingScore---max-->$maxRestingHr');
      //
      // printf(
      //     '---total--records------${totalRecords.length}---total-sitting---${totalSittingRecords.length}');
    }
  }

  void getLastUserId() async {
    printf('get_user_id_offline');
    try {
      userId = await Utility.getUserId();
      printf('userIdOffline-$userId');
      getHeartRateValueForYesterdayOffline(
          resultFormatter.format(yesterdayDate));
      getTodayDataOffline(resultFormatter.format(today));
      getCurrentWeekOffline(today);
      getMonthDataOffline(currentMonth);
      update();
    } catch (exe) {
      printf('exe-userId$exe');
    }
  }

  /// Return LAST DAY OF THE WEEK
  ///
  ///
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  /// Return FIRST DAY OF THE WEEK
  ///
  ///
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    // return dateTime.subtract(Duration(days: dateTime.weekday - 1));
    int currentDay = dateTime.weekday;
    DateTime firstDayOfWeek = dateTime.subtract(Duration(days: currentDay));
    return firstDayOfWeek;
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

  /// Method for fetching the Monthly data and show it as week wise
  /// @param selectedMonth - DateTime object of the any date of the targeted month
  ///
  /// @author Yagna Joshi
  Future<void> getMonthData(selectedMonth) async {
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

    printf('Total Days in Month  : ${lastDateOfMonth.day}');

    prepareWeeksOfMonthData(firstDateOfMonth, lastDateOfMonth);

    ///Fetching from Firebase
    final ref = dbMeasure
        .child(userId)
        .orderByChild('timeStamp')
        .startAt(firstDateOfMonth.millisecondsSinceEpoch)
        .endAt(lastDateOfMonth.millisecondsSinceEpoch);

    ref.once().then((value) {
      if (value.snapshot.exists) {
        //printf('Retrieved Records-${value.snapshot.children.length}');
        value.snapshot.children.forEach((element) {
          final data = Map<String, dynamic>.from(element.value as Map);
          MeasureResult measureModel = MeasureResult.fromJson(data);
          //printf('Retrieved Records-${measureModel.dateTime} / ${measureModel.timeStamp} / ${element.key}');
          monthMeasureList.add(measureModel);
          update();
        });

        printf('-month--total-->${monthMeasureList.length}');

        monthMeasureList
            .sort((a, b) => a.timeStamp ?? 0.compareTo(b.timeStamp ?? 0));

        var groupByDate = groupBy(monthMeasureList, (obj) => obj.dateTime);
        groupByDate.forEach((date, list) {
          int sumHearRate = 0;
          int sumDiastolic = 0;
          list.forEach((listItem) {
            if (title == 'heart_rate'.tr) {
              int hrt = int.parse(listItem.heartRate == null
                  ? "0"
                  : (listItem.heartRate!.isNotEmpty
                      ? listItem.heartRate!
                      : "0"));
              sumHearRate = sumHearRate + hrt;
            } else if (title == 'oxygen_level'.tr) {
              double hrt = double.parse(listItem.oxygen == null
                  ? "0"
                  : (listItem.oxygen!.isNotEmpty ? listItem.oxygen! : "0"));
              sumHearRate = sumHearRate + hrt.toInt();
            } else if (title == 'hr_variability'.tr) {
              double hrt = double.parse(listItem.hrVariability == null
                  ? "0"
                  : (listItem.hrVariability!.isNotEmpty
                      ? listItem.hrVariability!
                      : "0"));
              sumHearRate = sumHearRate + hrt.toInt();
            } else if (title == 'pulse_pressure'.tr) {
              double hrt = double.parse(listItem.pulsePressure == null
                  ? "0"
                  : (listItem.pulsePressure!.isNotEmpty
                      ? listItem.pulsePressure!
                      : "0"));
              sumHearRate = sumHearRate + hrt.toInt();
            } else if (title == 'arterial_pressure'.tr) {
              double hrt = double.parse(listItem.arterialPressure == null
                  ? "0"
                  : (listItem.arterialPressure!.isNotEmpty
                      ? listItem.arterialPressure!
                      : "0"));
              sumHearRate = sumHearRate + hrt.toInt();
            } else if (title == 'blood_pressure'.tr) {
              String input = listItem.bloodPressure.toString();
              List values = input.split("/");
              //printf('bp1-month--${values[0]} ${values[1]}');

              double s = double.parse(values[0].toString());
              double d = double.parse(values[1].toString());

              double hrt = s;
              sumHearRate = sumHearRate + hrt.toInt();

              double dd = d;
              sumDiastolic = sumDiastolic + dd.toInt();
            } else if (title == 'heart_health'.tr) {
              String input = listItem.bloodPressure.toString();
              List values = input.split("/");
              double s = double.parse(values[0].toString());

              double hrt = s;
              sumHearRate = sumHearRate + hrt.toInt();
            }
            /*else if (title == AppConstants.strokeVolume)
            {
              double s = double.parse(listItem.pulsePressure.toString());

              double hrt = s;
              sumHearRate = sumHearRate + hrt.toInt();
            } */
            else if (title == 'heart_function'.tr) {
              /*double s = double.parse(listItem.arterialPressure.toString());

              double hrt = s;
              sumHearRate = sumHearRate + hrt.toInt();*/

              //String input = listItem.bloodPressure.toString();
              //List values = input.split("/");
              //printf('bp1-month--${values[0]} ${values[1]}');

              double s = double.parse(listItem.pulsePressure.toString());
              double d = double.parse(listItem.arterialPressure.toString());

              double hrt = s;
              sumHearRate = sumHearRate + hrt.toInt();

              double dd = d;
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

        // TODO month
        double totalHeart = 0;
        double totalDiastolic = 0;

        for (int i = 0; i < weekOfMonth.length; i++) {
          /*if (kDebugMode) {
            print('Final Record Month:  ${weekOfMonth[i].weekStartDate?.day}/${weekOfMonth[i].weekStartDate?.month} to ${weekOfMonth[i].weekEndDate?.day}/${weekOfMonth[i].weekEndDate?.month}  Week :${weekOfMonth[i].weekOfYear} HeartRate :${weekOfMonth[i].avgMeasure ?? 0}');
          }*/
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

          //monthGraphPlot[i].value = weekOfMonth[i].avgMeasure ?? 0;
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

        printf(
            'Month-----avg-->$averageForMonthSystolic-----high-->$highestForMonthSystolic-----low-->$lowestForMonthSystolic');

        for (int i = 0; i < weekOfMonthForDiastolic.length; i++) {
          /*if (kDebugMode) {
            print(
                'Final Record Month Diastolic :  ${weekOfMonthForDiastolic[i].weekStartDate?.day}/${weekOfMonthForDiastolic[i].weekStartDate?.month} to ${weekOfMonthForDiastolic[i].weekEndDate?.day}/${weekOfMonthForDiastolic[i].weekEndDate?.month}  Week :${weekOfMonthForDiastolic[i].weekOfYear} HeartRate :${weekOfMonthForDiastolic[i].avgMeasure ?? 0}');
          }*/

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

  Future<void> getMonthDataOffline(selectedMonth) async {
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

    Database db = await dbHelper.database;

    final List<Map<String, dynamic>> records = await db.rawQuery(
        "SELECT * FROM MeasureTable WHERE timeStamp BETWEEN ${firstDateOfMonth.millisecondsSinceEpoch} AND ${lastDateOfMonth.millisecondsSinceEpoch}");

    printf('monthRecordsOffline-${records.length}');

    if (records.isNotEmpty) {
      records.forEach((element) {
        final data = Map<String, dynamic>.from(element);
        MeasureResult measureModel = MeasureResult.fromJson(data);
        printf(
            'Retrieved Records offline-${measureModel.dateTime} / ${measureModel.timeStamp}');
        monthMeasureList.add(measureModel);
        update();
      });
    }

    printf('monthDataOffline-${monthMeasureList.length}');

    if (monthMeasureList.isNotEmpty) {
      monthMeasureList
          .sort((a, b) => a.timeStamp ?? 0.compareTo(b.timeStamp ?? 0));

      var groupByDate = groupBy(monthMeasureList, (obj) => obj.dateTime);
      groupByDate.forEach((date, list) {
        int sumHearRate = 0;
        int sumDiastolic = 0;
        list.forEach((listItem) {
          if (title == 'heart_rate'.tr) {
            int hrt = int.parse(listItem.heartRate == null
                ? "0"
                : (listItem.heartRate!.isNotEmpty ? listItem.heartRate! : "0"));
            sumHearRate = sumHearRate + hrt;
          } else if (title == 'oxygen_level'.tr) {
            double hrt = double.parse(listItem.oxygen == null
                ? "0"
                : (listItem.oxygen!.isNotEmpty ? listItem.oxygen! : "0"));
            sumHearRate = sumHearRate + hrt.toInt();
          } else if (title == 'hr_variability'.tr) {
            double hrt = double.parse(listItem.hrVariability == null
                ? "0"
                : (listItem.hrVariability!.isNotEmpty
                    ? listItem.hrVariability!
                    : "0"));
            sumHearRate = sumHearRate + hrt.toInt();
          } else if (title == 'pulse_pressure'.tr) {
            double hrt = double.parse(listItem.pulsePressure == null
                ? "0"
                : (listItem.pulsePressure!.isNotEmpty
                    ? listItem.pulsePressure!
                    : "0"));
            sumHearRate = sumHearRate + hrt.toInt();
          } else if (title == 'arterial_pressure'.tr) {
            double hrt = double.parse(listItem.arterialPressure == null
                ? "0"
                : (listItem.arterialPressure!.isNotEmpty
                    ? listItem.arterialPressure!
                    : "0"));
            sumHearRate = sumHearRate + hrt.toInt();
          } else if (title == 'blood_pressure'.tr) {
            String input = listItem.bloodPressure.toString();
            List values = input.split("/");
            printf('bp1offline-${values[0]} ${values[1]}');

            double s = double.parse(values[0].toString());
            double d = double.parse(values[1].toString());

            double hrt = s;
            sumHearRate = sumHearRate + hrt.toInt();

            double dd = d;
            sumDiastolic = sumDiastolic + dd.toInt();
          } else if (title == 'heart_health'.tr) {
            String input = listItem.bloodPressure.toString();
            List values = input.split("/");
            double s = double.parse(values[0].toString());

            double hrt = s;
            sumHearRate = sumHearRate + hrt.toInt();
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
          if (kDebugMode) {
            print(
                'FilterDateOffline $i: ${filterData[i].weekOfYear} - ${filterData[i].avgMeasure ?? 0}');
          }
          filterData[i].avgMeasure = avgHrt;
        }

        for (int i = 0; i < filterDataForDiastolic.length; i++) {
          if (kDebugMode) {
            print(
                'FilterDateOffline $i: ${filterData[i].weekOfYear} - ${filterData[i].avgMeasure ?? 0}');
          }
          filterDataForDiastolic[i].avgMeasure = avhDiastolic;
        }
      });

      for (int i = 0; i < weekOfMonth.length; i++) {
        var round = weekOfMonth[i].avgMeasure ?? 0;
        monthGraphPlot[i].value = round.roundToDouble();
      }
      for (int i = 0; i < weekOfMonthForDiastolic.length; i++) {
        var round = weekOfMonthForDiastolic[i].avgMeasure ?? 0;
        monthGraphPlotForDiastolic[i].value = round.roundToDouble();
      }
      update();
    }
  }

  /// calculate no of days between the given dates
  ///
  /// @author: Yagna Joshi
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  /// calculate week of the given date's Month
  ///
  /// @author: Yagna Joshi
  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  void getCurrentMonthData(dateTime) {
    var lastDayDateTime = (dateTime.month < 12)
        ? DateTime(dateTime.year, dateTime.month + 1, 0)
        : DateTime(dateTime.year + 1, 1, 0);

    printf('lastDate-${resultFormatter.format(lastDayDateTime)}');
    var date = DateTime(dateTime.year, dateTime.month, 1).toString();
    var firstDayDateTime = DateTime.parse(date);
    printf('firstDate-${resultFormatter.format(firstDayDateTime)}');

    final ref = dbMeasure
        .child(userId)
        .orderByChild('dateTime')
        .startAt(resultFormatter.format(firstDayDateTime))
        .endAt(resultFormatter.format(lastDayDateTime));

    ref.once().then((value) {
      if (value.snapshot.exists) {
        printf('totalChildrenForMonth-${value.snapshot.children.length}');

        value.snapshot.children.forEach((element) {
          final data = Map<String, dynamic>.from(element.value as Map);
          MeasureResult measureModel = MeasureResult.fromJson(data);
          monthMeasureList.add(measureModel);
          update();
        });
      }
    });

    printf('totalMonthData-${monthMeasureList.length}');
  }

  Future<void> getWeekData(
      {required int startDate, required int endDate}) async {
    printf('-----------call_week-$startDate $endDate $userId------------');

    weekMeasureList.clear();
    isLoading.value = true;
    //Get.context!.loaderOverlay.show();

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
        weekMeasureList.forEach((e) {
          printf(
              'week-online--->${e.dateTime}-->${e.measureTime}-->${e.heartRate}');
          var dateTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(e.timeStamp.toString()));

          //printf('weekDataList--${weekDateList.length}');
          if (weekDateList.contains(resultFormatter.format(dateTime))) {
            if (listWeekData.isNotEmpty) {
              int index = listWeekData.indexWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              double hr = 0.0;
              int count = 0;

              double d = 0.0;
              int countD = 0;

              if (title == 'heart_rate'.tr) {
                hr = listWeekData[index].value +
                    double.parse(e.heartRate.toString());
                count = listWeekData[index].count;

                if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                  totalLastWeekScore =
                      totalLastWeekScore + double.parse(e.heartRate.toString());
                  lastWeekRecords.add(double.parse(e.heartRate.toString()));
                }
              } else if (title == 'oxygen_level'.tr) {
                hr = listWeekData[index].value +
                    double.parse(e.oxygen.toString());
                count = listWeekData[index].count;

                if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                  totalLastWeekScore =
                      totalLastWeekScore + double.parse(e.oxygen.toString());
                  lastWeekRecords.add(double.parse(e.oxygen.toString()));
                }
              } else if (title == 'hr_variability'.tr) {
                hr = listWeekData[index].value +
                    double.parse(e.hrVariability.toString());
                count = listWeekData[index].count;

                if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                  totalLastWeekScore = totalLastWeekScore +
                      double.parse(e.hrVariability.toString());
                  lastWeekRecords.add(double.parse(e.hrVariability.toString()));
                }
              } else if (title == 'pulse_pressure'.tr) {
                hr = listWeekData[index].value +
                    double.parse(e.pulsePressure.toString());
                count = listWeekData[index].count;

                if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                  totalLastWeekScore = totalLastWeekScore +
                      double.parse(e.pulsePressure.toString());
                  lastWeekRecords.add(double.parse(e.pulsePressure.toString()));
                }
              } else if (title == 'arterial_pressure'.tr) {
                hr = listWeekData[index].value +
                    double.parse(e.arterialPressure.toString());
                count = listWeekData[index].count;

                if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                  totalLastWeekScore = totalLastWeekScore +
                      double.parse(e.arterialPressure.toString());
                  lastWeekRecords
                      .add(double.parse(e.arterialPressure.toString()));
                }
              } else if (title == 'blood_pressure'.tr) {
                String input = e.bloodPressure.toString();
                List values = input.split("/");

                double s = double.parse(values[0].toString());
                double dd = double.parse(values[1].toString());

                if (e.activity == 'sitting'.tr || e.activity == 'sleeping'.tr) {
                  totalLastWeekScore = totalLastWeekScore + s;
                  lastWeekRecords.add(s);

                  totalLastWeekScoreForDia = totalLastWeekScoreForDia + dd;
                  lastWeekRecordForDia.add(dd);
                }

                hr = listWeekData[index].value + s;
                count = listWeekData[index].count;

                d = listWeekDataForDiastolic[index].value + dd;
                countD = listWeekDataForDiastolic[index].count;

                // printf('---------systolic data---$dd --- $d-----count--$countD');
              } else if (title == 'heart_function'.tr) {
                hr = listWeekData[index].value +
                    double.parse(e.pulsePressure.toString());
                count = listWeekData[index].count;

                d = listWeekDataForDiastolic[index].value +
                    double.parse(e.arterialPressure.toString());
                countD = listWeekDataForDiastolic[index].count;

                //listWeekDataForDiastolic.add(WeekModel(e.timeStamp.toString(), dd, 1));
              } else if (title == 'heart_health'.tr) {
                String input = e.bodyHealth.toString();
                List values = input.split("/");
                double s = double.parse(values[0].toString());

                //printf('heartHealth-$s');
                hr = listWeekData[index].value + s;
                count = listWeekData[index].count;
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

              //printf('856------hr-->$hr---->count---->$count-->count--->$countD-->');

              listWeekData
                  .add(WeekModel(e.timeStamp.toString(), hr, count + 1));

              listWeekDataForDiastolic
                  .add(WeekModel(e.timeStamp.toString(), d, countD + 1));
            }
            listWeekData.sort((a, b) => a.title.compareTo(b.title));
            listWeekDataForDiastolic.sort((a, b) => a.title.compareTo(b.title));
          }
        });

        double lastWeekScoreHr = 0, lastWeekScoreHrForDia = 0;
        double totalValueForDia = 0;
        double totalValue = totalHeartScore - totalLastWeekScore;
        printf(
            '------total-last-sore---$totalLastWeekScore------>${lastWeekRecords.length}');

        int totalAvg = totalSittingRecords.length - lastWeekRecords.length;

        printf('---total---value---$totalValue---totalAvg---$totalAvg--');

        double totalAvgHr = totalValue / totalAvg;

        printf('---total--avg--hr---$totalAvgHr--');

        if (title == 'heart_rate'.tr) {
          lastWeekScoreHr = 100 - (totalAvgHr - 65) * 1.82;
        } else if (title == 'oxygen_level'.tr) {
          if (totalAvgHr <= 96) {
            lastWeekScoreHr = 80 - ((96 - totalAvgHr) * 6.66);
          } else if (totalAvgHr > 96) {
            lastWeekScoreHr = 80 + ((totalAvgHr - 96) * 6.66);
          } else if (totalAvgHr > 99) {
            lastWeekScoreHr = 100;
          }
        } else if (title == 'hr_variability'.tr) {
          if (totalAvgHr > 120) {
            lastWeekScoreHr = 100;
          } else if (totalAvgHr < 120) {
            lastWeekScoreHr = 100 - ((120 - totalAvgHr) * 0.83);
          }
        } else if (title == 'pulse_pressure'.tr) {
          if (totalAvgHr == 40) {
            lastWeekScoreHr = 100;
          } else if (totalAvgHr < 40) {
            lastWeekScoreHr = 100 - ((40 - totalAvgHr) * 2.5);
          } else if (totalAvgHr > 40) {
            lastWeekScoreHr = 100 - ((totalAvgHr - 40) * 2.5);
          }
        } else if (title == 'arterial_pressure'.tr) {
          if (totalAvgHr == 85) {
            lastWeekScoreHr = 100;
          } else if (totalAvgHr < 85) {
            lastWeekScoreHr = 100 - ((85 - totalAvgHr) * 1.66);
          } else if (totalAvgHr > 85) {
            lastWeekScoreHr = 100 - ((totalAvgHr - 85) * 1.66);
          }
        } else if (title == 'blood_pressure'.tr) {
          if (totalAvgHr > 120) {
            lastWeekScoreHr = 100 - ((totalAvgHr - 120) * 1.6);
          } else if (totalAvgHr < 120) {
            lastWeekScoreHr = 100 - ((120 - totalAvgHr) * 3.2);
          }

          totalValueForDia = totalHeartScoreForDia - totalLastWeekScoreForDia;

          int totalAvgForDia =
              totalSittingRecordForDia.length - lastWeekRecordForDia.length;

          double totalAvgHrForDia = totalValueForDia / totalAvgForDia;

          printf('-----average--dia--->$totalAvgHrForDia');

          if (totalAvgHrForDia > 80) {
            lastWeekScoreHrForDia = 100 - ((totalAvgHrForDia - 80) * 5);
          } else if (totalAvgHrForDia < 80) {
            lastWeekScoreHrForDia = 100 - ((80 - totalAvgHrForDia) * 5);
          }

          double fc = totalDiaScore - lastWeekScoreHrForDia;

          double a = (fc / lastWeekScoreHrForDia) * 100;

          lastWeekResultForDia = a.toPrecision(2);

          printf(
              '---final--calculation--for--dia-->$fc<---->$a---->$lastWeekResultForDia');
          printf('---total---hr--score--for--dia-$lastWeekScoreHrForDia--');

          getAverageForBloodPressure(avgHeartRateScore,
              avgSys: avgHeartRateScore, avgDia: avgHeartRateScoreForDia);
        }

        try {
          double fc = totalHrScore - lastWeekScoreHr;

          double a = (fc / lastWeekScoreHr) * 100;

          lastWeekResult = a.toPrecision(2);
          printf('---final--calculation---->$fc<---->$a---->$lastWeekResult');
          printf('---total---hr--score---$lastWeekScoreHr--');
        } catch (e) {
          printf('exe-1315---${e.toString()}');
        }

        //double avgLastWeek = totalLastWeekScore / totalSittingRecords.length; //lastWeekRecords.length;

        // printf('---avg--for-last--week--${avgLastWeek.roundToDouble()}---reting--${lastWeekScoreHr.roundToDouble()}');
        // printf('---total---records---total--$totalHeartScore');
        // printf('---total---last--week--records---${lastWeekRecords.length}---total--$totalLastWeekScore');

        double totalHeart = 0;
        int count = 0;

        double totalSystolic = 0;
        int countSystolic = 0;
        // TODO week

        for (int i = 0; i < listWeekData.length; i++) {
          totalHeart = totalHeart + listWeekData[i].value;
          count = count + listWeekData[i].count;
          //printf('--------listWeekData---${listWeekData[i].value} for --${listWeekData[i].count}');
        }

        double avg = totalHeart / count;
        averageBPMForWeek = avg.roundToDouble();

        printf('average--for--week---$averageBPMForWeek');
        averageForWeekSystolic = averageBPMForWeek;

        List<double> tempList = [];
        for (var i = 0; i < listWeekData.length; i++) {
          var value = listWeekData[i].value / listWeekData[i].count;
          //printf('----week_value---${listWeekData[i].value} ${listWeekData[i].count}---value--$value');
          if (value.toString() != 'NaN') {
            tempList.add(value);
          }
        }

        tempList.sort((a, b) => a.compareTo(b));
        lowestBPMForWeek = tempList.first.roundToDouble();
        highestBPMForWeek = tempList.last.roundToDouble();

        //printf('---------lowest-----$lowestBPMForWeek---highest----$highestBPMForWeek------${tempList.last}');

        highestForWeekSystolic = highestBPMForWeek;
        lowestForWeekSystolic = lowestBPMForWeek;

        //printf('totalDiastolic---${listWeekDataForDiastolic.length}');
        List<double> tempListSystolic = [];
        for (int i = 0; i < listWeekDataForDiastolic.length; i++) {
          totalSystolic = totalSystolic + listWeekDataForDiastolic[i].value;
          countSystolic = countSystolic + listWeekDataForDiastolic[i].count;

          var value = listWeekDataForDiastolic[i].value;

          tempListSystolic.add(value);
        }

        tempListSystolic.sort((a, b) => a.compareTo(b));
        lowestForWeekDiastolic = tempListSystolic.first;
        highestForWeekDiastolic = tempListSystolic.last;

        double avgSystolic = totalSystolic / countSystolic;
        averageForWeekDiastolic = avgSystolic.roundToDouble();
        //printf('HighWeekDiastolic--$highestForWeekDiastolic -- $lowestForWeekDiastolic');
        //printf('systolicAverageForWeek---$avgSystolic');
        //printf('totalSystolicAverageWeek---$totalSystolic $countSystolic');
      } else {
        printf('---------------else-------------------check----');
        listWeekData = listWeekData.reversed.toList();
        if (title == 'blood_pressure'.tr) {
          listWeekDataForDiastolic = listWeekDataForDiastolic.reversed.toList();
        }

        printf('no_record_found $weekDate');
        update();
      }
      isLoading.value = false;
      // Get.context!.loaderOverlay.hide();
    });
  }

  Future<void> getWeekDataOffline(
      {required int startDate, required int endDate}) async {
    printf('call_week_offline-$startDate $endDate $userId');

    weekMeasureList.clear();
    Database db = await dbHelper.database;

    final List<Map<String, dynamic>> records = await db.rawQuery(
        "SELECT * FROM MeasureTable WHERE timeStamp BETWEEN $startDate AND $endDate");

    printf('weekRecords-${records.length}');

    if (records.isNotEmpty) {
      records.forEach((element) {
        final data = Map<String, dynamic>.from(element);
        MeasureResult measureModel = MeasureResult.fromJson(data);
        weekMeasureList.add(measureModel);
        update();
      });
    }

    printf('weekMeasureList-${weekMeasureList.length}');

    if (weekMeasureList.isNotEmpty) {
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

            double hr = 0.0;
            int count = 0;

            double d = 0.0;
            int countD = 0;

            if (title == 'heart_rate'.tr) {
              hr = listWeekData[index].value +
                  double.parse(e.heartRate.toString());
              count = listWeekData[index].count;
            } else if (title == 'oxygen_level'.tr) {
              hr =
                  listWeekData[index].value + double.parse(e.oxygen.toString());
              count = listWeekData[index].count;
            } else if (title == 'hr_variability'.tr) {
              hr = listWeekData[index].value +
                  double.parse(e.hrVariability.toString());
              count = listWeekData[index].count;
            } else if (title == 'pulse_pressure'.tr) {
              hr = listWeekData[index].value +
                  double.parse(e.pulsePressure.toString());
              count = listWeekData[index].count;
            } else if (title == 'arterial_pressure'.tr) {
              hr = listWeekData[index].value +
                  double.parse(e.arterialPressure.toString());
              count = listWeekData[index].count;
            } else if (title == 'blood_pressure'.tr) {
              String input = e.bloodPressure.toString();
              List values = input.split("/");

              double s = double.parse(values[0].toString());
              double dd = double.parse(values[1].toString());

              printf('bp2weekOffline-$s $dd');
              hr = listWeekData[index].value + s;
              count = listWeekData[index].count;

              d = listWeekDataForDiastolic[index].value + dd;
              countD = listWeekDataForDiastolic[index].count;

              printf(
                  'bpValueOffline-$d -  ${listWeekDataForDiastolic[index].value}');

              listWeekDataForDiastolic.removeWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              listWeekDataForDiastolic
                  .add(WeekModel(e.timeStamp.toString(), d, countD + 1));
            } else if (title == 'heart_health'.tr) {
              String input = e.bodyHealth.toString();
              List values = input.split("/");
              double s = double.parse(values[0].toString());

              printf('heartHealth-$s');
              hr = listWeekData[index].value + s;
              count = listWeekData[index].count;
            }

            listWeekData.removeWhere((element) =>
                resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(element.title.toString()))) ==
                resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(e.timeStamp.toString()))));

            listWeekData.add(WeekModel(e.timeStamp.toString(), hr, count + 1));
          }
          listWeekData.sort((a, b) => a.title.compareTo(b.title));
          listWeekDataForDiastolic.sort((a, b) => a.title.compareTo(b.title));
        }
      });

      for (int i = 0; i < listWeekData.length; i++) {
        var dateTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(listWeekData[i].title));

        printf(
            'weekListOffline-${DateFormat('dd-MMM-yyyy').format(dateTime)} ${listWeekData[i].value} ${listWeekData[i].count}');
      }
    } else {
      listWeekData = listWeekData.reversed.toList();
      if (title == 'blood_pressure'.tr) {
        listWeekDataForDiastolic = listWeekDataForDiastolic.reversed.toList();
      }

      printf('no_record_found_offline $weekDate');
      update();
    }
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

      printf(
          'weekListDate-${DateFormat('dd-MMM-yyyy HH:mm:ss').format(dt)} - ${dt.millisecondsSinceEpoch}');
    }
    weekNumberReversed = weekNumbers.reversed.toList();

    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(today)}';

    printf(
        'start-c${resultFormatter.format(weekList.last)} timeStamp ${weekList.last.millisecondsSinceEpoch}');
    printf(
        'end-c${resultFormatter.format(weekList.first)} timeSTamp ${weekList.first.millisecondsSinceEpoch}');

    var endTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(today.millisecondsSinceEpoch);
    var startTimeStamp = DateTime.fromMillisecondsSinceEpoch(
        weekList.last.millisecondsSinceEpoch);

    getWeekData(
        startDate: startTimeStamp.millisecondsSinceEpoch,
        endDate: endTimeStamp.millisecondsSinceEpoch);

    update();
  }

  void getCurrentWeekOffline(DateTime dateTime) {
    DateTime dt;
    for (int i = 0; i < 8; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekNumbers.add(GraphModel(DateFormat('dd').format(dt), 33));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      listWeekDataForDiastolic
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));

      weekList.add(dt);

      printf(
          'weekListDate-${DateFormat('dd-MMM-yyyy HH:mm:ss').format(dt)} - ${dt.millisecondsSinceEpoch}');
    }
    weekNumberReversed = weekNumbers.reversed.toList();

    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(today)}';

    var endTimeStamp =
        DateTime.fromMillisecondsSinceEpoch(today.millisecondsSinceEpoch);
    var startTimeStamp = DateTime.fromMillisecondsSinceEpoch(
        weekList.last.millisecondsSinceEpoch);

    getWeekDataOffline(
        startDate: startTimeStamp.millisecondsSinceEpoch,
        endDate: endTimeStamp.millisecondsSinceEpoch);

    update();
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
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      listWeekDataForDiastolic
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      weekList.add(date);
    }
    weekNumberReversed = weekNumbers.reversed.toList();
    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(weekList.first)}';

    /*printf(
        'startPrev-${resultFormatter.format(weekList.last)} timeStamp ${weekList.last.millisecondsSinceEpoch}');
    printf(
        'endPrev-${resultFormatter.format(weekList.first)} timeSTamp ${weekList.first.millisecondsSinceEpoch}');*/

    printf('weekDate->$weekDate');

    Utility.isConnected().then((value) {
      if (value) {
        getWeekData(
            startDate: weekList.last.millisecondsSinceEpoch,
            endDate: weekList.first.millisecondsSinceEpoch);

        printf('online_prev_week');
      } else {
        getWeekDataOffline(
            startDate: weekList.last.millisecondsSinceEpoch,
            endDate: weekList.first.millisecondsSinceEpoch);

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

    /*printf(
        'startPrev-${resultFormatter.format(weekList.last)} timeStamp ${weekList.last.millisecondsSinceEpoch}');
    printf(
        'endPrev-${resultFormatter.format(weekList.first)} timeSTamp ${today.millisecondsSinceEpoch}');*/

    printf('weekDateNext->$weekDate');

    Utility.isConnected().then((value) {
      if (value) {
        getWeekData(
            startDate: weekList.last.millisecondsSinceEpoch,
            endDate: weekList.first.millisecondsSinceEpoch);

        printf('online_next_week');
      } else {
        getWeekDataOffline(
            startDate: weekList.last.millisecondsSinceEpoch,
            endDate: weekList.first.millisecondsSinceEpoch);

        printf('offline_next_week');
      }
    });
    update();
  }

  void buttonPreviousWeekTab(totalAllRecords) {
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
      //getPreviousWeekData(weekList.last);
      getPreviousWeekDataForOneTime(weekList.last, totalAllRecords);
    }
    update();
  }

  void buttonNextWeekTab(totalAllRecords) {
    late DateTime dateTime;

    try {
      dateTime = formatterWeek.parse(displayWeekText);
    } catch (exe) {
      printf('exe-$exe');
    }

    if (displayWeekText == displayDateText) {
      printf('Oops...next_week..');
    } else {
      var currentDate =
          DateTime(dateTime.year, dateTime.month, dateTime.day + 7);
      displayWeekText = formatterWeek.format(currentDate);
      printf('dateTimeWeek-$displayWeekText');
      //getNextWeekData(currentDate);
      getNextWeekDataForOneTime(currentDate, totalAllRecords);
    }

    update();
  }

  Future<void> getHeartRateValueForSelectedDate(date) async {
    printf('todayDate-$date');
    graphDayList.clear();
    graphDayForBloodPressureList.clear();
    graphDayListForDiastolic.clear();
    measureUserList.clear();
    isLoading.value = true;
    //Get.context!.loaderOverlay.show();

    DataSnapshot snapshot = await dbMeasure.child(userId).get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        if (activityModel.dateTime.toString() == date.toString()) {
          measureUserList.add(activityModel);
        }
        update();
      });

      int totalHeart = 0;
      int totalDiastolic = 0;

      printf('measureList-${measureUserList.length}');

      for (int i = 0; i < measureUserList.length; i++) {
        if (title == 'heart_rate'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].heartRate.toString())));

          //graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
          //  double.parse(measureUserList[i].heartRate.toString())));

          totalHeart =
              totalHeart + int.parse(measureUserList[i].heartRate.toString());
          printf(
              'heart_rate-$totalHeart ->${measureUserList.length.toString()} ');
        } else if (title == 'oxygen_level'.tr) {
          printf('oxygen_level');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].oxygen.toString())));

          //graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
          //  double.parse(measureUserList[i].oxygen.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].oxygen.toString()).toInt();
        } else if (title == 'hr_variability'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].hrVariability.toString())));

          //graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
          //  double.parse(measureUserList[i].hrVariability.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].hrVariability.toString()).toInt();
        } else if (title == 'pulse_pressure'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].pulsePressure.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].pulsePressure.toString()).toInt();
        } else if (title == 'arterial_pressure'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].arterialPressure.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].arterialPressure.toString())
                  .toInt();
        } else if (title == 'blood_pressure'.tr) {
          String input = measureUserList[i].bloodPressure.toString();
          List values = input.split("/");

          double s = double.parse(values[0].toString());
          double d = double.parse(values[1].toString());

          printf('----day--bp2-$s $d');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              //measureUserList[i].measureTime.toString(),
              s.roundToDouble()));

          graphDayListForDiastolic.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              //measureUserList[i].measureTime.toString(),
              d.roundToDouble()));

          totalHeart = totalHeart + s.toInt();

          totalDiastolic = totalDiastolic + d.toInt();

          graphDayForBloodPressureList.add(GraphModelForBloodPressure(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble(),
              d.roundToDouble()));

          // graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
          //     double.parse(measureUserList[i].hrVariability.toString())));
          //
          // totalHeart = totalHeart +
          //     double.parse(measureUserList[i].hrVariability.toString()).toInt();
        } else if (title == 'heart_health'.tr) {
          String input = measureUserList[i].bodyHealth.toString();
          List values = input.split("/");
          double s = double.parse(values[0].toString());

          printf('heartHealth-$s');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble()));

          //graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(), s.roundToDouble()));

          totalHeart = totalHeart + s.toInt();
        } else if (title == 'heart_function'.tr) {
          double s = double.parse(measureUserList[i].pulsePressure.toString());
          double d =
              double.parse(measureUserList[i].arterialPressure.toString());

          printf('----day--pulse--->$s<---->arterial--->$d<---');

          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe---date--1490->$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble()));

          graphDayListForDiastolic.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              d.roundToDouble()));

          totalHeart = totalHeart + s.toInt();

          totalDiastolic = totalDiastolic + d.toInt();

          graphDayForBloodPressureList.add(GraphModelForBloodPressure(
              dateFormatTime.format(currentDate).toString(),
              s.roundToDouble(),
              d.roundToDouble()));
        }

        update();
      }

      //printf('totalMeasureListToday-${measureUserList.length}');

      printf('checkDate-$date - ${resultFormatter.format(today)}');

      try {
        GraphModel max = graphDayList.reduce(
            (value, element) => value.value > element.value ? value : element);
        GraphModel min = graphDayList.reduce(
            (value, element) => value.value < element.value ? value : element);

        lowestBPM = min.value;
        highestBPM = max.value;

        printf('---lowest--->$lowestBPM<----highest--->$highestBPM');
      } catch (e) {
        printf('exe1533--$e');
      }

      if (measureUserList.isNotEmpty) {
        double avg = totalHeart / measureUserList.length;
        averageBPM = avg.roundToDouble();

        printf('totalAverage->$averageBPM');

        //printf('graphDayList---${graphDayList.length} ${measureUserList.length}');

        /*if (avg > 85)
        {
          condition = 'Condition : Signs of ${'tachycardia'.tr}';
        } else if (avg > 100) {
          condition = 'Condition : Signs of ${'tachycardia'.tr}';
        } else if (avg < 60) {
          condition = 'Condition : Signs of ${'bradycardia'.tr}';
        } else if (avg < 55) {
          condition = 'Condition : Signs of ${'bradycardia'.tr}';
        } else {
          condition = 'Condition : Signs of ${'normal'.tr}';
          printf('---condition-else----');
        }*/

        if (graphDayListForDiastolic.isNotEmpty) {
          printf('iff_blood_pressure');
          double avg = totalDiastolic / measureUserList.length;
          averageForDiastolic = avg.roundToDouble();

          graphDayListForDiastolic.sort((a, b) => a.value.compareTo(b.value));
          lowestForDiastolic = graphDayListForDiastolic.first.value;
          highestForDiastolic = graphDayListForDiastolic.last.value;
        }

        printf('------totalAverage->$averageBPM<---->$averageForDiastolic<---');

        if (averageBPM >= 35 && averageBPM <= 45) {
          //isImproveHealth = false;
          strokeVolumeTip = "your_stroke_volume_is_in_the_healthy_range".tr;
        } else {
          getStrokeVolumeTips();
          printf('----else----stroke--tip');
        }

        if (averageForDiastolic >= 77 && averageForDiastolic <= 93) {
          cardiacVolumeTip = "your_cardiac_output_is_in_the_healthy_range".tr;
        } else {
          printf('----else----cardiac--tip');
          getCardiacVolumeTips();
        }

        if (isBloodPressure) {
          printf('averageForBloodPressure');
          // getAverageForBloodPressure(averageBPM.toDouble(), avgSys: averageBPM.toDouble(), avgDia: averageForDiastolic);
        } else {
          printf('averageForHeart');
          getAverageForDay(averageBPM.toDouble());
        }
      } else {
        averageBPM = 0;
        highestBPM = 0;
        lowestBPM = 0;
        if (isBloodPressure) {
          // getAverageForBloodPressure(averageBPM.toDouble(), avgSys: averageBPM.toDouble(), avgDia: averageForDiastolic);
        } else {
          getAverageForDay(averageBPM.toDouble());
        }
      }
      isLoading.value = false;
      //Get.context!.loaderOverlay.hide();

      update();
    } else {
      printf('no_children_exists_for_today');
    }
  }

  Future<void> getTodayDataOffline(date) async {
    printf('todayDateOffline-$date');

    final listOfRecords = await dbHelper.queryAllRows();
    graphDayList.clear();
    graphDayForBloodPressureList.clear();
    measureUserList.clear();

    if (listOfRecords.isNotEmpty) {
      listOfRecords.forEach((element) {
        final data = Map<String, dynamic>.from(element);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        if (activityModel.dateTime.toString() == date.toString()) {
          measureUserList.add(activityModel);
        }
        update();
      });

      printf('listOfRecordsOffline-${measureUserList.length}');

      int totalHeart = 0;
      int totalDiastolic = 0;

      if (measureUserList.isNotEmpty) {
        graphDayList.add(GraphModel("00:00", 0));
      }

      printf('measureListOffline-${measureUserList.length}');

      for (int i = 0; i < measureUserList.length; i++) {
        if (title == 'heart_rate'.tr) {
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].heartRate.toString())));

          totalHeart =
              totalHeart + int.parse(measureUserList[i].heartRate.toString());
          printf(
              'heart_rate_offline-$totalHeart ->${measureUserList.length.toString()} ');
        } else if (title == 'oxygen_level'.tr) {
          printf('oxygen_level_offline');
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].oxygen.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].oxygen.toString()).toInt();
        } else if (title == 'hr_variability'.tr) {
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].hrVariability.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].hrVariability.toString()).toInt();
        } else if (title == 'pulse_pressure'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].pulsePressure.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].pulsePressure.toString()).toInt();
        } else if (title == 'arterial_pressure'.tr) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${measureUserList[i].dateTime} ${measureUserList[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }

          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].arterialPressure.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].arterialPressure.toString())
                  .toInt();
        } else if (title == 'blood_pressure'.tr) {
          String input = measureUserList[i].bloodPressure.toString();
          List values = input.split("/");

          double s = double.parse(values[0].toString());
          double d = double.parse(values[1].toString());

          printf('bp2_offline-$s $d');

          graphDayList.add(GraphModel(
              measureUserList[i].measureTime.toString(), s.roundToDouble()));

          graphDayListForDiastolic.add(GraphModel(
              measureUserList[i].measureTime.toString(), d.roundToDouble()));

          totalHeart = totalHeart + s.toInt();

          totalDiastolic = totalDiastolic + d.toInt();
        } else if (title == 'heart_health'.tr) {
          String input = measureUserList[i].bodyHealth.toString();
          List values = input.split("/");
          double s = double.parse(values[0].toString());

          printf('heartHealthOffline-$s');

          graphDayList.add(GraphModel(
              measureUserList[i].measureTime.toString(), s.roundToDouble()));

          totalHeart = totalHeart + s.toInt();
        }

        update();
      }

      printf('checkDate-$date - ${resultFormatter.format(today)}');

      if (date == resultFormatter.format(today)) {
        if (measureUserList.isNotEmpty) {
          double avg = totalHeart / measureUserList.length;
          averageBPM = avg.roundToDouble();

          printf('totalAverageOffline-$averageBPM');

          if (graphDayList.isNotEmpty) {
            graphDayList.sort((a, b) => a.value.compareTo(b.value));
            lowestBPM = graphDayList.first.value;
            highestBPM = graphDayList.last.value;
          }

          if (graphDayListForDiastolic.isNotEmpty) {
            printf('iff_blood_pressure_offline');
            double avg = totalDiastolic / measureUserList.length;
            averageForDiastolic = avg.roundToDouble();

            graphDayListForDiastolic.sort((a, b) => a.value.compareTo(b.value));
            lowestForDiastolic = graphDayListForDiastolic.first.value;
            highestForDiastolic = graphDayListForDiastolic.last.value;
          }

          if (isBloodPressure) {
            printf('averageForBloodPressureOffline');
            // getAverageForBloodPressure(averageBPM.toDouble(), avgSys: averageBPM.toDouble(), avgDia: averageForDiastolic);
          } else {
            printf('averageForHeartOffline');
            getAverageForDay(averageBPM.toDouble());
          }
        } else {
          averageBPM = 0;
          highestBPM = 0;
          lowestBPM = 0;
          if (isBloodPressure) {
            // getAverageForBloodPressure(averageBPM.toDouble(), avgSys: averageBPM.toDouble(), avgDia: averageForDiastolic);
          } else {
            getAverageForDay(averageBPM.toDouble());
          }
        }
      } else {
        printf('date_not_match_offline');
      }

      update();
    } else {
      printf('offline_no_children_exists_for_today');
    }
  }

  Future<void> getHeartRateValueForYesterday(date) async {
    printf('yesterdayDate-$date');
    List<GraphModel> graphDayList = [];
    List<MeasureResult> measureUserList = [];

    //Get.context!.loaderOverlay.show();
    isLoading.value = true;

    DataSnapshot snapshot = await dbMeasure.child(userId).get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        if (activityModel.dateTime.toString() == date.toString()) {
          measureUserList.add(activityModel);
        }
        update();
      });

      int totalHeart = 0;
      // int totalDiastolic = 0;

      for (int i = 0; i < measureUserList.length; i++) {
        if (title == 'heart_rate'.tr) {
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].heartRate.toString())));

          totalHeart =
              totalHeart + int.parse(measureUserList[i].heartRate.toString());
        } else if (title == 'oxygen_level'.tr) {
          printf('oxygen_level');
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].oxygen.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].oxygen.toString()).toInt();
        } else if (title == 'hr_variability'.tr) {
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].hrVariability.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].hrVariability.toString()).toInt();
        } else if (title == 'blood_pressure'.tr) {
          printf('bloodPressureYesterday');
          /*String input = measureUserList[i].bloodPressure.toString();
          List values = input.split("/");

          double s = double.parse(values[0].toString());
          double d = double.parse(values[1].toString());

          printf('yesterday_bp-$s $d');

          graphDayList
              .add(GraphModel(measureUserList[i].measureTime.toString(), s));

          graphDayListForDiastolic.add(GraphModel(measureUserList[i].measureTime.toString(), d));

          totalHeart = totalHeart + s.toInt();

          totalDiastolic = totalDiastolic + d.toInt();*/
        }

        update();
      }

      if (measureUserList.isNotEmpty) {
        double avg = totalHeart / measureUserList.length;
        printf('today_average-$avg');
        avg = avgHeartRateScore;

        double a = 0;

        if (title == 'heart_rate'.tr) {
          // avg

          printf('today_all_time_average-$avg');
          if (avg < 65) {
            yesterdayMeasure = "your_heart_rate_is_up_to_the_mark".tr;
          } else {
            a = avgForAllTimeRecords - 3;
            yesterdayMeasure =
                "${'your_average_heart_rate_yesterday_was'.tr} $avgForAllTimeRecords, ${'try_maintaining_a_heart_rate_of'.tr} $a ${'today'.tr}. ";
          }
          printf('yesterday_measure_at-$avg');
        } else if (title == 'oxygen_level'.tr) {
          printf('yesterday_oxygen-$avg');

          if (avg <= 97) {
            double o = avgForAllTimeRecords + 1;
            yesterdayMeasure =
                " ${'your_average_oxygen_level_yesterday_was'.tr} $avgForAllTimeRecords %, ${'try_maintaining_an_average_of'.tr} $o % ${'today'.tr}.";
          } else {
            yesterdayMeasure = " ${'your_oxygen_level_is_up_to_the_mark'.tr} ";
          }
        } else if (title == 'hr_variability'.tr) {
          printf('yesterday_hr_v');
        } else {
          printf('yesterday_bp');
        }
      } else {
        printf('not_measure_yesterday');
        yesterdayMeasure = '';
        /*if (title == AppConstants.heartRate) {
          yesterdayMeasure = 'Heart rate not measured yesterday';
        } else if (title == AppConstants.oxygenLevel) {
          yesterdayMeasure = 'Oxygen level not measured yesterday';
        }*/
      }
      isLoading.value = false;
      //Get.context!.loaderOverlay.hide();

      update();
    } else {
      printf('no_children_exists_for_yesterday');
    }
  }

  Future<void> getHeartRateValueForYesterdayOffline(date) async {
    printf('yesterdayDateOffline-$date');
    List<MeasureResult> measureUserList = [];

    final listOfRecords = await dbHelper.queryAllRows();

    if (listOfRecords.isNotEmpty) {
      listOfRecords.forEach((element) {
        final data = Map<String, dynamic>.from(element);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        if (activityModel.dateTime.toString() == date.toString()) {
          measureUserList.add(activityModel);
        }
        update();
      });

      printf('listOfYesterdayRecordsOffline-${measureUserList.length}');

      int totalHeart = 0;
      // int totalDiastolic = 0;

      for (int i = 0; i < measureUserList.length; i++) {
        if (title == 'heart_rate'.tr) {
          // printf('heart_rate-yesterday_offline');
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].heartRate.toString())));

          totalHeart =
              totalHeart + int.parse(measureUserList[i].heartRate.toString());
        } else if (title == 'oxygen_level'.tr) {
          printf('oxygen_level_offline');
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].oxygen.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].oxygen.toString()).toInt();
        } else if (title == 'hr_variability'.tr) {
          graphDayList.add(GraphModel(measureUserList[i].measureTime.toString(),
              double.parse(measureUserList[i].hrVariability.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].hrVariability.toString()).toInt();
        } else if (title == 'blood_pressure'.tr) {
          printf('bloodPressureYesterdayOffline');
          /*String input = measureUserList[i].bloodPressure.toString();
          List values = input.split("/");

          double s = double.parse(values[0].toString());
          double d = double.parse(values[1].toString());

          printf('yesterday_bp_offline-$s $d');

          graphDayList
              .add(GraphModel(measureUserList[i].measureTime.toString(), s));

          graphDayListForDiastolic.add(GraphModel(measureUserList[i].measureTime.toString(), d));

          totalHeart = totalHeart + s.toInt();

          totalDiastolic = totalDiastolic + d.toInt();*/
        }

        update();
      }

      if (measureUserList.isNotEmpty) {
        double avg = totalHeart / measureUserList.length;
        double a = avg.roundToDouble() - 3;
        if (title == 'heart_rate'.tr) {
          if (avg < 65) {
            yesterdayMeasure = " ${'your_heart_rate_is_up_to_the_mark'.tr} ";
          } else {
            yesterdayMeasure =
                " ${'your_average_heart_rate_yesterday_was'.tr} ${avg.roundToDouble()}, ${'try_maintaining_a_heart_rate_of'.tr} $a ${'today'.tr}. ";
          }
          printf('yesterday_measure_at_offline-$avg');
        } else if (title == 'oxygen_level'.tr) {
          printf('yesterday_oxygen_offline-$avg');

          if (avg < 97) {
            double o = avg.roundToDouble() + 1;
            yesterdayMeasure =
                " ${'your_average_oxygen_level_yesterday_was'.tr} ${avg.roundToDouble()} %, ${'try_maintaining_an_average_of'.tr} $o % ${'today'.tr}.";
          } else {
            yesterdayMeasure = " ${'your_oxygen_level_is_up_to_the_mark'.tr} ";
          }
        } else if (title == 'hr_variability'.tr) {
          printf('yesterday_hr_v_offline');
        } else {
          printf('yesterday_bp_offline');
        }
      } else {
        printf('not_measure_yesterday_offline');
        yesterdayMeasure = '';
        /*if (title == AppConstants.heartRate) {
          yesterdayMeasure = 'Heart rate not measured yesterday';
        } else if (title == AppConstants.oxygenLevel) {
          yesterdayMeasure = 'Oxygen level not measured yesterday';
        }*/
      }

      update();
    } else {
      printf('offline_no_children_exists_for_yesterday');
    }
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

    /*Utility.isConnected().then((value) {
      if (value) {
        getHeartRateValueForSelectedDate(resultFormatter.format(prevDate));
        printf('online_selected_date');
      } else {
        getTodayDataOffline(resultFormatter.format(prevDate));
        printf('offline_selected_date');
      }
    });*/

    getHeartRateValueForSelectedDateForFirstTime(
        resultFormatter.format(prevDate), totalMeasureRecordList);

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

    getHeartRateValueForSelectedDateForFirstTime(
        resultFormatter.format(prevDate), totalMeasureRecordList);
    /*Utility.isConnected().then((value)
    {
      if (value) {
        getHeartRateValueForSelectedDate(resultFormatter.format(prevDate));
        printf('online_prev_day');
      } else {
        getTodayDataOffline(resultFormatter.format(prevDate));
        printf('offline_prev_day');
      }
    });*/

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

      /*Utility.isConnected().then((value)
      {
        if (value) {
          getHeartRateValueForSelectedDate(resultFormatter.format(nextDate));
          printf('online_next_day');
        } else {
          getTodayDataOffline(resultFormatter.format(nextDate));
          printf('offline_next_day');
        }
      });*/
      getHeartRateValueForSelectedDateForFirstTime(
          resultFormatter.format(nextDate), totalMeasureRecordList);
    }

    printf('dateTime-$displayDateText');
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

    //getMonthData(currentDate);
    getMonthDataForFirstTime(currentDate, totalMeasureRecordList);

    /*Utility.isConnected().then((value) {
      if (value) {
        getMonthData(currentDate);
        printf('online_prev_month');
      } else {
        getMonthDataOffline(currentDate);
        printf('offline_next_month');
      }
    });*/

    //monthGraphPlot = [];
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

    getMonthDataForFirstTime(currentDate, totalMeasureRecordList);

    /*Utility.isConnected().then((value) {
      if (value) {
        getMonthData(currentDate);
        printf('online_next_month');
      } else {
        getMonthDataOffline(currentDate);
        printf('offline_next_month');
      }
    });*/

    update();
  }

  void getAverageForDay(double hrr) {
    printf("---call--average-for---day--->$title--->$hrr");
    var factor = 0;
    green = false;
    lightGreen = false;
    orange = false;
    red = false;
    yellow = false;

    double hr = avgHeartRateScore;

    printf('----get_average_score---$hr');
    // heart rate
    if (title == 'heart_rate'.tr) {
      if (hr <= 65) {
        green = true;
        lightGreen = false;
        orange = false;
        red = false;
        yellow = false;
      } else if (hr >= 65 && hr <= 75) {
        lightGreen = true;
        green = false;
        orange = false;
        red = false;
        yellow = false;
      } else if (hr >= 75 && hr <= 82) {
        lightGreen = false;
        green = false;
        orange = false;
        red = false;
        yellow = true;
      } else if (hr >= 82 && hr <= 90) {
        lightGreen = false;
        green = false;
        orange = true;
        red = false;
        yellow = false;
      } else if (hr >= 90) {
        lightGreen = false;
        green = false;
        orange = false;
        red = true;
        yellow = false;
      }
    }

    // oxygen
    if (title == 'oxygen_level'.tr) {
      printf('calculation_for_oxygen');
      if (hr > 97) {
        green = true;
        lightGreen = false;
        orange = false;
        red = false;
        yellow = false;
      } else if (hr >= 96 && hr <= 97) {
        lightGreen = true;
        green = false;
        orange = false;
        red = false;
        yellow = false;
      } else if (hr >= 95 && hr <= 96) {
        lightGreen = false;
        green = false;
        orange = false;
        red = false;
        yellow = true;
      } else if (hr >= 94 && hr <= 95) {
        lightGreen = false;
        green = false;
        orange = true;
        red = false;
        yellow = false;
      } else if (hr <= 94) {
        lightGreen = false;
        green = false;
        orange = false;
        red = true;
        yellow = false;
      }
    }

    // hr variability
    if (title == 'hr_variability'.tr) {
      printf('calculation_for_hr_variability');
      if (hr > 150) {
        green = true;
        lightGreen = false;
        orange = false;
        red = false;
        yellow = false;
      } else if (hr >= 100 && hr <= 150) {
        lightGreen = true;
        green = false;
        orange = false;
        red = false;
        yellow = false;
      } else if (hr >= 50 && hr <= 100) {
        lightGreen = false;
        green = false;
        orange = false;
        red = false;
        yellow = true;
      } else if (hr >= 30 && hr <= 50) {
        lightGreen = false;
        green = false;
        orange = true;
        red = false;
        yellow = false;
      } else if (hr < 30) {
        lightGreen = false;
        green = false;
        orange = false;
        red = true;
        yellow = false;
      }
    }

    //---------------------------------------------------------------------------------------------

    if (title == 'heart_health'.tr) {
      if (hr >= 49 + factor && hr <= 55 + factor) {
        green = true;
        lightGreen = false;
        orange = false;
        red = false;
        yellow = false;
      }

      if (hr >= 56 + factor && hr <= 61 + factor) {
        //hrState = 'Excellent';
        green = true;
        lightGreen = false;
        orange = false;
        red = false;
        yellow = false;
      }

      if (hr >= 62 + factor && hr <= 65 + factor) {
        //hrState = 'Great';
        lightGreen = true;
        green = false;
        orange = false;
        red = false;
        yellow = false;
      }

      if (hr >= 66 + factor && hr <= 69 + factor) {
        //hrState = 'Good';
        lightGreen = true;
        green = false;
        orange = false;
        red = false;
        yellow = false;
      }

      if (hr >= 70 + factor && hr <= 73 + factor) {
        //hrState = 'Average';
        yellow = true;
        green = false;
        orange = false;
        red = false;
        lightGreen = false;
      }

      if (hr >= 74 + factor && hr <= 81 + factor) {
        //hrState = 'Below Average';
        orange = true;
        green = false;
        lightGreen = false;
        red = false;
        yellow = false;
      }

      if (hr >= 82 + factor) {
        //hrState = 'Poor';
        red = true;
        orange = false;
        green = false;
        lightGreen = false;
        yellow = false;
      }
    }

    //---------------------------------------------------------------------------------------------

    // PulsePressure
    //----------------------------------------------------------------------

    if (title == 'pulse_pressure'.tr) {
      printf('----pulse--pressure---$hr---');
      if (hr >= 35 && hr < 45) {
        green = true;
        lightGreen = false;
        orange = false;
        red = false;
        yellow = false;
      }

      if (hr >= 30 && hr < 35 || hr >= 45 && hr < 50) {
        lightGreen = true;
        green = false;
        orange = false;
        red = false;
        yellow = false;
      }

      if (hr >= 25 && hr < 30 || hr >= 50 && hr < 55) {
        yellow = true;
        green = false;
        orange = false;
        red = false;
        lightGreen = false;
      }

      if (hr >= 20 && hr < 25 || hr >= 55 && hr < 60) {
        orange = true;
        green = false;
        lightGreen = false;
        red = false;
        yellow = false;
      }

      if (hr < 20) {
        red = true;
        orange = false;
        green = false;
        lightGreen = false;
        yellow = false;
      }

      if (hr >= 60) {
        red = true;
        orange = false;
        green = false;
        lightGreen = false;
        yellow = false;
      }
    }

    //---------------------------------------------------------------------

    // ---------------------------------------------------
    // ArterialPressure
    if (title == 'arterial_pressure'.tr) {
      printf('----arterial--pressure---$hr---');

      if (hr >= 77 && hr < 93) {
        green = true;
        lightGreen = false;
        orange = false;
        red = false;
        yellow = false;
      }

      if (hr >= 70 && hr < 77 || hr >= 93 && hr < 100) {
        lightGreen = true;
        green = false;
        orange = false;
        red = false;
        yellow = false;
      }

      if (hr >= 65 && hr < 70 || hr >= 100 && hr < 105) {
        yellow = true;
        green = false;
        orange = false;
        red = false;
        lightGreen = false;
      }

      if (hr >= 55 && hr <= 65 || hr >= 105 && hr < 115) {
        orange = true;
        green = false;
        lightGreen = false;
        red = false;
        yellow = false;
      }

      if (hr >= 115) {
        red = true;
        orange = false;
        green = false;
        lightGreen = false;
        yellow = false;
      }

      if (hr < 55) {
        red = true;
        orange = false;
        green = false;
        lightGreen = false;
        yellow = false;
      }
    }

    update();
  }

  void getAverageForBloodPressure(double hr, {avgSys, avgDia}) {
    printf(
        "---call---calculate-average-day_blood_pressure-->$hr---sys-->$avgSys----avg--->$avgDia");
    green = false;
    lightGreen = false;
    orange = false;
    red = false;
    yellow = false;

    double sysScore = 0;

    /*118 – 122 = lthvery heay = 100 points
    116- 118 and 122-124 = healthy = 80 points
    114-116 and 124 – 126 = average = 60 points
    112- 114 and 126 – 128 = unhealthy = 40 points
    <112 and >128 = very unhealthy = 20 points*/

    if (hr >= 118 && hr <= 122) {
      sysScore = 100;
    }

    if (hr >= 116 && hr <= 118 || hr >= 122 && hr <= 124) {
      sysScore = 80;
    }

    if (hr >= 114 && hr <= 116 || hr >= 124 && hr <= 126) {
      sysScore = 60;
    }
    if (hr >= 112 && hr <= 114 || hr >= 126 && hr <= 128) {
      sysScore = 40;
    }

    if (hr < 112 || hr > 128) {
      sysScore = 20;
    }

    printf('----sys---score--->$sysScore-----value-->$avgSys');

    double diaScore = 0;

    if (avgDia >= 78 && avgDia <= 82) {
      diaScore = 100;
    }

    if (avgDia >= 76 && avgDia <= 78 || avgDia >= 82 && avgDia <= 84) {
      diaScore = 80;
    }

    if (avgDia >= 74 && avgDia <= 76 || avgDia >= 84 && avgDia <= 86) {
      diaScore = 60;
    }
    if (avgDia >= 72 && avgDia <= 74 || avgDia >= 86 && avgDia <= 88) {
      diaScore = 40;
    }

    if (avgDia < 72 || avgDia > 88) {
      diaScore = 20;
    }

    printf('----dia---score--->$diaScore----value-->$avgDia');

    double finalAvg = (sysScore + diaScore) / 2;

    printf('----average-for--blood--pressure--->$finalAvg');

    if (finalAvg > 80 && finalAvg <= 100) {
      green = true;
      lightGreen = false;
      orange = false;
      red = false;
      yellow = false;
    } else if (finalAvg > 60 && finalAvg <= 80) {
      green = false;
      lightGreen = true;
      orange = false;
      red = false;
      yellow = false;
    } else if (finalAvg > 40 && finalAvg <= 60) {
      lightGreen = false;
      green = false;
      orange = false;
      red = false;
      yellow = true;
    } else if (finalAvg > 20 && finalAvg <= 40) {
      lightGreen = false;
      green = false;
      orange = true;
      red = false;
      yellow = false;
    } else if (finalAvg <= 20) {
      yellow = false;
      green = false;
      orange = false;
      red = true;
      lightGreen = false;
    }

    /*if (finalAvg >= 85)
    {
      condition = 'Condition : Signs of ${'tachycardia'.tr}';
    } else if (finalAvg < 60) {
      condition = 'Condition : Signs of ${'bradycardia'.tr}';
    } else if (finalAvg >= 60 && finalAvg < 85) {
      condition = 'Condition : ${'normal'.tr}';
    } else {
      condition = 'Condition : ${'normal'.tr}';
      printf('---condition-else----');
    }*/

    update();
  }

  void getAverageForWeek(double hr) {
    printf("calculate-average-week$hr");
    var factor = 0;
    greenForWeek = false;
    lightGreenForWeek = false;
    orangeForWeek = false;
    redForWeek = false;
    yellowForWeek = false;
    if (hr >= 49 + factor && hr <= 55 + factor) {
      //hrState = 'Athlete';
      greenForWeek = true;
      lightGreenForWeek = false;
      orangeForWeek = false;
      redForWeek = false;
      yellowForWeek = false;
    }

    if (hr >= 56 + factor && hr <= 61 + factor) {
      //hrState = 'Excellent';
      greenForWeek = true;
      lightGreenForWeek = false;
      orangeForWeek = false;
      redForWeek = false;
      yellowForWeek = false;
    }

    if (hr >= 62 + factor && hr <= 65 + factor) {
      //hrState = 'Great';
      lightGreenForWeek = true;
      greenForWeek = false;
      orangeForWeek = false;
      redForWeek = false;
      yellowForWeek = false;
    }

    if (hr >= 66 + factor && hr <= 69 + factor) {
      //hrState = 'Good';
      lightGreenForWeek = true;
      greenForWeek = false;
      orangeForWeek = false;
      redForWeek = false;
      yellowForWeek = false;
    }

    if (hr >= 70 + factor && hr <= 73 + factor) {
      //hrState = 'Average';
      yellowForWeek = true;
      greenForWeek = false;
      orangeForWeek = false;
      redForWeek = false;
      lightGreenForWeek = false;
    }

    if (hr >= 74 + factor && hr <= 81 + factor) {
      //hrState = 'Below Average';
      orangeForWeek = true;
      greenForWeek = false;
      lightGreenForWeek = false;
      redForWeek = false;
      yellowForWeek = false;
    }

    if (hr >= 82 + factor) {
      //hrState = 'Poor';
      redForWeek = true;
      orangeForWeek = false;
      greenForWeek = false;
      lightGreenForWeek = false;
      yellowForWeek = false;
    }
    update();
  }

  /// Calculate the number of week of between dates and fill in the $weekOfMonth array list
  /// first date will be considered as start date of first week and vice versa fo Last date.
  /// First and Last will not contains full 7 days difference if weeks start and end in to the neighbour months
  /// Week will be counted from Monday to Sunday
  ///
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

  String getTimeFromDateAndTime(String date) {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(date).toLocal();
      return DateFormat.jm().format(dateTime).toString(); //5:08 PM
// String formattedTime = DateFormat.Hms().format(now);
// String formattedTime = DateFormat.Hm().format(now);   // //17:08  force 24 hour time
    } catch (e) {
      printf('exe-date-parse$e');
      return date;
    }
  }

  void getHealthTipsForHeartFunctionForDay(
      {required double s, required double c}) {}

  Future getStrokeVolumeTips() async {
    printf('--call--stroke-tips');
    isLoading.value = true;
    update();
    final String response =
        await rootBundle.loadString('assets/tips/stroke_tips.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();
    strokeVolumeTip = list[random.nextInt(list.length)]['Tips'];
    printf('--random--stroke--volume--tip--$strokeVolumeTip');
    isLoading.value = false;
    update();

    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.strokeVolumeTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     strokeVolumeTips.add(causeModel);
    //   });
    // }
    //
    // CausesTips health =
    //     strokeVolumeTips[random.nextInt(strokeVolumeTips.length)];
    // strokeVolumeTip = health.tip.toString();
    // printf('--random--stroke--volume--tip--$strokeVolumeTip');
    // update();
  }

  Future getCardiacVolumeTips() async {
    printf('--call--cardiac-tips');
    isLoading.value = true;
    update();
    final String response =
        await rootBundle.loadString('assets/tips/cardiac_tips.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();
    cardiacVolumeTip = list[random.nextInt(list.length)]['Tips'];
    printf('--random--cardiac--volume--tip--$cardiacVolumeTip');
    isLoading.value = false;
    update();

    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.cardiacOutPutTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     cardiacVolumeTips.add(causeModel);
    //   });
    // }
    //
    // CausesTips health =
    //     cardiacVolumeTips[random.nextInt(cardiacVolumeTips.length)];
    // cardiacVolumeTip = health.tip.toString();
    // printf('--random--cardiac--volume--tip--$cardiacVolumeTip');
    // update();
  }

  void callInit(title) {
    printf('--------------title--------->$title');
    if (title == 'heart_rate'.tr) {
      pointer = ImagePath.icHeartPointer;
      yesterdayMeasure = heartRateYesterday;
      labelMeasureLevel = 'about_heart_rate_levels'.tr;
      veryHealthy = '< 65 ${'bpm'.tr}';
      healthy = ' 65-75 ${'bpm'.tr}';
      average = ' 75-82 ${'bpm'.tr}';
      unHealthy = ' 82-90 ${'bpm'.tr}';
      veryUnhealthy = ' > 90 ${'bpm'.tr}';
    } else if (title == 'oxygen_level'.tr) {
      pointer = ImagePath.icPointerOxygen;
      yesterdayMeasure = oxygenLevelYesterday;
      labelMeasureLevel = 'about_spo2_levels'.tr;
      veryHealthy = ' > 97 %';
      healthy = '96-97 %';
      average = '95-96 %';
      unHealthy = '94-95 %';
      veryUnhealthy = ' < 94 %';
    } else if (title == 'hr_variability'.tr) {
      pointer = ImagePath.icPointerHRV;
      yesterdayMeasure = ''; //hrVariableYesterday;
      labelMeasureLevel = 'about_hr_variability_levels'.tr;
      veryHealthy = ' > 150 ${'ms'.tr}';
      healthy = '100-150 ${'ms'.tr}';
      average = '50-100 ${'ms'.tr}';
      unHealthy = '30-50 ${'ms'.tr}';
      veryUnhealthy = ' < 30 ${'ms'.tr}';
    } else if (title == 'heart_health'.tr) {
      yesterdayMeasure = ''; //hrVariableYesterday;
      //printf('heartHealth');
    } else if (title == 'pulse_pressure'.tr) {
      pointer = ImagePath.icPointerPulse;
      yesterdayMeasure = '';
      labelMeasureLevel = 'about_pulse_pressure_levels'.tr;
    } else if (title == 'arterial_pressure'.tr) {
      pointer = ImagePath.icPointerArterial;
      yesterdayMeasure = '';
      labelMeasureLevel = 'about_arterial_pressure_levels'.tr;
    } else if (title == 'heart_function'.tr) {
      yesterdayMeasure = '';
      printf('show_heart_function--data');
    } else {
      yesterdayMeasure = bloodPressureYesterday;
      isBloodPressure = true;
      labelMeasureLevel = 'about_blood_pressure_levels'.tr;
      update();
    }
  }
}

class WeekModel {
  WeekModel(this.title, this.value, this.count);

  final String title;
  final double value;
  final int count;
}

class GraphModel {
  GraphModel(this.title, this.value);

  final String title;
  double value;
}

class GraphModelForBloodPressure {
  GraphModelForBloodPressure(this.title, this.v1, this.v2);

  final String title;
  double v1;
  double v2;
}

class WeekTest {
  String? dateTime;
  String? total;

  WeekTest(this.dateTime, this.total);
}

class FinalWeekModel {
  DateTime dateTime;
  String value;

  FinalWeekModel(this.dateTime, this.value);
}

class DateTimeClass {
  static const int monday = 1;
  static const int tuesday = 2;
  static const int wednesday = 3;
  static const int thursday = 4;
  static const int friday = 5;
  static const int saturday = 6;
  static const int sunday = 7;
}
