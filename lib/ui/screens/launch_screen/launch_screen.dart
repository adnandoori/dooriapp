import 'package:doori_mobileapp/controllers/splash_controller.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double mWidth = MediaQuery.of(context).size.width;

    printf('mwidth-$mWidth');
    printf('height-$height');

    return GetBuilder<SplashController>(
        init: SplashController(context),
        builder: (controller) {
          return Scaffold(
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  height: Get.height,
                  width: Get.width,
                  alignment: Alignment.topCenter,
                  ImagePath.splashLogo,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          );
        });
  }
}
