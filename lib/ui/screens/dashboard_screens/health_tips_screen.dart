import 'package:doori_mobileapp/controllers/dashboard_controllers/health_tips_controller.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/components/data_not_found_widget.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/activity_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HealthTipsController>(
        init: HealthTipsController(context),
        builder: (controller) {
          return ColoredSafeArea(
            color: ColorConstants.blueColor,
            child: Scaffold(
              backgroundColor: Colors.white, //HexColor('#F5F5F5'),
              appBar: commonAppbar(
                  onBack: () {
                    Get.back();
                  },
                  title: 'health_tips'.tr.toUpperCase()),
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
                  /*SizedBox(
                    height: 20.h,
                  ),*/
                  controller.list.isEmpty
                      ? Expanded(
                          child: NoDataFound(
                            label: 'no_health_tips_recorded'.tr,
                            onClick: () {
                              //Get.toNamed(Routes.measureScreen);
                              controller.callNavigateToMeasure();
                            },
                          ),
                        )
                      : Expanded(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 18.w),
                              child: controller.list.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: controller.reverseList.length,
                                      itemBuilder: (context, index) {
                                        return widgetHealthTips(
                                            controller.reverseList[index],
                                            index);
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

  Widget widgetHealthTips(MeasureResult measureResult, int pos) {
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

    var measureAt = dateFormatTime.format(currentDate);

    printf('totalLength-${measureResult.healthTips.toString().length}');

    /*var a =
        'Try black beans on a whole-grain pita tostada with avocado, or combine them with corn kernels and onions to make stuffed bell peppers, it is really healthy for the heart';
    var b =
        'Be sure to consume garlic raw, or crush it and let it sit for a few minutes before cooking. This allows for the formation of allicin, maximizing its potential health benefits.';
    var c =
        'Instead of sugary soft drinks, white bread, pasta and processed foods like pizza, opt for unrefined whole grains like whole wheat or multigrain bread, brown rice, barley, quinoa, bran cereal, oatmeal, and non-starchy vegetables.';

    printf(
        'total-${a.toString().length} b-${b.toString().length} c-${c.toString().length}');*/

    double height = 150.h;
    //measureResult.healthTips = c;
    int length = measureResult.healthTips.toString().length;

    if (length > 100 && length < 125) {
      height = 155.h;
    } else if (length > 125 && length < 170) {
      height = 160.h;
    } else if (length > 170 && length < 200) {
      height = 175.h;
    } else if (length > 200 && length < 250) {
      height = 190.h;
    } else if (length > 50 && length < 100) {
      height = 110.h;
    } else if (length < 50) {
      height = 100.h;
    } else {
      height = 150.h;
    }

    return measureResult.healthTips.toString().isNotEmpty
        ? SizedBox(
            //height: 140.h,
            width: Get.width,
            child: Stack(
              children: [
                SizedBox(
                  width: 30.w,
                  //height: 140.h,
                  child: Stack(
                    children: [
                      pos == 0
                          ? Container()
                          : Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 5.w,
                                height: 20.h,
                                color: HexColor('#787878'), // Colors.blue,
                              ),
                            ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 10.h),
                          width: 5.w,
                          height: height, //200.h,
                          color: HexColor('#787878'), //Colors.blue,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: 10.h),
                          width: 22.w,
                          height: 22.w,
                          decoration: BoxDecoration(
                            color: HexColor('#787878'), //Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 5.w,
                              height: 5.w,
                              decoration: BoxDecoration(
                                color: HexColor('#787878'), //Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 40.w,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                measureAt.toString(),
                                style: defaultTextStyle(
                                    size: 14.sp,
                                    color: HexColor('#787878'),
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                measureResult.healthTips
                                    .toString()
                                    .toCapitalized(),
                                style: defaultTextStyle(
                                    size: 15.sp,
                                    color: HexColor('#000000'),
                                    fontWeight: FontWeight.w600),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Text(
                                  '${'heart_health'.tr} : ${measureResult.bodyHealth}',
                                  style: defaultTextStyle(
                                      size: 12.sp,
                                      color: HexColor('#787878'),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ))
        : Container();
  }
}
