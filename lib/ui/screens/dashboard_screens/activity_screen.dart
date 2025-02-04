import 'package:doori_mobileapp/controllers/dashboard_controllers/activity_controller.dart';
import 'package:doori_mobileapp/models/measure_model/activity_model.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ActivityController>(
        init: ActivityController(context),
        builder: (controller) {
          return ColoredSafeArea(
            color: ColorConstants.blueColor,
            child: Scaffold(
              backgroundColor: HexColor('#f5f5f5'),
              appBar: commonAppbar(
                  onBack: () {
                    Get.back();
                  },
                  title: 'activity'.tr),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.datePreviousTab();
                        },
                        child: Image.asset(
                          ImagePath.icBackBtn,
                          height: 30.w,
                          width: 30.w,
                        ),
                      ),
                      Text(
                        controller.date.toString(),
                        style: defaultTextStyle(
                            size: 16.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          controller.dateNextTab();
                        },
                        child: Image.asset(
                          ImagePath.icNextBtn,
                          height: 30.w,
                          width: 30.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w),
                          child: controller.reverseList.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.reverseList.length,
                                  itemBuilder: (context, index) {
                                    return widgetActivity(
                                        controller.reverseList[index]);
                                  },
                                )
                              : Center(
                                  child: Text('no_data_found'.tr),
                                ))),
                ],
              ),
            ),
          );
        });
  }

  Widget widgetActivity(MeasureResult measureResult) {
    String input = measureResult.reading.toString();

    //printf('activity-${measureResult.activity} l->${measureResult.lValues!.length.toString()} e->${measureResult.eValues!.length.toString()}');

    String H = input.substring(input.indexOf('H') + 'H'.length,
        input.indexOf('O', input.indexOf('H') + 'H'.length));

    String O = input.substring(input.indexOf('O') + 'O'.length,
        input.indexOf(r'$', input.indexOf('O') + 'O'.length));

    String S = input.substring(input.indexOf(r'$') + r'$'.length,
        input.indexOf('D', input.indexOf(r'$') + r'$'.length));

    String D = "";
    String V = "";

    if (input.contains("V")) {
      D = input.substring(input.indexOf('D') + 'D'.length,
          input.indexOf('V', input.indexOf('D') + 'D'.length));

      V = input.substring(input.indexOf('V') + 'V'.length,
          input.indexOf('T', input.indexOf('V') + 'V'.length));
    } else {
      D = input.substring(input.indexOf('D') + 'D'.length,
          input.indexOf('T', input.indexOf('D') + 'D'.length));
    }

    /*String D = input.substring(input.indexOf('D') + 'D'.length,
        input.indexOf('V', input.indexOf('D') + 'D'.length));

    String V = input.substring(input.indexOf('V') + 'V'.length,
        input.indexOf('T', input.indexOf('V') + 'V'.length));*/

    String T = input.substring(input.indexOf('T') + 'T'.length,
        input.indexOf(']', input.indexOf('T') + 'T'.length));

    //printf('result-$H $O $S $D $V $T');

    late DateTime dateTime;
    DateFormat dateFormat = DateFormat("dd-MMM-yyyy HH:mm:ss");
    DateFormat dateFormatTime = DateFormat("h:mm a");

    try {
      dateTime = dateFormat
          .parse('${measureResult.dateTime} ${measureResult.measureTime}');
    } catch (exe) {
      printf('exe-$exe');
    }
    var currentDate = DateTime(dateTime.year, dateTime.month, dateTime.day,
        dateTime.hour, dateTime.minute, dateTime.second);

    //lastHeartRateValue = '${measureUserList.last.dateTime} ${measureUserList.last.measureTime}';
    var measureAt = dateFormatTime.format(currentDate);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          '${'measure_at'.tr}: $measureAt',
          //'Measured at: ${measureResult.measureTime}',
          style: defaultTextStyle(size: 12.sp, color: Colors.black),
        ),
        SizedBox(
          height: 10.h,
        ),
        Material(
          elevation: 1,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          child: InkWell(
            onTap: () {},
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: Colors.white,
              ),
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 5.h, left: 5.w),
                        child: Image.asset(
                          ImagePath.icActivity,
                          height: 45.w,
                          width: 45.w,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            measureResult.activity.toString().toLowerCase().tr,
                            style: defaultTextStyle(
                                size: 22.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Text(
                            '${'heart_rate'.tr}: $H ${'bpm'.tr}',
                            style: defaultTextStyle(
                                size: 10.sp,
                                lineHeight: 1.4,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Text(
                            '${'oxygen_level'.tr}: $O %',
                            style: defaultTextStyle(
                                size: 10.sp,
                                lineHeight: 1.4,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          /*Text(
                            'Temperature: $T F',
                            style: defaultTextStyle(
                                size: 10.sp,
                                lineHeight: 1.4,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),*/
                          Text(
                            '${'blood_pressure'.tr}: $S/$D ${'mmHg'.tr}',
                            style: defaultTextStyle(
                                size: 10.sp,
                                lineHeight: 1.4,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                          Text(
                            '${'hr_variability'.tr}: ${measureResult.hrVariability} ${'ms'.tr}',
                            style: defaultTextStyle(
                                size: 10.sp,
                                lineHeight: 1.4,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          )
                        ],
                      ))
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}

class ColoredSafeArea extends StatelessWidget {
  final Widget child;
  final Color color;

  const ColoredSafeArea({Key? key, required this.child, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).colorScheme.primaryVariant,
      child: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: child,
      ),
    );
  }
}
