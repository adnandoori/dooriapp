import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/ui/screens/dashboard_screens/activity_screen.dart';
import 'package:doori_mobileapp/utils/app_constants.dart';
import 'package:doori_mobileapp/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutScreen extends StatelessWidget {
  String urlLink = 'http://www.doori.co.in';
  String title;

  AboutScreen(this.urlLink, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(urlLink));

    return ColoredSafeArea(
      color: ColorConstants.blueColor,
      child: Scaffold(
        appBar: commonAppbar(
            title: title, //AppConstants.aboutApp,
            onBack: () {
              Get.back();
            }),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
