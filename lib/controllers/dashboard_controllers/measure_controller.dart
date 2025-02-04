import 'dart:async';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

class MeasureController extends BaseController {
  BuildContext context;

  MeasureController(this.context);

  List<MeasureModel> measureList = [];

  List<MeasureModel> selectedList = [];

  var hex = '1';
  var txtEstimatedTime = 'estimated_time_for_measurement_60_seconds'
      .tr; //'estimated_time_for_measurement_15_seconds'.tr;

  bool isHeartRate = true;
  bool isOxygenLevel = true;
  bool isBodyTemperature = false;
  bool isBloodPressure = false;

  bool isVitalTest = true;
  bool isRealTimeTracking = false;

  bool isDeepSenseTest = false;

  @override
  void onInit() {
    //statusBarColor();
    printf('init_measure');

    MeasureModel measureOne = MeasureModel();
    measureOne.title = AppConstants.heartRate;
    measureList.add(measureOne);

    MeasureModel measureTwo = MeasureModel();
    measureTwo.title = AppConstants.oxygenLevel;
    measureList.add(measureTwo);

    MeasureModel measureThree = MeasureModel();
    measureThree.title = AppConstants.bodyTemperature;
    measureList.add(measureThree);

    MeasureModel measureFour = MeasureModel();
    measureFour.title = AppConstants.bloodPressure;
    measureList.add(measureFour);

    printf('total-${measureList.length}');

    super.onInit();
  }

  void tabSelection(int index) {
    printf('clicked-${measureList[index].title}');

    /*if (measureList[index].isSelected == false) {
      measureList[index].isSelected = true;
      selectedList.add(measureList[index]);
    } else {
      measureList[index].isSelected = false;
      selectedList.remove(measureList[index]);
    }*/

    update();
  }

  Future<void> startMeasure() async {
    if (isVitalTest) {
      hex = '3';
    } else {
      hex = '5';
      //hex = '4';
    }
    printf('show---->$hex----->$isVitalTest');

    final result = hex == '5'
        ? await Get.toNamed(Routes.deepSenseTestScreen, arguments: [hex])
        : await Get.toNamed(Routes.startMeasureScreen, arguments: [hex]);
    //

    if (result.toString() == 'save') {
      Get.back(result: result);
    } else if (result.toString() == 'loader') {
      Get.context!.loaderOverlay.show();
      printf('show_10_seconds_loader');
      Timer(const Duration(seconds: 3), () async {
        Get.context!.loaderOverlay.hide();
      });
    } else if (result.toString() == 'exit') {
      Get.back();
    }
    printf('result_measure-$result');
  }

  @override
  void onClose() {
    printf('close_measure');
    super.onClose();
  }
}

class MeasureModel {
  String? title;
  bool isSelected = false;
}
