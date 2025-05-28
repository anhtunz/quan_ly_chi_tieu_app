import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/setting/setting_bloc.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';

import '../../product/constants/icon/icon_constants.dart';
import '../../product/shared/shared_input_file.dart';

changePassword(BuildContext context, SettingBloc settingBloc) async {
  bool isChange = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isOldPasswordVisible = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String? password;
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (modalBoottomSheetContext) {
      return StreamBuilder<bool>(
        stream: settingBloc.streamIsChanged,
        initialData: isChange,
        builder: (context, isChangeSnapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Đổi mật khẩu"),
              centerTitle: true,
              actions: [
                isChangeSnapshot.data ?? isChange
                    ? IconButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            String oldPassword = oldPasswordController.text;
                            String newPassword = newPasswordController.text;
                            settingBloc.changePassword(modalBoottomSheetContext,
                                context, oldPassword, newPassword);
                            // Navigator.pop(modalBoottomSheetContext);
                          }
                        },
                        icon:
                            IconConstants.instance.getMaterialIcon(Icons.check),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: modalBoottomSheetContext.paddingLow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mật khẩu cũ",
                        style: modalBoottomSheetContext.responsiveBodyMedium,
                      ),
                      Padding(
                        padding: context.paddingLowVertical,
                        child: StreamBuilder<bool>(
                            stream: settingBloc.streamIsShowOldPassword,
                            initialData: isOldPasswordVisible,
                            builder: (context, isShowOldpasswordSnapshot) {
                              return TextFormField(
                                controller: oldPasswordController,
                                textInputAction: TextInputAction.next,
                                onChanged: (value) {
                                  isChange = true;
                                  settingBloc.sinkIsChanged.add(isChange);
                                },
                                obscureText: !isShowOldpasswordSnapshot.data!,
                                validator: (oldpassword) {
                                  if (oldpassword == "null" ||
                                      oldpassword!.isEmpty) {
                                    return "Mật khẩu không được để trống";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Nhập mật khẩu cũ",
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12)),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isShowOldpasswordSnapshot.data!
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      isOldPasswordVisible =
                                          !isOldPasswordVisible;
                                      settingBloc.sinkIsShowOldPassword
                                          .add(isOldPasswordVisible);
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                      Text(
                        "Mật khẩu mới",
                        style: modalBoottomSheetContext.responsiveBodyMedium,
                      ),
                      Padding(
                        padding: context.paddingLowVertical,
                        child: StreamBuilder<bool>(
                          stream: settingBloc.streamIsShowPassword,
                          initialData: isPasswordVisible,
                          builder: (context, isShowPasswordSnapshot) {
                            return TextFormField(
                              controller: newPasswordController,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                isChange = true;
                                settingBloc.sinkIsChanged.add(isChange);
                                password = value;
                              },
                              validator: (newPassword) {
                                if (newPassword == "null" ||
                                    newPassword!.isEmpty) {
                                  return "Mật khẩu mới không được để trống";
                                }
                                if (newPassword.length < 6) {
                                  return "Mật khẩu mới phải lớn hơn 6 kí tự";
                                }
                                return null;
                              },
                              obscureText: !isShowPasswordSnapshot.data!,
                              decoration: InputDecoration(
                                hintText: "Nhập mật khẩu mới",
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isShowPasswordSnapshot.data!
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    isPasswordVisible = !isPasswordVisible;
                                    settingBloc.sinkIsShowPassword
                                        .add(isPasswordVisible);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        "Xác nhận mật khẩu",
                        style: modalBoottomSheetContext.responsiveBodyMedium,
                      ),
                      Padding(
                        padding: context.paddingLowVertical,
                        child: StreamBuilder<bool>(
                          stream: settingBloc.streamIsConfirmPassword,
                          initialData: isConfirmPasswordVisible,
                          builder: (context, isConfirmPasswordSnapshot) {
                            return TextFormField(
                              controller: confirmPasswordController,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                isChange = true;
                                settingBloc.sinkIsChanged.add(isChange);
                              },
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Mật khẩu không được để trống";
                                }
                                if (text != password) {
                                  return "Mật khẩu không khớp";
                                }
                                return null;
                              },
                              obscureText: !isConfirmPasswordSnapshot.data!,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    isConfirmPasswordSnapshot.data!
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    isConfirmPasswordVisible =
                                        !isConfirmPasswordVisible;
                                    settingBloc.sinkIsConfirmPassword
                                        .add(isConfirmPasswordVisible);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: context.mediumValue),
                      isChangeSnapshot.data ?? isChange
                          ? Center(
                              child: TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    String oldPassword =
                                        oldPasswordController.text;
                                    String newPassword =
                                        newPasswordController.text;
                                    settingBloc.changePassword(
                                      modalBoottomSheetContext,
                                      context,
                                      oldPassword,
                                      newPassword,
                                    );
                                  }
                                },
                                style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.blue),
                                  foregroundColor:
                                      WidgetStatePropertyAll(Colors.white),
                                ),
                                child: Text("Cập nhật"),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
