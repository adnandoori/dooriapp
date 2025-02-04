import 'package:doori_mobileapp/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  String label;
  VoidCallback callback;
  double? elevation;
  double? height;
  double? radius;
  double? padding;
  Color? buttonColor;
  Color? labelColor;

  AppButton(this.label, this.callback,
      {double elevation = 0.0,
      this.height,
      this.radius,
      this.padding,
      this.buttonColor,
      this.labelColor}) {
    this.elevation = elevation;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: MaterialButton(
        elevation: this.elevation,
        onPressed: callback,
        child: Text(
          label,
          style: textMedium.copyWith(
              color: labelColor ?? Colors.white, fontSize: 16.sp),
        ),
        color: buttonColor ?? Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius ?? 30)),
        ),
      ),
    );
  }
}
