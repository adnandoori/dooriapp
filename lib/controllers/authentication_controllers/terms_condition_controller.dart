import 'package:doori_mobileapp/controllers/base_controller.dart';
import 'package:doori_mobileapp/ui/components/common.dart';
import 'package:flutter/material.dart';

class TermsConditionController extends BaseController {
  BuildContext context;

  TermsConditionController(this.context);

  final uniqueKey = UniqueKey();

  var url = 'www.google.com';

  @override
  void onInit() {
    printf('init_terms_condition');
    super.onInit();
  }

  @override
  void onClose() {
    printf('close_terms_condition');
    super.onClose();
  }
}
