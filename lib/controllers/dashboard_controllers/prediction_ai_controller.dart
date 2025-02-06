import 'dart:math';

import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/graph_screens/stroke_cardiac_graph_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PredictionAIController extends BaseController
    with WidgetsBindingObserver {
  BuildContext context;

  PredictionAIController(this.context);

  List<MeasureResult> readingList = [];

  final List<ChartData> chartData = [];
  var arguments = Get.arguments;

  late DateTime dateTime;
  DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
  var resultFormatter = DateFormat('dd/MM');

  var random = Random();

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

  var wellnessScore = '0';
  var concernLevel = '';

  var title = '';
  var content = '';

  Color colorForVeryHigh = const Color(0xFFf8555a);
  Color colorForMedium = const Color(0xFFb0d683);
  Color colorForLow = const Color(0xFF4fd286);
  Color colorForVeryLow = const Color(0xFFffa847);

  Color? color;

  int totalBodyHealth = 0;

  int avgBodyHealth = 0;

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addObserver(this);

      printf('init_prediction_AI_controller');

      if (arguments != null) {
        readingList = arguments[0];
      }

      printf('---last--15--readings----------->${readingList.length}');

      int xValue = 0;

      for (int i = 0; i < readingList.length; i++) {
        String input = readingList[i].bloodPressure.toString();
        List values = input.split("/");

        try {
          dateTime = dateFormat.parse('${readingList[i].dateTime}');
        } catch (exe) {
          printf('exe---date-->$exe');
        }

        var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute, dateTime.second);

        String dd = resultFormatter.format(currentDate);

        String tt = readingList[i].measureTime.toString();
        String time = DateFormat.jm().format(DateFormat("mm:ss").parse(tt));

        String date = '$dd ${time.substring(0, 5)}';

        double s = double.parse(values[0].toString());
        double d = double.parse(values[1].toString());
        double hr = double.parse(readingList[i].heartRate.toString());
        double ox = double.parse(readingList[i].oxygen.toString());
        double hrv = double.parse(readingList[i].hrVariability.toString());

        //printf('--------hr---value------>$hr');

        listHearRate.add(hr.toInt());
        listHRV.add(hrv.toInt());
        listSYS.add(s.toInt());
        listDYS.add(d.toInt());

        xValue = xValue + 5;

        chartData.add(ChartData(date, hr, ox, s, d, hrv, xValue));

        String bodyHealthValues = readingList[i].bodyHealth.toString();
        List bhValues = bodyHealthValues.split("/");

        var bodyHealth = bhValues[0].toString();
        totalBodyHealth = totalBodyHealth + int.parse(bodyHealth.toString());
      }
      update();

      double totalBH = totalBodyHealth / readingList.length;
      totalBH = totalBH.roundToDouble();

      avgBodyHealth = totalBH.toInt();

      wellnessScore = avgBodyHealth.toString();

      int wellness = int.parse(wellnessScore);

      // >80 low, 50-80, medium, 30 to 50 high, less than 30 very high
      if (wellness >= 80) {
        concernLevel = 'Low';
        color = colorForLow;
        // dark green
      } else if (wellness >= 50 && wellness < 80) {
        concernLevel = 'Medium';
        color = colorForMedium;
        // light green
      } else if (wellness >= 30 && wellness < 50) {
        concernLevel = 'High';
        color = colorForVeryLow;
        // orange
      } else if (wellness < 30) {
        // red
        concernLevel = 'Very high';
        color = colorForVeryHigh;
      }
      // wellnessScore = wellness.toString();
      printf('--------wellness--score------->$wellness');

      printf(
          '----total-body--health----->$totalBodyHealth---avg--->$avgBodyHealth');

      functionForHeartRate();
      functionForHRV();
      functionForSystolic();
      functionForDiastolic();

      //--------------------------------------
      functionForWellnessScore(
          avgHR: avgHR, avgHRV: avgHRV, avgSys: avgSystolic, avgDys: avgDia);
    });
  }

  void functionForWellnessContent() {
    printf('-------call---functionForWellnessContent----');
    printf(
        'adnan---avgHR--->$avgHR---avgHRV--->$avgHRV---avgSystolic--->$avgSystolic---avgDys--->$avgDia');

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

      String _classifyHR(double hr) {
        if (avgHR < 60) {
          return 'Low';
        } else if (hr <= 80) {
          return 'Normal';
        } else {
          return 'High';
        }
      }

      String _classifyHRV(double hrv) {
        if (avgHRV < 60) {
          return 'Low';
        } else if (hrv <= 80) {
          return 'Normal';
        } else {
          return 'High';
        }
      }

      String _classifyBP(double systolic) {
        if (systolic < 118) {
          return 'Low';
        } else if (systolic <= 122) {
          return 'Normal';
        } else {
          return 'High';
        }
      }

      final String hrCat = _classifyHR(avgHR);
      final String hrvCat = _classifyHRV(avgHRV);
      final String bpCat = _classifyBP(avgSystolic);

      print('hrcat---->$hrCat---hrvcat---->$hrvCat---bpcat---->$bpCat');

      if (hrCat == 'Low' && hrvCat == 'Low' && bpCat == 'Low') {
        title = "Low HR, Low HRV, Low BP";
        content =
            "You might be feeling tired or lightheaded, could be due to underlying issues or insufficient hydration.";
      } else if (hrCat == 'Low' && hrvCat == 'Low' && bpCat == 'Normal') {
        title = "Low HR, Low HRV, Normal BP";
        content =
            "You might be feeling fatigued or sluggish, could be due to overtraining or chronic stress.";
      } else if (hrCat == 'Low' && hrvCat == 'Low' && bpCat == 'High') {
        title = "Low HR, Low HRV, High BP";
        content =
            "You might be feeling somewhat off or weak, could be due to medications or cardiovascular concerns.";
      } else if (hrCat == 'Low' && hrvCat == 'Normal' && bpCat == 'Low') {
        title = "Low HR, Normal HRV, Low BP";
        content =
            "You might be feeling dizzy if you stand quickly, could be due to athletic adaptation or mild hypotension.";
      } else if (hrCat == 'Low' && hrvCat == 'Normal' && bpCat == 'Normal') {
        title = "Low HR, Normal HRV, Normal BP";
        content =
            "You might be feeling generally normal, could be due to good fitness if no other symptoms.";
      } else if (hrCat == 'Low' && hrvCat == 'Normal' && bpCat == 'High') {
        title = "Low HR, Normal HRV, High BP";
        content =
            "You might be feeling no major symptoms, could be due to medication or unique physiology.";
      } else if (hrCat == 'Low' && hrvCat == 'High' && bpCat == 'Low') {
        title = "Low HR, High HRV, Low BP";
        content =
            "You might be feeling occasional dizziness, could be due to excellent fitness or certain meds.";
      } else if (hrCat == 'Low' && hrvCat == 'High' && bpCat == 'Normal') {
        title = "Low HR, High HRV, Normal BP";
        content =
            "You might be feeling calm and well, could be due to strong cardiovascular fitness.";
      } else if (hrCat == 'Low' && hrvCat == 'High' && bpCat == 'High') {
        title = "Low HR, High HRV, High BP";
        content =
            "You might be feeling fairly normal, could be due to medication or mixed cardiovascular factors.";
      } else if (hrCat == 'Normal' && hrvCat == 'Low' && bpCat == 'Low') {
        title = "Normal HR, Low HRV, Low BP";
        content =
            "You might be feeling lightheaded or fatigued, could be due to stress, dehydration, or poor recovery.";
      } else if (hrCat == 'Normal' && hrvCat == 'Low' && bpCat == 'Normal') {
        title = "Normal HR, Low HRV, Normal BP";
        content =
            "You might be feeling tense or tired, could be due to stress or insufficient rest.";
      } else if (hrCat == 'Normal' && hrvCat == 'Low' && bpCat == 'High') {
        title = "Normal HR, Low HRV, High BP";
        content =
            "You might be feeling on edge or stressed, could be due to chronic stress or lifestyle factors.";
      } else if (hrCat == 'Normal' && hrvCat == 'Normal' && bpCat == 'Low') {
        title = "Normal HR, Normal HRV, Low BP";
        content =
            "You might be feeling mostly okay with occasional dizziness, could be due to normal variation.";
      } else if (hrCat == 'Normal' && hrvCat == 'Normal' && bpCat == 'Normal') {
        title = "Normal HR, Normal HRV, Normal BP";
        content =
            "You might be feeling healthy and balanced, could be due to a good overall lifestyle.";
      } else if (hrCat == 'Normal' && hrvCat == 'Normal' && bpCat == 'High') {
        title = "Normal HR, Normal HRV, High BP";
        content =
            "You might be feeling fine, could be due to mild hypertension or stress.";
      } else if (hrCat == 'Normal' && hrvCat == 'High' && bpCat == 'Low') {
        title = "Normal HR, High HRV, Low BP";
        content =
            "You might be feeling generally good with possible mild dizziness, could be due to strong fitness.";
      } else if (hrCat == 'Normal' && hrvCat == 'High' && bpCat == 'Normal') {
        title = "Normal HR, High HRV, Normal BP";
        content =
            "You might be feeling relaxed and healthy, could be due to good cardiovascular adaptability.";
      } else if (hrCat == 'Normal' && hrvCat == 'High' && bpCat == 'High') {
        title = "Normal HR, High HRV, High BP";
        content =
            "You might be feeling normal, could be due to acute stress or ‘white-coat’ effect.";
      } else if (hrCat == 'High' && hrvCat == 'Low' && bpCat == 'Low') {
        title = "High HR, Low HRV, Low BP";
        content =
            "You might be feeling shaky or weak, could be due to dehydration or shock-like state.";
      } else if (hrCat == 'High' && hrvCat == 'Low' && bpCat == 'Normal') {
        title = "High HR, Low HRV, Normal BP";
        content =
            "You might be feeling anxious or overworked, could be due to overexertion or poor recovery.";
      } else if (hrCat == 'High' && hrvCat == 'Low' && bpCat == 'High') {
        title = "High HR, Low HRV, High BP";
        content =
            "You might be feeling tense or stressed, could be due to significant cardiovascular strain.";
      } else if (hrCat == 'High' && hrvCat == 'Normal' && bpCat == 'Low') {
        title = "High HR, Normal HRV, Low BP";
        content =
            "You might be feeling faint or dizzy, could be due to volume depletion or acute stress.";
      } else if (hrCat == 'High' && hrvCat == 'Normal' && bpCat == 'Normal') {
        title = "High HR, Normal HRV, Normal BP";
        content =
            "You might be feeling anxious or overheated, could be due to recent activity or stimulants.";
      } else if (hrCat == 'High' && hrvCat == 'Normal' && bpCat == 'High') {
        title = "High HR, Normal HRV, High BP";
        content =
            "You might be feeling tense, could be due to acute stress, hypertension, or anxiety.";
      } else if (hrCat == 'High' && hrvCat == 'High' && bpCat == 'Low') {
        title = "High HR, High HRV, Low BP";
        content =
            "You might be feeling a rush or jittery, could be due to sudden stress or shock response.";
      } else if (hrCat == 'High' && hrvCat == 'High' && bpCat == 'Normal') {
        title = "High HR, High HRV, Normal BP";
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

    print("content:${result["content"]}");
    String wellnesscontent = result["content"] ?? "";
    content = wellnesscontent;
    update();
  }

  void functionForWellnessScore(
      {required int avgHR,
      required int avgHRV,
      required int avgSys,
      required int avgDys}) {
    printf(
        '-----average---->avgHR->$avgHR---avgHRV->$avgHRV---avgSys->$avgSys---avgDys->$avgDia');

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
    if (avgSys >= 118 && avgSys <= 122) {
      sysPoints = 100;
    }

    if (avgSys >= 116 && avgSys <= 118) {
      sysPoints = 80;
    }

    if (avgSys >= 122 && avgSys <= 124) {
      sysPoints = 80;
    }

    if (avgSys >= 114 && avgSys <= 116) {
      sysPoints = 60;
    }

    if (avgSys >= 124 && avgSys <= 126) {
      sysPoints = 60;
    }

    if (avgSys >= 112 && avgSys <= 114) {
      sysPoints = 40;
    }

    if (avgSys >= 126 && avgSys <= 128) {
      sysPoints = 40;
    }

    if (avgSys > 128) {
      sysPoints = 20;
    }

    if (avgSys < 112) {
      sysPoints = 20;
    }

    //

    if (avgDys >= 78 && avgDys <= 82) {
      dysPoints = 100;
    }

    if (avgDys >= 76 && avgDys <= 78) {
      dysPoints = 80;
    }

    if (avgDys >= 82 && avgDys <= 84) {
      dysPoints = 80;
    }

    if (avgDys >= 74 && avgDys <= 76) {
      dysPoints = 60;
    }
    if (avgDys >= 84 && avgDys <= 86) {
      dysPoints = 60;
    }

    if (avgDys >= 72 && avgDys <= 74) {
      dysPoints = 40;
    }

    if (avgDys >= 86 && avgDys <= 88) {
      dysPoints = 40;
    }

    if (avgDys <= 72) {
      dysPoints = 20;
    }
    if (avgDys >= 88) {
      dysPoints = 20;
    }

    int totalPoints = hrPoints + hrvPoints + sysPoints + dysPoints;

    printf(
        'points---->$hrPoints--hrv->$hrvPoints---sys->$sysPoints---dys->$dysPoints');

    final total = totalPoints / 4;

    printf('---total--point---->$total');

    update();

    functionForWellnessContent();
  }

  void functionForDiastolic() {
    //printf('-----call------functionForDiastolic--------------->');
    // Analyze BP

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
            "Your diastolic pressure is consistently within a healthy range, signaling good heart health. Keep up the excellent work with your lifestyle choices!";
      }
      if (avgDia >= 85) {
        dysContent =
            "Your diastolic pressure is consistently elevated, which could signal a risk for hypertension. It’s advisable to keep a closer watch on your health and consider consulting with a healthcare professional..";
      }
    }

    update();
  }

  void functionForSystolic() {
    //printf('-----call------functionForSystolic--------------->');
    // Analyze BP

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
            "Your blood pressure is consistently on the higher side. This could indicate a risk for hypertension. It might be a good idea to monitor your health more closely and consider speaking with a healthcare professional.";
      } else if (avgSystolic > 117 && avgSystolic < 123) {
        sysContent =
            "Your blood pressure is consistently within a healthy range, indicating strong cardiovascular health. Keep maintaining those great habits!.";
      } else if (avgSystolic <= 117) {
        sysContent =
            "Your systolic pressure is consistently low, which might suggest a risk of hypotension. Consider consulting a healthcare professional to ensure your blood pressure remains in a healthy range.";
      }
    }

    update();
  }

  void functionForHRV() {
    //printf('-----call------functionForHRV--------------->');

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
            "Your heart rate variability is consistently high, signaling excellent recovery and minimal stress—you're in great shape!";
      } else if (avgHRV < 50) {
        hrvContent =
            "Your heart rate variability has been decreasing under unhealthy levels, suggesting that you might be experiencing high stress or poor recovery. It's important to prioritize rest and manage stress effectively.";
      } else if (avgHRV >= 50 && avgHRV < 75) {
        hrvContent =
            "Your HRV is stable but on the lower side, indicating that you might be managing stress but still feeling its effects. Consider incorporating stress-relief practices into your routine.";
      } else if (avgHRV >= 75 && avgHRV <= 80) {
        hrvContent =
            "Your HRV is increasing, which suggests you're recovering well and experiencing low stress. Keep up the great work for continued good health";
      }
    }

    update();
  }

  void functionForHeartRate() {
    //printf('-----call------functionForHeartRate--------------->');

    avgHR = calculateAverage(list: listHearRate).toInt();

    highestHR = findHighest(list: listHearRate);

    printf(
        '-----call------functionForHeartRate------avg->$avgHR ----high->$highestHR----->');

    if ((highestHR - avgHR) > 15) {
      heartRateContent =
          "Your heart rate is fluctuating widely, which could be a sign of arrhythmia or sleep disturbances. It might be a good idea to consult with a healthcare provider for further evaluation.";
    } else {
      // Check the different conditions
      if (avgHR > 80) {
        heartRateContent =
            "Your heart rate has been consistently very high, which may indicate that you're feeling stressed or overexerted. Consider taking some time to relax and recharge.";
      } else if (avgHR < 60) {
        heartRateContent =
            "Your heart rate has been consistently low, which might indicate underactive heart function. It’s a good idea to check in with a healthcare provider to ensure everything is on track.";
      } else if (avgHR >= 60 && avgHR < 75) {
        heartRateContent =
            "Your heart rate is consistently stable, reflecting good cardiac health. Keep up the healthy habits!";
      } else if (avgHR >= 75 && avgHR <= 80) {
        heartRateContent =
            "Your heart rate has been slightly elevated, which might suggest mild stress or increased activity. It could be helpful to monitor how you're feeling and consider light relaxation if needed.";
      }
    }
  }
}

double calculateAverage({required List<int> list}) {
  int sum = 0;
  for (int i = 0; i < list.length; i++) {
    sum += list[i];
  }
  return sum / list.length;
}

int findHighest({required List<int> list}) {
  int highest = list[0];
  for (int i = 1; i < list.length; i++) {
    if (list[i] > highest) {
      highest = list[i];
    }
  }
  return highest;
}

int findLowest({required List<int> list}) {
  int lowest = list[0];
  for (int i = 1; i < list.length; i++) {
    if (list[i] < lowest) {
      lowest = list[i];
    }
  }
  return lowest;
}
