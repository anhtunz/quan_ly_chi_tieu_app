// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/model/event_model.dart';
import 'package:quan_ly_chi_tieu/product/services/toast_service.dart';

import '../../product/services/api_services.dart';

import '../../product/base/bloc/base_bloc.dart';
import '../home/model/label_model.dart';

class CalendarBloc extends BlocBase {
  APIServices apiServices = APIServices();
  ToastService toastService = ToastService();

  final events = StreamController<EventModel?>.broadcast();
  StreamSink<EventModel?> get sinkEvents => events.sink;
  Stream<EventModel?> get streamEvents => events.stream;

  final event = StreamController<Events>.broadcast();
  StreamSink<Events> get sinkEvent => event.sink;
  Stream<Events> get streamEvent => event.stream;

  final isLoading = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsLoading => isLoading.sink;
  Stream<bool> get streamIsLoading => isLoading.stream;

  final allLabels = StreamController<Map<String, List<LabelModel>>>.broadcast();
  StreamSink<Map<String, List<LabelModel>>> get sinkAllLabels => allLabels.sink;
  Stream<Map<String, List<LabelModel>>> get streamAllLabels => allLabels.stream;

  final selectedLabel = StreamController<int>.broadcast();
  StreamSink<int> get sinkSelectedLabel => selectedLabel.sink;
  Stream<int> get streamSelectedLabel => selectedLabel.stream;

  final noteImageUrl = StreamController<String>.broadcast();
  StreamSink<String> get sinkNoteImageUrl => noteImageUrl.sink;
  Stream<String> get streamNoteImageUrl => noteImageUrl.stream;

  @override
  void dispose() {}

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

  Future<EventModel> getAllNotes(
      BuildContext context, int month, int year) async {
    Map<String, dynamic> body = {
      "month": month,
      "year": year,
    };
    final response = await apiServices.getAllNotes(body);
    EventModel labels = EventModel();
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      labels = EventModel.fromJson(body['data']);
      sinkEvents.add(labels);
    } else {
      toastService.showErrorToast(
          context: context,
          title: "Thông báo",
          message: "Không thể tải ghi chú (${response.statusCode})");
    }
    return labels;
  }

  void updateNote(
      BuildContext context,
      int noteId,
      String description,
      int money,
      int labelID,
      String date,
      bool isIncome,
      List<EventImages> images) async {
    Map<String, dynamic> body = {
      "id": noteId,
      "isIncome": isIncome,
      "labelId": labelID,
      "money": money,
      "description": description,
      "dateUse": date,
      "images": images.isNotEmpty
          ? [
              {"id": images[0].id, "url": images[0].imageUrl}
            ]
          : []
    };
    final statusCode = await apiServices.createOrUpdateSpendingNote(body);
    if (statusCode == 200) {
      sinkEvents.add(EventModel());
      toastService.showSuccessToast(
        context: context,
        title: "Thông báo",
        message: "Sửa thông tin thành công",
      );
    } else {
      toastService.showErrorToast(
          context: context,
          title: "Thông báo",
          message: "Sửa thông tin thất bại: ($statusCode)");
    }
  }

  void deleteNote(BuildContext context, int noteID) async {
    final statusCode = await apiServices.deleteNote(noteID.toString());
    if (statusCode == 200) {
      sinkEvents.add(EventModel());
      toastService.showSuccessToast(
        context: context,
        title: "Thông báo",
        message: "Xóa thông tin thành công",
      );
    } else {
      toastService.showErrorToast(
          context: context,
          title: "Thông báo",
          message: "Xóa thông tin thất bại: ($statusCode)");
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
}
