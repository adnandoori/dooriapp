import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/models/measure_model/health_tips_model.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';

class VisualiseController extends BaseController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 1, vsync: this);

  bool gifH1 = false;
  bool gifH2 = false;
  bool gifH3 = false;
  bool gifH4 = false;
  bool gifH6 = false;
  bool normalHeartGif = false;
  Timer? timerH1, timerH2, timerH3, timerH4, timerH6, normalTimer;

  double systolic = 0;
  double diastolic = 0;

  var argument = Get.arguments;

  String currentState = 'your_heart_state_looks_normal'.tr;

  List<CausesTips> causesTips = [];
  String causesTip = '';

  List<CausesTips> symptomsTips = [];
  String symptomTip = '';

  List<CausesTips> visualiseTips = [];
  String visualiseTip = '';

  bool isNormal = true;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printf('init_visualise');

      if (argument != null)
      {
        systolic = argument[0];
        diastolic = argument[1];
        update();
      }

      startAnimation(systolic, diastolic);
      //startAnimation(125.0, 89.0);

      /*tabController.addListener(() {
        //printf('tabIndex-${tabController.index}');
        if (tabController.index == 0)
        {
          startAnimation(systolic, diastolic);
        } else {
          startAnimationForPredicted(systolic, diastolic);
        }
        update();
      });*/

      if (systolic > 0 || diastolic > 0) {
        getVisualiseTips().whenComplete(() {
          getSymptomsTips().whenComplete(() {
            getCausesTips().whenComplete(() {
              printf('completed----all----tips');
            });
          });
        });
      } else {
        printf('---no---systolic--or--diastolic--value--found');
      }

      printf('---check--if---normal-or---not--$isNormal');


    });
  }

  Future getVisualiseTips() async {
    printf('--call--visualise-tips');
    final String response =
        await rootBundle.loadString('assets/tips/visualise_tips.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();
    visualiseTip = list[random.nextInt(list.length)]['Tips'];
    printf('--random--visualise--tip--$visualiseTip');
    update();

    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.visualiseTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     visualiseTips.add(causeModel);
    //   });
    // }
    // CausesTips health = visualiseTips[random.nextInt(visualiseTips.length)];
    // visualiseTip = health.tip.toString();
    // printf('--random--visualise--tip--$visualiseTip');
    // update();
  }

  Future getSymptomsTips() async {
    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.symptomsTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     symptomsTips.add(causeModel);
    //   });
    // }

    // CausesTips health = symptomsTips[random.nextInt(symptomsTips.length)];
    // var tip1 = health.tip.toString();
    //
    // CausesTips health2 = symptomsTips[random.nextInt(symptomsTips.length)];
    // var tip2 = health2.tip.toString();
    //
    // CausesTips health3 = symptomsTips[random.nextInt(symptomsTips.length)];
    // var tip3 = health3.tip.toString();
    //
    // symptomTip = '$tip1\n$tip2\n$tip3';
    //
    // printf('--random--symptom--tip--$symptomTip -->');
    // update();

    printf('--call--symptoms-tips');
    final String response =
        await rootBundle.loadString('assets/tips/symptoms_tips.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();

    // visualiseTip = list[random.nextInt(list.length)]['Tips'];
    // printf('--random--visualise--tip--$visualiseTip');
    // update();

    var tip1 = list[random.nextInt(list.length)]['Tips'];
    var tip2 = list[random.nextInt(list.length)]['Tips'];
    var tip3 = list[random.nextInt(list.length)]['Tips'];

    symptomTip = '$tip1\n$tip2\n$tip3';

    printf('--random--symptom--tip--$symptomTip -->');
    update();
  }

  Future getCausesTips() async {
    // DatabaseReference dbVisualiseTips =
    //     FirebaseDatabase.instance.ref().child(AppConstants.causesTips);
    // DataSnapshot snapshot = await dbVisualiseTips.get();
    // final random = Random();
    // if (snapshot.exists) {
    //   snapshot.children.forEach((element) {
    //     final data = Map<String, dynamic>.from(element.value as Map);
    //     CausesTips causeModel = CausesTips.fromJson(data);
    //     causesTips.add(causeModel);
    //   });
    // }
    //
    // CausesTips health = causesTips[random.nextInt(causesTips.length)];
    // var tip1 = health.tip.toString();
    //
    // CausesTips health2 = causesTips[random.nextInt(causesTips.length)];
    // var tip2 = health2.tip.toString();
    //
    // causesTip = '$tip1 \n$tip2 ';
    // printf('--random--causes--tip--$causesTip');
    // update();

    printf('--call--causes-tips');
    final String response =
        await rootBundle.loadString('assets/tips/causes_tips.json');
    final data = await json.decode(response);
    List list = data['tips'];

    final random = Random();
    var tip1 = list[random.nextInt(list.length)]['Tips'];
    var tip2 = list[random.nextInt(list.length)]['Tips'];

    causesTip = '$tip1 \n$tip2 ';
    printf('--random--causes--tip--$causesTip');
    update();
  }

  void startAnimation(double s, double d) {
    //int s =  int.parse(sys.toString());
    //int d = int.parse(dys.toString());

    printf('--systolic--$s----dys---$d---double--value');

    if (s <= 124 && s >= 116) {
      currentState = 'your_heart_state_looks_normal'.tr;

      isNormal = true;
      //timerStartNormal();
    }

    if (d <= 84 && d >= 76) {
      currentState = 'your_heart_state_looks_normal'.tr;
      isNormal = true;
      //timerStartNormal();
    }

    stopAllAnimation();

    if (s >= 124 && s <= 129) {
      currentState = '${'elevated_blood_pressure_detected'.tr}\n'
          '${'the_walls_of_both_your_right_and_left_affected'.tr}';
      printf('---start---one--163');
      isNormal = false;
      timerStartH1();
    }

    if (d >= 76 && d <= 84) {
      // stopAllAnimation();
    }

    if (s >= 130 && s <= 139) {
      currentState =
          'the_walls_of_both_your_right_and_left_susceptible_to_damage'.tr;
      printf('---start---one--two--174');
      isNormal = false;
      timerStartH1();
      timerStartH2();
    }

    if (d >= 84 && d <= 89) {
      printf('---start---three--181');
      timerStartH3();
    }

    if (s == 140 || s > 140 && s <= 180) {
      printf('---start---one--two--three--186');
      timerStartH1();
      timerStartH2();
      timerStartH3();
    }

    if (d == 90 || d > 190) {
      printf('---start---one--three--193');
      timerStartH1();
      timerStartH3();
    }

    if (s >= 180) {
      currentState = "${'hypertensive_crisis_detected'.tr}"
          "${'when_a_person_experiences_a_hypertensive_crisis'.tr}";
      printf('---start---one--two--three--201');
      timerStartH1();
      timerStartH2();
      timerStartH3();
    }

    if (d >= 120) {
      printf('---start---one--three--six--209');
      timerStartH1();
      timerStartH3();
      timerStartH6();
    }

    // low blood pressure

    if (s > 80 && s <= 90) {
      currentState = "${'hypotension_detected'.tr}"
          "${'hypotension_is_a_condition_characterized_by_abnormally_low_blood_pressure'.tr}";
      printf('---start---one--220');
      timerStartH1();
    }

    if (d > 50 && d <= 60) {
      currentState = "${'hypotension_detected'.tr}"
          "${'hypotension_is_a_condition_characterized_by_abnormally_low_blood_pressure'.tr}";
      printf('---start---three--227');
      timerStartH3();
    }

    if (s <= 80 && s > 0) {
      currentState = "${'severe_hypotension_detected'.tr} "
          "${'often_referred_to_as_hypotensive_shock_or_shock_due_to_extremely_low_blood_pressure'.tr}";
      printf('---start---one--two--234');
      timerStartH1();
      timerStartH2();
    }

    if (d <= 50 && d > 0) {
      currentState = "${'severe_hypotension_detected'.tr} "
          "${'often_referred_to_as_hypotensive_shock_or_shock_due_to_extremely_low_blood_pressure'.tr}";
      printf('---start---one--three--242');
      timerStartH1();
      timerStartH3();
    }
  }

  void startAnimationForPredicted(double s, double d) {
    //int s = int.parse(sys.toString());
    //int d = int.parse(dys.toString());

    printf('--systolic--$s----dys---$d---double--value--for--predicted');

    if (s <= 124 && s >= 116) {
      'your_heart_state_looks_normal'.tr;
      isNormal = true;
      //timerStartNormal();
    }

    if (d <= 84 && d >= 76) {
      'your_heart_state_looks_normal'.tr;
      isNormal = true;
      //timerStartNormal();
    }

    stopAllAnimation();
    if (s >= 124 && s <= 129) {
      currentState = '${'elevated_blood_pressure_detected'.tr}\n'
          '${'the_walls_of_both_your_right_and_left_affected'.tr}';
      printf('---start---one--two--266');
      timerStartH1();
      timerStartH2();
    }

    if (d >= 76 && d <= 84) {
      // stopAllAnimation();
    }

    if (s >= 130 && s <= 139) {
      currentState =
          'the_walls_of_both_your_right_and_left_susceptible_to_damage'.tr;
      printf('---start---one--two--three--278');
      timerStartH1();
      timerStartH2();
      timerStartH3();
    }

    if (d >= 84 && d <= 89) {
      printf('---start---three--one--286');
      timerStartH3();
      timerStartH1();
    }

    if (s == 140 || s > 140 && s <= 180) {
      printf('---start---one--two--three--four--292');
      timerStartH1();
      timerStartH2();
      timerStartH3();
      timerStartH4();
    }

    if (d == 90 || d > 190) {
      printf('---start---one--three--six--300');
      timerStartH1();
      timerStartH3();
      timerStartH6();
    }

    if (s >= 180) {
      currentState = "${'hypotension_detected'.tr}"
          "${'hypotension_is_a_condition_characterized_by_abnormally_low_blood_pressure'.tr}";
      printf('---start---all--309');
      startAllAnimation();
    }

    if (d >= 120) {
      printf('---start---all--314');
      startAllAnimation();
    }

    // low blood pressure

    if (s > 80 && s <= 90) {
      currentState = "${'hypotension_detected'.tr}"
          "${'hypotension_is_a_condition_characterized_by_abnormally_low_blood_pressure'.tr}";
      printf('---start---one--two--323');
      timerStartH1();
      timerStartH2();
    }

    if (d > 50 && d <= 60) {
      currentState = "${'hypotension_detected'.tr}"
          "${'hypotension_is_a_condition_characterized_by_abnormally_low_blood_pressure'.tr}";
      printf('---start---three--one--331');
      timerStartH3();
      timerStartH1();
    }

    if (s <= 80 && s > 0) {
      currentState = "${'severe_hypotension_detected'.tr} "
          "${'often_referred_to_as_hypotensive_shock_or_shock_due_to_extremely_low_blood_pressure'.tr}";
      printf('---start---one--two--three--339');
      timerStartH1();
      timerStartH2();
      timerStartH3();
    }

    if (d <= 50 && d > 0) {
      currentState = "${'severe_hypotension_detected'.tr} "
          "${'often_referred_to_as_hypotensive_shock_or_shock_due_to_extremely_low_blood_pressure'.tr}";
      printf('---start---one--three--six--348');
      timerStartH1();
      timerStartH3();
      timerStartH6();
    }
  }

  void stopAllAnimation() {
    printf('<---stop--all--animation--->');
    timerH1?.cancel();
    timerH2?.cancel();
    timerH3?.cancel();
    timerH4?.cancel();
    timerH6?.cancel();
    normalTimer?.cancel();
  }

  void startAllAnimation() {
    printf('<---start--all--animation--->');
    timerStartH1();
    timerStartH2();
    timerStartH3();
    timerStartH4();
    timerStartH6();
  }

  void timerStartH1() {
    timerH1 = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      timerH1 = t;
      //printf('call_fade_in_fade_out-H1');
      gifH1 = !gifH1;
      update();
    });
  }

  void timerStartH2() {
    timerH2 = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      timerH2 = t;
      //printf('call_fade_in_fade_out-H2');
      gifH2 = !gifH2;
      update();
    });
  }

  void timerStartH3() {
    timerH3 = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      timerH3 = t;
      //printf('call_fade_in_fade_out-H3');
      gifH3 = !gifH3;
      update();
    });
  }

  void timerStartH4() {
    timerH4 = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      timerH4 = t;
      //printf('call_fade_in_fade_out-H4');
      gifH4 = !gifH4;
      update();
    });
  }

  void timerStartH6() {
    timerH6 = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      timerH6 = t;
      //printf('call_fade_in_fade_out-H6');
      gifH6 = !gifH6;
      update();
    });
  }

  void timerStartNormal() {
    normalTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      normalTimer = t;
      //normalHeartGif = !normalHeartGif;
      update();
    });
  }

  /*void fadeInFadeOutH1() {
    printf('call_fade_in_fade_out-H1');
    gifH1 = !gifH1;
    update();
  }*/

  Future<void> callNavigateToMeasure() async {
    final result = await Get.toNamed(Routes.measureScreen);

    if (result.toString() == 'save') {
      Get.back(result: result);
    } else if (result.toString() == 'exit') {
      //Get.back();
    }

    printf('--result_visualise--$result');
  }

  @override
  void onClose() {
    printf('------close_visualise----------');
    stopAllAnimation();
    super.onClose();
  }
}
