import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../services/toast_service.dart';

ToastService toastService = ToastService();

void showToastNotificationByResponse(
    BuildContext context, Response response, String title, String message) {
  if (response.statusCode == 200 || response.statusCode == 201) {
    toastService.showSuccessToast(
        context: context, title: title, message: message);
  } else {
    toastService.showErrorToast(
        context: context,
        title: response.statusCode.toString(),
        message: response.body);
  }
}
