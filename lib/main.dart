import 'dart:async';
import 'dart:io';
import 'package:doori_mobileapp/helper/database_helper.dart';
import 'package:doori_mobileapp/localization/constant.dart';
import 'package:doori_mobileapp/localization/language_controller.dart';
import 'package:doori_mobileapp/localization/messeges.dart';
import 'package:doori_mobileapp/route/app_pages.dart';
import 'package:doori_mobileapp/ui/components/color_extenstion.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:workmanager/workmanager.dart';
import 'localization/dependency_inj.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await dep.init();
  await ScreenUtil.ensureScreenSize();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    Workmanager()
        .initialize(callbackDispatcher,
            // The top level function, aka callbackDispatcher
            isInDebugMode:
                false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
            )
        .then((value) => {
              Workmanager().cancelAll().then((value) => {
                    Workmanager().registerOneOffTask(
                        "online_sync", "Regular Sync With Firebase Task",
                        constraints: Constraints(
                            networkType: NetworkType.connected,
                            requiresBatteryNotLow: true,
                            requiresCharging: false,
                            requiresDeviceIdle: false,
                            requiresStorageNotLow: false))
                  })
            });
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  runZonedGuarded(
    () {
      runApp(MyApp(
        languages: languages,
      ));
    },
    (error, stack) => FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: true,
    ),
  );

  // runApp(MyApp(
  //   languages: languages,
  // ));
}

Completer uploadCompleter = Completer();

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    //  printf("SYNC_CALL - Native called background task1: $task"); //simpleTask will be emitted here.
    var dbHelper = DatabaseHelper.instance;
    //  printf("SYNC_CALL - dbHelper1 : $dbHelper");
    var db = await dbHelper.database;
    //  printf("SYNC_CALL - dbHelper2 : $dbHelper & $db");
    var dataArray = await dbHelper.queryNonSyncRows(db);
    // printf("SYNC_CALL - Non synced record = ${dataArray.length}");
    await Firebase.initializeApp();
    if (dataArray.isNotEmpty) {
      var dbRef = FirebaseDatabase.instance;
      //   printf("SYNC_CALL - $dbRef");
      await DatabaseHelper.instance.syncNonSyncedRows(dataArray, dbRef, db);
    }
    uploadCompleter.complete();

    await uploadCompleter.future;

    return true;
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});

  final Map<String, Map<String, String>> languages;

  @override
  Widget build(BuildContext context) {
    Size size = WidgetsBinding.instance.window.physicalSize;
    double ratio = WidgetsBinding.instance.window.devicePixelRatio;
    double width = size.width / ratio;
    printf('width-$width');
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: false,
      statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    ));
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return ScreenUtilInit(
        builder: (BuildContext context, Widget? child) {
          return GlobalLoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: Colors.white,
                size: 25,
              ),
            ),
            overlayColor:  HexColor('90000000'), //const Color(0xff90000000),
            overlayOpacity: 0.5,
            child: GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Montserrat',
                primaryColorDark: Colors.black,
                appBarTheme: const AppBarTheme(
                    systemOverlayStyle: SystemUiOverlayStyle()),
                //  primaryColor: ColorConstants.black,
              ),
              locale: localizationController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                  AppLanguageConstants.languages[0].languageCode.toString(),
                  AppLanguageConstants.languages[0].countryCode),
              initialRoute: Routes.splash,
              getPages: AppPages.routes,
              title: AppConstants.appName,
            ),
          );
        },
      );
    });
  }
}

// username - Asachdev94@gmail.com 12345678
// username - Ssachdev90@gmail.com 12345678
//            s60 Ankit16 ssachdev60@

// asia-southeast1
// mwidth-540.0
// height-1176.0

//mwidth-360.0
//height-640.0
//

/*

Apk link : https://drive.google.com/file/d/18cTRC5UqI1j9fjjRqk5c6KXkb4R0i1pn/view?usp=sharing

- Update systolic adjust calculation
- Hide and disable back button in Activity screen and Measure result screen



 */




