import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/helper/database_helper.dart';
import 'package:doori_mobileapp/models/authentication_model/user_model.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityController extends BaseController {
  BuildContext context;

  ActivityController(this.context);

  var todayDate = DateTime.now();
  var formatter = DateFormat('dd MMM, yyyy');

  var date = '';
  int next = 0;
  int previous = 0;

  late UserModel userModel;
  final dbHelper = DatabaseHelper.instance;

  List<MeasureResult> measureList = [];
  List<MeasureResult> measureUserList = [];
  List<MeasureResult> activityList = [];

  var userId = '';

  var dateResult = DateTime.now();
  var resultFormatter = DateFormat('dd-MMM-yyyy');

  DatabaseReference dbRef =
      FirebaseDatabase.instance.ref().child(AppConstants.tableMeasure);

  List<MeasureResult> list = [];
  List<MeasureResult> reverseList = [];

  var arguments = Get.arguments;
  List<MeasureResult> totalMeasureRecordList = [];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      printf('init_activity');
      date = formatter.format(todayDate);
      printf('todayDate-$date');
      update();
      if (arguments != null) {
        try {
          userId = arguments[0];
          totalMeasureRecordList = arguments[1];

          printf('--userId->$userId-->${totalMeasureRecordList.length}');

          getListOfActivityForOneTime(userId, resultFormatter.format(dateResult), totalMeasureRecordList);
        } catch (e) {
          printf('exe-$e');
        }
      }

      /*Utility.isConnected().then((value)
      {
        if (value) {
          User user = AuthenticationHelper().user;
          userId = user.uid;
          printf('userUId-${user.uid}');
          update();
          getListOfActivity(userId, resultFormatter.format(dateResult));

          printf('internet_online');
        } else {
          printf('internet_offline');
        }
      });*/
    });
  }

  void datePreviousTab() {
    previous = DateTime.now().day; //  previous + 1;

    printf('day-$previous');

    late DateTime dateTime;

    try {
      dateTime = formatter.parse(date);
    } catch (exe) {
      printf('exe-$exe');
    }
    var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day - 1);
    date = formatter.format(currentDate);
    printf('dateTime-$date');

    //getListOfActivity(userId, resultFormatter.format(currentDate));
    getListOfActivityForOneTime(
        userId, resultFormatter.format(currentDate), totalMeasureRecordList);
    update();
  }

  void dateNextTab() {
    next = next + 1;
    late DateTime dateTime;

    try {
      dateTime = formatter.parse(date);
    } catch (exe) {
      printf('exe-$exe');
    }
    var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day + 1);
    date = formatter.format(currentDate);
    printf('dateTimeNext-$date');

    //getListOfActivity(userId, resultFormatter.format(currentDate));
    getListOfActivityForOneTime(
        userId, resultFormatter.format(currentDate), totalMeasureRecordList);

    update();
  }

  Future<void> getListOfActivity(userId, date) async {
    printf('call_list-$userId $date');
    list.clear();
    reverseList.clear();
    DataSnapshot snapshot = await dbRef.child(userId).get();
    printf("children-${snapshot.children.length}");
    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        if (activityModel.dateTime.toString() == date.toString()) {
          list.add(activityModel);
          reverseList = list.reversed.toList();
          printf(
              'today--data---${activityModel.activity} ${activityModel.bloodPressure}');
        }
        update();
      });
    }
  }

  Future<void> getListOfActivityForOneTime(
      userId, date, List<MeasureResult> allTotalRecords) async {
    printf('call_list-$userId-->$date-->${allTotalRecords.length}');
    list.clear();
    reverseList.clear();

    //DataSnapshot snapshot = await dbRef.child(userId).get();

    //printf("children-${snapshot.children.length}");

    if (allTotalRecords.isNotEmpty) {
      allTotalRecords.forEach((activityModel) {
        //final data = Map<String, dynamic>.from(element.value as Map);
        //MeasureResult activityModel = MeasureResult.fromJson(data);
        if (activityModel.dateTime.toString() == date.toString()) {
          list.add(activityModel);
          reverseList = list.reversed.toList();
          printf(
              'today--data---${activityModel.activity} ${activityModel.bloodPressure}');
        }
        update();
      });
    }
  }

  Future<void> showListOfActivity(String date) async {
    printf('date-Result-$date');
    //

    //
    final allRows = await dbHelper.queryAllRows();
    measureList.clear();
    measureUserList.clear();
    activityList.clear();
    allRows.forEach((row) => measureList.add(MeasureResult.fromJson(row)));

    if (measureList.isNotEmpty) {
      printf('listOfMeasure-${measureList.length}');
      printf('data-${measureList.last.userId} ${measureList.last.deviceId}');

      for (int i = 0; i < measureList.reversed.length; i++) {
        if (userId == measureList[i].userId) {
          measureUserList.add(measureList[i]);
        }
      }
      if (measureUserList.isNotEmpty) {
        printf('total-Activity-${measureUserList.length}');
        printf('total-Activity-${measureUserList.last.dateTime}');
        for (int i = 0; i < measureUserList.length; i++) {
          if (measureUserList[i].dateTime == date) {
            activityList.add(measureUserList[i]);
          }
        }
        printf('todayActivity-${activityList.length}');
      }

      update();
    } else {
      printf('no_record_found_please_measure');
    }
  }

  @override
  void onClose() {
    printf('close_activity');
    super.onClose();
  }
}
