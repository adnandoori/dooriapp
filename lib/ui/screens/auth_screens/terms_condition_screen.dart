import 'package:doori_mobileapp/controllers/authentication_controllers/terms_condition_controller.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:doori_mobileapp/utils/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConditionScreen extends StatelessWidget {
  String urlLink;

  TermsConditionScreen(this.urlLink);

  @override
  Widget build(BuildContext context) {
    context.loaderOverlay.show();
    WebViewController webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            printf("WebPage load : $progress%");
          },
          onPageStarted: (String url) {
            printf("WebPage onPageStarted : $url");
          },
          onPageFinished: (String url) {
            printf("WebPage onPageFinished : $url");
            context.loaderOverlay.hide();
          },
          onWebResourceError: (WebResourceError error) {
            printf("WebPage onWebResourceError : $error");
            context.loaderOverlay.hide();
          },
          onNavigationRequest: (NavigationRequest request) {
            printf("WebPage onNavigationRequest : $request");

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(urlLink));
    return GetBuilder<TermsConditionController>(
        init: TermsConditionController(context),
        builder: (controller) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80.h),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 36.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Image.asset(
                            height: 25.w,
                            width: 25.w,
                            ImagePath.icBackButton,
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    )
                  ]),
            ),
            body: WebViewWidget(controller: webController),
          );
        });
  }
}
