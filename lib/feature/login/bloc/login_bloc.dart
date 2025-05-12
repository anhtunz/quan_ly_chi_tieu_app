// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quan_ly_chi_tieu/feature/login/model/login_model.dart';
import 'package:quan_ly_chi_tieu/product/constants/enums/app_route_enums.dart';
import 'package:quan_ly_chi_tieu/product/services/language_services.dart';
import 'package:quan_ly_chi_tieu/product/shared/shared_toast_notification.dart';

import '../../../product/cache/locale_manager.dart';
import '../../../product/constants/enums/locale_keys_enum.dart';
import '../../../product/services/api_services.dart';

import '../../../product/base/bloc/base_bloc.dart';

class LoginBloc extends BlocBase {
  APIServices apiServices = APIServices();

  final isShowPassword = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsShowPassword => isShowPassword.sink;
  Stream<bool> get streamIsShowPassword => isShowPassword.stream;

  @override
  void dispose() {}

  void login(BuildContext context, String email, String password) async {
    Map<String, dynamic> loginRequest = {"email": email, "password": password};
    final response = await apiServices.login(loginRequest);
    showToastNotificationByResponse(
        context,
        response,
        appLocalization(context).notification_message,
        appLocalization(context).login_success);
    if (response.statusCode == 200) {
      log(response.body);
      Map<String, dynamic> data = jsonDecode(response.body);
      LoginModel loginModel = LoginModel.fromJson(data['data']);
      log("LoginModel: ${loginModel.token}");
      LocaleManager.instance
          .setString(PreferencesKeys.TOKEN, loginModel.token ?? "");
      LocaleManager.instance
          .setString(PreferencesKeys.EMAIL, loginModel.email ?? "");
      LocaleManager.instance
          .setString(PreferencesKeys.NAME, loginModel.name ?? "");
      String userToken = getBaseToken(loginModel.token!);
      var decode = decodeBase64Token(userToken);
      String userID = decode['UserId'];
      int exp = decode['exp'];
      LocaleManager.instance.setString(PreferencesKeys.UID, userID);
      LocaleManager.instance.setInt(PreferencesKeys.EXP, exp);
      context.goNamed(AppRoutes.HOME.name);
    }
  }

  getBaseToken(String token) {
    List<String> parts = token.split('.');
    String userToken = parts[1];
    return userToken;
  }

  Map<String, dynamic> decodeBase64Token(String value) {
    List<int> res = base64.decode(base64.normalize(value));
    String jsonString = utf8.decode(res);
    return json.decode(jsonString);
  }
}
