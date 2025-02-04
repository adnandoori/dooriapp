import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/controllers/dashboard_controllers/graph_controllers/heart_graph_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/models/graph/bmi_model.dart';
import 'package:doori_mobileapp/models/graph/week_of_month_model.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BMIDetailController extends BaseController
    with GetSingleTickerProviderStateMixin {
  var pointer = 'assets/images/ic_bmi_pointer.png';

  bool red = true, // poor
      orange = false, // Below average
      yellow = false, // average
      lightGreen = false, // healthy
      green = false; // excellent, athl

  var todayDate = DateTime.now();
  var displayDateText = '';

  var formatter = DateFormat('dd MMM, yyyy');
  DateTime today = DateTime.now().toUtc();
  var currentWeek = DateTime.now();
  var formatterWeek = DateFormat('dd MMM, yyyy');
  var displayWeekText = '';
  var resultFormatter = DateFormat('dd-MMM-yyyy');

  //
  List<DateTime> weekList = [];

  var weekDate = '';
  List<BMIModel> weekMeasureList = [];
  List<BMIModel> finalMeasureWeekList = [];

  List<GraphModel> weekNumbers = [];
  List<GraphModel> weekNumberReversed = [];

  List<String> weekDateList = [];
  List<WeekModel> listWeekData = [];

  //Month graph vars
  var currentMonth = DateTime.now();
  var formatterMonth = DateFormat(' MMM, yyyy');
  var displayMonthText = '';
  List<BMIModel> monthMeasureList = [];
  List<WeekOfMonthModel> weekOfMonth = [];

  List<WeekOfMonthModel> weekOfMonthForDiastolic = [];

  List<GraphModel> monthGraphPlot = [];

  int selectedTab = 0;
  late TabController tabController = TabController(length: 2, vsync: this);
  var userId = '';

  DatabaseReference dbMeasure =
      FirebaseDatabase.instance.ref().child(AppConstants.tableBMI);

  double bmiValue = 0;

  bool isSevereThinness = false,
      isModerateThinness = false,
      isMildThinness = false,
      isNormalThinness = false,
      isOverWeightThinness = false,
      isObeseClass = false,
      isObeseClass2 = false,
      isObeseClass3 = false;

  var bmiMessage = 'normal'.tr;

  var tipsForBmi = 'your_bmi_is_the_normal_range'.tr;

  String height = '', weight = '';

  var bmiScore = '0';
  var bmiCondition = '';

  var argument = Get.arguments;

  //isLoading = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_bmi_detail');
      callInit();
    });
  }

  void callInit() {
    tabController.addListener(() {
      selectedTab = tabController.index;
      printf('tabIndexGraph-${tabController.index}');
      update();
    });

    displayDateText = formatter.format(todayDate);
    displayWeekText = formatterWeek.format(currentWeek);
    displayMonthText = formatterMonth.format(currentMonth);

    Utility.isConnected().then((value) {
      if (value) {
        User user = AuthenticationHelper().user;
        userId = user.uid;
        printf('userUId-${user.uid}');

        //getTodayBMI();

        height = argument[0];
        weight = argument[1];

        getBMIValue(height: height, weight: weight);

        printf('internet_online');
      } else {
        printf('internet_offline');
      }
    });
  }

  @override
  void onClose() {
    printf('close_bmi_detail');
    super.onClose();
  }

  Future<void> callNavigateToProfileScreen() async {
    final result =
        await Get.toNamed(Routes.myProfileScreen, arguments: ['bmi']);

    if (result != null) {
      if (result.toString() == 'true') {
        Get.back();
        //callInit();
      } else {
        printf('--result---else-->$result');
      }
    } else {
      printf('---result--null--');
    }
    printf('--result---final---$result');
  }

  Future<void> getTodayBMI() async {
    late DatabaseReference dbBMI =
        FirebaseDatabase.instance.ref().child(AppConstants.tableBMI);
    var todayDate = DateTime.now();
    var todayDateTemp =
        DateTime(todayDate.year, todayDate.month, todayDate.day);
    var resultFormatter = DateFormat('dd-MMM-yyyy');
    var today = resultFormatter.format(todayDateTemp);
    printf('--call--check--bmi--records--for--today--$today');

    DataSnapshot snapshot = await dbBMI.child(userId).get();
    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        BMIModel bmiModel = BMIModel.fromJson(data);
        if (bmiModel.dateTime == today) {
          height = bmiModel.height.toString();
          weight = bmiModel.weight.toString();
          getBMIValue(height: bmiModel.height, weight: bmiModel.weight);
        }
      });
    } else {
      printf('not---today--record--found----please--add--record');
    }
  }

  void getBMIValue({height, weight}) {
    printf('--------bmi---height-->$height--weight--->$weight');

    isSevereThinness = false;
    isModerateThinness = false;
    isMildThinness = false;
    isNormalThinness = false;
    isOverWeightThinness = false;
    isObeseClass = false;
    isObeseClass2 = false;
    isObeseClass3 = false;

    double bmi = 0;

    try {
      bmi = double.parse(weight) / pow(double.parse(height) / 100, 2);
    } catch (e) {
      printf('---exe---bmi-----207->$e');
    }

    printf('--------bmi----->$bmi');

    try {
      bmiValue = bmi.toPrecision(1);
    } catch (e) {
      bmiValue = 0;
      printf('exe---209-->$e');
    }

    double score = 0;

    if (bmi < 19.5) {
      score = 100 - ((19.5 - bmi) * 25);
    } else if (bmi > 24) {
      score = 100 - ((bmi - 24) * 6.66);
    } else if (bmi > 19.5 && bmi < 24) {
      score = 100;
    }
    if (score < 0) {
      bmiScore = '0';
    } else {
      bmiScore = score.toPrecision(1).toString();
    }

    printf('---bm--value--->$bmi--->$bmiValue---score-->$score--->$bmiScore');

    if (bmiValue > 0 && bmiValue < 16) {
      isSevereThinness = true;
      bmiMessage = 'very_bad'.tr;
      bmiCondition = 'severely_underweight'.tr;
      getUnderWeightTips();
    } else if (bmiValue >= 16 && bmiValue < 17) {
      isModerateThinness = true;
      bmiMessage = 'bad'.tr;
      bmiCondition = 'moderately_underweight'.tr;
      getUnderWeightTips();
    } else if (bmiValue >= 17 && bmiValue < 18.5) {
      isMildThinness = true;
      bmiMessage = 'average'.tr;
      bmiCondition = 'mildly_underweight'.tr;
      getUnderWeightTips();
    } else if (bmiValue >= 18.5 && bmiValue < 25) {
      isNormalThinness = true;
      bmiMessage = 'normal'.tr;
      bmiCondition = 'normal'.tr;
    } else if (bmiValue >= 25 && bmiValue < 30) {
      isOverWeightThinness = true;
      bmiMessage = 'very_good'.tr;
      bmiCondition = 'over_weight'.tr;
      getOverWeightTips();
    } else if (bmiValue >= 30 && bmiValue < 35) {
      isObeseClass = true;
      bmiMessage = 'average'.tr;
      bmiCondition = 'mildly_overweight'.tr;
      getOverWeightTips();
    } else if (bmiValue >= 35 && bmiValue < 40) {
      isObeseClass2 = true;
      bmiMessage = 'bad'.tr;
      bmiCondition = 'moderately_overweight';
      getOverWeightTips();
    } else if (bmiValue >= 40) {
      isObeseClass3 = true;
      bmiMessage = 'very_bad'.tr;
      bmiCondition = 'severely_overweight'.tr;
      getOverWeightTips();
    }

    //printf('--bmi--->$bmiMessage--->$bmiValue');
    update();
  }

  void getCurrentWeek(DateTime dateTime) {
    DateTime dt;
    for (int i = 0; i < 8; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekNumbers.add(GraphModel(DateFormat('dd').format(dt), 33));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));

      weekList.add(dt);
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

  Future<void> getWeekData(
      {required int startDate, required int endDate}) async {
    printf('-----------call_week-$startDate $endDate $userId------------');
    //listWeekData.clear();
    //weekMeasureList.clear();
    isLoading.value = true;
    //Get.context!.loaderOverlay.show();

    final ref = dbMeasure
        .child(userId)
        .orderByChild('timeStamp')
        .startAt(startDate)
        .endAt(endDate);

    await ref.once().then((value) {
      if (value.snapshot.exists) {
        value.snapshot.children.forEach((element) {
          final data = Map<String, dynamic>.from(element.value as Map);
          BMIModel measureModel = BMIModel.fromJson(data);
          weekMeasureList.add(measureModel);
          update();
        });
      }

      if (weekMeasureList.isNotEmpty) {
        weekMeasureList.forEach((e) {
          var dateTime = DateTime.fromMillisecondsSinceEpoch(
              int.parse(e.timeStamp.toString()));

          if (weekDateList.contains(resultFormatter.format(dateTime))) {
            if (listWeekData.isNotEmpty) {
              listWeekData.removeWhere((element) =>
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element.title.toString()))) ==
                  resultFormatter.format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(e.timeStamp.toString()))));

              double bmi = double.parse(e.weight.toString()) /
                  pow(double.parse(e.height.toString()) / 100, 2);

              printf(
                  '---data---measure--time-->${e.dateTime}bmi-->${bmi.toPrecision(1)}---${e.height}---${e.weight}');

              listWeekData.add(
                  WeekModel(e.timeStamp.toString(), bmi.toPrecision(1), 0));
              update();
            }
            listWeekData.sort((a, b) => a.title.compareTo(b.title));
            update();
          }
        });
      } else {
        printf('---------------else-------------------check----');
        listWeekData = listWeekData.reversed.toList();
        printf('no_record_found $weekDate');
        update();
      }
      update();
      isLoading.value = false;
      //Get.context!.loaderOverlay.hide();
    });
  }

  void getPreviousWeekData(DateTime dateTime) {
    weekList.clear();
    weekNumbers.clear();
    weekDateList.clear();
    listWeekData.clear();
    update();

    DateTime dt;
    for (int i = 0; i < 8; i++) {
      dt = dateTime.subtract(Duration(days: i));
      weekNumbers.add(GraphModel(DateFormat('dd').format(dt), 33.0 + i));
      weekDateList.add(DateFormat('dd-MMM-yyyy').format(dt));
      listWeekData.add(WeekModel(dt.millisecondsSinceEpoch.toString(), 0.0, 0));

      //weekNumbers.reversed;
      var date = DateTime(dt.year, dt.month, dt.day, 0, 0, 0, 0, 0);
      weekList.add(date);
    }

    weekNumberReversed = weekNumbers.reversed.toList();

    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(weekList.first)}';

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

      weekList.add(date);
    }

    weekNumberReversed = weekNumbers.reversed.toList();
    weekDate =
        '${formatter.format(weekList.last)}-${formatterWeek.format(weekList.first)}';

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

  /// Method for fetching the Monthly data and show it as week wise
  /// @param selectedMonth - DateTime object of the any date of the targeted month
  ///
  /// @author Yagna Joshi
  void getMonthData(selectedMonth) {
    weekOfMonth = [];
    monthMeasureList = [];
    monthGraphPlot = [];
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
        // printf('Retrieved Records-${value.snapshot.children.length}');
        value.snapshot.children.forEach((element) {
          final data = Map<String, dynamic>.from(element.value as Map);

          BMIModel bmiModel = BMIModel.fromJson(data);
          //MeasureResult measureModel = MeasureResult.fromJson(data);
          monthMeasureList.add(bmiModel);
          update();
        });

        monthMeasureList
            .sort((a, b) => a.timeStamp ?? 0.compareTo(b.timeStamp ?? 0));

        var groupByDate = groupBy(monthMeasureList, (obj) => obj.dateTime);
        groupByDate.forEach((date, list) {
          double sumHearRate = 0;
          list.forEach((listItem) {
            double bmi = double.parse(listItem.weight.toString()) /
                pow(double.parse(listItem.height.toString()) / 100, 2);

            double b = bmi.toPrecision(1);

            printf(
                'month--bmi->${listItem.height}-weight->${listItem.weight}-bmi->$b-dt->${listItem.dateTime}-time->${listItem.measureTime}');

            sumHearRate = sumHearRate + b;
          });

          double avgHrt = sumHearRate / list.length;

          printf('---month--avg-->$avgHrt--->${list.length}');

          DateTime recordDate =
              DateTime.fromMillisecondsSinceEpoch(list.first.timeStamp!);

          var filterData = weekOfMonth
              .where((itemFound) => isBetweenDate(
                  recordDate, itemFound.weekStartDate!, itemFound.weekEndDate!))
              .toList();

          for (int i = 0; i < filterData.length; i++) {
            filterData[i].avgMeasure = avgHrt;
            printf('--filter-->${filterData[i].avgMeasure}');
          }
        });

        // TODO month
        double totalHeart = 0;

        for (int i = 0; i < weekOfMonth.length; i++) {
          var round = weekOfMonth[i].avgMeasure ?? 0;

          printf('-week-month-->${round.toPrecision(1)}');
          monthGraphPlot[i].value = round.toPrecision(1); // .roundToDouble();

          totalHeart = totalHeart + monthGraphPlot[i].value;
        }

        update();
      } else {
        printf('month_records_not_found');
        update();
      }
    });
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

      //printf("Adding New Week :${weekOfMonth.last.weekOfYear} ${weekOfMonth.last.weekStartDate} to ${weekOfMonth.last.weekEndDate}");

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

      //printf("Adding New Week :${weekOfMonth.last.weekOfYear} ${weekOfMonth.last.weekStartDate} to ${weekOfMonth.last.weekEndDate}");
    }
    monthGraphPlot = [];
    weekOfMonth.forEach((element) {
      monthGraphPlot.add(GraphModel('Week${element.weekOfYear}', 0));
    });
    update();
  }

  /// calculate week of the given date's Month
  ///
  /// @author: Yagna Joshi
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

  Future getOverWeightTips() async {
    printf('--call--overweight-tips');
    isLoading.value = true;
    update();
    final String response =
        await rootBundle.loadString('assets/tips/over_weight.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();
    tipsForBmi = list[random.nextInt(list.length)]['Tips'];
    printf('overweight-tips--->$tipsForBmi');
    isLoading.value = false;
    update();

    // --random--over-weight--tip--Mindful meal consistencies, aid in regulated BMI

    // isLoading.value = true;
    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.overWeightTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // List<CausesTips> overWeightTips = [];
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     overWeightTips.add(causeModel);
    //   });
    // }
    //
    // CausesTips health = overWeightTips[random.nextInt(overWeightTips.length)];
    // tipsForBmi = health.tip.toString();
    // printf('--random--over-weight--tip--${health.tip}');
    // isLoading.value = false;
    // update();
  }

  Future getUnderWeightTips() async {
    printf('--call--underweight-tips');

    isLoading.value = true;
    update();
    final String response =
        await rootBundle.loadString('assets/tips/under_weight.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();
    tipsForBmi = list[random.nextInt(list.length)]['Tips'];

    printf('underweight-tips--->$tipsForBmi');

    isLoading.value = false;
    update();

    // isLoading.value = true;
    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.underWeightTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // List<CausesTips> overWeightTips = [];
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     overWeightTips.add(causeModel);
    //   });
    // }
    //
    // CausesTips health = overWeightTips[random.nextInt(overWeightTips.length)];
    // tipsForBmi = health.tip.toString();
    // printf('--random--under-weight--tip--${health.tip}');
    // isLoading.value = false;
    // update();
  }
}
