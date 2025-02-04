import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddSymptomScreen extends StatelessWidget {
  const AddSymptomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                widgetAppbar(),
                widgetSelectedSymptoms(),
                widgetSymptomList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget widgetSymptomList() {
  return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: HexColor('#E3F7FF'),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You might also have:',
              style: defaultTextStyle(
                  size: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: 20.h,
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                widgetSymptom(title: 'Cough'),
                widgetSymptom(title: 'Sore throat'),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ));
}

Widget widgetSelectedSymptoms() {
  return Container(
      width: Get.width,
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        color: HexColor('#E3F7FF'),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selected symptoms:',
              style: defaultTextStyle(
                  size: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: 20.h,
            ),
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                widgetSymptom(title: 'Cough', isRemove: true),
                widgetSymptom(title: 'Sore throat', isRemove: true),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 40.h,
              child: commonButton(title: 'ANALYZE DISEASE', onTap: () {}),
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 40.h,
              child: commonButton(title: 'CLEAR ALL', onTap: () {}),
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ));
}

Widget widgetSymptom({String title = '', bool isRemove = false}) {
  return Container(
    margin: EdgeInsets.only(top: 10.h),
    width: Get.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: defaultTextStyle(
                  color: Colors.black,
                  size: 14.sp,
                  fontWeight: FontWeight.w500),
            )),
            isRemove
                ? InkWell(
                    onTap: () {
                      printf('removed');
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Image.asset(
                        ImagePath.icCancelRedBtn,
                        height: 15.w,
                        width: 15.w,
                      ),
                    ),
                  )
                : SizedBox(
                    height: 15.w,
                    width: 15.w,
                  )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        widgetDivider(
          height: 0.3,
        ),
      ],
    ),
  );
}

Widget widgetAppbar() {
  return Container(
    width: Get.width,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      color: ColorConstants.blueColor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, left: 15.w),
          child: InkWell(
            onTap: () {
              Get.back();
            },
            child: Image.asset(
              ImagePath.icBackBtn,
              height: 30.w,
              width: 30.w,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
          width: Get.width,
          height: 42.h,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                      onChanged: (v) {},
                      style: defaultTextStyle(
                          size: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              top: 0.0, bottom: 7.0, left: 14, right: 10),
                          filled: true,
                          hintText: 'Enter symptoms',
                          hintStyle: defaultTextStyle(
                              size: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                          fillColor: Colors.transparent,
                          labelStyle: defaultTextStyle(
                              size: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                          border: InputBorder.none))),
              InkWell(
                onTap: () {
                  printf('added');
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),
                  child: Image.asset(
                    ImagePath.icAddBtn,
                    height: 20.w,
                    width: 20.w,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 45.w, bottom: 20.h),
          child: Text(
            'Eg. Cough, Headache, Joint pain etc.',
            style: defaultTextStyle(size: 14.sp, fontWeight: FontWeight.w400),
          ),
        )
      ],
    ),
  );
}
