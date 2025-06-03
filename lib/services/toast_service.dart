import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  static void show({
    required String message,
    ToastificationType type = ToastificationType.success,
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(message),
      alignment: Alignment.bottomCenter,
      animationDuration: const Duration(milliseconds: 300),
      showIcon: true,
      showProgressBar: true,
    );
  }
}
