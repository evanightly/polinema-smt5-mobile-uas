import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoadingIndicator {
  static show() {
    return EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      status: 'Loading...',
      dismissOnTap: true,
    );
  }

  static dismiss() {
    return EasyLoading.dismiss();
  }

  static showError(String message) {
    return EasyLoading.showError(message, dismissOnTap: true);
  }
}
