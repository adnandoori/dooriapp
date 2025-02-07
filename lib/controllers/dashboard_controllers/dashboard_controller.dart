import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/graph_controllers/heart_graph_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/measure_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/prediction_ai_controller.dart';
import 'package:doori_mobileapp/controllers/measure_controllers/measure_result_controller.dart';
import 'package:doori_mobileapp/controllers/measure_controllers/measure_result_reading_controller.dart';
import 'package:doori_mobileapp/controllers/measure_controllers/start_measure_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/helper/database_helper.dart';
import 'package:doori_mobileapp/models/authentication_model/user_model.dart';
import 'package:doori_mobileapp/models/graph/body_health_model.dart';
import 'package:doori_mobileapp/models/measure_model/activity_model.dart';
import 'package:doori_mobileapp/models/measure_model/health_tips_model.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/graph_screens/stroke_cardiac_graph_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_logs/flutter_logs.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class DashboardController extends BaseController
    with GetTickerProviderStateMixin {
  BuildContext context;

  DashboardController(this.context);

  bool isMyVitals = true;
  bool isInsights = false;

  late DatabaseReference dbRef;

  DatabaseReference dbMeasure =
      FirebaseDatabase.instance.ref().child(AppConstants.tableMeasure);

  DatabaseReference dbHealthTips =
      FirebaseDatabase.instance.ref().child(AppConstants.tableHealthTips);

  DatabaseReference dbBodyHealth =
      FirebaseDatabase.instance.ref().child(AppConstants.tableBodyHealth);

  var username = '';
  late UserModel userModel;
  final dbHelper = DatabaseHelper.instance;

  List<MeasureResult> measureList = [];
  List<MeasureResult> measureUserList = [];
  List<MeasureResult> measureListForHeartRythm = [];

  List<MeasureResult> dooriReportList = [];

  // offline last user records
  List<MeasureResult> lastMeasureRecord = [];

  // my vitals
  var activity = 'working'.tr;
  var heartRate = '0',
      oxygen = '0',
      bloodPressure = '0',
      temperature = '0',
      hrVariability = '0',
      bodyHealth = '0';

  var hrState = 'not_measured'.tr, //'healthy'.tr,
      oxygenState = 'not_measured'.tr, //'healthy'.tr,
      bpState = 'not_measured'.tr, //'low'.tr,
      tempState = 'not_measured'.tr, //'low'.tr,
      hrvState = 'not_measured'.tr, //'unhealthy'.tr,
      bodyState = 'not_measured'.tr; //'unhealthy'.tr;

  var hrTag = 'normal'.tr;

  var lastHeartRateValue = '';

  var hrPoints = 0;

  var userId = '';
  var gender = 'Male';
  var isNonVegetarian = 'No';
  int age = 18;

  var healthTips = 'Your health is in normal shape';
  var tempTips = 'High-protein foods, nuts, and meat can cause body heat.';
  var heartHealthValue = '';

  var heartRhythmTitle = 'normal'.tr;
  var heartRhythmStatus = 'healthy'.tr;
  var averageHeartRate = 'avg_heart_rate'.tr;

  double progressValue = 0.0;

  double stressLevelProgress = 0.0;
  double energyLevelProgress = 0.0;

  var stressLevelMsg = 'high'.tr, energyLevelMsg = 'average'.tr;
  int stressLevel = 0, energyLevel = 0;

  int concernLevel = 0;

  String mood = 'excited'.tr;
  String moodIcon = ImagePath.icEmojiHappy;

  List<ActivityModel> list = [];

  List<HealthTips> listNonVegTips = [];
  List<HealthTips> listVegTips = [];

  var newHealthTips = '';
  late TabController tabController = TabController(length: 2, vsync: this);

  //late FlutterGifController gifController = FlutterGifController(vsync: this);

  List<DateTime> weekList = [];
  List<String> weekDateList = [];
  List<WeekModel> listWeekData = [];

  var avg7days = '0';

  var strokeVolume = '0';
  var cardiacOutput = '0';
  var pulsePressure = '0';
  var pulseMessage = 'not_measured'.tr;
  var bfiStatement = '';
  var hriStatement = '';
  var sv = '0';
  var arterialPressure = '0';
  var arterialMessage = 'not_measured'.tr;

  int gifSpeed = 1;

  var systolic = '';
  var diastolic = '';

  var strokeMsg = 'not_measured'.tr;
  var cardiacMsg = 'not_measured'.tr;

  var tag = "DooriDashboard";
  var myLogFileName = "DooriLogFileDashboard";
  var toggle = false;
  var logStatus = '';
  static Completer completer = Completer<String>();

  bool isLast14DaysValue = true;
  bool isLast14DaysHeartRhythm = true;
  bool isLast15DaysHeartHealth = true;

  List<double> last14daySystolic = [];
  List<double> last14daysDiastolic = [];

  double systolicAverage = 0;
  double diastolicAverage = 0;

  List<DateTime> weekListForConcernLevel = [];
  List<String> weekDateListForConcernLevel = [];
  List<WeekModel> listWeekDataForConcernLevel = [];

  var userHeight = '';
  var userWeight = '';
  var userDateOfBirth = '';
  double bmiValue = 0;

  bool isSevereThinness = false,
      isModerateThinness = false,
      isMildThinness = false,
      isnormalThinness = false,
      isOverWeightThinness = false,
      isObeseClass = false,
      isObeseClass2 = false,
      isObeseClass3 = false;

  var bmiMessage = 'normal'.tr;

  List<BodyHealthModel> totalBodyHealthRecordList = [];

  bool isOfflineRecordInserted = false;

  var wellnessScore = '0';
  var wellnessConcernLevel = '';
  var wellnessTitle = '';

  Color colorForVeryHigh = const Color(0xFFf8555a);
  Color colorForMedium = const Color(0xFFb0d683);
  Color colorForLow = const Color(0xFF4fd286);
  Color colorForVeryLow = const Color(0xFFffa847);

  Color? color;

  int heartStrain = 0;

  bool isWellnessScore = false;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //isLoading.value = true;
      //update();
      setUpLogs();

      tabController.addListener(() {
        update();
      });
      logFile('......init....dashboard...');

      checkOfflineRecordInsertedOrNot();

      getUserIdAndUserDetails();
      //callInit();
    });
  }

  void checkOfflineRecordInsertedOrNot() async {
    try {
      isOfflineRecordInserted = (await Utility.getIsOfflineRecordFetch())!;
    } catch (e) {
      printf('exe---check--offline--record-->$e');
    }
    printf('check--offline--record--ogin->$isOfflineRecordInserted');
  }

  Future<void> getUserIdAndUserDetails() async {
    try {
      userId = await Utility.getUserId();
      printf('--userId--->$userId');
    } catch (e) {
      printf('exe-userId-->$e');
    }

    try {
      Utility.getUserDetails().then((value) {
        if (value != null) {
          userModel = value;

          gender = userModel.gender.toString();

          try {
            username = userModel.name.toString()[0].toUpperCase() +
                userModel.name.toString().substring(1);
            age = int.parse(userModel.age.toString());
            isNonVegetarian = userModel.nonVegetarian.toString();

            userHeight = userModel.height.toString();
            userWeight = userModel.weight.toString();

            userDateOfBirth = userModel.dob.toString();
            getBMIValue(height: userHeight, weight: userWeight);
          } catch (exe) {
            printf('exe--user--detail---237-->$exe');
          }
          update();
        }
      });
    } catch (e) {
      printf('exe-userDetails-->$e');
    }

    Utility.isConnected().then((value) async {
      if (value) {
        printf('--call---getUserRecordList--here--247>');
        getUserRecordList();
      } else {
        logFile('internet_offline---252-->');

        showLastRecordOffline();
        Utility().snackBarForInternetIssue();
      }
    });
  }

  void callInit() {
    logFile('....call..init....fetch...records...from...firebase...');
    isLoading.value = true;
    update();

    Utility.isConnected().then((value) {
      if (value) {
        try {
          User user = AuthenticationHelper().user;
          userId = user.uid;
          dbRef = FirebaseDatabase.instance.ref().child('Users');

          getUserRecordList();

          getUserDetail(user.uid).whenComplete(() {
            //showUpdatedResultOnline(userId);

            getAllUserRecordsFirstTime(userId).whenComplete(() {
              isLoading.value = false;
              update();
            });
          });

          logFile('internet_online---215-->$userId');
        } catch (e) {
          logFile('exe---372--$e');
          isLoading.value = false;
          //Get.context!.loaderOverlay.hide();
        }
      } else {
        isLoading.value = false;
        // isLast14DaysValue = false;
        logFile('internet_offline---312-->');
        showLastRecordOffline();
        Utility().snackBarForInternetIssue();
      }
    });
  }

  //-----------------------------------------------------------------------

  void getUserRecordList() async {
    try {
      List<MeasureResult> list = [];
      final prefs = await SharedPreferences.getInstance();
      final List<dynamic> jsonData =
          jsonDecode(prefs.getString('userRecordList') ?? '[]');
      jsonData.forEach((e) {
        list.add(MeasureResult.fromJson(e));
      });

      if (isOfflineRecordInserted) {
        printf(
            '<------------------------FETCH--TOTAL--RECORDS-FROM---Firebase--With--Fetch--Local---Reord--------------->');
        getAllUserRecordsFirstTime(userId).whenComplete(() {
          printf(
              '--------------getAllUserRecordsFirstTime---------------348->${measureList.length}');

          if (measureList.isNotEmpty) {
            getLast15ReadingsForPredictionAI(
                    measureList: measureList, userId: userId)
                .whenComplete(() {
              printf(
                  '<--------completed---last--15--readings----------------358>');
            });
          }
        });
      } else {
        if (jsonData.isEmpty) {
          printf(
              '<------------------------FETCH--TOTAL--RECORDS-FROM---Firebase--First-Time------------------>');
          getAllUserRecordsFirstTime(userId).whenComplete(() {
            printf(
                '--------------getAllUserRecordsFirstTime---------------356->${measureList.length}');

            if (measureList.isNotEmpty) {
              getLast15ReadingsForPredictionAI(
                      measureList: measureList, userId: userId)
                  .whenComplete(() {
                printf(
                    '<--------completed---last--15--readings----------------373>');
              });
            }
          });
        } else {
          measureList = list;
          update();
          printf(
              '<------------------------FETCH--TOTAL--RECORDS-FROM-LOCALLY-------------------392->${measureList.length}-->${list.length}');
          dashboardRecord(measureList).whenComplete(() {
            if (measureList.isNotEmpty) {
              getLast15ReadingsForPredictionAI(
                      measureList: measureList, userId: userId)
                  .whenComplete(() {
                printf(
                    '<--------completed---last--15--readings----------------386>');
              });
            }
          });
        }
      }
    } catch (e) {
      printf('exe-fetch-all-records-from-locally-->$e');
    }

    //------------------------

    try {
      List<BodyHealthModel> listBodyHealth = [];
      final prefs = await SharedPreferences.getInstance();
      final List<dynamic> jsonData =
          jsonDecode(prefs.getString('userBodyHealthRecordList') ?? '[]');
      jsonData.forEach((e) {
        listBodyHealth.add(BodyHealthModel.fromJson(e));
      });

      if (jsonData.isNotEmpty) {
        totalBodyHealthRecordList = listBodyHealth;
        update();
      }
      printf(
          '<------------------------FETCH--TOTAL--BODY--HEALTH--RECORDS-FROM-LOCALLY------------------->${totalBodyHealthRecordList.length}-->${listBodyHealth.length}');
    } catch (e) {
      printf('exe-fetch-body-health-records-from-locally-->$e');
    }
  }

  Future<void> getAllUserRecordsFirstTime(userId) async {
    isLoading.value = true;
    update();

    List<MeasureResult> totalMeasureRecordList = [];

    DataSnapshot snapshot = await dbMeasure.child(userId).get();
    if (snapshot.children.isNotEmpty) {
      Get.context!.loaderOverlay.hide();

      if (snapshot.exists) {
        snapshot.children.forEach((element) async {
          final data = Map<String, dynamic>.from(element.value as Map);
          MeasureResult activityModel = MeasureResult.fromJson(data);
          totalMeasureRecordList.add(activityModel);
          update();
        });

        measureList = totalMeasureRecordList;
        Utility().setUserRecordList(measureList);

        update();

        printf(
            '<---------------total--all--records--first--time---------------->${totalMeasureRecordList.length}');

        Utility.setIsOfflineRecord(false);
        dashboardRecord(measureList);
        // getVisualiseForList(measureList);
        // getConcernListOneTime(measureList);
        isLoading.value = false;
        update();
      }
    } else {
      printf('record_not_found_please_measure_first');
      Get.context!.loaderOverlay.hide();
      buttonMeasure();
    }

    DataSnapshot snapshotBodyHealth = await dbBodyHealth.child(userId).get();

    List<BodyHealthModel> bodyHealthRecordList = [];

    if (snapshotBodyHealth.exists) {
      snapshotBodyHealth.children.forEach((element) async {
        final data = Map<String, dynamic>.from(element.value as Map);
        BodyHealthModel bodyHealthModel = BodyHealthModel.fromJson(data);
        bodyHealthRecordList.add(bodyHealthModel);
        update();
      });

      totalBodyHealthRecordList = bodyHealthRecordList;
      Utility().setUserBodyHealthRecordList(totalBodyHealthRecordList);

      printf(
          '---total--body--health--records--first--time-->${bodyHealthRecordList.length}-->${totalBodyHealthRecordList.length}');
    }
  }

  Future<void> dashboardRecord(measureList) async {
    if (measureList.isNotEmpty) {
      for (int i = 0; i < measureList.reversed.length; i++) {
        if (userId == measureList[i].userId) {
          measureUserList.add(measureList[i]);
        }
      }
      if (measureUserList.isNotEmpty) {
        // offline record stored
        try {
          Utility.setLastMeasureRecord(jsonEncode(measureUserList.last));
        } catch (e) {
          printf('exe-stored-last-record-->${e.toString()}');
        }
        activity = measureUserList.last.activity.toString();
        heartRate = measureUserList.last.heartRate.toString();
        oxygen = measureUserList.last.oxygen.toString();
        bloodPressure = measureUserList.last.bloodPressure.toString();
        temperature = measureUserList.last.temperature.toString();
        hrVariability = measureUserList.last.hrVariability.toString();
        bodyHealth = measureUserList.last.bodyHealth.toString();

        getPulsePressure(bp: bloodPressure);
        calculateStrokeVolume(
            bp: bloodPressure,
            hr: double.parse(heartRate.toString()),
            hrv: double.parse(hrVariability.toString()));
        calculateBFI(bp: bloodPressure);
        calculateHRI(
            hr: double.parse(heartRate.toString()),
            hrv: double.parse(hrVariability.toString()));

        try {
          heartStrain = calculateHeartStrain(
                  hrv: double.parse(hrVariability.toString()),
                  bloodPressure: bloodPressure,
                  hr: double.parse(heartRate.toString()))
              .toInt();

          printf('--------final-------strain------>$heartStrain');
        } catch (e) {
          printf('---exe---heart-strain--->$e');
        }

        try {
          newHealthTips = measureUserList.last.healthTips.toString();
        } catch (e) {
          printf('exe-tips-online--383-->$e');
        }

        late DateTime dateTime;
        DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
        DateFormat dateFormatTime = DateFormat("dd-MMM-yyyy, h:mm a");

        try {
          dateTime = dateFormat.parse(
              '${measureUserList.last.dateTime} ${measureUserList.last.measureTime}');
        } catch (exe) {
          printf('exe-365-->$exe');
        }
        var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        lastHeartRateValue = dateFormatTime.format(currentDate);

        getBodyState(double.parse(temperature), double.parse(heartRate),
            bodyHealth, oxygen, bloodPressure);

        getEnergyLevelList(double.parse(heartRate), measureList);

        double sys = 0.0;

        if (bloodPressure.length > 4) {
          String v = bloodPressure.substring(0, 3);
          try {
            sys = double.parse(v);
          } catch (e) {
            printf('exe-387-->$e');
          }
        }
        //--------------------------------------------------
        getHeartRateCalculationList(
            age: age,
            hr: double.parse(heartRate.toString()),
            oxygenLevel: double.parse(oxygen.toString()),
            bloodPressure: sys,
            activity: activity,
            bodyHealth: bodyHealth,
            hrv: double.parse(hrVariability.toString()));
        //---------------------------------------------------

        getVisualiseForList(measureList);
        getConcernListOneTime(measureList);
      } else {
        printf('online_user_record_not_found');
      }

      update();
    }
  }

  getVisualiseForList(totalMeasureRecordList) {
    printf(
        '---call-----visualise--for----locally------->${totalMeasureRecordList.length}');
    DateTime dateTime = DateTime.now().subtract(const Duration(days: 1));

    List<DateTime> weekList = [];

    DateTime dt;
    for (int i = 0; i < 15; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      weekList.add(date);
    }
    List<MeasureResult> weekMeasureList = [];

    var resultFormatter = DateFormat('dd-MMM-yyyy');

    var dtStart = DateTime.fromMillisecondsSinceEpoch(
        weekList.last.millisecondsSinceEpoch);

    DateTime endDt = DateTime.now().subtract(const Duration(days: 1));

    DateTime endDtt = DateTime.now(); //.subtract(const Duration(days: 1));

    printf(
        '--startDate--->${resultFormatter.format(dtStart)}--end->${resultFormatter.format(endDt)}--endDate-->${resultFormatter.format(endDtt)}');

    weekMeasureList = totalMeasureRecordList
        .where((item) =>
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isAfter(dtStart) &&
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isBefore(endDtt))
        .toList();

    printf('----week--list---->${weekMeasureList.length}'
        '---total---visualise--->${totalMeasureRecordList.length}');

    update();

    if (weekMeasureList.isNotEmpty) {
      weekMeasureList.forEach((e) {
        //printf('---element-ei-->${e.dateTime}-->${e.measureTime}--->${e.activity}');
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

            hr = listWeekData[index].value +
                double.parse(e.heartRate.toString());
            count = listWeekData[index].count;

            listWeekData.removeWhere((element) =>
                resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(element.title.toString()))) ==
                resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(e.timeStamp.toString()))));

            listWeekData.add(WeekModel(e.timeStamp.toString(), hr, count + 1));

            String sys = e.bloodPressure
                .toString()
                .substring(0, e.bloodPressure.toString().indexOf('/'));
            String dys = e.bloodPressure.toString().substring(
                e.bloodPressure.toString().indexOf('/') + '/'.length,
                e.bloodPressure.toString().length);

            //double systolicValue = double.parse(sys).roundToDouble() - double.parse(dys).roundToDouble();

            last14daySystolic.add(double.parse(sys).roundToDouble());
            last14daysDiastolic.add(double.parse(dys).roundToDouble());
          }
          listWeekData.sort((a, b) => a.title.compareTo(b.title));
        } else {
          printf('opps_else');
        }
      });

      printf('---total---sitting---visualise-->${listWeekData.length}');

      double totalHeart = 0;
      int count = 0;

      for (int i = 1; i < listWeekData.length; i++) {
        printf(
            '-------visualise--value------>${listWeekData[i].value}----->${listWeekData[i].title}');

        if (listWeekData[i].value > 0) {
          totalHeart = totalHeart +
              listWeekData[i]
                  .value; //int.parse(measureUserList[i].heartRate.toString());
          count = count + listWeekData[i].count;
        } else {
          isLast14DaysValue = false;
        }
      }

      double avg = totalHeart / count;

      avg7days = avg.roundToDouble().toString();

      double gifValue = avg.roundToDouble() * 12 / 60;

      try {
        gifSpeed = gifValue.toInt();
      } catch (e) {
        printf('exe--gif-speed-->$e');
      }

      for (int i = 0; i < last14daySystolic.length; i++) {
        systolicAverage = systolicAverage + last14daySystolic[i];
      }

      for (int i = 0; i < last14daysDiastolic.length; i++) {
        diastolicAverage = diastolicAverage + last14daysDiastolic[i];
      }

      systolicAverage = systolicAverage / last14daySystolic.length;
      diastolicAverage = diastolicAverage / last14daysDiastolic.length;

      // printf('-----------total systolic and diastolic ------$systolicAverage---$diastolicAverage---');
    } else {
      listWeekData = listWeekData.reversed.toList();
      isLast14DaysValue = false;
      logFile(
          '----no--record--found---for--last--14--days----getVisualizeDataForLast14Days----619>$gifSpeed');
      update();
    }
  }

  getConcernListOneTime(totalMeasureRecordList) {
    List<MeasureResult> weekMeasureList = [];
    List<DateTime> weekList = [];
    DateTime dateTime = DateTime.now().subtract(const Duration(days: 1));
    DateTime dt;
    for (int i = 0; i < 16; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekDateListForConcernLevel.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekDataForConcernLevel
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      weekList.add(date);
      weekListForConcernLevel.add(date);
    }
    var resultFormatter = DateFormat('dd-MMM-yyyy');
    var dtStart = DateTime.fromMillisecondsSinceEpoch(
        weekList.last.millisecondsSinceEpoch);
    // var dtEnd = DateTime.fromMillisecondsSinceEpoch(
    //   weekList.first.millisecondsSinceEpoch);

    // printf(
    //     '--startDate--->${resultFormatter.format(dtStart)}--end->${resultFormatter.format(dtEnd)}');
    // printf('--startDate--->${weekList.last.millisecondsSinceEpoch}--end->'
    //     '${weekList.first.millisecondsSinceEpoch}');

    DateTime endDt = DateTime.now().subtract(const Duration(days: 1));

    //   DateTime startDt = DateTime.now().subtract(const Duration(days: 14));

    // printf('-->${DateFormat('dd-MMM-yyyy').format(startDt)}--->''${DateFormat('dd-MMM-yyyy').format(endDt)}');

    weekMeasureList = totalMeasureRecordList
        .where((item) =>
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isAfter(dtStart) &&
            DateTime.fromMillisecondsSinceEpoch(item.timeStamp!)
                .isBefore(endDt))
        .toList();

    //printf('--total---concern-->${weekMeasureList.length}');

    if (weekMeasureList.isNotEmpty) {
      weekMeasureList.forEach((e) {
        //printf('concern-level--->${e.dateTime}--->${e.activity}');

        var dateTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(e.timeStamp.toString()));

        if (weekDateListForConcernLevel
            .contains(resultFormatter.format(dateTime))) {
          if (listWeekDataForConcernLevel.isNotEmpty) {
            int index = listWeekDataForConcernLevel.indexWhere((element) =>
                resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(element.title.toString()))) ==
                resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(e.timeStamp.toString()))));

            double hr = 0.0;
            int count = 0;

            String bh = e.bodyHealth
                .toString()
                .substring(0, e.bodyHealth.toString().indexOf('/'));

            //  printf('------body---health---${e.bodyHealth}  --- $bh');

            hr = listWeekDataForConcernLevel[index].value +
                double.parse(bh.toString());
            count = listWeekDataForConcernLevel[index].count;

            listWeekDataForConcernLevel.removeWhere((element) =>
                resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(element.title.toString()))) ==
                resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(e.timeStamp.toString()))));

            listWeekDataForConcernLevel
                .add(WeekModel(e.timeStamp.toString(), hr, count + 1));
          }
          listWeekDataForConcernLevel
              .sort((a, b) => a.title.compareTo(b.title));
        } else {
          printf('opps_else_getConcernLevelDataFor15Days');
        }
      });

      double totalHeart = 0;
      int count = 0;

      for (int i = 0; i < listWeekDataForConcernLevel.length; i++) {
        // var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(listWeekDataForConcernLevel[i].title));

        //printf('getConcernLevelDataFor15Days---weekList-15-days${DateFormat('dd-MMM-yyyy').format(dateTime)}'
        //    ' ${listWeekDataForConcernLevel[i].value} ${listWeekDataForConcernLevel[i].count}');

        if (listWeekDataForConcernLevel[i].value > 0) {
          totalHeart = totalHeart +
              listWeekDataForConcernLevel[i]
                  .value; //int.parse(measureUserList[i].heartRate.toString());
          count = count + listWeekDataForConcernLevel[i].count;
        } else {
          isLast15DaysHeartHealth = false;
        }
      }

      double avg = totalHeart / count;

      concernLevel = 100 - avg.roundToDouble().toInt();

      // printf('---getConcernLevelDataFor15Days--average---$avg  $concernLevel');
    } else {
      listWeekDataForConcernLevel =
          listWeekDataForConcernLevel.reversed.toList();
      //logFile('----no--record--found---for--last--15--days----getConcernLevelDataFor15Days');
      update();
    }
  }

  //-----------------------------------------------------------------

  Future<void> getUserDetail(userId) async {
    logFile('----userId---$userId---');
    DataSnapshot snapshot = await dbRef.child('$userId').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);

      logFile('user_values--${snapshot.value}');

      Utility.setUserDetails(jsonEncode(data));

      userModel = UserModel.fromJson(data);

      gender = userModel.gender.toString();

      //logFile('userAge-------${userModel.age}');

      try {
        username = userModel.name.toString()[0].toUpperCase() +
            userModel.name.toString().substring(1);
        age = int.parse(userModel.age.toString());
        isNonVegetarian = userModel.nonVegetarian.toString();

        userHeight = userModel.height.toString();
        userWeight = userModel.weight.toString();
        userDateOfBirth = userModel.dob.toString();

        getBMIValue(height: userHeight, weight: userWeight);
        //printf('userAge-$age $isNonVegetarian');
      } catch (exe) {
        logFile('-----exe---561---$exe');
      }

      update();
    } else {
      logFile('---no--data---available--567');
    }
  }

  void getHeartRythm(List<MeasureResult> rhythmList) {
    //printf('--------------------heartRhythmList-${rhythmList.length}');
    logFile('------heartRhythmLimit------${rhythmList.length}');

    try {
      rhythmList =
          rhythmList.sublist(rhythmList.length - 14, rhythmList.length);
    } catch (e) {
      printf('exe--820-->${e.toString()}');
    }

    if (rhythmList.length >= 14) {
      printf('----------rhythmList----${rhythmList.length}');

      double totalValue = 0;
      for (int i = 0; i < rhythmList.length; i++) {
        //printf('----------rhythmList----activity-$i--${rhythmList[i].activity}---date->${rhythmList[i].dateTime}');
        totalValue =
            totalValue + double.parse(rhythmList[i].heartRate.toString());
      }
      if (rhythmList[0].activity == 'sitting'.tr &&
          rhythmList[1].activity == 'sitting'.tr &&
          rhythmList[2].activity == 'sitting'.tr &&
          rhythmList[3].activity == 'sitting'.tr &&
          rhythmList[4].activity == 'sitting'.tr &&
          rhythmList[5].activity == 'sitting'.tr &&
          rhythmList[6].activity == 'sitting'.tr &&
          rhythmList[7].activity == 'sitting'.tr &&
          rhythmList[8].activity == 'sitting'.tr &&
          rhythmList[9].activity == 'sitting'.tr &&
          rhythmList[10].activity == 'sitting'.tr &&
          rhythmList[11].activity == 'sitting'.tr &&
          rhythmList[12].activity == 'sitting'.tr && // AppConstants.sitting
          rhythmList[13].activity == 'sitting'.tr) {
        var avg = totalValue / 14;
        if (avg > 85) {
          heartRhythmTitle = 'tachycardia'.tr;
          heartRhythmStatus = 'unhealthy'.tr;
        } else if (avg > 100) {
          heartRhythmTitle = 'tachycardia'.tr;
          heartRhythmStatus = 'very_unhealthy'.tr;
        } else if (avg < 60) {
          heartRhythmTitle = 'bradycardia'.tr;
          heartRhythmStatus = 'unhealthy'.tr;
        } else if (avg < 55) {
          heartRhythmTitle = 'bradycardia'.tr;
          heartRhythmStatus = 'very_unhealthy'.tr;
        }
      } else {
        isLast14DaysHeartRhythm = false;
      }
    } else {
      printf('no--heart--rhythm--found');
    }
  }

  void getBodyState(bteVal, hrVal, String bhealth, String oxVal, String bp) {
    int bhVal = 0;
    if (bhealth.length > 2) {
      String v = bhealth.substring(0, 2);
      bhVal = int.parse(v);
    }
    double sys = 0.0;

    if (bp.length > 4) {
      String v = bp.substring(0, 3);
      try {
        sys = double.parse(v);
      } catch (e) {
        printf('exe-$e');
      }

      //printf('sys-$sys');
    }

    double bte = bteVal;
    double hr = hrVal;
    int hearthealth = 0;
    int hrr = 0;
    int orr = 0;
    int brr = 0;

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

//-----------------------------------mood---end---------------------------------
    //
    if (bte < 93) {
      tempState = 'very_unhealthy'.tr;
    }
    if (bte < 95 && bte >= 93) {
      tempState = 'unhealthy'.tr;
    }
    if (bte >= 95 && bte < 96.5) {
      tempState = 'average'.tr;
    }
    if (bte >= 96.5 && bte < 97.5) {
      tempState = 'healthy'.tr;
      tempTips = 'your_body_temperature_is_well_maintained'.tr;
    }
    if (bte >= 97.5 && bte <= 98.5) {
      tempState = 'very_healthy';
      tempTips = 'your_body_temperature_is_well_maintained'.tr;
    }
    if (bte > 98.5 && bte <= 99.5) {
      tempState = 'healthy'.tr;
      tempTips = 'your_body_temperature_is_well_maintained'.tr;
    }
    if (bte > 99.5 && bte <= 100) {
      tempState = 'average'.tr;
    }
    if (bte > 100 && bte <= 101) {
      tempState = 'unhealthy'.tr;
    }
    if (bte > 101) {
      tempState = 'very_unhealthy'.tr;
    }

    //
    if (bhVal > 90) {
      bodyState = 'very_healthy'.tr;
    }
    if (bhVal > 80 && bhVal <= 90) {
      bodyState = 'healthy'.tr;
    }
    if (bhVal > 70 && bhVal <= 80) {
      bodyState = 'average'.tr;
    }
    if (bhVal > 60 && bhVal <= 70) {
      bodyState = 'unhealthy'.tr;
    }
    if (bhVal <= 60) {
      bodyState = 'very_unhealthy'.tr;
    }
    //
    if (hr == 0) {}
    if (hr > 0 && hr <= 67) {
      hrr = 100;
    }
    if (hr > 67) {
      if (hr > 67 && hr <= 71) {
        hrr = 95;
      }
      if (hr > 71 && hr <= 76) {
        hrr = 90;
      }
      if (hr > 76 && hr <= 83) {
        hrr = 80;
      }
      if (hr > 83) {
        hrr = 70;
      }
    }

    //
    if (sys <= 121 && sys >= 119) {
      brr = 100;
      bpState = 'very_healthy'.tr;
    }
    if (sys <= 123 && sys > 121) {
      brr = 90;
      bpState = 'healthy'.tr;
    }
    if (sys > 123 && sys <= 125) {
      brr = 80;
      bpState = 'average'.tr;
    }
    if (sys > 125) {
      brr = 70;
      bpState = 'unhealthy'.tr;
    }
    if (sys < 119 && sys >= 117) {
      brr = 90;
      bpState = 'healthy'.tr;
    }
    if (sys < 117 && sys >= 115) {
      brr = 80;
      bpState = 'average'.tr;
    }
    if (sys > 0 && sys < 115) {
      brr = 70;
      bpState = 'healthy'.tr;
    }
    if (sys == 0) {
      bpState = 'Not measured';
    }

    hearthealth = hrr + orr + brr; //((hrr + orr + brr) / 3) as int;

    double sl = stressLevelProgress * 100;
    stressLevel = sl.toInt();

    if (hearthealth >= 90) {
      healthTips = 'your_heart_is_in_normal_shape'.tr;
    }

    // // TODO here 2 fab,2024
    // Utility.isConnected().then((value) {
    //   if (value) {
    //     getEnergyLevel(hr);
    //   } else {
    //     logFile('internet_error---1074---get--energy-->');
    //   }
    // });
  }

  void getHeartRateCalculation(
      {required int age,
      required double hr,
      required double oxygenLevel,
      required double bloodPressure,
      required String activity,
      required String bodyHealth,
      required double hrv}) {
    printf(
        '----------------------getHeartRateCalculation------------------hr-->$hr');

    String userAge = '18';

    try {
      userAge =
          Utility.calculateAge(DateTime.parse(userDateOfBirth.toString()));
    } catch (e) {
      printf('exe--user-age-->$e');
    }

    age = int.parse(userAge);

    printf('--user--age-->$age');

    // var  = 0;
    if (activity == 'working'.tr || activity == 'studying'.tr) {
      //   = 10;
      hr = hr + 10;
    } else if (activity == 'running'.tr) {
      //   = 20;
      hr = hr + 20;
    } else if (activity == 'walking'.tr) {
      //     = 15;
      hr = hr + 15;
    }

    if (gender == 'Male' || gender == 'male') {
      printf('calculation-Male-$age $hr');

      if (age >= 18 && age <= 25) {
        printf('age---$age');

        if (hr <= 55) {
          hrState = 'normal';
        }

        if (hr >= 56 && hr <= 61) {
          hrState = 'normal';
        }

        if (hr >= 62 && hr <= 65) {
          hrState = 'normal'.tr;
        }

        if (hr >= 66 && hr <= 69) {
          hrState = 'normal'.tr;
        }

        if (hr >= 70 && hr <= 73) {
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 81) {
          hrState = 'high'.tr;
        }

        if (hr >= 82) {
          hrState = 'high'.tr;
        }
        printf('check---all-condition');
      }
      //
      if (age >= 26 && age <= 35) {
        if (hr <= 54) {
          hrState = 'normal';
        }

        if (hr >= 55 && hr <= 61) {
          hrState = 'normal';
        }

        if (hr >= 62 && hr <= 66) {
          hrState = 'normal'.tr;
        }

        if (hr >= 66 && hr <= 70) {
          hrState = 'normal'.tr;
        }

        if (hr >= 71 && hr <= 74) {
          hrState = 'normal'.tr;
        }

        if (hr >= 75 && hr <= 81) {
          hrState = 'high'.tr;
        }

        if (hr >= 82) {
          hrState = 'high'.tr;
        }
      }
      //
      if (age >= 36 && age <= 45) {
        if (hr <= 60) {
          hrState = 'normal';
        }

        if (hr >= 57 && hr <= 62) {
          hrState = 'normal';
        }

        if (hr >= 63 && hr <= 66) {
          hrState = 'normal'.tr;
        }

        if (hr >= 67 && hr <= 70) {
          hrState = 'normal'.tr;
        }

        if (hr >= 71 && hr <= 75) {
          hrState = 'normal'.tr;
        }

        if (hr >= 76 && hr <= 82) {
          hrState = 'high'.tr;
        }

        if (hr >= 83) {
          hrState = 'high'.tr;
        }
      }
      //
      if (age >= 46 && age <= 55) {
        if (hr <= 73) {
          hrState = 'normal';
        }

        if (hr >= 58 && hr <= 63) {
          hrState = 'normal';
        }

        if (hr >= 64 && hr <= 67) {
          hrState = 'normal'.tr;
        }

        if (hr >= 68 && hr <= 71) {
          hrState = 'normal'.tr;
        }

        if (hr >= 72 && hr <= 76) {
          hrState = 'normal'.tr;
        }
        if (hr >= 77 && hr <= 83) {
          hrState = 'high'.tr;
        }

        if (hr >= 84) {
          hrState = 'high'.tr;
        }
      }
      //
      if (age >= 56 && age <= 65) {
        if (hr <= 56) {
          hrState = 'normal';
        }

        if (hr >= 57 && hr <= 61) {
          hrState = 'normal';
        }

        if (hr >= 62 && hr <= 67) {
          hrState = 'normal'.tr;
        }

        if (hr >= 68 && hr <= 71) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 72 && hr <= 75) {
          hrState = 'normal'.tr;
        }

        if (hr >= 76 && hr <= 81) {
          hrState = 'high'.tr;
        }

        if (hr >= 82) {
          hrState = 'high'.tr;
        }
        //
        if (age > 65) {
          if (hr <= 55) {
            hrState = 'normal';
          }

          if (hr >= 56 && hr <= 61) {
            hrState = 'normal';
          }

          if (hr >= 62 && hr <= 65) {
            hrState = 'normal'.tr;
          }

          if (hr >= 66 && hr <= 69) {
            //hrState = 'Healthy';
            hrState = 'normal'.tr;
          }

          if (hr >= 70 && hr <= 73) {
            hrState = 'normal'.tr;
          }

          if (hr >= 74 && hr <= 79) {
            hrState = 'high'.tr;
          }

          if (hr > 80) {
            hrState = 'high'.tr;
          }
        }
      }
    }

    if (gender == 'Female' || gender == 'female') {
      printf('calculation-Female-$age');

      if (age >= 18 && age <= 25) {
        if (hr <= 65) {
          hrState = 'normal';
        }

        if (hr >= 61 && hr <= 65) {
          hrState = 'normal';
        }

        if (hr >= 66 && hr <= 69) {
          hrState = 'normal'.tr;
        }

        if (hr >= 70 && hr <= 73) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 78) {
          hrState = 'normal'.tr;
        }

        if (hr >= 79 && hr <= 84) {
          hrState = 'high'.tr;
        }

        if (hr > 85) {
          hrState = 'high'.tr;
        }
      }
      //
      if (age >= 26 && age <= 35) {
        if (hr <= 66) {
          hrState = 'normal';
        }

        if (hr >= 60 && hr <= 64) {
          hrState = 'normal';
        }

        if (hr >= 65 && hr <= 68) {
          hrState = 'normal'.tr;
        }

        if (hr >= 69 && hr <= 72) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 73 && hr <= 76) {
          hrState = 'normal'.tr;
        }

        if (hr >= 77 && hr <= 82) {
          hrState = 'high'.tr;
        }

        if (hr > 83) {
          hrState = 'high'.tr;
        }
      }
      //
      if (age >= 36 && age <= 45) {
        if (hr <= 66) {
          hrState = 'normal';
        }

        if (hr >= 60 && hr <= 64) {
          hrState = 'normal';
        }

        if (hr >= 65 && hr <= 69) {
          hrState = 'normal'.tr;
        }

        if (hr >= 70 && hr <= 73) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 78) {
          hrState = 'normal'.tr;
        }

        if (hr >= 79 && hr <= 84) {
          hrState = 'high'.tr;
        }

        if (hr > 85) {
          hrState = 'high'.tr;
        }
      }
      //
      if (age >= 46 && age <= 55) {
        if (hr <= 67) {
          hrState = 'normal';
        }

        if (hr >= 61 && hr <= 65) {
          hrState = 'normal';
        }

        if (hr >= 66 && hr <= 69) {
          hrState = 'normal'.tr;
        }

        if (hr >= 70 && hr <= 73) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 77) {
          hrState = 'normal'.tr;
        }

        if (hr >= 78 && hr <= 83) {
          hrState = 'high'.tr;
        }

        if (hr >= 84) {
          hrState = 'high'.tr;
        }
      }
      //
      if (age >= 56 && age <= 65) {
        if (hr <= 67) {
          hrState = 'normal';
        }

        if (hr >= 60 && hr <= 64) {
          hrState = 'normal';
        }

        if (hr >= 65 && hr <= 68) {
          hrState = 'normal'.tr;
        }

        if (hr >= 69 && hr <= 73) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 77) {
          hrState = 'normal'.tr;
        }

        if (hr >= 78 && hr <= 83) {
          hrState = 'high'.tr;
        }

        if (hr >= 84) {
          hrState = 'high'.tr;
        }
        //
        if (age > 65) {
          if (hr <= 65) {
            hrState = 'normal';
          }

          if (hr >= 60 && hr <= 64) {
            hrState = 'normal';
          }

          if (hr >= 65 && hr <= 68) {
            hrState = 'normal'.tr;
          }

          if (hr >= 69 && hr <= 72) {
            //hrState = 'Healthy';
            hrState = 'normal'.tr;
          }

          if (hr >= 73 && hr <= 76) {
            hrState = 'normal'.tr;
          }

          if (hr >= 77 && hr <= 84) {
            hrState = 'high'.tr;
          }

          if (hr > 85) {
            hrState = 'high'.tr;
          }
        }
      }
    }

    // oxygenLevel

    if (oxygenLevel > 97) {
      //oxygenState = 'Very healthy';
      oxygenState = 'normal'.tr;
    }

    if (oxygenLevel >= 96 && oxygenLevel <= 97) {
      //oxygenState = 'Healthy';
      oxygenState = 'normal'.tr;
    }

    if (oxygenLevel >= 95 && oxygenLevel <= 96) {
      oxygenState = 'low'.tr;
    }

    if (oxygenLevel >= 94 && oxygenLevel <= 95) {
      oxygenState = 'low'.tr;
    }

    if (oxygenLevel < 94) {
      oxygenState = 'low'.tr;
    }

    // Blood pressure

    if (bloodPressure >= 118 && bloodPressure <= 122) {
      bpState = 'normal'.tr;
    }

    if (bloodPressure >= 116 && bloodPressure <= 118) {
      bpState = 'low'.tr;
    }

    if (bloodPressure >= 122 && bloodPressure <= 124) {
      bpState = 'normal'.tr;
    }

    if (bloodPressure >= 114 && bloodPressure <= 116) {
      bpState = 'low'.tr;
    }

    if (bloodPressure >= 124 && bloodPressure <= 126) {
      bpState = 'high'.tr;
    }

    if (bloodPressure >= 112 && bloodPressure <= 114) {
      bpState = 'low'.tr;
    }

    if (bloodPressure >= 126 && bloodPressure <= 128) {
      bpState = 'high'.tr;
    }

    if (bloodPressure > 128) {
      bpState = 'high'.tr;
    }

    if (bloodPressure < 112) {
      bpState = 'low'.tr;
    }

    // HRVariability

    if (hrv < 80) {
      hrvState = 'low'.tr;
    } else if (hrv >= 80) {
      hrvState = 'normal'.tr;
    }

    //
// task 1 starts
    if (hrState == 'normal') {
      hrPoints = 100;
      hrTag = 'very_healthy'.tr;
    } else if (hrState == 'normal'.tr) {
      hrPoints = 80;
      hrTag = 'healthy'.tr;
    } else if (hrState == 'average'.tr) {
      hrPoints = 60;
      hrTag = 'average'.tr;
    } else if (hrState == 'below_average'.tr || hrState == 'below_average'.tr) {
      hrPoints = 40;
      hrTag = 'unhealthy'.tr;
    } else if (hrState == 'normal'.tr) {
      hrPoints = 20;
      hrTag = 'very_unhealthy'.tr;
    }

    // task1 ends

    //printf('-------checkHeartRate-$hrState $hrPoints');

    if (bodyHealth.length == 6) {
      var b = bodyHealth.substring(0, 2);
      int v = int.parse(b);
      progressValue = v / 100;
      heartHealthValue = "$v/100";
      printf('6--$b $v $progressValue');
    } else if (bodyHealth.length > 6) {
      var b = bodyHealth.substring(0, 3);
      int v = int.parse(b);
      progressValue = v / 100;
      heartHealthValue = "$v/100";
      printf('7--$b $v $progressValue');
    }
  }

  //

  void getHeartRateCalculationList(
      {required int age,
      required double hr,
      required double oxygenLevel,
      required double bloodPressure,
      required String activity,
      required String bodyHealth,
      required double hrv}) {
    String userAge = '18';

    try {
      userAge =
          Utility.calculateAge(DateTime.parse(userDateOfBirth.toString()));
    } catch (e) {
      printf('exe--user-age-->$e');
    }

    age = int.parse(userAge);

    // var  = 0;
    if (activity == 'working'.tr || activity == 'studying'.tr) {
      //   = 10;
      hr = hr - 10;
    } else if (activity == 'running'.tr) {
      //   = 20;
      hr = hr - 20;
    } else if (activity == 'walking'.tr) {
      //     = 15;
      hr = hr - 15;
    }

    printf(
        '<---------------------heart-rate----------------->$hr----age->$age----------gender-->$gender');
    //printf('----------------user--age-->$age--gender-->$gender');

    update();
    if (gender == 'Male'.tr || gender == 'male'.tr) {
      // printf('calculation-Male-$age $hr');

      if (age >= 18 && age <= 25) {
        printf('age---$age');

        if (hr <= 55) {
          hrState = 'normal';
        }

        if (hr >= 56 && hr <= 61) {
          hrState = 'normal';
        }

        if (hr >= 62 && hr <= 65) {
          hrState = 'normal'.tr;
        }

        if (hr >= 66 && hr <= 69) {
          hrState = 'normal'.tr;
        }

        if (hr >= 70 && hr <= 73) {
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 81) {
          hrState = 'high'.tr;
        }

        if (hr >= 82) {
          hrState = 'below_average'.tr;
        }
        printf('check---all-condition');
      }
      //
      if (age >= 26 && age <= 35) {
        if (hr <= 54) {
          hrState = 'normal';
        }

        if (hr >= 55 && hr <= 61) {
          hrState = 'normal';
        }

        if (hr >= 62 && hr <= 66) {
          hrState = 'normal'.tr;
        }

        if (hr >= 66 && hr <= 70) {
          hrState = 'normal'.tr;
        }

        if (hr >= 71 && hr <= 74) {
          hrState = 'average'.tr;
        }

        if (hr >= 75 && hr <= 81) {
          hrState = 'below_average'.tr;
        }

        if (hr >= 82) {
          hrState = 'below_average'.tr;
        }
      }
      //
      if (age >= 36 && age <= 45) {
        if (hr <= 57) {
          hrState = 'normal';
        }

        if (hr >= 57 && hr <= 62) {
          hrState = 'normal';
        }

        if (hr >= 63 && hr <= 66) {
          hrState = 'normal'.tr;
        }

        if (hr >= 67 && hr <= 70) {
          hrState = 'normal'.tr;
        }

        if (hr >= 71 && hr <= 75) {
          hrState = 'average'.tr;
        }

        if (hr >= 76 && hr <= 82) {
          hrState = 'below_average'.tr;
        }

        if (hr >= 83) {
          hrState = 'below_average'.tr;
        }
      }
      //
      if (age >= 46 && age <= 55) {
        if (hr <= 58) {
          hrState = 'normal';
        }

        if (hr >= 58 && hr <= 63) {
          hrState = 'normal';
        }

        if (hr >= 64 && hr <= 67) {
          hrState = 'normal'.tr;
        }

        if (hr >= 68 && hr <= 71) {
          hrState = 'normal'.tr;
        }

        if (hr >= 72 && hr <= 76) {
          hrState = 'average'.tr;
        }
        if (hr >= 77 && hr <= 83) {
          hrState = 'below_average'.tr;
        }

        if (hr >= 84) {
          hrState = 'below_average'.tr;
        }
      }
      //
      if (age >= 56) {
        if (hr <= 56) {
          hrState = 'normal';
        }

        if (hr >= 57 && hr <= 61) {
          hrState = 'normal';
        }

        if (hr >= 62 && hr <= 67) {
          hrState = 'normal'.tr;
        }

        if (hr >= 68 && hr <= 71) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 72 && hr <= 75) {
          hrState = 'average'.tr;
        }

        if (hr >= 76 && hr <= 81) {
          hrState = 'below_average'.tr;
        }

        if (hr >= 82) {
          hrState = 'below_average'.tr;
        }
        //
        if (age > 65) {
          if (hr >= 50 && hr <= 55) {
            hrState = 'normal';
          }

          if (hr >= 56 && hr <= 61) {
            hrState = 'normal';
          }

          if (hr >= 62 && hr <= 65) {
            hrState = 'normal'.tr;
          }

          if (hr >= 66 && hr <= 69) {
            //hrState = 'Healthy';
            hrState = 'normal'.tr;
          }

          if (hr >= 70 && hr <= 73) {
            hrState = 'average'.tr;
          }

          if (hr >= 74 && hr <= 79) {
            hrState = 'below_average'.tr;
          }

          if (hr > 80) {
            hrState = 'below_average'.tr;
          }
        }
      }
    }

    if (gender == 'Female'.tr || gender == 'female'.tr) {
      //printf('calculation-Female-$age');

      if (age >= 18 && age <= 25) {
        if (hr <= 60) {
          hrState = 'normal';
        }

        if (hr >= 61 && hr <= 65) {
          hrState = 'normal';
        }

        if (hr >= 66 && hr <= 69) {
          hrState = 'normal'.tr;
        }

        if (hr >= 70 && hr <= 73) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 78) {
          hrState = 'average'.tr;
        }

        if (hr >= 79 && hr <= 84) {
          hrState = 'below_average'.tr;
        }

        if (hr > 85) {
          hrState = 'below_average'.tr;
        }
      }
      //
      if (age >= 26 && age <= 35) {
        if (hr <= 59) {
          hrState = 'normal';
        }

        if (hr >= 60 && hr <= 64) {
          hrState = 'normal';
        }

        if (hr >= 65 && hr <= 68) {
          hrState = 'normal'.tr;
        }

        if (hr >= 69 && hr <= 72) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 73 && hr <= 76) {
          hrState = 'average'.tr;
        }

        if (hr >= 77 && hr <= 82) {
          hrState = 'below_average'.tr;
        }

        if (hr > 83) {
          hrState = 'below_average'.tr;
        }
      }
      //
      if (age >= 36 && age <= 45) {
        if (hr <= 59) {
          hrState = 'normal';
        }

        if (hr >= 60 && hr <= 64) {
          hrState = 'normal';
        }

        if (hr >= 65 && hr <= 69) {
          hrState = 'normal'.tr;
        }

        if (hr >= 70 && hr <= 73) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 78) {
          hrState = 'average'.tr;
        }

        if (hr >= 79 && hr <= 84) {
          hrState = 'below_average'.tr;
        }

        if (hr > 85) {
          hrState = 'below_average'.tr;
        }
      }
      //
      if (age >= 46 && age <= 55) {
        if (hr <= 60) {
          hrState = 'normal';
        }

        if (hr >= 61 && hr <= 65) {
          hrState = 'normal';
        }

        if (hr >= 66 && hr <= 69) {
          hrState = 'normal'.tr;
        }

        if (hr >= 70 && hr <= 73) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 77) {
          hrState = 'average'.tr;
        }

        if (hr >= 78 && hr <= 83) {
          hrState = 'below_average'.tr;
        }

        if (hr >= 84) {
          hrState = 'below_average'.tr;
        }
      }
      //
      if (age >= 56) {
        if (hr <= 59) {
          hrState = 'normal';
        }

        if (hr >= 60 && hr <= 64) {
          hrState = 'normal';
        }

        if (hr >= 65 && hr <= 68) {
          hrState = 'normal'.tr;
        }

        if (hr >= 69 && hr <= 73) {
          //hrState = 'Healthy';
          hrState = 'normal'.tr;
        }

        if (hr >= 74 && hr <= 77) {
          hrState = 'average'.tr;
        }

        if (hr >= 78 && hr <= 83) {
          hrState = 'below_average'.tr;
        }

        if (hr >= 84) {
          hrState = 'below_average'.tr;
        }
        //
        if (age > 65) {
          if (hr >= 62 && hr <= 65) {
            hrState = 'normal';
          }

          if (hr >= 60 && hr <= 64) {
            hrState = 'normal';
          }

          if (hr >= 65 && hr <= 68) {
            hrState = 'normal'.tr;
          }

          if (hr >= 69 && hr <= 72) {
            //hrState = 'Healthy';
            hrState = 'normal'.tr;
          }

          if (hr >= 73 && hr <= 76) {
            hrState = 'average'.tr;
          }

          if (hr >= 77 && hr <= 84) {
            hrState = 'below_average'.tr;
          }

          if (hr > 85) {
            hrState = 'below_average'.tr;
          }
        }
      }
    }

    // oxygenLevel

    if (oxygenLevel > 97) {
      //oxygenState = 'Very healthy';
      oxygenState = 'normal'.tr;
    }

    if (oxygenLevel >= 96 && oxygenLevel <= 97) {
      //oxygenState = 'Healthy';
      oxygenState = 'normal'.tr;
    }

    if (oxygenLevel >= 95 && oxygenLevel <= 96) {
      oxygenState = 'average'.tr;
    }

    if (oxygenLevel >= 94 && oxygenLevel <= 95) {
      oxygenState = 'below_average'.tr;
    }

    if (oxygenLevel < 94) {
      oxygenState = 'bad'.tr;
    }

    // Blood pressure

    if (bloodPressure >= 118 && bloodPressure <= 122) {
      bpState = 'normal'.tr;
    }

    if (bloodPressure >= 116 && bloodPressure <= 118) {
      bpState = 'normal'.tr;
    }

    if (bloodPressure >= 122 && bloodPressure <= 124) {
      bpState = 'normal'.tr;
    }

    if (bloodPressure >= 114 && bloodPressure <= 116) {
      bpState = 'average'.tr;
    }

    if (bloodPressure >= 124 && bloodPressure <= 126) {
      bpState = 'average'.tr;
    }

    if (bloodPressure >= 112 && bloodPressure <= 114) {
      bpState = 'below_average'.tr;
    }

    if (bloodPressure >= 126 && bloodPressure <= 128) {
      bpState = 'below_average'.tr;
    }

    if (bloodPressure > 128) {
      bpState = 'bad'.tr;
    }

    if (bloodPressure < 112) {
      bpState = 'bad'.tr;
    }

    // HRVariability

    if (hrv < 50) {
      hrvState = 'below_average'.tr;
    } else if (hrv >= 50 && hrv < 100) {
      hrvState = 'average'.tr;
    } else if (hrv >= 100) {
      hrvState = 'normal'.tr;
    }

    //

    if (hrState == 'normal' ||
        hrState == 'very_healthy'.tr ||
        hrState == 'normal') {
      hrPoints = 100;
      hrTag = 'very_healthy'.tr;
    } else if (hrState == 'normal'.tr || hrState == 'normal'.tr) {
      hrPoints = 80;
      hrTag = 'healthy'.tr;
    } else if (hrState == 'average'.tr) {
      hrPoints = 60;
      hrTag = 'average'.tr;
    } else if (hrState == 'below_average'.tr || hrState == 'below_average'.tr) {
      hrPoints = 40;
      hrTag = 'unhealthy'.tr;
    } else if (hrState == 'normal'.tr) {
      hrPoints = 20;
      hrTag = 'very_unhealthy'.tr;
    }

    //printf('-------checkHeartRate-$hrState $hrPoints');

    if (bodyHealth.length == 6) {
      var b = bodyHealth.substring(0, 2);
      int v = int.parse(b);
      progressValue = v / 100;
      heartHealthValue = "$v/100";
      //printf('6--$b $v $progressValue');
      // TODO 5 fab,2024
      //  getRandomTips(v);
    } else if (bodyHealth.length > 6) {
      var b = bodyHealth.substring(0, 3);
      int v = int.parse(b);
      progressValue = v / 100;
      heartHealthValue = "$v/100";
      //printf('7--$b $v $progressValue');
      // TODO 5 fab,2024
      //  getRandomTips(v);
    }
  }

  void calculateStrokeVolume(
      {required String bp, required double hr, required double hrv}) {
    String sys = bp.substring(0, bp.indexOf('/'));
    String dys = bp.substring(bp.indexOf('/') + '/'.length, bp.length);
    double pulsePress =
        double.parse(sys).roundToDouble() - double.parse(dys).roundToDouble();

    double k1 = 1.75 * 30;
    double k2 = 200;
    printf('pulse----->$pulsePress');
    printf('hr----->$hr');
    printf('hrv----->$hrv');
    double sv =
        (pulsePress * k1 * (1 + (hrv / k2))) / hr; //stroke volume formulaS

    printf('stroke ----->$sv');
    strokeVolume = sv.toString();
    if (sv <= 35) {
      strokeMsg = 'low'.tr;
    }
    if (sv > 65) {
      strokeMsg = 'high'.tr;
    }
    if (sv > 35 && sv <= 65) {
      strokeMsg = 'normal'.tr;
    }

//cardiac output
    double co = (sv * hr) / 1000; //cardiac output formula
    cardiacOutput = co.toString();
    printf('$co');
    if (co <= 5.5) {
      cardiacMsg = 'low'.tr;
    }
    if (co > 7.5) {
      cardiacMsg = 'high'.tr;
    }
    if (co > 5.5 && co <= 7.5) {
      cardiacMsg = 'normal'.tr;
    }
  }

  void calculateBFI({required String bp}) {
    String sys = bp.substring(0, bp.indexOf('/'));
    String dys = bp.substring(bp.indexOf('/') + '/'.length, bp.length);

    double systolicBP = double.parse(sys); // Systolic blood pressure
    double diastolicBP = double.parse(dys); // Diastolic blood pressure
    if (systolicBP <= diastolicBP) return; // Ensure valid BP values

    double pulsePressure = systolicBP - diastolicBP;
    double meanArterialPressure = diastolicBP + (pulsePressure / 3);
    double bpMean = (systolicBP + (2 * diastolicBP)) / 3;

    // Optimal and physiological ranges
    double ppOptimal = 40, ppRange = 20;
    double mapOptimal = 93, mapRange = 20;
    double bpMeanOptimal = 93, bpRange = 20;

    // Weighting factors
    double w1 = 4, w2 = 3, w3 = 3;

    // Compute individual deviations
    double ppDeviation = (pulsePressure - ppOptimal).abs() / ppRange;
    double mapDeviation = (meanArterialPressure - mapOptimal).abs() / mapRange;
    double bpMeanDeviation = (bpMean - bpMeanOptimal).abs() / bpRange;

    // Compute Blood Flow Index (BFI) out of 10
    double bfi =
        10 - (w1 * ppDeviation + w2 * mapDeviation + w3 * bpMeanDeviation);
    printf('bfi----->$bfi');

    //statements logic

    if (bfi >= 9) {
      bfiStatement +=
          "A high level indicates excellent blood flow, ensuring efficient oxygen delivery, minimal vascular resistance, and a well-functioning cardiovascular system.";
    } else if (bfi >= 7) {
      bfiStatement =
          "A good level suggests healthy circulation with only minor variations, maintaining stable oxygen supply and heart performance with minimal effort.";
    } else if (bfi >= 5) {
      bfiStatement =
          "A moderate level indicates some inefficiencies in circulation, possibly due to mild vascular resistance, stress, or temporary fluctuations in blood pressure.";
    } else if (bfi >= 3) {
      bfiStatement =
          "A lower level suggests reduced blood flow efficiency, potential vascular stiffness, and a higher workload on the heart, which may require lifestyle adjustments.";
    }

    printf('bfiStatement----->$bfiStatement');
  }

// calcultae hri

  double calculateHRI({required double hr, required double hrv}) {
    if (hr <= 0 || hrv < 0) return 0.0;

    double rrInterval = 60000 / hr;
    // Optimal and physiological ranges
    double hrOptimal = 60, hrRange = 30;
    double rrOptimal = 1000, rrRange = 400;
    double hrvOptimal = 120, hrvRange = 70;

    // Weighting factors
    double w1 = 4, w2 = 3, w3 = 3;

    // Compute individual deviations
    double hrDeviation = (hr - hrOptimal).abs() / hrRange;
    double rrDeviation = (rrInterval - rrOptimal).abs() / rrRange;
    double hrvDeviation = (hrv - hrvOptimal).abs() / hrvRange;

    // Compute Heart Rhythm Index (HRI) out of 10
    double hri = 10 - (w1 * hrDeviation + w2 * rrDeviation + w3 * hrvDeviation);
    printf("hri----->$hri");

    if (hri >= 9) {
      hriStatement =
          "A high level indicates excellent heart adaptability, stable nervous system regulation, and minimal irregularities in heartbeat patterns.";
    } else if (hri >= 7) {
      hriStatement =
          "A good level suggests a well-maintained rhythm with only minor variations, indicating strong cardiovascular efficiency and stress adaptability.";
    } else if (hri >= 5) {
      hriStatement =
          "A moderate level suggests some fluctuations, possibly linked to stress, fatigue, or early signs of autonomic imbalances that should be monitored over time.";
    } else if (hri >= 3) {
      hriStatement =
          "A lower level suggests increased irregularities in heart rhythm, potential autonomic dysfunction, or a higher cardiac workload that may require lifestyle adjustments.";
    } else {
      hriStatement =
          "A very low level indicates significant heart rhythm instability, autonomic stress, or irregular beats that may require medical attention and further evaluation.";
    }

    printf('hriStatement----->$hriStatement');
    // Ensure HRI stays within 0-10 range
    return hri.clamp(0.0, 10.0);
  }

// calculate pulsePressure
  void getPulsePressure({required String bp}) {
    printf(
        '---------------------------getPulsePressure----------------------$bp');
    String sys = bp.substring(0, bp.indexOf('/'));
    String dys = bp.substring(bp.indexOf('/') + '/'.length, bp.length);

    systolic = sys;
    diastolic = dys;

    double pulse =
        double.parse(sys).roundToDouble() - double.parse(dys).roundToDouble();
    // double pulse = 55;

    pulsePressure = pulse.toString();

    try {
      getArterialPressure(dys: double.parse(dys).roundToDouble(), pulse: pulse);
    } catch (e) {
      printf('exe-pulse-$e');
    }

    if (pulse <= 35) {
      pulseMessage = 'Low'.tr;
    }
    if (pulse >= 45) {
      pulseMessage = 'High'.tr;
    }
    if (pulse > 35 && pulse <= 45) {
      pulseMessage = 'Normal'.tr;
    }

    update();
  }

  void getArterialPressure({required double dys, required double pulse}) {
    printf(
        '---------------------------getArterialPressure---------------------->$dys--->$pulse-->');
    // printf('arterial pressure---$dys---$pulse');
    //logFile('-----arterial---pressure-----$dys---$pulse');

    double map = dys + (1 / 3 * pulse).toInt();
    // double map = 115;

    // printf('----map--value--$map');

    arterialPressure = map.toString();
    if (map >= 70 && map <= 100) {
      arterialMessage = 'normal'.tr;
    }

    if (map < 70) {
      arterialMessage = 'low'.tr; //AppConstants.low;
    }

    if (map > 100) {
      arterialMessage = 'high'.tr; // AppConstants.high;
    }

    update();
  }

  Future<void> getVisualise(userId) async {
    //logFile('--------call---last--14--days----average------getVisualise--');
    //DateTime dateTime = DateTime.now().toUtc();
    DateTime dateTime = DateTime.now().subtract(const Duration(days: 1));

    List<DateTime> weekList = [];

    DateTime dt;
    for (int i = 0; i < 14; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));

      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      weekList.add(date);
    }

    Utility.isConnected().then((value) {
      if (value) {
        getVisualizeDataForLast14Days(
            userId: userId,
            startDate: weekList.last.millisecondsSinceEpoch,
            endDate: weekList.first.millisecondsSinceEpoch);

        printf(
            '--start->${weekList.last.millisecondsSinceEpoch}---end-->${weekList.first.millisecondsSinceEpoch}');
      } else {
        logFile('----offline---14---days--getVisualise---');
      }
    });

    // update();
  }

  Future<void> getVisualizeDataForLast14Days(
      {required String userId,
      required int startDate,
      required int endDate}) async {
    List<MeasureResult> weekMeasureList = [];

    var resultFormatter = DateFormat('dd-MMM-yyyy');

    var dtStart = DateTime.fromMillisecondsSinceEpoch(startDate);
    var dtEnd = DateTime.fromMillisecondsSinceEpoch(endDate);
    printf(
        '--startDate!!--->${resultFormatter.format(dtStart)}--end->${resultFormatter.format(dtEnd)}');
    //logFile('----get--week--data-----getVisualizeDataForLast14Days---1542');

    // Get.context!.loaderOverlay.show();

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

      //weekMeasureList.setRange(startDate, endDate, iterable);

      //weekMeasureList.map((e) => e.);

      printf('total---14---days--->${weekMeasureList.length}---1524');

      if (weekMeasureList.isNotEmpty) {
        weekMeasureList.forEach((e) {
          printf(
              '---element-e-->${e.dateTime}-->${e.measureTime}--->${e.activity}');
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

              if (e.activity == 'sitting'.tr) {
                measureListForHeartRythm.add(e);
              }

              hr = listWeekData[index].value +
                  double.parse(e.heartRate.toString());
              count = listWeekData[index].count;

              listWeekData.removeWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              listWeekData
                  .add(WeekModel(e.timeStamp.toString(), hr, count + 1));

              String sys = e.bloodPressure
                  .toString()
                  .substring(0, e.bloodPressure.toString().indexOf('/'));
              String dys = e.bloodPressure.toString().substring(
                  e.bloodPressure.toString().indexOf('/') + '/'.length,
                  e.bloodPressure.toString().length);

              //double systolicValue = double.parse(sys).roundToDouble() - double.parse(dys).roundToDouble();

              last14daySystolic.add(double.parse(sys).roundToDouble());
              last14daysDiastolic.add(double.parse(dys).roundToDouble());
            }
            listWeekData.sort((a, b) => a.title.compareTo(b.title));
          } else {
            printf('opps_else');
          }
        });

        double totalHeart = 0;
        int count = 0;

        for (int i = 0; i < listWeekData.length; i++) {
          if (listWeekData[i].value > 0) {
            totalHeart = totalHeart +
                listWeekData[i]
                    .value; //int.parse(measureUserList[i].heartRate.toString());
            count = count + listWeekData[i].count;
          } else {
            isLast14DaysValue = false;
          }
        }

        double avg = totalHeart / count;

        avg7days = avg.roundToDouble().toString();

        double gifValue = avg.roundToDouble() * 12 / 60;

        try {
          gifSpeed = gifValue.toInt();
        } catch (e) {
          printf('exe--gif-speed-->$e');
        }

        // TODO calculation 88*12/60 = gifSpeed

        // printf('-----------gif-value---$avg7days---');
        // printf('-----------gif-calculation---$avg7days*12/60=$gifSpeed');

        for (int i = 0; i < last14daySystolic.length; i++) {
          systolicAverage = systolicAverage + last14daySystolic[i];
        }

        for (int i = 0; i < last14daysDiastolic.length; i++) {
          diastolicAverage = diastolicAverage + last14daysDiastolic[i];
        }

        systolicAverage = systolicAverage / last14daySystolic.length;
        diastolicAverage = diastolicAverage / last14daysDiastolic.length;

        //  printf('-----------total systolic and diastolic ------$systolicAverage---$diastolicAverage---');
      } else {
        listWeekData = listWeekData.reversed.toList();
        isLast14DaysValue = false;
        logFile(
            '----no--record--found---for--last--14--days----getVisualizeDataForLast14Days----1666>$gifSpeed');
        update();
      }
      //logFile('----end--14---days---week--data--$isLast14DaysValue');

      // --------------------------------------------------------
      if (isLast14DaysValue) {
        if (measureUserList.length >= 14) {
          getHeartRythm(measureListForHeartRythm);
        } else {
          isLast14DaysHeartRhythm = false;
        }
      } else {
        isLast14DaysHeartRhythm = false;
      }
      // ----------------------------------------------------------

      //Get.context!.loaderOverlay.hide();
    });

    // Get.context!.loaderOverlay.hide();
  }

  Future<void> getEnergyLevel(double hr) async {
    // get total today's records value for hrv and get average
    // energy level = today's total/ total records

    var todayDate = DateTime.now();
    //today = DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
    var todayDateTemp =
        //'08-Dec-2023';
        DateTime(todayDate.year, todayDate.month, todayDate.day);
    var resultFormatter = DateFormat('dd-MMM-yyyy');

    //printf('call---get--energy--level---todayDate-$todayDateTemp--->${resultFormatter.format(todayDateTemp)} ');
    List<MeasureResult> measureUserList = [];
    List<GraphModel> graphDayList = [];

    //Get.context!.loaderOverlay.show();

    DataSnapshot snapshot = await dbMeasure.child(userId).get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        MeasureResult activityModel = MeasureResult.fromJson(data);

        //logFile('----date-time-for-energy ---${activityModel.dateTime}');

        if (activityModel.dateTime.toString() ==
            resultFormatter.format(todayDateTemp)) {
          measureUserList.add(activityModel);
        }
        update();
      });

      int totalHeart = 0;

      //printf('----energy--level---measureList-${measureUserList.length}');

      if (measureUserList.isNotEmpty) {
        for (int i = 0; i < measureUserList.length; i++) {
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

          //printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].hrVariability.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].hrVariability.toString()).toInt();

          // printf('----energy--level---hrv--value--->${measureUserList[i].hrVariability.toString()}');

          update();
        }

        printf('----energy--level---List-->${graphDayList.length}');
        int avgLevel = 0;
        if (measureUserList.isNotEmpty) {
          double avg = totalHeart / measureUserList.length;
          avgLevel = avg.roundToDouble().toInt();
        } else {
          avgLevel = 0;
        }

        double el = avgLevel * 0.5;

        energyLevelProgress = el / 100;
        energyLevel = el.toInt();

        printf('---energy--level--today--average--->$avgLevel-->${el.toInt()}');

        if (energyLevel >= 80 && energyLevel < 100) {
          energyLevelMsg = 'very_high'.tr;
        } else if (energyLevel >= 60 && energyLevel < 80) {
          energyLevelMsg = 'high'.tr;
        } else if (energyLevel >= 40 && energyLevel < 60) {
          energyLevelMsg = 'average'.tr;
        } else if (energyLevel >= 20 && energyLevel < 40) {
          energyLevelMsg = 'low'.tr;
        } else if (energyLevel >= 0 && energyLevel < 20) {
          energyLevelMsg = 'very_low'.tr;
        }
      } else {
        printf('--no---records--found--for---energy---level');
      }

      //Get.context!.loaderOverlay.hide();

      //update();

      //getStressLevel(hr);
    } else {
      printf('no_children_exists_for_today_hrv');
    }
  }

  Future<void> getEnergyLevelList(
      double hr, List<MeasureResult> totalMeasureRecordList) async {
    // get total today's records value for hrv and get average
    // energy level = today's total/ total records

    printf(
        '-------------------enery---level---------------------------------->$hr----->${totalMeasureRecordList.length}');

    var todayDate = DateTime.now();
    //today = DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
    var todayDateTemp =
        DateTime(todayDate.year, todayDate.month, todayDate.day);
    var resultFormatter = DateFormat('dd-MMM-yyyy');
    List<MeasureResult> measureUserList = [];
    List<GraphModel> graphDayList = [];

    //Get.context!.loaderOverlay.show();

    //DataSnapshot snapshot = await dbMeasure.child(userId).get();

    if (totalMeasureRecordList.isNotEmpty) {
      totalMeasureRecordList.forEach((element) {
        if (element.dateTime.toString() ==
            resultFormatter.format(todayDateTemp)) {
          measureUserList.add(element);
        }
        update();
      });

      int totalHeart = 0;

      printf('----energy--level---measureList-${measureUserList.length}');

      if (measureUserList.isNotEmpty) {
        for (int i = 0; i < measureUserList.length; i++) {
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

          //printf('------------------${dateFormatTime.format(currentDate)}');

          graphDayList.add(GraphModel(
              dateFormatTime.format(currentDate).toString(),
              double.parse(measureUserList[i].hrVariability.toString())));

          totalHeart = totalHeart +
              double.parse(measureUserList[i].hrVariability.toString()).toInt();

          // printf('----energy--level---hrv--value--->${measureUserList[i].hrVariability.toString()}');

          update();
        }

        printf('----energy--level---List-->${graphDayList.length}');
        int avgLevel = 0;
        if (measureUserList.isNotEmpty) {
          double avg = totalHeart / measureUserList.length;
          avgLevel = avg.roundToDouble().toInt();
        } else {
          avgLevel = 0;
        }

        double el = avgLevel * 0.5;

        energyLevelProgress = el / 100;
        energyLevel = el.toInt();

        printf('---energy--level--today--average--->$avgLevel-->${el.toInt()}');

        if (energyLevel >= 80 && energyLevel < 100) {
          energyLevelMsg = 'very_high'.tr;
        } else if (energyLevel >= 60 && energyLevel < 80) {
          energyLevelMsg = 'high'.tr;
        } else if (energyLevel >= 40 && energyLevel < 60) {
          energyLevelMsg = 'average'.tr;
        } else if (energyLevel >= 20 && energyLevel < 40) {
          energyLevelMsg = 'low'.tr;
        } else if (energyLevel >= 0 && energyLevel < 20) {
          energyLevelMsg = 'very_low'.tr;
        } else if (energyLevel > 100) {
          energyLevelMsg = 'very_high'.tr;
          energyLevel = 100;
        }
      } else {
        printf('--no---records--found--for---energy---level');
      }

      //Get.context!.loaderOverlay.hide();

      //update();

      //getStressLevel(hr);
      getStressLevelList(hr, totalMeasureRecordList);
    } else {
      printf('no_children_exists_for_today_hrv');
    }
  }

  Future<void> getStressLevelList(
      double hr, List<MeasureResult> totalMeasureRecordList) async {
    // get total today's records value for blood pressure and get average

    // stress level = today's total/ total records

    var todayDate = DateTime.now();
    //today = DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
    var resultFormatter = DateFormat('dd-MMM-yyyy');
    var todayDateTemp =
        //'08-Dec-2023';
        DateTime(todayDate.year, todayDate.month, todayDate.day);
    //printf('call---get--stress--level---todayDate-$todayDateTemp---hr-- $hr');
    List<MeasureResult> measureUserList = [];
    List<GraphModel> graphDayList = [];

    //Get.context!.loaderOverlay.show();
    if (totalMeasureRecordList.isNotEmpty) {
      totalMeasureRecordList.forEach((element) {
        if (element.dateTime.toString() ==
            resultFormatter.format(todayDateTemp)) {
          measureUserList.add(element);
        }
        update();
      });

      int totalHeart = 0;
      double totalStress = 0;

      //printf('----stress--level---measureList-${measureUserList.length}');

      if (measureUserList.isNotEmpty) {
        for (int i = 0; i < measureUserList.length; i++) {
          String input = measureUserList[i].bloodPressure.toString();
          String heartRate = measureUserList[i].heartRate.toString();
          List values = input.split("/");

          double sys = double.parse(values[0].toString());
          double hr = double.parse(heartRate.toString());
          //double d = double.parse(values[1].toString());

          //  printf('----stress---level--bp-->$sys  hr->$hr');

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
              sys.roundToDouble()));

          totalHeart = totalHeart + sys.toInt();

          if (sys > 0) {
            if (sys <= 123 && sys >= 117) {
              if (hr <= 62) {
                stressLevelProgress = 0;
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

          totalStress = totalStress + stressLevelProgress;
          // printf('----stress---progress--->$stressLevelProgress --> $totalStress');
          update();
        }
        // printf('--total--stress---progress-->$totalStress');

        totalStress = totalStress * 100 / measureUserList.length;

        stressLevel = totalStress.toInt();

        stressLevelProgress = totalStress / 100;

        // printf('--total--stress---progress-2->$totalStress--progress-->$stressLevelProgress');

        if (totalStress >= 80 && totalStress < 100) {
          stressLevelMsg = 'very_high'.tr;
        } else if (totalStress >= 60 && totalStress < 80) {
          stressLevelMsg = 'high'.tr;
        } else if (totalStress >= 40 && totalStress < 60) {
          stressLevelMsg = 'average'.tr;
        } else if (totalStress >= 20 && totalStress < 40) {
          stressLevelMsg = 'low'.tr;
        } else if (totalStress >= 0 && totalStress < 20) {
          stressLevelMsg = 'very_low'.tr;
        }
      } else {
        printf('--no---records--found--for---stress---level');
      }

      printf('--last---loader--hide--');
      isLoading.value = false;
      //Get.context!.loaderOverlay.hide();

      update();
    } else {
      printf('no_children_exists_for_today_stress_level');
    }
  }

  Future<void> getStressLevel(double hr) async {
    // get total today's records value for blood pressure and get average

    // stress level = today's total/ total records

    var todayDate = DateTime.now();
    //today = DateTime(today.year, today.month, today.day, 0, 0, 0, 0, 0);
    var resultFormatter = DateFormat('dd-MMM-yyyy');
    var todayDateTemp =
        //'08-Dec-2023';
        DateTime(todayDate.year, todayDate.month, todayDate.day);
    printf('call---get--stress--level---todayDate-$todayDateTemp---hr-- $hr');
    List<MeasureResult> measureUserList = [];
    List<GraphModel> graphDayList = [];

    //Get.context!.loaderOverlay.show();

    DataSnapshot snapshot = await dbMeasure.child(userId).get();

    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        if (activityModel.dateTime.toString() ==
            resultFormatter.format(todayDateTemp)) {
          measureUserList.add(activityModel);
        }
        update();
      });

      int totalHeart = 0;
      double totalStress = 0;

      printf('----stress--level---measureList-${measureUserList.length}');

      if (measureUserList.isNotEmpty) {
        for (int i = 0; i < measureUserList.length; i++) {
          String input = measureUserList[i].bloodPressure.toString();
          String heartRate = measureUserList[i].heartRate.toString();
          List values = input.split("/");

          double sys = double.parse(values[0].toString());
          double hr = double.parse(heartRate.toString());
          //double d = double.parse(values[1].toString());

          //  printf('----stress---level--bp-->$sys  hr->$hr');

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
              sys.roundToDouble()));

          totalHeart = totalHeart + sys.toInt();

          if (sys > 0) {
            if (sys <= 123 && sys >= 117) {
              if (hr <= 62) {
                stressLevelProgress = 0;
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

          totalStress = totalStress + stressLevelProgress;
          // printf('----stress---progress--->$stressLevelProgress --> $totalStress');
          update();
        }
        // printf('--total--stress---progress-->$totalStress');

        totalStress = totalStress * 100 / measureUserList.length;

        stressLevel = totalStress.toInt();

        stressLevelProgress = totalStress / 100;

        // printf('--total--stress---progress-2->$totalStress--progress-->$stressLevelProgress');

        if (totalStress >= 80 && totalStress < 100) {
          stressLevelMsg = 'very_high'.tr;
        } else if (totalStress >= 60 && totalStress < 80) {
          stressLevelMsg = 'high'.tr;
        } else if (totalStress >= 40 && totalStress < 60) {
          stressLevelMsg = 'average'.tr;
        } else if (totalStress >= 20 && totalStress < 40) {
          stressLevelMsg = 'low'.tr;
        } else if (totalStress >= 0 && totalStress < 20) {
          stressLevelMsg = 'very_low'.tr;
        }
      } else {
        printf('--no---records--found--for---stress---level');
      }

      printf('--last---loader--hide--');
      isLoading.value = false;
      //Get.context!.loaderOverlay.hide();

      update();
    } else {
      printf('no_children_exists_for_today_stress_level');
    }
  }

  Future<void> getConcernLevel(userId) async {
    //logFile('--------call---last--15--days----average------for--concern--level');

    // get last 15 days records for body health
    //DateTime dateTime = DateTime.now().toUtc();
    DateTime dateTime = DateTime.now().subtract(const Duration(days: 1));

    /*List<DateTime> weekList = [];
    List<String> weekDateList = [];
    List<WeekModel> listWeekData = [];*/

    DateTime dt;
    for (int i = 0; i < 15; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekDateListForConcernLevel.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekDataForConcernLevel
          .add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      weekListForConcernLevel.add(date);
    }

    Utility.isConnected().then((value) {
      if (value) {
        getConcernLevelDataFor15Days(
            userId: userId,
            startDate: weekListForConcernLevel.last.millisecondsSinceEpoch,
            endDate: weekListForConcernLevel.first.millisecondsSinceEpoch);
        //logFile('----online---15---days-----for--concern--level');
      } else {
        logFile('----offline---15---days----for--concern--level');
      }
    });

    //update();
  }

  Future<void> getConcernLevelDataFor15Days(
      {required String userId,
      required int startDate,
      required int endDate}) async {
    List<MeasureResult> weekMeasureList = [];

    // List<WeekModel> listWeekData = [];
    var resultFormatter = DateFormat('dd-MMM-yyyy');

    //logFile('----call----getConcernLevelDataFor15Days-----');

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

      printf(
          'total---getConcernLevelDataFor15Days---${weekMeasureList.length}---');

      if (weekMeasureList.isNotEmpty) {
        weekMeasureList.forEach((e) {
          printf('concern-level--->${e.dateTime}--->${e.activity}');

          var dateTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(e.timeStamp.toString()));

          if (weekDateListForConcernLevel
              .contains(resultFormatter.format(dateTime))) {
            if (listWeekDataForConcernLevel.isNotEmpty) {
              int index = listWeekDataForConcernLevel.indexWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              double hr = 0.0;
              int count = 0;

              String bh = e.bodyHealth
                  .toString()
                  .substring(0, e.bodyHealth.toString().indexOf('/'));

              //  printf('------body---health---${e.bodyHealth}  --- $bh');

              hr = listWeekDataForConcernLevel[index].value +
                  double.parse(bh.toString());
              count = listWeekDataForConcernLevel[index].count;

              listWeekDataForConcernLevel.removeWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              listWeekDataForConcernLevel
                  .add(WeekModel(e.timeStamp.toString(), hr, count + 1));
            }
            listWeekDataForConcernLevel
                .sort((a, b) => a.title.compareTo(b.title));
          } else {
            printf('opps_else_getConcernLevelDataFor15Days');
          }
        });

        double totalHeart = 0;
        int count = 0;

        for (int i = 0; i < listWeekDataForConcernLevel.length; i++) {
          // var dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(listWeekDataForConcernLevel[i].title));

          //printf('getConcernLevelDataFor15Days---weekList-15-days${DateFormat('dd-MMM-yyyy').format(dateTime)}'
          //    ' ${listWeekDataForConcernLevel[i].value} ${listWeekDataForConcernLevel[i].count}');

          if (listWeekDataForConcernLevel[i].value > 0) {
            totalHeart = totalHeart +
                listWeekDataForConcernLevel[i]
                    .value; //int.parse(measureUserList[i].heartRate.toString());
            count = count + listWeekDataForConcernLevel[i].count;
          } else {
            isLast15DaysHeartHealth = false;
          }
        }

        double avg = totalHeart / count;

        concernLevel = 100 - avg.roundToDouble().toInt();

        // printf('---getConcernLevelDataFor15Days--average---$avg  $concernLevel');
      } else {
        listWeekDataForConcernLevel =
            listWeekDataForConcernLevel.reversed.toList();
        //logFile('----no--record--found---for--last--15--days----getConcernLevelDataFor15Days');
        update();
      }
      //logFile('----end--15---days---week--data--$isLast15DaysHeartHealth');

      //Get.context!.loaderOverlay.hide();
    });

    //Get.context!.loaderOverlay.hide();
  }

  Future<void> generateAndSavePDF(
      {avgHr,
      avgSys,
      avgDia,
      avgOx,
      avgHRV,
      height,
      weight,
      age,
      username,
      dooriReportList}) async {
    final image = await imageFromAssetBundle(
        'assets/images/ic_doori_logo.png'); // import 'package:printing/printing.dart'
    final doc = pw.Document(); // import 'package:pdf/widgets.dart' as pw
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            // recreate the entire UI
            padding: const pw.EdgeInsets.all(18.00),
            child: pw.Column(
              children: [
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  child: pw.Image(image,
                      width: 100,
                      height: 100), // our school logo for the official PDF
                ),
                pw.SizedBox(height: 10.00),
                pw.Text(
                  'Health Reports',
                  style: const pw.TextStyle(fontSize: 18.00),
                ),
                pw.SizedBox(height: 20.00),
                pw.Align(
                  alignment: pw.Alignment.topLeft,
                  child: pw.Text(
                    'Name : $username',
                    style: const pw.TextStyle(fontSize: 14.00),
                  ),
                ),
                pw.SizedBox(height: 10.00),
                pw.Container(
                    width: double.infinity,
                    color: PdfColor.fromHex('#EDEDED'),
                    child: pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 5, bottom: 5),
                      child: pw.Row(
                        children: [
                          pw.Expanded(
                            child: pw.Container(
                                child: pw.Center(
                              child: pw.Text('Avg. resting\nHeartRate:',
                                  style: const pw.TextStyle(fontSize: 9.00)),
                            )),
                          ),
                          pw.Expanded(
                              child: pw.Container(
                                  child: pw.Center(
                            child: pw.Text('Avg. Blood\npressure:',
                                style: const pw.TextStyle(fontSize: 9.00)),
                          ))),
                          pw.Expanded(
                              child: pw.Center(
                            child: pw.Text('Avg. Oxygen\nlevel:',
                                style: const pw.TextStyle(fontSize: 9.00)),
                          )),
                          pw.Expanded(
                              child: pw.Center(
                            child: pw.Text('Avg. HRV:',
                                style: const pw.TextStyle(fontSize: 9.00)),
                          )),
                          pw.Expanded(
                              child: pw.Center(
                            child: pw.Text('Height:',
                                style: const pw.TextStyle(fontSize: 9.00)),
                          )),
                          pw.Expanded(
                              child: pw.Center(
                            child: pw.Text('Weight:',
                                style: const pw.TextStyle(fontSize: 9.00)),
                          )),
                          pw.Expanded(
                              child: pw.Center(
                            child: pw.Text('Age:',
                                style: const pw.TextStyle(fontSize: 9.00)),
                          )),
                        ],
                      ),
                    )),
                pw.SizedBox(height: 5.00),
                pw.Container(
                  width: double.infinity,
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        child: pw.Container(
                            child: pw.Center(
                          child: pw.Text(avgHr.toString(),
                              style: const pw.TextStyle(fontSize: 9.00)),
                        )),
                      ),
                      pw.Expanded(
                          child: pw.Container(
                              child: pw.Center(
                        child: pw.Text('Sys- $avgSys \n\nDia- $avgDia',
                            style: const pw.TextStyle(fontSize: 9.00)),
                      ))),
                      pw.Expanded(
                          child: pw.Center(
                        child: pw.Text(avgOx.toString(),
                            style: const pw.TextStyle(fontSize: 9.00)),
                      )),
                      pw.Expanded(
                          child: pw.Center(
                        child: pw.Text(avgHRV.toString(),
                            style: const pw.TextStyle(fontSize: 9.00)),
                      )),
                      pw.Expanded(
                          child: pw.Center(
                        child: pw.Text('175 cm',
                            style: const pw.TextStyle(fontSize: 9.00)),
                      )),
                      pw.Expanded(
                          child: pw.Center(
                        child: pw.Text('55 kg',
                            style: const pw.TextStyle(fontSize: 9.00)),
                      )),
                      pw.Expanded(
                          child: pw.Center(
                        child: pw.Text('25',
                            style: const pw.TextStyle(fontSize: 9.00)),
                      )),
                    ],
                  ),
                ),
                pw.SizedBox(height: 15.00),
                pw.Container(
                  height: 150,
                  width: double.infinity,
                  color: PdfColor.fromHex('#EDEDED'),
                ),
                pw.SizedBox(height: 10.00),
                pw.Divider(),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Container(
                          child: pw.Center(
                        child: pw.Text('Date',
                            style: const pw.TextStyle(fontSize: 11.00)),
                      )),
                    ),
                    pw.Expanded(
                        child: pw.Container(
                            child: pw.Center(
                      child: pw.Text('Time',
                          style: const pw.TextStyle(fontSize: 11.00)),
                    ))),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Text('HeartRate',
                          style: const pw.TextStyle(fontSize: 11.00)),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Text('Oxygen',
                          style: const pw.TextStyle(fontSize: 11.00)),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Text('B-P',
                          style: const pw.TextStyle(fontSize: 11.00)),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Text('HR',
                          style: const pw.TextStyle(fontSize: 11.00)),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Text('Activity',
                          style: const pw.TextStyle(fontSize: 11.00)),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Text('Heart',
                          style: const pw.TextStyle(fontSize: 11.00)),
                    )),
                  ],
                ),
                pw.SizedBox(height: 10.00),
                pw.Row(
                  children: [
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: List.generate(
                            dooriReportList.length,
                            (i) => pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.start,
                                    children: [
                                      pw.Expanded(
                                        child: pw.Column(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.center,
                                            children: [
                                              pw.Row(children: [
                                                pw.Text(
                                                  dooriReportList[i]
                                                      .dateTime
                                                      .toString(),
                                                  style: const pw.TextStyle(
                                                      fontSize: 10.00),
                                                ),
                                              ]),
                                              pw.SizedBox(height: 2),
                                            ]),
                                      ),
                                      /*pw.Container(
                                    width: 1,
                                    height: 13,
                                    color: PdfColor.fromHex('#000000'),
                                  )*/
                                    ])),
                      ),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: List.generate(
                            dooriReportList.length,
                            (i) => pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        dooriReportList[i]
                                            .measureTime
                                            .toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 10.00),
                                      ),
                                      pw.SizedBox(height: 2),
                                    ])),
                      ),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: List.generate(
                            dooriReportList.length,
                            (i) => pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        dooriReportList[i].heartRate.toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 10.00),
                                      ),
                                      pw.SizedBox(height: 2),
                                    ])),
                      ),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: List.generate(
                            dooriReportList.length,
                            (i) => pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        dooriReportList[i].oxygen.toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 10.00),
                                      ),
                                      pw.SizedBox(height: 2),
                                    ])),
                      ),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: List.generate(
                            dooriReportList.length,
                            (i) => pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text(
                                        dooriReportList[i]
                                            .bloodPressure
                                            .toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 10.00),
                                      ),
                                      pw.SizedBox(height: 2),
                                    ])),
                      ),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: List.generate(
                            dooriReportList.length,
                            (i) => pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        dooriReportList[i]
                                            .hrVariability
                                            .toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 10.00),
                                      ),
                                      pw.SizedBox(height: 2),
                                    ])),
                      ),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: List.generate(
                            dooriReportList.length,
                            (i) => pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        dooriReportList[i].activity.toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 10.00),
                                      ),
                                      pw.SizedBox(height: 2),
                                    ])),
                      ),
                    )),
                    pw.Expanded(
                        child: pw.Center(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: List.generate(
                            dooriReportList.length,
                            (i) => pw.Column(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(
                                        dooriReportList[i]
                                            .bodyHealth
                                            .toString()
                                            .substring(
                                                0,
                                                dooriReportList[i]
                                                    .bodyHealth
                                                    .toString()
                                                    .indexOf('/')),
                                        //dooriReportList[i].bodyHealth.toString(),
                                        style:
                                            const pw.TextStyle(fontSize: 10.00),
                                      ),
                                      pw.SizedBox(height: 2),
                                    ])),
                      ),
                    )),
                  ],
                ),
                pw.SizedBox(height: 30.00),
              ],
            ),
          );
        },
      ),
    );

    printf('---pdf--printing--completed---');
    Get.context!.loaderOverlay.hide();
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  Future<void> checkStoragePermission(List<MeasureResult> measureList) async {
    printf('checked---permission---');

    // Get.context!.loaderOverlay.show();
    // update();

    getLast30DaysRecordForGenerateReport(userId, measureList);
  }

  Future<void> getLast30DaysRecordForGenerateReport(
      userId, List<MeasureResult> measureList) async {
    logFile(
        '--------call---last--30--days----records---for---pdf->$userId---total--measure--list--->${measureList.length}');

    var now = DateTime.now();
    var formatter = DateFormat('dd-MMM-yyyy');
    String reportDate = formatter.format(now);

    var name = '',
        gender = '',
        dob = '',
        userAge = '',
        height = '',
        weight = '';

    List<MeasureResult> last30DaysRecord = [];
    List<MeasureResult> last15Records = [];
    List<MeasureResult> filterList = [];
    List<MeasureResult> readingList = [];

    List<ChartDataModel> chartData = [];

    List<int> listHearRate = [];
    List<int> listHRV = [];
    List<int> listSYS = [];
    List<int> listDYS = [];

    var heartRateContent = '';
    var hrvContent = '';
    var sysContent = '';
    var dysContent = '';

    var avgHR = 0;
    var avgHRV = 0;
    var avgSystolic = 0;
    var avgDia = 0;

    var highestDia = 0;
    var highestHR = 0;
    var highestHRV = 0;
    var highestSystolic = 0;

    var healthyRangeForHR = '';

    late DateTime dateTime;
    DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
    var resultFormatter = DateFormat('dd/MM');

    var hrRange = '';
    int age = 0;

    await Utility.getUserDetails().then((userModel) {
      if (userModel != null) {
        try {
          name = userModel.name.toString();
          dob = userModel.dob.toString();
          gender = userModel.gender.toString();
          height = userModel.height.toString();
          weight = userModel.weight.toString();
        } catch (exe) {
          printf('exeOffline-$exe');
        }

        try {
          userAge = Utility.calculateAge(DateTime.parse(dob.toString()));
        } catch (e) {
          printf('exe--user-age-->$e');
        }

        age = int.parse(userAge.toString());
        printf('-------------gender-->$gender-----user--age-->$age');

        update();
      }
    });

    if (gender.toLowerCase() == 'female') {
      printf('------------------female----------------------->');
      if (age >= 18 && age <= 25) {
        hrRange = '61-73';
      } else if (age >= 26 && age <= 35) {
        hrRange = '60-72';
      } else if (age >= 36 && age <= 45) {
        hrRange = '60-73';
      } else if (age >= 46 && age <= 55) {
        hrRange = '61-73';
      } else if (age >= 56 && age <= 65) {
        hrRange = '62-73';
      } else if (age > 65) {
        hrRange = '62-72';
      }
    } else {
      printf('------------------male----------------------->');
      if (age >= 18 && age <= 25) {
        hrRange = '56-69';
      } else if (age >= 26 && age <= 35) {
        hrRange = '55-70';
      } else if (age >= 36 && age <= 45) {
        hrRange = '57-70';
      } else if (age >= 46 && age <= 55) {
        hrRange = '58-71';
      } else if (age >= 56 && age <= 65) {
        hrRange = '57-71';
      } else if (age > 65) {
        hrRange = '56-69';
      }
    }

    // Function to fetch last 5 days records
    List<MeasureResult> getLastFiveDaysRecords(List<MeasureResult> list) {
      int fiveDaysAgoTimestamp = DateTime.now()
          .subtract(const Duration(days: 30))
          .millisecondsSinceEpoch;
      return list
          .where((record) =>
              record.timeStamp != null &&
              record.timeStamp! >= fiveDaysAgoTimestamp)
          .toList();
    }

    last30DaysRecord = getLastFiveDaysRecords(measureList);

    if (measureList.isNotEmpty) {
      filterList = measureList
          .where((name) => name.activity.toString() == 'sitting'.tr)
          .toList();

      if (filterList.length > 15) {
        filterList.reversed.take(15).forEach((element) {
          last15Records.add(element);
          readingList.add(element);
        });
      } else {
        filterList.forEach((element) {
          last15Records.add(element);
          readingList.add(element);
        });
      }
    } else {
      printf('--else--empty----getLast15ReadingsForPredictionAI->');
    }

    printf('---last---15---total---->${last15Records.length}');

//-----------------------------------------------------------------------

    if (last15Records.isNotEmpty) {
      printf('total----records---->${last15Records.length}');

      Get.context!.loaderOverlay.hide();

      for (int i = 0; i < last15Records.length; i++) {
        String input = last15Records[i].bloodPressure.toString();
        List values = input.split("/");

        try {
          dateTime = dateFormat.parse('${last15Records[i].dateTime}');
        } catch (exe) {
          printf('exe---date-->$exe');
        }

        var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        String dd = resultFormatter.format(currentDate);
        String tt = last15Records[i].measureTime.toString(); //.substring(0, 4);

        String time = DateFormat.jm().format(DateFormat("mm:ss").parse(tt));

        String date = '$dd ${time.substring(0, 5)}';

        double s = double.parse(values[0].toString());
        double d = double.parse(values[1].toString());
        double hr = double.parse(last15Records[i].heartRate.toString());
        double ox = double.parse(last15Records[i].oxygen.toString());
        double hrv = double.parse(last15Records[i].hrVariability.toString());

        listHearRate.add(hr.toInt());
        listHRV.add(hrv.toInt());
        listSYS.add(s.toInt());
        listDYS.add(d.toInt());

        chartData.add(
            ChartDataModel(dd, time.substring(0, 5), hr, ox, s, d, hrv, 0));
      }

      chartData = chartData.reversed.toList();

      avgHR = calculateAverage(list: listHearRate).toInt();
      highestHR = findHighest(list: listHearRate);

      if ((highestHR - avgHR) > 15) {
        heartRateContent =
            "Your heart rate is fluctuating widely, which could be a sign of arrhythmia or sleep disturbances. It might be a normal idea to consult with a healthcare provider for further evaluation.";
      } else {
        // Check the different conditions
        if (avgHR > 80) {
          heartRateContent =
              "Your heart rate has been consistently very high, which may indicate that you're feeling stressed or overexerted. Consider taking some time to relax and recharge.";
        } else if (avgHR < 60) {
          heartRateContent =
              "Your heart rate has been consistently low, which might indicate underactive heart function. It’s a normal idea to check in with a healthcare provider to ensure everything is on track.";
        } else if (avgHR >= 60 && avgHR < 75) {
          heartRateContent =
              "Your heart rate is consistently stable, reflecting normal cardiac health. Keep up the healthy habits!";
        } else if (avgHR >= 75 && avgHR <= 80) {
          heartRateContent =
              "Your heart rate has been slightly elevated, which might suggest mild stress or increased activity. It could be helpful to monitor how you're feeling and consider light relaxation if needed.";
        }
      }

      avgHRV = calculateAverage(list: listHRV).toInt();

      final lowestHRV = findLowest(list: listHRV);

      highestHRV = findHighest(list: listHRV);

      printf(
          '-----call------functionForHRV------avg->$avgHRV ----lowest->$lowestHRV----->');

      if ((avgHRV - lowestHRV) > 20) {
        hrvContent =
            "Your HRV is fluctuating, This could be a sign of an acute stress response. It might be helpful to manage your stress levels and consult with a healthcare provider if needed";
      } else {
        if (avgHRV > 80) {
          hrvContent =
              "Your heart rate variability is consistently high, signaling normal recovery and minimal stress—you're in normal shape!";
        } else if (avgHRV < 50) {
          hrvContent =
              "Your heart rate variability has been decreasing under unhealthy levels, suggesting that you might be experiencing high stress or poor recovery. It's important to prioritize rest and manage stress effectively.";
        } else if (avgHRV >= 50 && avgHRV < 75) {
          hrvContent =
              "Your HRV is stable but on the lower side, indicating that you might be managing stress but still feeling its effects. Consider incorporating stress-relief practices into your routine.";
        } else if (avgHRV >= 75 && avgHRV <= 80) {
          hrvContent =
              "Your HRV is increasing, which suggests you're recovering well and experiencing low stress. Keep up the normal work for continued normal health";
        }
      }
      //

      avgSystolic = calculateAverage(list: listSYS).toInt();

      highestSystolic = findHighest(list: listSYS);

      printf(
          '-----call------functionForSystolic------avgSys->$avgSystolic ----highSys->$highestSystolic----->');

      if ((highestSystolic - avgSystolic) > 8) {
        sysContent =
            "Sudden spikes in your blood pressure could indicate a risk of a hypertensive crisis. It's important to monitor this closely and consult a healthcare provider if it persists";
      } else {
        // Check the different conditions
        if (avgSystolic >= 123 && avgSystolic <= 126) {
          sysContent =
              "Your blood pressure has been consistently high, which increases your risk of hypertension. Consider managing stress and reviewing your lifestyle for better heart health.";
        } else if (avgSystolic > 126) {
          sysContent =
              "Your blood pressure is consistently on the higher side. This could indicate a risk for hypertension. It might be a normal idea to monitor your health more closely and consider speaking with a healthcare professional.";
        } else if (avgSystolic > 117 && avgSystolic < 123) {
          sysContent =
              "Your blood pressure is consistently within a healthy range, indicating strong cardiovascular health. Keep maintaining those normal habits!.";
        } else if (avgSystolic <= 117) {
          sysContent =
              "Your systolic pressure is consistently low, which might suggest a risk of hypotension. Consider consulting a healthcare professional to ensure your blood pressure remains in a healthy range.";
        }
      }

      //

      avgDia = calculateAverage(list: listDYS).toInt();

      highestDia = findHighest(list: listDYS);

      printf(
          '-----call--functionForDiastolic----avgDys->$avgDia----highDys->$highestDia----->');

      if ((highestDia - avgDia) > 5) {
        dysContent =
            "Sudden fluctuations in your diastolic pressure might suggest instability in your blood pressure. It's crucial to keep an eye on this and seek medical advice if the pattern continues..";
      } else {
        if (avgDia > 82 && avgDia < 85) {
          dysContent =
              "Your diastolic pressure has been consistently high, which could increase your risk of developing hypertension. It's important to monitor your stress levels and consider lifestyle adjustments to support your heart health.";
        }
        if (avgDia < 76) {
          dysContent =
              "Your diastolic pressure is consistently low, which could indicate a risk of hypotension. It might be worth checking in with a healthcare professional to ensure everything is okay.";
        }
        if (avgDia >= 76 && avgDia <= 82) {
          dysContent =
              "Your diastolic pressure is consistently within a healthy range, signaling normal heart health. Keep up the normal work with your lifestyle choices!";
        }
        if (avgDia >= 85) {
          dysContent =
              "Your diastolic pressure is consistently elevated, which could signal a risk for hypertension. It’s advisable to keep a closer watch on your health and consider consulting with a healthcare professional..";
        }
      }

      final chartForHeartRate = pw.Chart(
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis.fromStrings(
            List<String>.generate(
                chartData.length,
                (index) =>
                    '${chartData[index].date}\n${chartData[index].time}'),
            ticks: true,
            textStyle: const pw.TextStyle(fontSize: 6),
          ),
          yAxis: pw.FixedAxis(
            [0, 50, 100, 150],
            format: (v) => '$v',
            divisions: true,
            textStyle: const pw.TextStyle(fontSize: 6),
          ),
        ),
        datasets: [
          pw.LineDataSet(
            lineWidth: 2,
            lineColor: PdfColors.blue,
            drawLine: true,
            drawPoints: true,
            drawSurface: false,
            data: List<pw.PointChartValue>.generate(
              chartData.length,
              (i) {
                final v = chartData[i].hr as num;
                return pw.PointChartValue(i.toDouble(), v.toDouble());
              },
            ),
          ),
        ],
      );

      //---------------------

      // --------------------
      final chartForSystolic = pw.Chart(
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis.fromStrings(
            List<String>.generate(
                chartData.length,
                (index) =>
                    '${chartData[index].date}\n${chartData[index].time}'),
            ticks: true,
            textStyle: const pw.TextStyle(fontSize: 6),
          ),
          yAxis: pw.FixedAxis(
            [0, 50, 100, 150, 200],
            format: (v) => '$v',
            divisions: true,
            textStyle: const pw.TextStyle(fontSize: 6),
          ),
        ),
        datasets: [
          pw.LineDataSet(
            lineWidth: 2,
            lineColor: PdfColors.blue,
            drawLine: true,
            drawPoints: true,
            drawSurface: false,
            data: List<pw.PointChartValue>.generate(
              chartData.length,
              (i) {
                final v = chartData[i].sys as num;
                return pw.PointChartValue(i.toDouble(), v.toDouble());
              },
            ),
          ),
        ],
      );
      final chartForDiastolic = pw.Chart(
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis.fromStrings(
            List<String>.generate(
                chartData.length,
                (index) =>
                    '${chartData[index].date}\n${chartData[index].time}'),
            ticks: true,
            textStyle: const pw.TextStyle(fontSize: 6),
          ),
          yAxis: pw.FixedAxis(
            [0, 50, 100, 150],
            format: (v) => '$v',
            divisions: true,
            textStyle: const pw.TextStyle(fontSize: 6),
          ),
        ),
        datasets: [
          pw.LineDataSet(
            lineWidth: 2,
            lineColor: PdfColors.blue,
            drawLine: true,
            drawPoints: true,
            drawSurface: false,
            data: List<pw.PointChartValue>.generate(
              chartData.length,
              (i) {
                final v = chartData[i].dia as num;
                return pw.PointChartValue(i.toDouble(), v.toDouble());
              },
            ),
          ),
        ],
      );

      final chartForHRV = pw.Chart(
        grid: pw.CartesianGrid(
          xAxis: pw.FixedAxis.fromStrings(
            List<String>.generate(
                chartData.length,
                (index) =>
                    '${chartData[index].date}\n${chartData[index].time}'),
            ticks: true,
            textStyle: const pw.TextStyle(fontSize: 6),
          ),
          yAxis: pw.FixedAxis(
            [0, 100, 200, 300, 400],
            format: (v) => '$v',
            divisions: true,
            textStyle: const pw.TextStyle(fontSize: 6),
          ),
        ),
        datasets: [
          pw.LineDataSet(
            lineWidth: 2,
            lineColor: PdfColors.blue,
            drawLine: true,
            drawPoints: true,
            drawSurface: false,
            data: List<pw.PointChartValue>.generate(
              chartData.length,
              (i) {
                final v = chartData[i].hrv as num;
                return pw.PointChartValue(i.toDouble(), v.toDouble());
              },
            ),
          ),
        ],
      );

      //---------------------

      commonChart(
          {required String type,
          required String title,
          required String content}) async {
        var icon =
            await imageFromAssetBundle('assets/images/ic_heart_rate.png');

        if (type == 'HR') {
          icon = await imageFromAssetBundle('assets/images/ic_heart_rate.png');
        } else if (type == 'HRV') {
          icon = await imageFromAssetBundle('assets/images/hrv.png');
        } else if (type == 'SYS') {
          icon = await imageFromAssetBundle('assets/images/blood_pressur.png');
        } else if (type == 'DYS') {
          icon = await imageFromAssetBundle('assets/images/blood_pressur.png');
        }
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    margin: const pw.EdgeInsets.only(right: 10),
                    height: 18,
                    width: 18,
                    child: pw.Image(
                      icon,
                      height: 18,
                      width: 18,
                    ),
                  ),
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                        fontSize: 13, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                content,
                style: const pw.TextStyle(fontSize: 11),
              ),
              pw.SizedBox(height: 8),
              pw.Container(
                  height: 80,
                  child: type == 'HR'
                      ? chartForHeartRate
                      : type == 'HRV'
                          ? chartForHRV
                          : type == 'SYS'
                              ? chartForSystolic
                              : chartForDiastolic),
            ]);
      }

      //
      List<pw.Widget> widgets = [];

      final image =
          await imageFromAssetBundle('assets/images/ic_doori_logo.png');
      final headerColumn = pw.Column(children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Align(
            alignment: pw.Alignment.topLeft,
            child: pw.Image(image,
                width: 100,
                height: 100), // our school logo for the official PDF
          ),
          pw.Text(
            'Health Reports'.toUpperCase(),
            style:
                pw.TextStyle(fontSize: 18.00, fontWeight: pw.FontWeight.bold),
          ),
        ]),
        pw.SizedBox(height: 20.00),
        pw.Container(
            decoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(12)),
              color: PdfColors.grey100, //ColorConstants.textColor,
            ),
            child: pw.Padding(
                padding: const pw.EdgeInsets.only(left: 0, right: 0),
                child: pw.Column(children: [
                  pw.Row(children: [
                    pw.Expanded(
                        child: pw.Container(
                            padding: const pw.EdgeInsets.only(left: 20),
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.SizedBox(height: 20.00),
                                  pw.Text(
                                    'Name: $name',
                                    style: const pw.TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  pw.SizedBox(height: 18.00),
                                  pw.Text(
                                    'Age: $age years',
                                    style: const pw.TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  pw.SizedBox(height: 18.00),
                                  pw.Text(
                                    'Gender: $gender',
                                    style: const pw.TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ]))),
                    pw.Expanded(
                        child: pw.Container(
                            padding: const pw.EdgeInsets.only(right: 20),
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.SizedBox(height: 20.00),
                                  pw.Text(
                                    'Height: $height cm',
                                    style: const pw.TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  pw.SizedBox(height: 18.00),
                                  pw.Text(
                                    'Weight: $weight kg',
                                    style: const pw.TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  pw.SizedBox(height: 18.00),
                                  pw.Text(
                                    'Date: $reportDate',
                                    style: const pw.TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ]))),
                  ]),
                  pw.SizedBox(height: 20.00),
                  pw.Container(
                      height: 125,
                      color: PdfColors.grey200,
                      child: pw.Padding(
                          padding: const pw.EdgeInsets.only(
                              right: 20, left: 20, top: 20, bottom: 20),
                          child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              children: [
                                pw.Expanded(
                                  child: pw.Row(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.Container(
                                            width: 100,
                                            child: pw.Column(
                                                crossAxisAlignment:
                                                    pw.CrossAxisAlignment.start,
                                                children: [
                                                  pw.Text(
                                                    'Vital\nSummary',
                                                    style: pw.TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          pw.FontWeight.bold,
                                                    ),
                                                  ),
                                                  pw.Text(
                                                    '(Resting Average):',
                                                    style: const pw.TextStyle(
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ])),
                                        pw.Container(
                                          width: 0.5,
                                          color: PdfColors.black,
                                        ),
                                        pw.Expanded(
                                            child: pw.Container(
                                                child: pw.Column(
                                                    mainAxisAlignment: pw
                                                        .MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .center,
                                                    children: [
                                              pw.Text(
                                                'Heart rate',
                                                style: const pw.TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              pw.SizedBox(height: 4),
                                              pw.Text(
                                                avgHR.toString(),
                                                style: pw.TextStyle(
                                                  fontSize: 22,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.SizedBox(height: 2),
                                              pw.Text(
                                                '(bpm)',
                                                style: const pw.TextStyle(
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ]))),
                                        pw.Container(
                                          width: 0.5,
                                          color: PdfColors.black,
                                        ),
                                        pw.Expanded(
                                            child: pw.Container(
                                                child: pw.Column(
                                                    mainAxisAlignment: pw
                                                        .MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .center,
                                                    children: [
                                              pw.Text(
                                                'Systolic',
                                                style: const pw.TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              pw.SizedBox(height: 4),
                                              pw.Text(
                                                avgSystolic.toString(),
                                                style: pw.TextStyle(
                                                  fontSize: 22,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.SizedBox(height: 2),
                                              pw.Text(
                                                '(mmHg)',
                                                style: const pw.TextStyle(
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ]))),
                                        pw.Container(
                                          width: 0.5,
                                          color: PdfColors.black,
                                        ),
                                        pw.Expanded(
                                            child: pw.Container(
                                                child: pw.Column(
                                                    mainAxisAlignment: pw
                                                        .MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .center,
                                                    children: [
                                              pw.Text(
                                                'Diastolic',
                                                style: const pw.TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              pw.SizedBox(height: 4),
                                              pw.Text(
                                                avgDia.toString(),
                                                style: pw.TextStyle(
                                                  fontSize: 22,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.SizedBox(height: 2),
                                              pw.Text(
                                                '(mmHg)',
                                                style: const pw.TextStyle(
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ]))),
                                        pw.Container(
                                          width: 0.5,
                                          color: PdfColors.black,
                                        ),
                                        pw.Expanded(
                                            child: pw.Container(
                                                child: pw.Column(
                                                    mainAxisAlignment: pw
                                                        .MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment: pw
                                                        .CrossAxisAlignment
                                                        .center,
                                                    children: [
                                              pw.Text(
                                                'HRV',
                                                style: const pw.TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              pw.SizedBox(height: 4),
                                              pw.Text(
                                                avgHRV.toString(),
                                                style: pw.TextStyle(
                                                  fontSize: 22,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                              pw.SizedBox(height: 2),
                                              pw.Text(
                                                '(ms)',
                                                style: const pw.TextStyle(
                                                  fontSize: 8,
                                                ),
                                              ),
                                            ]))),
                                      ]),
                                ),
                                pw.Row(children: [
                                  pw.SizedBox(width: 1),
                                  pw.Expanded(
                                    child: pw.Container(
                                      height: 0.5,
                                      color: PdfColors.black,
                                    ),
                                  ),
                                  pw.SizedBox(width: 1),
                                ]),
                                pw.Row(
                                    crossAxisAlignment:
                                        pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Container(
                                          width: 100,
                                          child: pw.Padding(
                                            padding: const pw.EdgeInsets.only(
                                                top: 6),
                                            child: pw.Text(
                                              'Healthy Range',
                                              style: const pw.TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          )),
                                      pw.Container(
                                        width: 0.5,
                                        color: PdfColors.black,
                                        height: 22,
                                      ),
                                      pw.Expanded(
                                          child: pw.Container(
                                              child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.only(
                                                          top: 6),
                                                  child: pw.Center(
                                                    child: pw.Text(
                                                      hrRange.toString(),
                                                      style: const pw.TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  )))),
                                      pw.Container(
                                        width: 0.5,
                                        color: PdfColors.black,
                                        height: 22,
                                      ),
                                      pw.Expanded(
                                          child: pw.Container(
                                              child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.only(
                                                          top: 6),
                                                  child: pw.Center(
                                                    child: pw.Text(
                                                      '118-122',
                                                      style: const pw.TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  )))),
                                      pw.Container(
                                        width: 0.5,
                                        color: PdfColors.black,
                                        height: 22,
                                      ),
                                      pw.Expanded(
                                          child: pw.Container(
                                              child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.only(
                                                          top: 6),
                                                  child: pw.Center(
                                                    child: pw.Text(
                                                      '78-82',
                                                      style: const pw.TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  )))),
                                      pw.Container(
                                        width: 0.5,
                                        color: PdfColors.black,
                                        height: 22,
                                      ),
                                      pw.Expanded(
                                          child: pw.Container(
                                              child: pw.Padding(
                                                  padding:
                                                      const pw.EdgeInsets.only(
                                                          top: 6),
                                                  child: pw.Center(
                                                    child: pw.Text(
                                                      '>80',
                                                      style: const pw.TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  )))),
                                    ]),
                              ]))),
                  pw.SizedBox(height: 20.00),
                  pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 20, right: 20),
                      child: pw.Column(children: [
                        pw.Row(children: [
                          pw.Text(
                            'Trend Analysis',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(width: 4),
                          pw.Expanded(
                            child: pw.Text(
                              '(Last 15 readings during resting stage):',
                              style: const pw.TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ]),
                        pw.SizedBox(height: 15),
                        await commonChart(
                            type: 'HR',
                            title: 'Heart Rate',
                            content: heartRateContent),
                        pw.SizedBox(height: 15),
                        await commonChart(
                            type: 'HRV',
                            title: 'HR Variability',
                            content: hrvContent),
                        pw.SizedBox(height: 20),
                      ]))
                ]))),

        pw.SizedBox(height: 15.00),
        pw.Container(
            padding: const pw.EdgeInsets.only(left: 20, right: 20),
            decoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(12)),
              color: PdfColors.grey100, //ColorConstants.textColor,
            ),
            child: pw.ListView(children: [
              pw.SizedBox(height: 15),
              await commonChart(
                  type: 'SYS',
                  title: 'Systolic blood pressure',
                  content: sysContent),
              pw.SizedBox(height: 15),
              await commonChart(
                  type: 'DYS',
                  title: 'Diastolic blood pressure',
                  content: dysContent),
              pw.SizedBox(height: 15.00),
            ])),
        pw.SizedBox(height: 15.00),
        pw.Row(children: [
          pw.Text(
            'Vitals History',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(width: 4),
          pw.Expanded(
            child: pw.Text(
              '(Last 30 days)',
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ]),
        pw.SizedBox(height: 20.00),
        pw.Row(
          children: [
            pw.Expanded(
              child: pw.Container(
                  child: pw.Center(
                child:
                    pw.Text('Date', style: const pw.TextStyle(fontSize: 11.00)),
              )),
            ),
            pw.Expanded(
                child: pw.Container(
                    child: pw.Center(
              child:
                  pw.Text('Time', style: const pw.TextStyle(fontSize: 11.00)),
            ))),
            pw.Expanded(
                child: pw.Center(
              child: pw.Text('Heart rate',
                  style: const pw.TextStyle(fontSize: 11.00)),
            )),
            pw.Expanded(
                child: pw.Center(
              child:
                  pw.Text('Oxygen', style: const pw.TextStyle(fontSize: 11.00)),
            )),
            pw.Expanded(
                child: pw.Center(
              child: pw.Text('BP', style: const pw.TextStyle(fontSize: 11.00)),
            )),
            pw.Expanded(
                child: pw.Center(
              child: pw.Text('HRV', style: const pw.TextStyle(fontSize: 11.00)),
            )),
            pw.Expanded(
                child: pw.Center(
              child: pw.Text('Activity',
                  style: const pw.TextStyle(fontSize: 11.00)),
            )),
            pw.Expanded(
                child: pw.Center(
              child: pw.Text('Heart Score',
                  style: const pw.TextStyle(fontSize: 11.00)),
            )),
          ],
        ),
        pw.SizedBox(height: 5.00),
        pw.Divider(),
        // pw.ListView.builder(
        //   itemCount: last30DaysRecord.length,
        //   itemBuilder: (context, i) {
        //     return pw.Row(
        //       children: [
        //         pw.Expanded(
        //             child: pw.Center(
        //           child: pw.Column(
        //               crossAxisAlignment: pw.CrossAxisAlignment.center,
        //               children: [
        //                 pw.Row(children: [
        //                   pw.Text(
        //                     last30DaysRecord[i].dateTime.toString(),
        //                     style: const pw.TextStyle(fontSize: 10.00),
        //                   ),
        //                 ]),
        //                 pw.SizedBox(height: 2),
        //               ]),
        //         )),
        //         pw.Expanded(
        //             child: pw.Center(
        //                 child: pw.Column(
        //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
        //                     children: [
        //               pw.Text(
        //                 last30DaysRecord[i].measureTime.toString(),
        //                 style: const pw.TextStyle(fontSize: 10.00),
        //               ),
        //               pw.SizedBox(height: 2),
        //             ]))),
        //         pw.Expanded(
        //             child: pw.Center(
        //                 child: pw.Column(
        //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
        //                     children: [
        //               pw.Text(
        //                 last30DaysRecord[i].heartRate.toString(),
        //                 style: const pw.TextStyle(fontSize: 10.00),
        //               ),
        //               pw.SizedBox(height: 2),
        //             ]))),
        //         pw.Expanded(
        //             child: pw.Center(
        //                 child: pw.Column(
        //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
        //                     children: [
        //               pw.Text(
        //                 last30DaysRecord[i].oxygen.toString(),
        //                 style: const pw.TextStyle(fontSize: 10.00),
        //               ),
        //               pw.SizedBox(height: 2),
        //             ]))),
        //         pw.Expanded(
        //             child: pw.Center(
        //                 child: pw.Column(
        //                     crossAxisAlignment: pw.CrossAxisAlignment.start,
        //                     children: [
        //               pw.Text(
        //                 last30DaysRecord[i].bloodPressure.toString(),
        //                 style: const pw.TextStyle(fontSize: 10.00),
        //               ),
        //               pw.SizedBox(height: 2),
        //             ]))),
        //         pw.Expanded(
        //             child: pw.Center(
        //                 child: pw.Column(
        //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
        //                     children: [
        //               pw.Text(
        //                 last30DaysRecord[i].hrVariability.toString(),
        //                 style: const pw.TextStyle(fontSize: 10.00),
        //               ),
        //               pw.SizedBox(height: 2),
        //             ]))),
        //         pw.Expanded(
        //             child: pw.Center(
        //                 child: pw.Column(
        //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
        //                     children: [
        //               pw.Text(
        //                 last30DaysRecord[i].activity.toString(),
        //                 style: const pw.TextStyle(fontSize: 10.00),
        //               ),
        //               pw.SizedBox(height: 2),
        //             ]))),
        //         pw.Expanded(
        //             child: pw.Center(
        //                 child: pw.Column(
        //                     crossAxisAlignment: pw.CrossAxisAlignment.center,
        //                     children: [
        //               pw.Text(
        //                 last30DaysRecord[i].bodyHealth.toString().substring(
        //                     0,
        //                     last30DaysRecord[i]
        //                         .bodyHealth
        //                         .toString()
        //                         .indexOf('/')),
        //                 style: const pw.TextStyle(fontSize: 10.00),
        //               ),
        //               pw.SizedBox(height: 2),
        //             ]))),
        //       ],
        //     );
        //   },
        // ),
        pw.SizedBox(height: 10),
      ]);

      widgets.add(headerColumn);
      final vitalList = pw.ListView.builder(
        itemCount: last30DaysRecord.length,
        itemBuilder: (context, i) {
          late DateTime dateTime;
          DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
          DateFormat dateFormatTime = DateFormat("h:mm");

          try {
            dateTime = dateFormat.parse(
                '${last30DaysRecord[i].dateTime} ${last30DaysRecord[i].measureTime}');
          } catch (exe) {
            printf('exe-$exe');
          }
          var currentDate = DateTime(dateTime.year, dateTime.month,
              dateTime.day, dateTime.hour, dateTime.minute, dateTime.second);

          //DateTime parsedTime = DateTime.parse(last30DaysRecord[i].measureTime.toString());
          String formattedTime = DateFormat('HH:mm').format(currentDate);
          return pw.Container(
            child: pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Center(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Row(children: [
                          pw.Text(
                            last30DaysRecord[i].dateTime.toString(),
                            style: const pw.TextStyle(fontSize: 10.00),
                          ),
                        ]),
                        pw.SizedBox(height: 2),
                      ]),
                )),
                pw.Expanded(
                    child: pw.Center(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                      pw.Text(
                        formattedTime,
                        // last30DaysRecord[i].measureTime.toString(),
                        style: const pw.TextStyle(fontSize: 10.00),
                      ),
                      pw.SizedBox(height: 2),
                    ]))),
                pw.Expanded(
                    child: pw.Center(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                      pw.Text(
                        last30DaysRecord[i].heartRate.toString(),
                        style: const pw.TextStyle(fontSize: 10.00),
                      ),
                      pw.SizedBox(height: 2),
                    ]))),
                pw.Expanded(
                    child: pw.Center(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                      pw.Text(
                        last30DaysRecord[i].oxygen.toString(),
                        style: const pw.TextStyle(fontSize: 10.00),
                      ),
                      pw.SizedBox(height: 2),
                    ]))),
                pw.Expanded(
                    child: pw.Center(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                      pw.Text(
                        last30DaysRecord[i].bloodPressure.toString(),
                        style: const pw.TextStyle(fontSize: 10.00),
                      ),
                      pw.SizedBox(height: 2),
                    ]))),
                pw.Expanded(
                    child: pw.Center(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                      pw.Text(
                        last30DaysRecord[i].hrVariability.toString(),
                        style: const pw.TextStyle(fontSize: 10.00),
                      ),
                      pw.SizedBox(height: 2),
                    ]))),
                pw.Expanded(
                    child: pw.Center(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                      pw.Text(
                        last30DaysRecord[i].activity.toString(),
                        style: const pw.TextStyle(fontSize: 10.00),
                      ),
                      pw.SizedBox(height: 2),
                    ]))),
                pw.Expanded(
                    child: pw.Center(
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                      pw.Text(
                        last30DaysRecord[i].bodyHealth.toString().substring(
                            0,
                            last30DaysRecord[i]
                                .bodyHealth
                                .toString()
                                .indexOf('/')),
                        style: const pw.TextStyle(fontSize: 10.00),
                      ),
                      pw.SizedBox(height: 2),
                    ]))),
              ],
            ),
          );
        },
      );

      widgets.add(vitalList);

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => widgets,
        ),
      );

      // Printing.layoutPdf(
      //   onLayout: (PdfPageFormat format) async => pdf.save().whenComplete(() {
      //     printf('---pdf---is--saved');
      //   }),
      // );

      final directory = Platform.isAndroid
          ? await getDownloadsDirectory()
          : await getTemporaryDirectory(); //getExternalStorageDirectory();
      printf('file--path---${directory?.path}');
      final file = File("${directory?.path}/doori_health_report.pdf");

      final pdfBytes = await pdf.save();
      await file.writeAsBytes(pdfBytes.toList());

      Share.shareFiles([(file.path)]).whenComplete(() {
        Get.context!.loaderOverlay.hide();
      });
    } else {
      Get.context!.loaderOverlay.hide();
      printf('---last--15-----record--not--found--please--measure');
    }
  }

  Future<void> navigateToPredictionAI(
      userId, List<MeasureResult> measureList) async {
    logFile(
        '--------call---last--15--days----records---for---prediction-AI->$userId---total--measure--list--->${measureList.length}');

    List<MeasureResult> last15Records = [];
    List<MeasureResult> filterList = [];
    if (measureList.isNotEmpty) {
      filterList = measureList
          .where((name) => name.activity.toString() == 'sitting'.tr)
          .toList();

      if (filterList.length > 15) {
        filterList.reversed.take(15).forEach((element) {
          last15Records.add(element);
        });
      } else {
        filterList.forEach((element) {
          last15Records.add(element);
        });
      }
    } else {
      printf('--else--empty----getLast15ReadingsForPredictionAI----------->');
    }

//-----------------------------------------------------------------------

    if (last15Records.isNotEmpty) {
      Get.toNamed(Routes.predictionAIScreen, arguments: [last15Records]);
    } else {
      printf('---last--15-----record--not--found--please--measure');
    }
  }

  Future<void> getLast15ReadingsForPredictionAI(
      {userId, required List<MeasureResult> measureList}) async {
    logFile(
        '--------call---last--15--days----records---for---prediction-AI->$userId---total--measure--list--->${measureList.length}');

    List<MeasureResult> last15Records = [];
    List<MeasureResult> filterList = [];

    List<int> listHearRate = [];
    List<int> listHRV = [];
    List<int> listSYS = [];
    List<int> listDYS = [];
    List<int> listBodyHealth = [];

    var heartRateContent = '';
    var hrvContent = '';
    var sysContent = '';
    var dysContent = '';

    var avgHR = 0;
    var avgHRV = 0;
    var avgSystolic = 0;
    var avgDia = 0;

    var highestDia = 0;
    var highestHR = 0;
    var highestHRV = 0;
    var highestSystolic = 0;

    var ws = '0';
    var concernLevel = '';

    var title = '';
    var content = '';
    List<MeasureResult> readingList = [];

    late DateTime dateTime;
    DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
    var resultFormatter = DateFormat('dd/MM');

    int totalBodyHealth = 0;

    int avgBodyHealth = 0;

    if (measureList.isNotEmpty) {
      filterList = measureList
          .where((name) => name.activity.toString() == 'sitting'.tr)
          .toList();

      if (filterList.length > 15) {
        filterList.reversed.take(15).forEach((element) {
          last15Records.add(element);
          readingList.add(element);
        });
      } else {
        filterList.forEach((element) {
          last15Records.add(element);
          readingList.add(element);
        });
      }
    } else {
      printf('--else--empty----getLast15ReadingsForPredictionAI->');
    }

//-----------------------------------------------------------------------

    printf('------------reading-list--------->${readingList.length}');

    if (readingList.length > 14) {
      for (int i = 0; i < readingList.length; i++) {
        String input = readingList[i].bloodPressure.toString();
        List values = input.split("/");

        try {
          dateTime = dateFormat.parse('${readingList[i].dateTime}');
        } catch (exe) {
          printf('exe---date-->$exe');
        }

        double s = double.parse(values[0].toString());
        double d = double.parse(values[1].toString());
        double hr = double.parse(readingList[i].heartRate.toString());
        double hrv = double.parse(readingList[i].hrVariability.toString());

        // printf('--------activity-----$i------${readingList[i].activity}---date-->${readingList[i].dateTime}');

        // printf('--------body-health-----$i------${readingList[i].activity}----->${readingList[i].bodyHealth}');

        listHearRate.add(hr.toInt());
        listHRV.add(hrv.toInt());
        listSYS.add(s.toInt());
        listDYS.add(d.toInt());

        String bodyHealthValues = readingList[i].bodyHealth.toString();
        List bhValues = bodyHealthValues.split("/");

        var bodyHealth = bhValues[0].toString();

        //listBodyHealth.add(bod)

        totalBodyHealth = totalBodyHealth + int.parse(bodyHealth.toString());
      }

      isWellnessScore = true;
      update();

      double totalBH = totalBodyHealth / readingList.length;
      totalBH = totalBH.roundToDouble();
      printf('total body health: $totalBH');
      avgBodyHealth = totalBH.toInt();

      printf(
          '----total-body--health----->$totalBodyHealth---avg--->$avgBodyHealth');
      avgHR = calculateAverage(list: listHearRate).toInt();

      highestHR = findHighest(list: listHearRate);

      printf(
          '-----call----functionForHeartRate------avg->$avgHR ----high->$highestHR----->');

      if ((highestHR - avgHR) > 15) {
        heartRateContent =
            "Your heart rate is fluctuating widely, which could be a sign of arrhythmia or sleep disturbances. It might be a normal idea to consult with a healthcare provider for further evaluation.";
      } else {
        // Check the different conditions
        if (avgHR > 80) {
          heartRateContent =
              "Your heart rate has been consistently very high, which may indicate that you're feeling stressed or overexerted. Consider taking some time to relax and recharge.";
        } else if (avgHR < 60) {
          heartRateContent =
              "Your heart rate has been consistently low, which might indicate underactive heart function. It’s a normal idea to check in with a healthcare provider to ensure everything is on track.";
        } else if (avgHR >= 60 && avgHR < 75) {
          heartRateContent =
              "Your heart rate is consistently stable, reflecting normal cardiac health. Keep up the healthy habits!";
        } else if (avgHR >= 75 && avgHR <= 80) {
          heartRateContent =
              "Your heart rate has been slightly elevated, which might suggest mild stress or increased activity. It could be helpful to monitor how you're feeling and consider light relaxation if needed.";
        }
      }
      //

      // -----call------functionForHRV------avg-------
      avgHRV = calculateAverage(list: listHRV).toInt();

      final lowestHRV = findLowest(list: listHRV);

      highestHRV = findHighest(list: listHRV);

      printf(
          '-----call------functionForHRV------avg->$avgHRV ----lowest->$lowestHRV----->');

      if ((avgHRV - lowestHRV) > 20) {
        hrvContent =
            "Your HRV is fluctuating, This could be a sign of an acute stress response. It might be helpful to manage your stress levels and consult with a healthcare provider if needed";
      } else {
        if (avgHRV > 80) {
          hrvContent =
              "Your heart rate variability is consistently high, signaling normal recovery and minimal stress—you're in normal shape!";
        } else if (avgHRV < 50) {
          hrvContent =
              "Your heart rate variability has been decreasing under unhealthy levels, suggesting that you might be experiencing high stress or poor recovery. It's important to prioritize rest and manage stress effectively.";
        } else if (avgHRV >= 50 && avgHRV < 75) {
          hrvContent =
              "Your HRV is stable but on the lower side, indicating that you might be managing stress but still feeling its effects. Consider incorporating stress-relief practices into your routine.";
        } else if (avgHRV >= 75 && avgHRV <= 80) {
          hrvContent =
              "Your HRV is increasing, which suggests you're recovering well and experiencing low stress. Keep up the normal work for continued normal health";
        }
      }
      //

      avgSystolic = calculateAverage(list: listSYS).toInt();

      highestSystolic = findHighest(list: listSYS);

      printf(
          '-----call------functionForSystolic------avgSys->$avgSystolic ----highSys->$highestSystolic----->');

      if ((highestSystolic - avgSystolic) > 8) {
        sysContent =
            "Sudden spikes in your blood pressure could indicate a risk of a hypertensive crisis. It's important to monitor this closely and consult a healthcare provider if it persists";
      } else {
        // Check the different conditions
        if (avgSystolic >= 123 && avgSystolic <= 126) {
          sysContent =
              "Your blood pressure has been consistently high, which increases your risk of hypertension. Consider managing stress and reviewing your lifestyle for better heart health.";
        } else if (avgSystolic > 126) {
          sysContent =
              "Your blood pressure is consistently on the higher side. This could indicate a risk for hypertension. It might be a normal idea to monitor your health more closely and consider speaking with a healthcare professional.";
        } else if (avgSystolic > 117 && avgSystolic < 123) {
          sysContent =
              "Your blood pressure is consistently within a healthy range, indicating strong cardiovascular health. Keep maintaining those normal habits!.";
        } else if (avgSystolic <= 117) {
          sysContent =
              "Your systolic pressure is consistently low, which might suggest a risk of hypotension. Consider consulting a healthcare professional to ensure your blood pressure remains in a healthy range.";
        }
      }

      //

      avgDia = calculateAverage(list: listDYS).toInt();

      highestDia = findHighest(list: listDYS);

      printf(
          '-----call--functionForDiastolic----avgDys->$avgDia----highDys->$highestDia----->');

      if ((highestDia - avgDia) > 5) {
        dysContent =
            "Sudden fluctuations in your diastolic pressure might suggest instability in your blood pressure. It's crucial to keep an eye on this and seek medical advice if the pattern continues..";
      } else {
        if (avgDia > 82 && avgDia < 85) {
          dysContent =
              "Your diastolic pressure has been consistently high, which could increase your risk of developing hypertension. It's important to monitor your stress levels and consider lifestyle adjustments to support your heart health.";
        }
        if (avgDia < 76) {
          dysContent =
              "Your diastolic pressure is consistently low, which could indicate a risk of hypotension. It might be worth checking in with a healthcare professional to ensure everything is okay.";
        }
        if (avgDia >= 76 && avgDia <= 82) {
          dysContent =
              "Your diastolic pressure is consistently within a healthy range, signaling normal heart health. Keep up the normal work with your lifestyle choices!";
        }
        if (avgDia >= 85) {
          dysContent =
              "Your diastolic pressure is consistently elevated, which could signal a risk for hypertension. It’s advisable to keep a closer watch on your health and consider consulting with a healthcare professional..";
        }
      }

      int hrPoints = 0, hrvPoints = 0, sysPoints = 0, dysPoints = 0;
      int factor = 0;

      if (avgHR >= 49 + factor && avgHR <= 55 + factor) {
        hrPoints = 60;
      }

      if (avgHR >= 56 + factor && avgHR <= 61 + factor) {
        hrPoints = 80;
      }

      if (avgHR >= 62 + factor && avgHR <= 65 + factor) {
        hrPoints = 100;
      }

      if (avgHR >= 66 + factor && avgHR <= 69 + factor) {
        hrPoints = 80;
      }

      if (avgHR >= 70 + factor && avgHR <= 73 + factor) {
        hrPoints = 60;
      }

      if (avgHR >= 74 + factor && avgHR <= 81 + factor) {
        hrPoints = 40;
      }

      if (avgHR >= 82 + factor) {
        hrPoints = 20;
      }

      //

      if (avgHRV > 150) {
        hrvPoints = 100;
      }

      if (avgHRV >= 100 && avgHRV <= 150) {
        hrvPoints = 80;
      }

      if (avgHRV >= 50 && avgHRV < 100) {
        hrvPoints = 60;
      }

      if (avgHRV >= 30 && avgHRV < 50) {
        hrvPoints = 40;
      }

      if (avgHRV < 30) {
        hrvPoints = 20;
      }

      //------------
      if (avgSystolic >= 118 && avgSystolic <= 122) {
        sysPoints = 100;
      }

      if (avgSystolic >= 116 && avgSystolic <= 118) {
        sysPoints = 80;
      }

      if (avgSystolic >= 122 && avgSystolic <= 124) {
        sysPoints = 80;
      }

      if (avgSystolic >= 114 && avgSystolic <= 116) {
        sysPoints = 60;
      }

      if (avgSystolic >= 124 && avgSystolic <= 126) {
        sysPoints = 60;
      }

      if (avgSystolic >= 112 && avgSystolic <= 114) {
        sysPoints = 40;
      }

      if (avgSystolic >= 126 && avgSystolic <= 128) {
        sysPoints = 40;
      }

      if (avgSystolic > 128) {
        sysPoints = 20;
      }

      if (avgSystolic < 112) {
        sysPoints = 20;
      }

      //

      if (avgDia >= 78 && avgDia <= 82) {
        dysPoints = 100;
      }

      if (avgDia >= 76 && avgDia <= 78) {
        dysPoints = 80;
      }

      if (avgDia >= 82 && avgDia <= 84) {
        dysPoints = 80;
      }

      if (avgDia >= 74 && avgDia <= 76) {
        dysPoints = 60;
      }
      if (avgDia >= 84 && avgDia <= 86) {
        dysPoints = 60;
      }

      if (avgDia >= 72 && avgDia <= 74) {
        dysPoints = 40;
      }

      if (avgDia >= 86 && avgDia <= 88) {
        dysPoints = 40;
      }

      if (avgDia <= 72) {
        dysPoints = 20;
      }
      if (avgDia >= 88) {
        dysPoints = 20;
      }

      int totalPoints = hrPoints + hrvPoints + sysPoints + dysPoints;

      printf(
          'points---->$hrPoints--hrv->$hrvPoints---sys->$sysPoints---dys->$dysPoints');

      final total = totalPoints / 4;

      printf('---total--point---->$total');

      printf('-------call---functionForWellnessContent----');
      printf("---->avgHR->$avgHR--avgHRV->$avgHRV--avgSystolic->$avgSystolic");

      Map<String, String> evaluateAllCombos({
        required double avgHR,
        required double avgHRV,
        required double avgSystolic,
      }) {
        print('avgHR: $avgHR'); // Add this line to print the value of avgHR
        print('avgHRV: $avgHRV'); // Add this line to print the value of avgHRV
        print(
            'avgSystolic: $avgSystolic'); // Add this line to print the value of avgSystolic

        String title = '';
        String content = '';

        /// Helper function to classify HR
        String _classifyHR(double hr) {
          if (avgHR < 60) {
            return 'Low';
          } else if (hr <= 80) {
            return 'normal';
          } else {
            return 'High';
          }
        }

        /// Helper function to classify HRV
        String _classifyHRV(double hrv) {
          if (avgHRV < 60) {
            return 'Low';
          } else if (hrv <= 80) {
            return 'normal';
          } else {
            return 'High';
          }
        }

        /// Helper function to classify Systolic BP
        String _classifyBP(double systolic) {
          if (systolic < 118) {
            return 'Low';
          } else if (systolic <= 122) {
            return 'normal';
          } else {
            return 'High';
          }
        }

        // Classify each parameter
        final String hrCat = _classifyHR(avgHR);
        final String hrvCat = _classifyHRV(avgHRV);
        final String bpCat = _classifyBP(avgSystolic);

        print('hrcat---->$hrCat---hrvcat---->$hrvCat---bpcat---->$bpCat');

        if (hrCat == 'Low' && hrvCat == 'Low' && bpCat == 'Low') {
          title = "Low HR, Low HRV, Low BP";
          content =
              "You might be feeling tired or lightheaded, could be due to underlying issues or insufficient hydration.";
        } else if (hrCat == 'Low' && hrvCat == 'Low' && bpCat == 'normal') {
          title = "Low HR, Low HRV, normal BP";
          content =
              "You might be feeling fatigued or sluggish, could be due to overtraining or chronic stress.";
        } else if (hrCat == 'Low' && hrvCat == 'Low' && bpCat == 'High') {
          title = "Low HR, Low HRV, High BP";
          content =
              "You might be feeling somewhat off or weak, could be due to medications or cardiovascular concerns.";
        } else if (hrCat == 'Low' && hrvCat == 'normal' && bpCat == 'Low') {
          title = "Low HR, normal HRV, Low BP";
          content =
              "You might be feeling dizzy if you stand quickly, could be due to athletic adaptation or mild hypotension.";
        } else if (hrCat == 'Low' && hrvCat == 'normal' && bpCat == 'normal') {
          title = "Low HR, normal HRV, normal BP";
          content =
              "You might be feeling generally normal, could be due to normal fitness if no other symptoms.";
        } else if (hrCat == 'Low' && hrvCat == 'normal' && bpCat == 'High') {
          title = "Low HR, normal HRV, High BP";
          content =
              "You might be feeling no major symptoms, could be due to medication or unique physiology.";
        } else if (hrCat == 'Low' && hrvCat == 'High' && bpCat == 'Low') {
          title = "Low HR, High HRV, Low BP";
          content =
              "You might be feeling occasional dizziness, could be due to normal fitness or certain meds.";
        } else if (hrCat == 'Low' && hrvCat == 'High' && bpCat == 'normal') {
          title = "Low HR, High HRV, normal BP";
          content =
              "You might be feeling calm and well, could be due to strong cardiovascular fitness.";
        } else if (hrCat == 'Low' && hrvCat == 'High' && bpCat == 'High') {
          title = "Low HR, High HRV, High BP";
          content =
              "You might be feeling fairly normal, could be due to medication or mixed cardiovascular factors.";
        } else if (hrCat == 'normal' && hrvCat == 'Low' && bpCat == 'Low') {
          title = "normal HR, Low HRV, Low BP";
          content =
              "You might be feeling lightheaded or fatigued, could be due to stress, dehydration, or poor recovery.";
        } else if (hrCat == 'normal' && hrvCat == 'Low' && bpCat == 'normal') {
          title = "normal HR, Low HRV, normal BP";
          content =
              "You might be feeling tense or tired, could be due to stress or insufficient rest.";
        } else if (hrCat == 'normal' && hrvCat == 'Low' && bpCat == 'High') {
          title = "normal HR, Low HRV, High BP";
          content =
              "You might be feeling on edge or stressed, could be due to chronic stress or lifestyle factors.";
        } else if (hrCat == 'normal' && hrvCat == 'normal' && bpCat == 'Low') {
          title = "normal HR, normal HRV, Low BP";
          content =
              "You might be feeling mostly okay with occasional dizziness, could be due to normal variation.";
        } else if (hrCat == 'normal' &&
            hrvCat == 'normal' &&
            bpCat == 'normal') {
          title = "normal HR, normal HRV, normal BP";
          content =
              "You might be feeling healthy and balanced, could be due to a normal overall lifestyle.";
        } else if (hrCat == 'normal' && hrvCat == 'normal' && bpCat == 'High') {
          title = "normal HR, normal HRV, High BP";
          content =
              "You might be feeling fine, could be due to mild hypertension or stress.";
        } else if (hrCat == 'normal' && hrvCat == 'High' && bpCat == 'Low') {
          title = "normal HR, High HRV, Low BP";
          content =
              "You might be feeling generally normal with possible mild dizziness, could be due to strong fitness.";
        } else if (hrCat == 'normal' && hrvCat == 'High' && bpCat == 'normal') {
          title = "normal HR, High HRV, normal BP";
          content =
              "You might be feeling relaxed and healthy, could be due to normal cardiovascular adaptability.";
        } else if (hrCat == 'normal' && hrvCat == 'High' && bpCat == 'High') {
          title = "normal HR, High HRV, High BP";
          content =
              "You might be feeling normal, could be due to acute stress or ‘white-coat’ effect.";
        } else if (hrCat == 'High' && hrvCat == 'Low' && bpCat == 'Low') {
          title = "High HR, Low HRV, Low BP";
          content =
              "You might be feeling shaky or weak, could be due to dehydration or shock-like state.";
        } else if (hrCat == 'High' && hrvCat == 'Low' && bpCat == 'normal') {
          title = "High HR, Low HRV, normal BP";
          content =
              "You might be feeling anxious or overworked, could be due to overexertion or poor recovery.";
        } else if (hrCat == 'High' && hrvCat == 'Low' && bpCat == 'High') {
          title = "High HR, Low HRV, High BP";
          content =
              "You might be feeling tense or stressed, could be due to significant cardiovascular strain.";
        } else if (hrCat == 'High' && hrvCat == 'normal' && bpCat == 'Low') {
          title = "High HR, normal HRV, Low BP";
          content =
              "You might be feeling faint or dizzy, could be due to volume depletion or acute stress.";
        } else if (hrCat == 'High' && hrvCat == 'normal' && bpCat == 'normal') {
          title = "High HR, normal HRV, normal BP";
          content =
              "You might be feeling anxious or overheated, could be due to recent activity or stimulants.";
        } else if (hrCat == 'High' && hrvCat == 'normal' && bpCat == 'High') {
          title = "High HR, normal HRV, High BP";
          content =
              "You might be feeling tense, could be due to acute stress, hypertension, or anxiety.";
        } else if (hrCat == 'High' && hrvCat == 'High' && bpCat == 'Low') {
          title = "High HR, High HRV, Low BP";
          content =
              "You might be feeling a rush or jittery, could be due to sudden stress or shock response.";
        } else if (hrCat == 'High' && hrvCat == 'High' && bpCat == 'normal') {
          title = "High HR, High HRV, normal BP";
          content =
              "You might be feeling energized or restless, could be due to exercise or emotional excitement.";
        } else if (hrCat == 'High' && hrvCat == 'High' && bpCat == 'High') {
          title = "High HR, High HRV, High BP";
          content =
              "You might be feeling stressed or overexcited, could be due to acute exertion or strong emotional state.";
        } else {
          title = "Unknown";
          content = "Unable to determine wellness title.";
        }
        return {
          "title": title,
          "content": content,
        };
      }

      final result = evaluateAllCombos(
        avgHR: avgHR.toDouble(),
        avgHRV: avgHRV.toDouble(),
        avgSystolic: avgSystolic.toDouble(),
      );
      // final String title = result["title"] ?? "";
      final String content = result["content"] ?? "";

      wellnessTitle = content;
      // wellnessScore = ws;
      wellnessScore = avgBodyHealth.toString();
      int wellness = int.parse(wellnessScore);
      printf('$wellness');

      // >80 low, 50-80, medium, 30 to 50 high, less than 30 very high
      if (wellness >= 80) {
        wellnessConcernLevel = 'Low';
        color = colorForLow;
      } else if (wellness >= 50 && wellness < 80) {
        wellnessConcernLevel = 'Medium';
        color = colorForMedium;
      } else if (wellness >= 30 && wellness < 50) {
        wellnessConcernLevel = 'High';
        color = colorForVeryLow;
      } else if (wellness < 30) {
        wellnessConcernLevel = 'Very high';
        color = colorForVeryHigh;
      }

      // ws = wellness.toString();

      printf('--------wellness--score------->$ws');
      printf('Wellness score: $wellnessScore');
      printf('Color: $color');

      update();
    } else {
      isWellnessScore = false;
      printf('---------last-15--reading-not-found------>${readingList.length}');
      update();
    }
  }

  Future<String?> getDownloadPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      externalStorageDirPath = directory?.path;
    } else if (Platform.isIOS) {
      externalStorageDirPath = (await getApplicationDocumentsDirectory()).path;
    }
    return externalStorageDirPath;
  }

  void getBMIValue({height, weight}) {
    //printf('---bm---h->$height--w->$weight');

    isSevereThinness = false;
    isModerateThinness = false;
    isMildThinness = false;
    isnormalThinness = false;
    isOverWeightThinness = false;
    isObeseClass = false;
    isObeseClass2 = false;
    isObeseClass3 = false;

    double bmi = double.parse(weight) / pow(double.parse(height) / 100, 2);

    bmiValue = bmi.toPrecision(1);

    //printf('---bm--value---$bmi--$bmiValue');

    if (bmiValue > 0 && bmiValue < 16) {
      isSevereThinness = true;
      bmiMessage = 'very_bad'.tr; //bmiMessage = 'severe_thinness'.tr;
    } else if (bmiValue >= 16 && bmiValue < 17) {
      isModerateThinness = true;
      bmiMessage = 'bad'.tr; //bmiMessage = 'moderate_thinness'.tr;
    } else if (bmiValue >= 17 && bmiValue < 18.5) {
      isMildThinness = true;
      bmiMessage = 'average'.tr; // bmiMessage = 'mild_thinness'.tr;
    } else if (bmiValue >= 18.5 && bmiValue < 25) {
      isnormalThinness = true;
      bmiMessage = 'normal'.tr;
    } else if (bmiValue >= 25 && bmiValue < 30) {
      isOverWeightThinness = true;
      bmiMessage = 'very_normal'.tr; // bmiMessage = 'over_weight'.tr;
    } else if (bmiValue >= 30 && bmiValue < 35) {
      isObeseClass = true;
      bmiMessage = 'average'.tr; // bmiMessage = 'obese_class1'.tr;
    } else if (bmiValue >= 35 && bmiValue < 40) {
      isObeseClass2 = true;
      bmiMessage = 'bad'.tr; //bmiMessage = 'obese_class2'.tr;
    } else if (bmiValue >= 40) {
      isObeseClass3 = true;
      bmiMessage = 'very_bad'.tr; //bmiMessage = 'obese_class3'.tr;
    }
    update();
  }

  void setOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  Future<void> showLastRecordOffline() async {
    try {
      userId = await Utility.getUserId();
      printf('--show--last--record--->$userId');

      Utility.getUserDetails().then((value) {
        if (value != null) {
          userModel = value;

          gender = userModel.gender.toString();

          try {
            username = userModel.name.toString()[0].toUpperCase() +
                userModel.name.toString().substring(1);
            age = int.parse(userModel.age.toString());
            isNonVegetarian = userModel.nonVegetarian.toString();

            userHeight = userModel.height.toString();
            userWeight = userModel.weight.toString();

            userDateOfBirth = userModel.dob.toString();
            getBMIValue(height: userHeight, weight: userWeight);
          } catch (exe) {
            printf('exe--user--detail---258-->$exe');
          }
          update();
        }
      }).whenComplete(() {
        Utility.getLastMeasureRecord().then((value) {
          if (value != null) {
            try {
              MeasureResult lastRecord = value;
              //MeasureResult lastRecord = lastMeasureRecord;

              printf(
                  '----last--record--stored--->${value.dateTime}--->${value.measureTime}--');

              if (userId == lastRecord.userId) {
                activity = lastRecord.activity.toString();
                heartRate = lastRecord.heartRate.toString();
                oxygen = lastRecord.oxygen.toString();
                bloodPressure = lastRecord.bloodPressure.toString();
                temperature = lastRecord.temperature.toString();
                hrVariability = lastRecord.hrVariability.toString();
                bodyHealth = lastRecord.bodyHealth.toString();

                getPulsePressure(bp: bloodPressure);
                calculateStrokeVolume(
                    bp: bloodPressure,
                    hr: double.parse(heartRate.toString()),
                    hrv: double.parse(hrVariability.toString()));

                calculateBFI(bp: bloodPressure);
                calculateHRI(
                    hr: double.parse(heartRate.toString()),
                    hrv: double.parse(hrVariability.toString()));

                try {
                  newHealthTips = lastRecord.healthTips.toString();
                } catch (e) {
                  printf('exe-tips-online--4978-->$e');
                }

                late DateTime dateTime;
                DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
                DateFormat dateFormatTime = DateFormat("dd-MMM-yyyy, h:mm a");

                try {
                  dateTime = dateFormat.parse(
                      '${lastRecord.dateTime} ${lastRecord.measureTime}');
                } catch (exe) {
                  printf('exe-268-->$exe');
                }

                var currentDate = DateTime(
                    dateTime.year,
                    dateTime.month,
                    dateTime.day,
                    dateTime.hour,
                    dateTime.minute,
                    dateTime.second);

                lastHeartRateValue = dateFormatTime.format(currentDate);

                getBodyState(double.parse(temperature), double.parse(heartRate),
                    bodyHealth, oxygen, bloodPressure);

                double sys = 0.0;

                if (bloodPressure.length > 4) {
                  String v = bloodPressure.substring(0, 3);
                  try {
                    sys = double.parse(v);
                  } catch (e) {
                    printf('exe--294-->$e');
                  }
                }

                getHeartRateCalculation(
                    age: age,
                    hr: double.parse(heartRate.toString()),
                    oxygenLevel: double.parse(oxygen.toString()),
                    bloodPressure: sys,
                    activity: activity,
                    bodyHealth: bodyHealth,
                    hrv: double.parse(hrVariability.toString()));
              } else {
                printf('user--mot-match-with-last-record');
              }
            } catch (exe) {
              printf('exe-get-last-stored-record--313-->$exe');
            }

            update();
          }
        });
      });
    } catch (exe) {
      logFile('--exe--236--->$exe');
    }
  }

  double calculateHeartStrain(
      {required double hrv,
      required String bloodPressure,
      required double hr}) {
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
    double k1 = 1.75 * 30;
    double k2 = 200;
    String sys = bloodPressure.substring(0, bloodPressure.indexOf('/'));
    String dys = bloodPressure.substring(
        bloodPressure.indexOf('/') + '/'.length, bloodPressure.length);

    double pulsePressure =
        double.parse(sys).roundToDouble() - double.parse(dys).roundToDouble();

    // double cardiacStrain = ((pulsePressure * k1) / hr) * (1 - (hrv / k2));
    double cardiacStrain =
        ((double.parse(sys).roundToDouble() * hr) / 20000) * 100;
    printf('########cardiacStrain--->$cardiacStrain');
    printf(
        '<--########-----------------call----------calculateHeartStrain-------hrv->$hrv---sys->$sysBP--dia->$diaBP');
    const int hrvnormal = 100;
    const int bpSystolicnormal = 120;
    const int bpDiastolicnormal = 80;
    double strain = 0.0;

    strain = cardiacStrain;

    // Calculate HRV-based strain (lower HRV increases strain)

    // strain += (hrvnormal - hrv).abs(); // Max 50% strain from HRV

    // // Calculate BP-based strain (higher BP increases strain)

    // strain += (sysBP - bpSystolicnormal).abs() * 10;

    // strain += (diaBP - bpDiastolicnormal).abs() * 10;

    // Cap the strain percentage at 100%
    if (strain >= 300) {
      strain = 300;
    }
    printf('$strain');
    return strain;
  }

  void logFile(String logMsg) {
    FlutterLogs.logToFile(
        appendTimeStamp: true,
        overwrite: false,
        logMessage: '\n $logMsg',
        logFileName: myLogFileName);
  }

  void setUpLogs() async {
    await FlutterLogs.initLogs(
        timeStampFormat: TimeStampFormat.TIME_FORMAT_READABLE,
        directoryStructure: DirectoryStructure.FOR_DATE,
        logTypesEnabled: [myLogFileName],
        logFileExtension: LogFileExtension.LOG,
        logsWriteDirectoryName: "MyLogsDashboard",
        logsExportDirectoryName: "MyLogsDashboard/Exported",
        debugFileOperations: true,
        isDebuggable: true);

    FlutterLogs.channel.setMethodCallHandler((call) async {
      if (call.method == 'logsExported') {
        // Contains file name of zip
        FlutterLogs.logInfo(
            tag, "setUpLogs", "logsExported: ${call.arguments.toString()}");

        // Notify Future with value
        completer.complete(call.arguments.toString());
      } else if (call.method == 'logsPrinted') {
        FlutterLogs.logInfo(
            tag, "setUpLogs", "logsPrinted: ${call.arguments.toString()}");
      }
    });
  }

  void getLastUserId() async {
    logFile('......get...user..id...481');
    try {
      userId = await Utility.getUserId();
      printf('userId-$userId');
      update();
    } catch (exe) {
      logFile('--exe-deviceToken---491---$exe');
    }
  }

  void tabSelectionMyVitals() {
    isMyVitals = true;
    isInsights = false;
    update();
  }

  void tabSelectionInsights() {
    isMyVitals = false;
    isInsights = true;
    update();
  }

  Future<void> buttonMeasure() async {
    final result = await Get.toNamed(Routes.measureScreen);

    if (result.toString() == 'save') {
      Get.delete<MeasureController>();
      Get.delete<StartMeasureController>();
      Get.delete<MeasureResultController>();
      Get.delete<MeasureResultReadingController>();
      callInit();
    }
  }

  Future<void> buttonGraph(title, userId,
      {value, levelMsg, lastMeasured, totalRecords}) async {
    final result = await Get.toNamed(Routes.heartGraphScreen, arguments: [
      title,
      userId,
      value,
      levelMsg,
      lastMeasured,
      totalRecords
    ]);

    if (result.toString() == 'save') {
      Get.delete<MeasureController>();
      Get.delete<StartMeasureController>();
      Get.delete<MeasureResultController>();
      Get.delete<MeasureResultReadingController>();
      callInit();
    }
  }

  Future<void> buttonGraphForEnergyStressLevel(title, userId,
      {totalBodyHealthRecords, totalAllRecords}) async {
    final result = await Get.toNamed(Routes.energyStressLevelGraphScreen,
        arguments: [title, userId, totalBodyHealthRecords, totalAllRecords]);

    if (result.toString() == 'save') {
      Get.delete<MeasureController>();
      Get.delete<StartMeasureController>();
      Get.delete<MeasureResultController>();
      Get.delete<MeasureResultReadingController>();
      callInit();
    }
  }

  @override
  void onClose() {
    printf('---close---dashboard---');
    super.onClose();
  }
}
