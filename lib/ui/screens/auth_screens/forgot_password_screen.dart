import 'package:doori_mobileapp/controllers/authentication_controllers/forgot_password_contoller.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:doori_mobileapp/utils/validator.dart';
import 'package:doori_mobileapp/widgets/button_widget.dart';
import 'package:doori_mobileapp/widgets/text_form_field.dart';
import 'package:doori_mobileapp/widgets/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(context),
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: Padding(
                padding: EdgeInsets.all(12.w),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    ImagePath.icBackButton,
                  ),
                ),
              ),
              title:  Text(
                'reset_password'.tr,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppConstants.fontFamily),
              ),
            ),
            body: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35.h,
                    ),
                     Text(
                      'enter_username_to_continue'.tr,
                      style: const TextStyle(
                          fontFamily: AppConstants.fontFamily,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    AppTextField(
                      label: 'email'.tr,
                      hint: 'email'.tr,
                      controller: controller.textEmailController,
                      keyboardAction: TextInputAction.done,
                      validators: emailValidator,
                      inputFormatters: [NoLeadingSpaceFormatter()],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    AppButton(
                      'reset_password'.tr,
                      () {
                        if (_formKey.currentState!.validate()) {
                          controller.getPassword();
                        }
                      },
                      height: 40.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
