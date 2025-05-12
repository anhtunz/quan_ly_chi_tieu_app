import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/home/bloc/home_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/home/model/label_model.dart';
import 'package:quan_ly_chi_tieu/product/constants/icon/icon_constants.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';
import 'package:quan_ly_chi_tieu/product/services/toast_service.dart';

createOrUpdateLabel(BuildContext context, LabelModel label, HomeBloc homeBloc,
    int value) async {
  ToastService toastService = ToastService();
  TextEditingController labelNameController = TextEditingController();
  String? iconDefault;
  String? colorDefault;
  List<String> icons = [];
  for (int i = 1; i <= 50; i++) {
    String iconName = "icon_$i";
    icons.add(iconName);
  }

  if (label.id != null) {
    iconDefault = label.iconName!;
    colorDefault = label.color!;
    labelNameController.text = label.name!;
  } else {
    iconDefault = "icon_1";
    colorDefault = popularColors[0];
  }
  homeBloc.sinkSelectedColorName.add(colorDefault);
  homeBloc.sinkSelectedIconName.add(iconDefault);
  showModalBottomSheet(
    isScrollControlled: true,
    useSafeArea: true,
    context: context,
    builder: (modalBottomSheetContext) {
      return Scaffold(
        appBar: AppBar(
          title: Text(label.name == null ? "Tạo mới" : "Chỉnh sửa"),
          centerTitle: true,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MaterialButton(
            color: Colors.lightGreenAccent,
            onPressed: () {
              String name = labelNameController.text;
              bool isIncome = value == 0 ? false : true;
              if (name != "") {
                log("Icon: $iconDefault");
                log("color: $colorDefault");
                log("name: $name");
                if (label.id == null) {
                  homeBloc.createOrUpdateLabel(
                      context, "", name, iconDefault!, colorDefault!, isIncome);
                } else {
                  homeBloc.createOrUpdateLabel(context, label.id.toString(),
                      name, iconDefault!, colorDefault!, isIncome);
                }
                Navigator.pop(modalBottomSheetContext);
              } else {
                toastService.showWarningToast(
                    context: modalBottomSheetContext,
                    title: "Thông báo",
                    message: "Hãy nhập đầy đủ các trường");
              }
            },
            minWidth: double.infinity,
            child: Text(
              "Lưu",
              style: modalBottomSheetContext.responsiveBodyMediumWithBold,
            ),
          ),
        ),
        body: StreamBuilder<String>(
          stream: homeBloc.streamSelectedColorName,
          initialData: colorDefault,
          builder: (context, colorNameSnapshot) {
            return StreamBuilder<String>(
              stream: homeBloc.streamSelectedIconName,
              initialData: iconDefault,
              builder: (context, iconNameSnapshot) {
                return SafeArea(
                  child: Padding(
                    padding: modalBottomSheetContext.paddingLow,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Tên",
                              style: modalBottomSheetContext
                                  .responsiveBodyLargeWithBold,
                            ),
                            SizedBox(
                              width: modalBottomSheetContext.normalValue,
                            ),
                            Expanded(
                              child: TextField(
                                controller: labelNameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Vui lòng nhập tên đề mục",
                                  hintStyle: TextStyle(
                                    // fontWeight: FontWeight.w300,
                                    color: Colors.grey[350],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(height: modalBottomSheetContext.lowValue),
                        Row(
                          children: [
                            Text(
                              "Biểu tượng",
                              style: modalBottomSheetContext
                                  .responsiveBodyLargeWithBold,
                            ),
                          ],
                        ),
                        SizedBox(height: modalBottomSheetContext.lowValue),
                        SizedBox(
                          height: modalBottomSheetContext.dynamicHeight(0.3),
                          width: modalBottomSheetContext.width,
                          child: SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6,
                              runSpacing: 5,
                              children: icons.map((icon) {
                                // Kiểm tra xem icon có phải là icon được chọn không
                                bool isSelected = icon == iconNameSnapshot.data;
                                return GestureDetector(
                                  onTap: () {
                                    // Cập nhật icon được chọn vào Stream
                                    iconDefault = icon;
                                    homeBloc.sinkSelectedIconName.add(icon);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.black
                                            : const Color.fromARGB(
                                                255, 245, 238, 248),
                                        width: isSelected ? 2.0 : 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 50,
                                    width: modalBottomSheetContext
                                        .dynamicWidth(0.22),
                                    child: Center(
                                      child: Image.asset(
                                        IconConstants.instance.getIcon(icon),
                                        width: 30,
                                        height: 30,
                                        color: isSelected &&
                                                colorNameSnapshot.data != null
                                            ? Color(int.parse(
                                                colorNameSnapshot.data!))
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Divider(),
                        SizedBox(height: modalBottomSheetContext.lowValue),
                        Row(
                          children: [
                            Text(
                              "Màu sắc",
                              style: modalBottomSheetContext
                                  .responsiveBodyLargeWithBold,
                            ),
                          ],
                        ),
                        SizedBox(height: modalBottomSheetContext.lowValue),
                        SizedBox(
                          height: modalBottomSheetContext.dynamicHeight(0.3),
                          width: modalBottomSheetContext.width,
                          child: SingleChildScrollView(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 6,
                              runSpacing: 5,
                              children: [
                                ...popularColors.map((color) {
                                  bool isSelected =
                                      color == colorNameSnapshot.data;
                                  return GestureDetector(
                                    onTap: () {
                                      colorDefault = color;
                                      homeBloc.sinkSelectedColorName.add(color);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(color)),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.transparent,
                                          width: isSelected ? 2.0 : 1.0,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      height: 50,
                                      width: modalBottomSheetContext
                                          .dynamicWidth(0.22),
                                    ),
                                  );
                                }),
                                GestureDetector(
                                  onTap: () {
                                    // Xử lý chọn màu từ color picker (nếu có)
                                    // Ví dụ: homeBloc.sinkSelectedColorName.add("0xFF123456");
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Colors.blue,
                                          Colors.purple,
                                          Colors.yellow,
                                          Colors.red,
                                          Colors.green,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      height: 50,
                                      width: modalBottomSheetContext
                                          .dynamicWidth(0.22),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          IconConstants.instance
                                              .getIcon("color_picker"),
                                          width: 30,
                                          height: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    },
  );
}

final List<String> popularColors = [
  "0xFF000000", // Black
  "0xFF333333", // Dark Gray
  "0xFF4CAF50", // White
  "0xFFE040FB", // Light Gray
  "0xFFBDBDBD", // Gray
  "0xFF2196F3", // Blue
  "0xFF97CEEA", // Light Blue
  "0xFF1E3A8A", // Navy
  "0xFF87CEEB", // Sky Blue
  "0xFF00BCD4", // Cyan
  "0xFF009688", // Teal
  "0xFF7CB342", // Green
  "0xFFC8E6C9", // Light Green
  "0xFF2ECC71", // Emerald
  "0xFFCDDC39", // Lime
  "0xFFFFEB3B", // Yellow
  "0xFFFFC107", // Amber
  "0xFFFF9800", // Orange
  "0xFFFF5722", // Deep Orange
  "0xFFF44336", // Red
  "0xFFE91E63", // Pink
  "0xFFF8BBD0", // Light Pink
  "0xFF9C27B0", // Purple
  "0xFF673AB7", // Deep Purple
  "0xFF3F51B5", // Indigo
  "0xFF795548", // Brown
  "0xFFF5F5DC", // Beige
  "0xFFAAF0D1", // Mint
  "0xFFFF7F50", // Coral
  "0xFFFFD700", // Gold
  "0xff443a49"
];
