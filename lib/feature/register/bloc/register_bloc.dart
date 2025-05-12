// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../product/constants/enums/app_route_enums.dart';
import '../../../product/services/language_services.dart';
import '../../../product/services/api_services.dart';
import '../../../product/shared/shared_toast_notification.dart';

import '../../../product/base/bloc/base_bloc.dart';

class RegisterBloc extends BlocBase {
  APIServices apiServices = APIServices();

  @override
  void dispose() {}

  final isShowPassword = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsShowPassword => isShowPassword.sink;
  Stream<bool> get streamIsShowPassword => isShowPassword.stream;

  final isConfirmPassword = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsConfirmPassword => isConfirmPassword.sink;
  Stream<bool> get streamIsConfirmPassword => isConfirmPassword.stream;

  void registerUser(
      BuildContext context, String name, String email, String password) async {
    Map<String, dynamic> registerRequest = {
      'name': name,
      'email': email,
      'password': password
    };
    final response = await apiServices.register(registerRequest);
    showToastNotificationByResponse(
        context,
        response,
        appLocalization(context).notification_message,
        appLocalization(context).register_success);
    if (response.statusCode == 200 || response.statusCode == 201) {
      context.goNamed(AppRoutes.LOGIN.name);
    }
  }
}
