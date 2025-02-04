import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void statusBarColor() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blue,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
}

Widget divider() {
  return const Divider(
    thickness: 0.3,
    color: ColorConstants.black,
  );
}

Widget widgetDivider({double height = 1.0, String hexColor = '#000000'}) {
  return Container(
    height: height,
    width: Get.width,
    color: HexColor(hexColor),
  );
}

defaultTextStyle(
    {double size = 18,
    Color? color,
    double lineHeight = 1.2,
    double letterSpacing = .1,
    FontWeight? fontWeight}) {
  return TextStyle(
      fontWeight: fontWeight ?? FontWeight.normal,
      fontFamily: 'Montserrat',
      fontSize: size,
      letterSpacing: letterSpacing,
      height: lineHeight,
      color: color ?? ColorConstants.white);
}

printf(String msg) {
  if (kDebugMode) {
    print(msg);
  }
}

commonSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

commonAppbar({VoidCallback? onBack, String title = ''}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(60.h),
    child: Container(
      width: Get.width,
      height: 60.h,
      color: ColorConstants.blueColor,
      child: Padding(
        padding: EdgeInsets.only(
          left: 15.w,
        ),
        child: Row(
          children: [
            InkWell(
              onTap: onBack,
              child: Image.asset(
                ImagePath.icBackBtn,
                height: 25.w,
                width: 25.w,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              title.toUpperCase(),
              style: defaultTextStyle(size: 16.sp, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    ),
  );
}

commonAppbarWhiteColor({VoidCallback? onBack, String title = ''}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(60.h),
    child: Material(
      elevation: 1,
      child: Container(
        width: Get.width,
        height: 60.h,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(
            left: 15.w,
          ),
          child: Row(
            children: [
              InkWell(
                onTap: onBack,
                child: Image.asset(
                  ImagePath.icBackBtn,
                  height: 25.w,
                  width: 25.w,
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(child: Text(
                title.toUpperCase(),
                maxLines: 1,
                style: defaultTextStyle(
                    size: 16.sp,
                    color: HexColor('#787878'),
                    fontWeight: FontWeight.w500),
              )),
            ],
          ),
        ),
      ),
    ),
  );
}

appBarStatic() {
  PreferredSize(
    preferredSize: Size.fromHeight(60.h),
    child: AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.green,
        // <-- SEE HERE
        statusBarIconBrightness: Brightness.dark,
        //<-- For Android SEE HERE (dark icons)
        statusBarBrightness:
            Brightness.dark, //<-- For iOS SEE HERE (dark icons)
      ),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImagePath.icBackBtn,
            height: 25.w,
            width: 25.w,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            'Test title',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

commonButton(
    {required String title,
    required VoidCallback onTap,
    Color? bgColor,
    Color? textColor}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(0.0),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    onPressed: onTap,
    child: SizedBox(
      height: 47.h,
      width: Get.width,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
          color: bgColor ?? ColorConstants.blueColor,
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Center(
              child: Text(
                title,
                style: defaultTextStyle(
                    size: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor ?? Colors.white),
              ),
            )),
      ),
    ),
  );
}
