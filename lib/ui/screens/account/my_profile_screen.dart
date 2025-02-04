import 'dart:typed_data';
import 'package:doori_mobileapp/controllers/authentication_controllers/profile_controller.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/image_upload.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:doori_mobileapp/utils/style.dart';
import 'package:doori_mobileapp/utils/utility.dart';
import 'package:doori_mobileapp/utils/validator.dart';
import 'package:doori_mobileapp/widgets/button_widget.dart';
import 'package:doori_mobileapp/widgets/text_form_field.dart';
import 'package:doori_mobileapp/widgets/validations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);
  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  Uint8List? _image;
  void selectImage() async {
    Uint8List? img = await ImageUpload().pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
        init: ProfileController(context),
        builder: (controller) {
          return GestureDetector(
            onTap: () {
              printf('keyboard_dismissed');
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 220.h,
                    width: Get.width, // MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Image.asset(
                          ImagePath.bgImageDashboard,
                          height: 220.h,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _image != null
                                ? Center(
                                    child: ClipOval(
                                      child: Image.memory(
                                        _image!,
                                        height: 70.w,
                                        width: 70.w,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Image.asset(
                                      ImagePath.icUserProfile,
                                      height: 70.w,
                                      width: 70.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                            Positioned(
                                child: InkWell(
                              onTap: () {
                                selectImage();
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                  size: 30.sp,
                                ),
                              ),
                            )),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              controller.username.toTitleCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Montserrat',
                              ),
                            )
                          ],
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () {
                              Get.back(result: controller.isDataUpdate);
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 45.h, left: 10.w),
                              width: 30.w,
                              height: 30.w,
                              child: Center(
                                child: Image.asset(
                                  ImagePath.icBackButton,
                                  width: 25.w,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              printf('clicked_edit_profile');
                              controller.isEditable = true;
                              controller.update();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 45.h, right: 10.w),
                              width: 30.w,
                              height: 30.w,
                              child: const Center(
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  controller.isEditable
                      ? widgetEditProfile(controller)
                      : widgetProfileDetail(controller),
                ],
              ),
            ),
          );
        });
  }

  Widget widgetProfileDetail(ProfileController controller) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'email'.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            controller.email,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'date_of_birth'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      controller.dob,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'gender'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      controller.gender,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'height'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      '${controller.height} ${'cm'.tr}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'weight'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "${controller.weight} ${'kg'.tr}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget widgetEditProfile(ProfileController controller) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 25.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              validators: nameValidator,
              controller: controller.textNameController,
              inputFormatters: [NoLeadingSpaceFormatter()],
              label: 'name'.tr,
              hint: 'name'.tr,
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150.w,
                  child: AppTextField(
                    label: 'date_of_birth'.tr,
                    keyboardType: TextInputType.phone,
                    readOnly: true,
                    validators: dateOfBirthValidator,
                    hint: 'date_of_birth'.tr,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime(DateTime.now().year - 18),
                          firstDate: DateTime(1901),
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        printf(formattedDate);
                        setState(() {
                          controller.textDateOfBirthController.text =
                              formattedDate;
                          DateTime selectedDate = DateTime(pickedDate.year,
                              pickedDate.month, pickedDate.day);

                          DateTime todayDate = DateTime.now();

                          controller.age = todayDate.year - selectedDate.year;
                        });
                      }
                    },
                    maxLength: 11,
                    inputFormatters: [NoLeadingSpaceFormatter()],
                    controller: controller.textDateOfBirthController,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 160.w,
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.5), width: 1.w),
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: DropdownButton<String>(
                      value: controller.dropDownValue,
                      onChanged: (value) {
                        setState(() {
                          controller.dropDownValue = value;
                        });
                      },
                      underline: Container(),
                      isExpanded: true,
                      items: ["male".tr, "female".tr, "other".tr]
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: textMedium.copyWith(
                                    color: Colors.grey,
                                    fontSize: 15.sp,
                                    fontFamily: AppConstants.fontFamily),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150.w,
                  child: AppTextField(
                    label: '${'height'.tr} (${'in_cms'.tr})',
                    //AppConstants.heightInCms,
                    hint: '${'height'.tr} (${'in_cms'.tr})',
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validators: heightValidator,
                    controller: controller.textHeightController,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 160.w,
                  child: AppTextField(
                    label: '${'weight'.tr} (${'in_kgs'.tr})',
                    //AppConstants.weightInKgs,
                    hint: '${'weight'.tr} (${'in_kgs'.tr})',
                    //AppConstants.weightInKgs,
                    keyboardAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validators: weightValidator,
                    controller: controller.textWeightController,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 135.h, left: 12.w, right: 12.w),
              child: AppButton(AppConstants.save, () {
                printf('saved');

                if (_formKey.currentState!.validate()) {
                  printf('call_update');

                  controller.callCheckTodayBMIRecords();
                  //controller.callUpdateUserDetail();
                }

                // if (controller.textNameController.text.isEmpty) {
                // } else if (controller.textHeightController.text.isEmpty) {
                // } else if (controller.textWeightController.text.isEmpty) {
                // } else {
                //   controller.callUpdateUserDetail();
                // }
              }, height: 40.h),
            ),
          ],
        ),
      ),
    );
  }
}
