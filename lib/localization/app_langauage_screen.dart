// ignore_for_file: use_key_in_widget_constructors

import 'package:doori_mobileapp/localization/constant.dart';
import 'package:doori_mobileapp/localization/language_controller.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/activity_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppLanguageScreen extends StatefulWidget {
  String? routeName;

  AppLanguageScreen({this.routeName, super.key});

  @override
  State<StatefulWidget> createState() {
    return AppLanguageState();
  }
}

class AppLanguageState extends State<AppLanguageScreen> {
  int? selectedOption;

  bool isSelectedItem = false;
  final LocalizationController controller = Get.find();

  List<LanguageModel> english = [];

  //final sharedPreference = await SharedPreferences.getInstance();
  // final languageController = LocalizationController(sharedPreferences: Get.find());
  // final sharedPreference = await SharedPreferences.getInstance();
  // Get.lazyPut(() => sharedPreference);

  @override
  void initState() {
    super.initState();

    printf('--route-name--${widget.routeName}');

    english.add(LanguageModel(
        title: 'English', subTitle: '', countryCode: 'US', languageCode: 'en'));

    english.add(LanguageModel(
        title: 'हिंदी',
        subTitle: 'Hindi',
        countryCode: 'IN',
        languageCode: 'hi'));

    english.add(LanguageModel(
        title: 'ગુજરાતી',
        subTitle: 'Gujarati',
        countryCode: 'IN',
        languageCode: 'gu'));

    english.add(LanguageModel(
        title: 'मराठी',
        subTitle: 'Marathi',
        countryCode: 'IN',
        languageCode: 'mh'));

    english.add(LanguageModel(
        title: 'বাংলা',
        subTitle: 'Bangla',
        countryCode: 'IN',
        languageCode: 'bn'));

    english.add(LanguageModel(
        title: 'ଓଡିଆ',
        subTitle: 'Odia',
        countryCode: 'IN',
        languageCode: 'or'));

    english.add(LanguageModel(
        title: 'മലയാളം',
        subTitle: 'Malayalam',
        countryCode: 'IN',
        languageCode: 'ml'));

    english.add(LanguageModel(
        title: 'ಕನ್ನಡ',
        subTitle: 'Kannada',
        countryCode: 'IN',
        languageCode: 'kn'));

    english.add(LanguageModel(
        title: 'தமிழ்',
        subTitle: 'Tamil',
        countryCode: 'IN',
        languageCode: 'ta'));

    english.add(LanguageModel(
        title: 'తెలుగు',
        subTitle: 'Telugu',
        countryCode: 'IN',
        languageCode: 'te'));

    english.add(LanguageModel(
        title: 'ਪੰਜਾਬੀ',
        subTitle: 'Punjabi',
        countryCode: 'IN',
        languageCode: 'pa'));

    english.add(LanguageModel(
        title: 'Polski',
        subTitle: 'Polish',
        countryCode: 'IN',
        languageCode: 'pl'));

    english.add(LanguageModel(
        title: 'slovenský',
        subTitle: 'Slovak',
        countryCode: '+421',
        languageCode: 'sk'));

    english.add(LanguageModel(
        title: 'čeština',
        subTitle: 'Czech',
        countryCode: '+420',
        languageCode: 'cs'));

    english.add(LanguageModel(
        title: 'Deutsch',
        subTitle: 'German',
        countryCode: '+49',
        languageCode: 'de'));

    english.add(LanguageModel(
        title: 'Magyar',
        subTitle: 'Hungarian',
        countryCode: '+36',
        languageCode: 'hu'));

    english.add(LanguageModel(
        title: 'Српски',
        subTitle: 'Serbian',
        countryCode: '+381',
        languageCode: 'sr'));

    // printf('total-Lang--${english.length}');

    selectedOption = controller.selectedIndex;

    printf('check--index--lang--${controller.selectedIndex}');
  }

  @override
  Widget build(BuildContext context) {
    return ColoredSafeArea(
      color: ColorConstants.blueColor,
      child: Scaffold(
          appBar: commonAppbar(
            onBack: () {
              Get.back();
            },
            title: 'Choose Language',
          ),
          body: Stack(
            children: [
              SizedBox(
                height: Get.height,
                width: Get.width,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      /*Padding(
                        padding: EdgeInsets.only(left: 5.w),
                        child: Text(
                          'Choose Language',
                          style: defaultTextStyle(
                              size: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),*/
                      Expanded(
                          child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: (1 / .55),
                              children: List.generate(
                                english.length,
                                (index) {
                                  return widgetLanguage(english[index], index);
                                },
                              ))),
                      SizedBox(
                        height: 80.h,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  elevation: 10,
                  color: Colors.white,
                  child: Container(
                    height: 80.h,
                    width: Get.width,
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: SizedBox(
                          width: double.infinity,
                          height: 50.h,
                          child: MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              printf('selectedLang-$selectedOption');

                              controller.setLanguage(Locale(
                                AppLanguageConstants
                                    .languages[selectedOption!].languageCode
                                    .toString(),
                                AppLanguageConstants
                                    .languages[selectedOption!].countryCode,
                              ));
                              controller.setSelectedIndex(selectedOption!);

                              if (widget.routeName == 'login') {
                                Get.back();
                              } else {
                                Get.deleteAll();
                                Get.offNamedUntil(
                                    Routes.dashboardScreen, (route) => false);
                              }
                            },
                            color: Colors.blue,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Text(
                              'Continue',
                              style: textMedium.copyWith(
                                  color: Colors.white, fontSize: 16.sp),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget widgetLanguage(LanguageModel data, int index) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      //height: 90.h,
      //width: 125.w,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: selectedOption == index ? HexColor('#e5f6fd') : Colors.white,
        border: Border.all(
            width: 1,
            color: selectedOption == index ? Colors.blue : Colors.grey),
      ),
      child: InkWell(
        onTap: () {
          printf('clicked--radio-${data.title}');
          setState(() {
            selectedOption = index;
            //data.isSelected = !data.isSelected;
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                  padding: EdgeInsets.only(top: 10.h, left: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        data.title.toString(),
                        style: defaultTextStyle(
                            size: 16.sp,
                            color: selectedOption == index
                                ? Colors.blue
                                : Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        data.subTitle.toString(),
                        style: defaultTextStyle(
                            size: 15.sp,
                            color: selectedOption == index
                                ? Colors.blue
                                : Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )),
            ),
            Radio(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: 1,
              groupValue: selectedOption == index ? 1 : 0,
              onChanged: (value) {
                setState(() {
                  printf("Button value: $value");
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
