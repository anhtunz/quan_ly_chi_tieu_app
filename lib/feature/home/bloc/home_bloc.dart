// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/home/model/label_model.dart';
import 'package:quan_ly_chi_tieu/product/services/api_services.dart';
import 'package:quan_ly_chi_tieu/product/services/toast_service.dart';

import '../../../product/base/bloc/base_bloc.dart';

class HomeBloc extends BlocBase {
  APIServices apiServices = APIServices();
  ToastService toastService = ToastService();
  final isMoneySpend = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsMoneySpend => isMoneySpend.sink;
  Stream<bool> get streamIsMoneySpend => isMoneySpend.stream;

  final allLabels = StreamController<Map<String, List<LabelModel>>?>.broadcast();
  StreamSink<Map<String, List<LabelModel>>?> get sinkAllLabels => allLabels.sink;
  Stream<Map<String, List<LabelModel>>?> get streamAllLabels => allLabels.stream;

  final labelsByCategory = StreamController<List<LabelModel>>.broadcast();
  StreamSink<List<LabelModel>> get sinkLabelsByCategory =>
      labelsByCategory.sink;
  Stream<List<LabelModel>> get streamLabelsByCategory =>
      labelsByCategory.stream;

  final selectedIconName = StreamController<String>.broadcast();
  StreamSink<String> get sinkSelectedIconName => selectedIconName.sink;
  Stream<String> get streamSelectedIconName => selectedIconName.stream;

  final selectedColorName = StreamController<String>.broadcast();
  StreamSink<String> get sinkSelectedColorName => selectedColorName.sink;
  Stream<String> get streamSelectedColorName => selectedColorName.stream;

  final noteImageUrl = StreamController<String>.broadcast();
  StreamSink<String> get sinkNoteImageUrl => noteImageUrl.sink;
  Stream<String> get streamNoteImageUrl => noteImageUrl.stream;

  final isDeleledDisplay = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsDeleledDisplay => isDeleledDisplay.sink;
  Stream<bool> get streamIsDeleledDisplay => isDeleledDisplay.stream;

  void getAllLabel(BuildContext context) async {
    final response = await apiServices.getAllLabels();
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<LabelModel> labels = LabelModel.fromJsonDynamicList(body['data']);
      Map<String, List<LabelModel>> categorizedLabels = {
        'income': [],
        'expense': [],
      };
      for (var label in labels) {
        if (label.isDeleted == false) {
          if (label.isIncome == true) {
            categorizedLabels['income']!.add(label);
          } else if (label.isIncome == false) {
            categorizedLabels['expense']!.add(label);
          }
        }
      }
      sinkAllLabels.add(categorizedLabels);
    } else {
      toastService.showWarningToast(
          context: context,
          title: "Thông báo",
          message: "Lấy nhãn lỗi (${response.statusCode})");
    }
  }

  void getLabelByCategory(BuildContext context, int state) async {
    final response = await apiServices.getAllLabels();
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      List<LabelModel> labels = LabelModel.fromJsonDynamicList(body['data']);
      List<LabelModel> selectedList = [];

      for (var label in labels) {
        if (label.isDeleted == false) {
          if (state == 0 && label.isIncome == false) {
            selectedList.add(label);
          } else if (state == 1 && label.isIncome == true) {
            selectedList.add(label);
          }
        }
      }

      sinkLabelsByCategory.add(selectedList);
    } else {
      toastService.showWarningToast(
        context: context,
        title: "Thông báo",
        message: "Lấy nhãn lỗi (${response.statusCode})",
      );
    }
  }

  void createOrUpdateLabel(BuildContext context, String id, String name,
      String icon, String color, bool isIncome) async {
    Map<String, dynamic> body = {};
    if (id == "") {
      body = {
        "name": name,
        "isIncome": isIncome,
        "icon": icon,
        "color": color,
      };
    } else {
      body = {
        "id": int.parse(id),
        "name": name,
        "isIncome": isIncome,
        "icon": icon,
        "color": color
      };
    }
    final statusCode = await apiServices.createOrUpdateLabel(body);
    if (statusCode == 200) {
      getLabelByCategory(context, isIncome ? 1 : 0);
      getAllLabel(context);
      toastService.showSuccessToast(
          context: context,
          title: "Thông báo",
          message:
              id == "" ? "Tạo mới nhãn thành công" : "Sửa nhãn thành công");
    } else {
      toastService.showErrorToast(
          context: context,
          title: "Thông báo",
          message: "Lỗi hệ thống ($statusCode)");
    }
  }

  void createNewNote(BuildContext context, String description, int money,
      int labelID, String date, String imageUrl, bool isIncome) async {
    List<Object> images = [];
    if (imageUrl != "") {
      images.add({'id': 0, 'url': imageUrl});
    }
    Map<String, dynamic> body = {
      "isIncome": isIncome,
      "labelId": labelID,
      "money": money,
      "description": description,
      "dateUse": date,
      "images": images
    };
    final statusCode = await apiServices.createOrUpdateSpendingNote(body);
    if (statusCode == 200) {
      getLabelByCategory(context, isIncome ? 1 : 0);
      getAllLabel(context);
      toastService.showSuccessToast(
        context: context,
        title: "Thông báo",
        message: "Thêm thông tin thành công",
      );
    } else {
      toastService.showErrorToast(
          context: context,
          title: "Thông báo",
          message: "Thêm thông tin thất bại: ($statusCode)");
    }
  }

  Future<String> uploadNoteImage(BuildContext context, File file) async {
    final response = await apiServices.uploadNoteImage(file);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return body['data'];
    } else {
      return "";
    }
  }

  @override
  void dispose() {}
}
