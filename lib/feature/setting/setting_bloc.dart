// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/setting/model/user_model.dart';
import 'package:quan_ly_chi_tieu/product/base/bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/product/cache/locale_manager.dart';
import 'package:quan_ly_chi_tieu/product/constants/enums/locale_keys_enum.dart';
import 'package:quan_ly_chi_tieu/product/services/api_services.dart';
import 'package:quan_ly_chi_tieu/product/services/toast_service.dart';

class SettingBloc extends BlocBase {
  APIServices apiServices = APIServices();
  ToastService toastService = ToastService();

  final userInfo = StreamController<Map<String, dynamic>>.broadcast();
  StreamSink<Map<String, dynamic>> get sinkUserInfo => userInfo.sink;
  Stream<Map<String, dynamic>> get streamUserInfo => userInfo.stream;

  final isChanged = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsChanged => isChanged.sink;
  Stream<bool> get streamIsChanged => isChanged.stream;

  // Change Profile
  final isGenderChanged = StreamController<String>.broadcast();
  StreamSink<String> get sinkIsGenderChanged => isGenderChanged.sink;
  Stream<String> get streamIsGenderChanged => isGenderChanged.stream;

  final userInfomation = StreamController<UserModel>.broadcast();
  StreamSink<UserModel> get sinkUserInfomation => userInfomation.sink;
  Stream<UserModel> get streamUserInfomation => userInfomation.stream;

// Change Password
  final isShowOldPassword = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsShowOldPassword => isShowOldPassword.sink;
  Stream<bool> get streamIsShowOldPassword => isShowOldPassword.stream;

  final isShowPassword = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsShowPassword => isShowPassword.sink;
  Stream<bool> get streamIsShowPassword => isShowPassword.stream;

  final isConfirmPassword = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsConfirmPassword => isConfirmPassword.sink;
  Stream<bool> get streamIsConfirmPassword => isConfirmPassword.stream;

  void getUserInfo() async {
    // await LocaleManager.prefrencesInit();
    String email = LocaleManager.instance.getStringValue(PreferencesKeys.EMAIL);
    String name = LocaleManager.instance.getStringValue(PreferencesKeys.NAME);
    Map<String, dynamic> userInfo = {"email": email, "name": name};
    sinkUserInfo.add(userInfo);
  }

  void getUserFromServer(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController addressController,
      TextEditingController birthdayController,
      String gender) async {
    final response = await apiServices.getUserInfomation();
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      UserModel user = UserModel.fromJson(data['data']);
      nameController.text = user.name!;
      addressController.text = user.address ?? "";
      birthdayController.text = user.birthday?.toIso8601String() ?? "";
      gender = user.gender.toString();
      sinkIsGenderChanged.add(gender);
      userInfomation.add(user);
    } else {
      toastService.showErrorToast(
          context: context,
          title: "Thông báo",
          message: "Lấy thông tin người dùng thất bại");
    }
  }

  void updateUser(BuildContext context, String name, String address, int gender,
      String birthday) async {
    Map<String, dynamic> body = {
      "name": name,
      "address": address,
      "gender": gender,
      "dateOfBirth": birthday
    };

    final statusCode = await apiServices.updateUserInfomation(body);
    if (statusCode == 200) {
      toastService.showSuccessToast(
          context: context,
          title: "Thông báo",
          message: "Cập nhật thông tin người dùng thành công");
    } else {
      toastService.showErrorToast(
          context: context,
          title: "Thông báo",
          message: "Cập nhật thông tin người dùng thất bại");
    }
  }

  void changePassword(BuildContext currentContext, BuildContext context,
      String oldPassword, String newPassword) async {
    Map<String, dynamic> body = {
      "oldPassword": oldPassword,
      "newPassword": newPassword,
    };

    final response = await apiServices.changePassword(body);
    if (response.statusCode == 200) {
      Navigator.pop(currentContext);
      toastService.showSuccessToast(
          context: context,
          title: "Thông báo",
          message: "Đổi mật khẩu thành công");
    } else {
      toastService.showErrorToast(
          context: currentContext, title: "Thông báo", message: response.body);
    }
  }

  void logout(BuildContext context) {
    apiServices.logOut(context);
  }

  @override
  void dispose() {}
}
