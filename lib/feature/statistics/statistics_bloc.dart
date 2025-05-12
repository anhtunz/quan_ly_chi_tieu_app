// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/product/base/bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/product/services/api_services.dart';
import 'package:quan_ly_chi_tieu/product/services/toast_service.dart';

import '../calendar/model/event_model.dart';

class StatisticsBloc extends BlocBase {
  APIServices apiServices = APIServices();
  ToastService toastService = ToastService();
  @override
  void dispose() {}

  final isCalendarForMonth = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsCalendarForMonth => isCalendarForMonth.sink;
  Stream<bool> get streaIsCalendarForMonth => isCalendarForMonth.stream;

  final isIncome = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsIncome => isIncome.sink;
  Stream<bool> get streaIsIncome => isIncome.stream;

  final eventModal = StreamController<EventModel?>.broadcast();
  StreamSink<EventModel?> get sinkEventModal => eventModal.sink;
  Stream<EventModel?> get streamEventModal => eventModal.stream;

  final yearEvents = StreamController<YearlyDataModel?>.broadcast();
  StreamSink<YearlyDataModel?> get sinkYearEvents => yearEvents.sink;
  Stream<YearlyDataModel?> get streamYearEvents => yearEvents.stream;

  final events = StreamController<Map<String, List<Events>>>.broadcast();
  StreamSink<Map<String, List<Events>>> get sinkEvents => events.sink;
  Stream<Map<String, List<Events>>> get streamEvents => events.stream;

  final isPieChartLoading = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsPieChartLoading => isPieChartLoading.sink;
  Stream<bool> get streamIsPieChartLoading => isPieChartLoading.stream;

  final isScreenLoading = StreamController<bool>.broadcast();
  StreamSink<bool> get sinkIsScreenLoading => isScreenLoading.sink;
  Stream<bool> get streamIsScreenLoading => isScreenLoading.stream;

  void getAllNotes(BuildContext context, int month, int year, bool isIncome,
      bool isCalendarForMonth) async {
    sinkIsScreenLoading.add(true);
    if (isCalendarForMonth == true) {
      sinkEvents.add({});
      sinkIsPieChartLoading.add(true);
      Map<String, dynamic> body = {
        "month": month,
        "year": year,
      };
      final response = await apiServices.getAllNotes(body);
      EventModel eventModel;
      List<Events> categoryEvents = [];
      if (response.statusCode == 200) {
        Map<String, List<Events>> allEvents = {};
        Map<String, dynamic> body = jsonDecode(response.body);
        eventModel = EventModel.fromJson(body['data']);
        sinkEventModal.add(eventModel);
        if (isIncome) {
          for (var event in eventModel.events!) {
            if (event.isIncome! == true) {
              categoryEvents.add(event);
            }
          }
        } else {
          for (var event in eventModel.events!) {
            if (event.isIncome! == false) {
              categoryEvents.add(event);
            }
          }
        }
        allEvents = groupDataByLabelId(categoryEvents);
        sinkEvents.add(allEvents);
      }
      sinkIsScreenLoading.add(false);
      sinkIsPieChartLoading.add(false);
    } else if (isCalendarForMonth == false) {
      final response = await apiServices.getAllNotesInYear(year);
      YearlyDataModel yearlyDataModel;
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        yearlyDataModel = YearlyDataModel.fromJson(body['data']);
        sinkYearEvents.add(yearlyDataModel);
      }
      sinkIsScreenLoading.add(false);
      sinkIsPieChartLoading.add(false);
    } else {
      toastService.showErrorToast(
          context: context,
          title: "Thông báo",
          message: "Không thể tải ghi chú");
    }
  }

  Map<String, List<Events>> groupDataByLabelId(List<Events> data) {
    // Bước 1: Nhóm dữ liệu theo labelId
    Map<int, List<Events>> groupedByLabelId = {};

    // Duyệt qua từng phần tử trong data
    for (var item in data) {
      int labelId = item.labelId!;

      // Nếu labelId chưa tồn tại trong groupedByLabelId, tạo danh sách mới
      if (!groupedByLabelId.containsKey(labelId)) {
        groupedByLabelId[labelId] = [];
      }

      // Thêm phần tử vào danh sách tương ứng với labelId
      groupedByLabelId[labelId]!.add(item);
    }

    // Bước 2: Tạo Map với key là labelName
    Map<String, List<Events>> result = {};

    // Duyệt qua groupedByLabelId để map với labelName
    groupedByLabelId.forEach((labelId, items) {
      // Lấy labelName từ phần tử đầu tiên trong danh sách (vì labelName giống nhau cho cùng labelId)
      String labelName = items.first.labelName!;
      result[labelName] = items;
    });

    return result;
  }
}
