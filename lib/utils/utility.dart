import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:doori_mobileapp/models/authentication_model/user_model.dart';
import 'package:doori_mobileapp/models/graph/body_health_model.dart';
import 'package:doori_mobileapp/models/measure_model/measure_model.dart';
import 'package:doori_mobileapp/ui/components/common.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_constants.dart';
import 'color_constants.dart';

class Utility {
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      if (kDebugMode) {
        print('Internet mode : mobile');
      }
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      if (kDebugMode) {
        print('Internet mode : wifi');
      }
      return true;
    }
    return false;
  }

  bool isValidEmail(String text) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(text);
  }

  static Widget? hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return null;
  }

  static Future<String> getUserAPIKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userAPIKey = prefs.getString(AppConstants.apiKey);
    return userAPIKey!;
  }

  //------------------------------------

  static Future<void> setUserDetails(String userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userDetails', userDetails);
  }

  static Future<UserModel?> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userDetails');
    if (userData != null && userData.isNotEmpty) {
      return UserModel.fromJson(jsonDecode(userData));
    } else {
      return null;
    }
  }

  // store all user records
  static Future<void> setAllRecords(String userRecords) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userRecords', userRecords);
  }

  static Future<String?> getAllRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userRecords = prefs.getString('userRecords');
    return userRecords;
  }

  Future<void> setUserRecordList(List<MeasureResult> tList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userRecordList', jsonEncode(tList));
    } catch (e) {
      printf('exe-set-user-records-->$e');
    }
  }

  Future<void> setUserBodyHealthRecordList(List<BodyHealthModel> tList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userBodyHealthRecordList', jsonEncode(tList));
    } catch (e) {
      printf('exe-set-user-records-->$e');
    }
  }

  //

  // store last user record
  static Future<void> setLastMeasureRecord(String userDetails) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastRecord', userDetails);
  }

  static Future<MeasureResult?> getLastMeasureRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('lastRecord');
    if (userData != null && userData.isNotEmpty) {
      return MeasureResult.fromJson(jsonDecode(userData));
    } else {
      return null;
    }
  }

  //

  static setUserName(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.userName, userName);
  }

  static Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString(AppConstants.userName);
    return userToken!;
  }

  /*static setDevice(BluetoothDevice device) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('device', device.toString());
  }

  static Future<BluetoothDevice> getDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    BluetoothDevice device = prefs.getString('device');
    return device;
  }*/

  static setDeviceId(String deviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceId', deviceId);
  }

  static Future<String> getDeviceId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('deviceId');
    return deviceId!;
  }

  static void setDeviceName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceName', name);
  }

  static Future<String> getDeviceName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceName = prefs.getString('deviceName');
    return deviceName!;
  }


  // static void setDeviceType(BluetoothDeviceType type) async
  // {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('deviceType', type.name);
  // }

  static Future<String> getDeviceType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceType = prefs.getString('deviceType');
    return deviceType!;
  }

  static setUserEmail(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.userEmail, userEmail);
  }

  static Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString(AppConstants.userEmail);
    return userToken!;
  }

  static setUserMobileNo(String userMobile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.userMobileNo, userMobile);
  }

  static Future<String> getUserMobile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString(AppConstants.userMobileNo);
    return userToken!;
  }

  //-----------------------------------

  static setUserToken(String token) async {
    printf('save_token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.userToken, token);
  }

  static Future<String> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString(AppConstants.userToken);
    return userToken!;
  }

  static setUserData(String userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.userInfo, userData);
  }

  static Future<String> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userInfo = prefs.getString(AppConstants.userInfo);
    return userInfo!;
  }

  /*static Future<String> getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userType = prefs.getString(AppConstantss.userType);
    return userType!;
  }*/

  static Future<String> getUserPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPassword = prefs.getString(AppConstants.userPassword);
    return userPassword!;
  }

  static Future<String> getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userProfile = prefs.getString(AppConstants.userProfile);
    return userProfile!;
  }

  static setUserId(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(AppConstants.userId, value);
  }

  static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString(AppConstants.userId);
    return userId!;
  }

  static setIsUserLoggedIn(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppConstants.isLogin, value);
  }

  static Future<bool?> getIsUserLoggedIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(AppConstants.isLogin);
  }

  static setIsOfflineRecord(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(AppConstants.isOfflineRecordInserted, value);
  }

  static Future<bool?> getIsOfflineRecordFetch() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(AppConstants.isOfflineRecordInserted);
  }

  static buildProgressIndicator() {
    return Container(
      height: Get.height,
      color: Colors.transparent, //ColorConstants.black.withOpacity(0.4),
      child: Center(
        child: LoadingAnimationWidget.hexagonDots(
          color: Colors.white,
          size: 25,
        ),
        /*CupertinoActivityIndicator(
          color: Colors.grey,

        ),*/
        /*CircularProgressIndicator(
          backgroundColor: ColorConstants.tealColor,
          valueColor: AlwaysStoppedAnimation<Color>(ColorConstants.white),
        ),*/
      ),
    );
  }

  void snackBarError(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: msg == 'internet_error'.tr //''AppConstants.noInternet
            ? Colors.red
            : ColorConstants.darkPurple,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void snackBarForInternetIssue() {
    Fluttertoast.showToast(
        msg: 'internet_error'.tr,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor:
             Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void snackBarSuccess(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static String calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age.toString();
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
