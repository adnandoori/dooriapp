import 'package:doori_mobileapp/ui/screens/account/about_screen.dart';
import 'package:doori_mobileapp/ui/screens/account/account_screen.dart';
import 'package:doori_mobileapp/localization/app_langauage_screen.dart';
import 'package:doori_mobileapp/ui/screens/account/my_profile_screen.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/forgot_password_screen.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/login_screen.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/personal_details_screen.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/scan_device_screen.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/sign_up_screen.dart';
import 'package:doori_mobileapp/ui/screens/auth_screens/start_scan_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/activity_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/bmi_detail_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/dashboard_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/graph_screens/energy_and_stress_level_graph.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/graph_screens/heart_graph_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/graph_screens/stroke_cardiac_graph_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/health_tips_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/measure_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/prediction_ai_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/tools_screen.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/visualise_screen.dart';
import 'package:doori_mobileapp/ui/screens/launch_screen/launch_screen.dart';
import 'package:doori_mobileapp/ui/screens/measure_screens/deep_sense_test_screen.dart';
import 'package:doori_mobileapp/ui/screens/measure_screens/error_connection_screen.dart';
import 'package:doori_mobileapp/ui/screens/measure_screens/measure_result_readings_screen.dart';
import 'package:doori_mobileapp/ui/screens/measure_screens/measure_result_screen.dart';
import 'package:doori_mobileapp/ui/screens/measure_screens/start_measure_screen.dart';
import 'package:doori_mobileapp/ui/screens/tools_screens/add_symptom_screen.dart';
import 'package:doori_mobileapp/ui/screens/tools_screens/analysis_detail_screen.dart';
import 'package:doori_mobileapp/ui/screens/tools_screens/health_analysis_screen.dart';
import 'package:doori_mobileapp/ui/screens/tools_screens/meditation_test_screen.dart';
import 'package:doori_mobileapp/ui/screens/tools_screens/symptom_checker_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
        name: Routes.splash,
        page: () => const SplashScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.dashboardScreen,
        page: () => const DashboardScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.signUpScreen,
        page: () => const SignUpScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.loginScreen,
        page: () => const LoginScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.myProfileScreen,
        page: () => const MyProfileScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.accountScreen,
        page: () => const AccountScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.forgotPasswordScreen,
        page: () => const ForgotPasswordScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.activityScreen,
        page: () => const ActivityScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.toolsScreen,
        page: () => const ToolsScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.measureScreen,
        page: () => const MeasureScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.startMeasureScreen,
        page: () => const StartMeasureScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.meditationTestScreen,
        page: () => const MeditationTestScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.symptomCheckerScreen,
        page: () => const SymptomCheckerScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.addSymptomScreen,
        page: () => const AddSymptomScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.healthAnalysisScreen,
        page: () => const HealthAnalysisScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.inDepthAnalysisScreen,
        page: () => AnalysisDetailScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.measureResultScreen,
        page: () => const MeasureResultScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.measureResultReadingsScreen,
        page: () => const ResultReadingsScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.heartGraphScreen,
        page: () => const HeartGraphScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.personalDetailsScreen,
        page: () => const PersonalDetailsScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.personalDetailsScreen,
        page: () => const PersonalDetailsScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.scanDeviceScreen,
        page: () => const ScanDeviceScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.aboutScreen,
        page: () => AboutScreen('', ''),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.errorConnectionScreen,
        page: () => const ErrorConnectionScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.healthTipsScreen,
        page: () => const HealthTipsScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.startScanScreen,
        page: () => const StartScanScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.visualiseScreen,
        page: () => const VisualiseScreen(),
        transition: Transition.rightToLeftWithFade),
    /*GetPage(
        name: Routes.strokeCardiacGraphScreen,
        page: () => StrokeCardiacGraphScreen(),
        transition: Transition.rightToLeftWithFade),*/
    GetPage(
        name: Routes.appLanguagesScreen,
        page: () => AppLanguageScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.energyStressLevelGraphScreen,
        page: () => const EnergyStressLevelScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.bmiDetailScreen,
        page: () => const BMIDetailScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.deepSenseTestScreen,
        page: () => const DeepSenseTestScreen(),
        transition: Transition.rightToLeftWithFade),
    GetPage(
        name: Routes.predictionAIScreen,
        page: () => const PredictionAIScreen(),
        transition: Transition.rightToLeftWithFade),
  ];
}
