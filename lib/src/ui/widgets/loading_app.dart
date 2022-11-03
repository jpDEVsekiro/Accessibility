import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingApp {
  BuildContext? dialogContext;
  void show({BuildContext? dialogContext}) {
    if (dialogContext == null) {
      Get.dialog(WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          alignment: Alignment.center,
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: LoadingAnimationWidget.discreteCircle(
                color: Colors.greenAccent,
                secondRingColor: Colors.green,
                thirdRingColor: Colors.cyan,
                size: ((Get.height + Get.width) / 10) * 0.5),
          ),
        ),
      ));
    } else {
      showDialog(
        context: dialogContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Dialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.greenAccent,
                  secondRingColor: Colors.green,
                  thirdRingColor: Colors.cyan,
                  size: ((Get.height + Get.width) / 10) * 0.5),
            ),
          );
        },
      );
    }
  }

  void close({BuildContext? dialogContext}) {
    Get.closeAllSnackbars();
    if (dialogContext == null) {
      Get.back();
    } else {
      try {
        Navigator.pop(dialogContext);
      } finally {}
    }
  }
}
