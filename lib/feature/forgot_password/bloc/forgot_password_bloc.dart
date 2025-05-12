// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/product/base/bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/product/constants/enums/app_route_enums.dart';
import 'package:quan_ly_chi_tieu/product/services/api_services.dart';
import 'package:quan_ly_chi_tieu/product/services/toast_service.dart';

class ForgotPasswordBloc extends BlocBase {
  APIServices apiServices = APIServices();
  ToastService toastService = ToastService();
  final isEmailDisable = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkisEmailDisable => isEmailDisable.sink;
  Stream<bool> get streamisEmailDisable => isEmailDisable.stream;

  final isOTPDisable = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkisOTPDisable => isOTPDisable.sink;
  Stream<bool> get streamisOTPDisable => isOTPDisable.stream;

  final isClearOTP = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkisClearOTP => isClearOTP.sink;
  Stream<bool> get streamisClearOTP => isClearOTP.stream;

  final isShowPassword = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsShowPassword => isShowPassword.sink;
  Stream<bool> get streamIsShowPassword => isShowPassword.stream;

  final isConfirmPassword = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsConfirmPassword => isConfirmPassword.sink;
  Stream<bool> get streamIsConfirmPassword => isConfirmPassword.stream;

  @override
  void dispose() {}

  void sendOTPMail(BuildContext context, String email, String otp) async {
    Map<String, dynamic> body = {
      "email": email,
      "otp": otp,
    };
    toastService.showInfoToast(
        duration: Duration(seconds: 2),
        context: context,
        title: "Thông báo",
        message: "Đang xử lý");
    final statusCode = await apiServices.sendOTPMail(body);
    if (statusCode == 200) {
      toastService.showSuccessToast(
          context: context,
          title: "Thông báo",
          message: "Mã OTP đã được gửi đến email của bạn");
    } else {
      toastService.showWarningToast(
          context: context,
          title: "Thông báo",
          message: "Hệ thống lỗi! Vui lòng thử lại");
    }
  }

  void refreshPassword(
      BuildContext context, String email, String newPassword) async {
    Map<String, dynamic> body = {
      "email": email,
      "password": newPassword,
    };
    final statusCode = await apiServices.refreshPassword(body);
    if (statusCode == 200) {
      toastService.showSuccessToast(
          context: context,
          title: "Thông báo",
          message: "Đổi mật khẩu thành công");
      context.pushNamed(AppRoutes.LOGIN.name);
    } else {
      toastService.showWarningToast(
          context: context,
          title: "Thông báo",
          message: "Hệ thống lỗi! Vui lòng thử lại");
    }
  }
}
