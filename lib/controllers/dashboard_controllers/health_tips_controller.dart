import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/helper/authentication_helper.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HealthTipsController extends BaseController {
  BuildContext context;

  HealthTipsController(this.context);

  var todayDate = DateTime.now();
  var formatter = DateFormat('dd MMM, yyyy');

  var date = '';
  int next = 0;
  int previous = 0;

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
      printf('init_health_tips');
      date = formatter.format(todayDate);
      printf('todayDate-$date');

      if (arguments != null) {
        try {
          userId = arguments[0];
          totalMeasureRecordList = arguments[1];

          printf('--userId->$userId-->${totalMeasureRecordList.length}');

          getListOfActivityForOneTime(userId, resultFormatter.format(dateResult),totalMeasureRecordList);

        } catch (e) {
          printf('exe-$e');
        }
      }

      // Utility.isConnected().then((value) {
      //   if (value) {
      //     User user = AuthenticationHelper().user;
      //     userId = user.uid; // 'rJ3bFcPyZIQPJhh2AnZy2t0fjJF2'; //user.uid;
      //     printf('userUId-${user.uid}');
      //     update();
      //     getListOfActivity(userId, resultFormatter.format(dateResult));
      //     printf('internet_online');
      //   } else {
      //     printf('internet_offline');
      //   }
      // });

    });
  }

  Future<void> getListOfActivityForOneTime(userId, date,List<MeasureResult> allTotalRecords) async {
    printf('call_list-->$userId-->$date--->${allTotalRecords.length}');
    list.clear();
    //DataSnapshot snapshot = await dbRef.child(userId).get();
    //printf("children-${snapshot.children.length}");

    if (allTotalRecords.isNotEmpty)
    {
      allTotalRecords.forEach((activityModel) {
        if (activityModel.dateTime.toString() == date.toString()) {
          list.add(activityModel);
          reverseList = list.reversed.toList();
        }
        update();
      });
    }
  }

  Future<void> getListOfActivity(userId, date) async {
    printf('call_list-$userId $date');
    list.clear();
    DataSnapshot snapshot = await dbRef.child(userId).get();
    printf("children-${snapshot.children.length}");
    if (snapshot.exists) {
      snapshot.children.forEach((element) {
        final data = Map<String, dynamic>.from(element.value as Map);
        MeasureResult activityModel = MeasureResult.fromJson(data);
        if (activityModel.dateTime.toString() == date.toString()) {
          list.add(activityModel);
          reverseList = list.reversed.toList();
        }
        update();
      });
    }
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
    getListOfActivityForOneTime(userId, resultFormatter.format(currentDate),totalMeasureRecordList);
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
    getListOfActivityForOneTime(userId, resultFormatter.format(currentDate),totalMeasureRecordList);
    update();
  }

  Future<void> callNavigateToMeasure()
  async {
    final result = await Get.toNamed(Routes.measureScreen);

    if (result.toString() == 'save')
    {
      getListOfActivity(userId, resultFormatter.format(dateResult));
      //Get.back(result: result);
    } else if (result.toString() == 'exit') {
      //Get.back();
    }

    printf('--result_health-tips--$result');

  }


}
