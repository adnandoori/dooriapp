import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeasureResultController extends BaseController {
  BuildContext context;

  MeasureResultController(this.context);

  var arguments = Get.arguments;

  var hex = '';
  var heartRate = '0',
      oxygen = '0',
      bloodPressure = '0',
      temperature = '0',
      hrVariability = '0';

  late MeasureResult measureModel;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('<----------init_measure_result----------->');

      if (arguments != null) {
        measureModel = arguments[0];
        printf('measureModel--->${measureModel.heartRate}');

        /*hex = arguments[0];
        heartRate = arguments[1];
        oxygen = arguments[2];
        temperature = arguments[3];
        printf('hex-$hex');


        if (hex == '1') {
          heartRate = arguments[1];
          oxygen = arguments[2];
        } else if (hex == '2') {
          temperature = arguments[3];
        } else {
          heartRate = arguments[1];
          oxygen = arguments[2];
          temperature = arguments[3];
        }*/

        printf('heartRate-${measureModel.heartRate}');
        printf('oxygen-${measureModel.oxygen}');
        printf('temperature-${measureModel.temperature}');
        printf('bloodPressure-${measureModel.bloodPressure}');
        update();
      } else {
        printf('null_arguments');
      }
    });
  }

  Future<void> measureComplete(activity) async {
    printf('selectedActivity-$activity');

    measureModel.activity = activity.toString();

    final result =
        await Get.toNamed(Routes.measureResultReadingsScreen, arguments: [
      /*activity,
      heartRate,
      oxygen,
      temperature,
      bloodPressure,
      hrVariability,*/
      measureModel,
    ]);

    if (result.toString() == 'retry') {
      Get.back(result: 'back');
    } else if (result.toString() == 'save') {
      Get.back(result: result);
    }

    printf('result-back-measure_result--$result');
  }

  @override
  void onClose() {
    printf('close_measure_result');
    super.onClose();
  }



}
