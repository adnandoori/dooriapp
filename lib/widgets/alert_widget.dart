import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alerts {
  static showAlertWithCancelAction(
    BuildContext context,
    final VoidCallback onTap, {
    String cancelTitle = "Cancel",
    String okTitle = "Ok",
    String alertTitle = "Error!",
    String alertMessage = "",
  }) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(cancelTitle),
      onPressed: () {
        Get.back();
      },
    );
    Widget continueButton = TextButton(
      onPressed: onTap,
      child: Text(okTitle),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        alertTitle,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      content: ((alertMessage.isEmpty))
          ? null
          : Text(
              alertMessage,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showAlertWithOkAction(
    BuildContext context,
    final VoidCallback onTap, {
    String okTitle = "Ok",
    String alertTitle = "Error!",
    String alertMessage = "",
  }) {
    // set up the buttons
    Widget continueButton = TextButton(
      onPressed: onTap,
      child: Text(okTitle),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: ((alertMessage.isEmpty)) ? null : Text(alertMessage),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
