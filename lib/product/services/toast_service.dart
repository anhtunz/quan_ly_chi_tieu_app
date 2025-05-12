import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastService {
  // Default duration for toasts
  static const Duration _defaultDuration = Duration(seconds: 2);

  // Show a toast with custom configuration
  void _showToast({
    required BuildContext context,
    required String title,
    required String message,
    required ToastificationType type,
    ToastificationStyle style = ToastificationStyle.fillColored,
    Duration? duration,
    Alignment? alignment,
    Icon? icon,
  }) {
    toastification.show(
      context: context,
      type: type,
      style: style,
      title: Text(title),
      description: Text(message),
      alignment: alignment ?? Alignment.topCenter,
      autoCloseDuration: duration ?? _defaultDuration,
      icon: icon,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 10.0,
          spreadRadius: 2.0,
          offset: Offset(0.0, 2.0),
        ),
      ],
      showProgressBar: true,
      closeOnClick: false,
      pauseOnHover: true,
    );
  }

  // Show a success toast
  void showSuccessToast({
    required BuildContext context,
    required String title,
    required String message,
    Duration? duration,
    Alignment? alignment,
  }) {
    _showToast(
      context: context,
      title: title,
      message: message,
      type: ToastificationType.success,
      duration: duration ?? _defaultDuration,
      alignment: alignment,
      icon: const Icon(Icons.check_circle),
    );
  }

  // Show an error toast
  void showErrorToast({
    required BuildContext context,
    required String title,
    required String message,
    Duration? duration,
    Alignment? alignment,
  }) {
    _showToast(
      context: context,
      title: title,
      message: message,
      type: ToastificationType.error,
      duration: duration ?? _defaultDuration,
      alignment: alignment,
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }

  // Show an info toast
  void showInfoToast({
    required BuildContext context,
    required String title,
    required String message,
    Duration? duration,
    Alignment? alignment,
  }) {
    _showToast(
      context: context,
      title: title,
      message: message,
      type: ToastificationType.info,
      duration: duration ?? _defaultDuration,
      alignment: alignment,
      icon: const Icon(Icons.info, color: Colors.white),
    );
  }

  // Show a warning toast
  void showWarningToast({
    required BuildContext context,
    required String title,
    required String message,
    Duration? duration,
    Alignment? alignment,
  }) {
    _showToast(
      context: context,
      title: title,
      message: message,
      type: ToastificationType.warning,
      duration: duration ?? _defaultDuration,
      alignment: alignment,
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }

  // Dismiss all toasts
  void dismissAll() {
    toastification.dismissAll();
  }
}
