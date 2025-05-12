import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/setting/setting_bloc.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';

import '../../product/constants/icon/icon_constants.dart';
import '../../product/shared/shared_input_file.dart';
import 'model/user_model.dart';

changeUserInfomation(BuildContext context, SettingBloc settingBloc) async {
  bool isChange = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  String genderSelected = "0";
  // settingBloc.getUserFromServer(context);
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (bottomSheetContext) {
      return StreamBuilder<bool>(
        stream: settingBloc.streamIsChanged,
        builder: (context, isChangeSnapshot) {
          return StreamBuilder<UserModel>(
              stream: settingBloc.streamUserInfomation,
              builder: (context, userSnapshot) {
                if (userSnapshot.data == null) {
                  settingBloc.getUserFromServer(
                      bottomSheetContext,
                      usernameController,
                      addressController,
                      birthdayController,
                      genderSelected);
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text("Đổi thông tin cá nhân"),
                      centerTitle: true,
                      actions: [
                        isChangeSnapshot.data ?? isChange
                            ? IconButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    String name = usernameController.text;
                                    String address = addressController.text;
                                    String dateOfBirth =
                                        birthdayController.text;
                                    settingBloc.updateUser(
                                        context,
                                        name,
                                        address,
                                        int.parse(genderSelected),
                                        dateOfBirth);
                                    Navigator.pop(bottomSheetContext);
                                  }
                                },
                                icon: IconConstants.instance
                                    .getMaterialIcon(Icons.check),
                              )
                            : const SizedBox.shrink()
                      ],
                    ),
                    body: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Padding(
                          padding: context.paddingLow,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tên người dùng",
                                style: bottomSheetContext.responsiveBodyMedium,
                              ),
                              Padding(
                                padding: context.paddingLowVertical,
                                child: TextFormField(
                                  controller: usernameController,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    isChange = true;
                                    settingBloc.sinkIsChanged.add(isChange);
                                  },
                                  validator: (usernameValue) {
                                    if (usernameValue == "null" ||
                                        usernameValue!.isEmpty) {
                                      return "Tên không được để trống";
                                    }
                                    return null;
                                  },
                                  decoration: borderRadiusTopLeftAndBottomRight(
                                      bottomSheetContext, "Nhập tên"),
                                ),
                              ),
                              Text(
                                "Địa chỉ",
                                style: bottomSheetContext.responsiveBodyMedium,
                              ),
                              Padding(
                                padding: context.paddingLowVertical,
                                child: TextFormField(
                                  controller: addressController,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    isChange = true;
                                    settingBloc.sinkIsChanged.add(isChange);
                                  },
                                  decoration: borderRadiusTopLeftAndBottomRight(
                                      bottomSheetContext, "Nhập địa chỉ"),
                                ),
                              ),
                              Text(
                                "Ngày sinh",
                                style: bottomSheetContext.responsiveBodyMedium,
                              ),
                              Padding(
                                padding: context.paddingLowVertical,
                                child: TextFormField(
                                  controller: birthdayController,
                                  keyboardType: TextInputType.datetime,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (value) {
                                    isChange = true;
                                    settingBloc.sinkIsChanged.add(isChange);
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Chọn ngày sinh",
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomRight: Radius.circular(12),
                                        ),
                                      ),
                                      suffixIcon:
                                          Icon(Icons.date_range_outlined)),
                                  onTap: () async {
                                    DateTime? date = DateTime(1900);
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    date = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2100));

                                    birthdayController.text =
                                        date?.toIso8601String() ?? "";
                                    isChange = true;
                                    settingBloc.sinkIsChanged.add(isChange);
                                  },
                                ),
                              ),
                              Text(
                                "Giới tính",
                                style: bottomSheetContext.responsiveBodyMedium,
                              ),
                              StreamBuilder<String>(
                                stream: settingBloc.streamIsGenderChanged,
                                builder: (context, genderSnapshot) {
                                  return Padding(
                                    padding: context.paddingLowVertical,
                                    child: DropdownMenu<String>(
                                      width: context.width,
                                      initialSelection:
                                          userSnapshot.data!.gender.toString(),
                                      dropdownMenuEntries: [
                                        DropdownMenuEntry(
                                            value: '1', label: "Nam"),
                                        DropdownMenuEntry(
                                            value: '2', label: "Nữ"),
                                      ],
                                      onSelected: (gender) {
                                        genderSelected = gender!;
                                        settingBloc.sinkIsGenderChanged
                                            .add(genderSelected);
                                        isChange = true;
                                        settingBloc.sinkIsChanged.add(isChange);
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: context.mediumValue),
                              isChangeSnapshot.data ?? isChange
                                  ? Center(
                                      child: TextButton(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            String name =
                                                usernameController.text;
                                            String address =
                                                addressController.text;
                                            String dateOfBirth =
                                                birthdayController.text;
                                            settingBloc.updateUser(
                                                context,
                                                name,
                                                address,
                                                int.parse(genderSelected),
                                                dateOfBirth);
                                            Navigator.pop(bottomSheetContext);
                                          }
                                        },
                                        style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.blue),
                                          foregroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.white),
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
                }
              },);
        },
      );
    },
  );
}
