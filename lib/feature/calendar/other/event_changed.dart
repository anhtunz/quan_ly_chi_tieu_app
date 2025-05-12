// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/calendar_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/model/event_model.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/other/event_images.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';
import 'package:quan_ly_chi_tieu/product/services/toast_service.dart';
import 'package:quan_ly_chi_tieu/product/utils/money_untils.dart';

import '../../../product/constants/icon/icon_constants.dart';
import '../../../product/utils/datetime_utils.dart';
import '../../home/model/label_model.dart';
import '../../home/screen/home_screen.dart';

eventChanged(BuildContext context, Events event, CalendarBloc calendarBloc,
    ToastService toastService, DateTime forcusDate) async {
  TextEditingController datePickerController = TextEditingController(
      text: DateTimeUtils.instance.formatDateToDayMonthYear(event.inDate!));
  TextEditingController noteController =
      TextEditingController(text: event.name);
  TextEditingController moneyController = TextEditingController(
      text: MoneyUntils.instance.formatMoney(event.money ?? 0));
  int selectedLabel = event.labelId!;
  String imageUrl = "";
  File? selectedFile;
  final picker = ImagePicker();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (modalBottomSheetContext) {
      return StreamBuilder<Events>(
        stream: calendarBloc.streamEvent,
        initialData: event,
        builder: (context, eventSnapshot) {
          return Padding(
            padding: modalBottomSheetContext.paddingLow,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Chỉnh sửa"),
                centerTitle: true,
              ),
              bottomNavigationBar: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      calendarBloc.deleteNote(context, event.id!);
                      Navigator.pop(modalBottomSheetContext);
                      calendarBloc.sinkEvents.add(null);
                    },
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minWidth: modalBottomSheetContext.dynamicWidth(0.3),
                    height: 60,
                    child: Text("Xóa",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18)),
                  ),
                  SizedBox(
                    width: context.lowValue,
                  ),
                  MaterialButton(
                    onPressed: () {
                      String date = convertToIso8601(datePickerController.text);
                      String note = noteController.text;
                      String money =
                          moneyController.text.replaceAll(RegExp(r'[,.]'), '');
                      log("Date: $date");
                      log("Event: $event");
                      calendarBloc.updateNote(
                          context,
                          event.id!,
                          note,
                          int.parse(money),
                          event.labelId!,
                          date,
                          event.isIncome!,
                          event.images ?? []);

                      Navigator.pop(modalBottomSheetContext);
                      calendarBloc.sinkEvents.add(null);
                    },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    minWidth: modalBottomSheetContext.dynamicWidth(0.6),
                    height: 60,
                    child: Text("Chỉnh sửa",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 18)),
                  )
                ],
              ),
              body: Column(
                children: [
                  Row(
                    children: [
                      Text("Ngày"),
                      SizedBox(width: context.lowValue),
                      SizedBox(
                        width: context.dynamicWidth(0.8),
                        child: TextField(
                          controller: datePickerController,
                          readOnly: true,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: IconButton(
                                onPressed: () {
                                  String text = datePickerController.text;
                                  DateTime getDate = DateTimeUtils.instance
                                      .convertFromStringToDateTime(text);
                                  DateTime value = getDate;
                                  value = getDate.subtract(Duration(days: 1));
                                  datePickerController.value = TextEditingValue(
                                      text: DateTimeUtils.instance
                                          .formatDateToDayMonthYear(value));
                                },
                                icon: Icon(Icons.chevron_left)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                String text = datePickerController.text;
                                DateTime getDate = DateTimeUtils.instance
                                    .convertFromStringToDateTime(text);

                                DateTime value = getDate;
                                value = getDate.add(Duration(days: 1));
                                datePickerController.value = TextEditingValue(
                                    text: DateTimeUtils.instance
                                        .formatDateToDayMonthYear(value));
                              },
                              icon: Icon(Icons.chevron_right),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text("Ghi chú"),
                      SizedBox(width: context.lowValue),
                      SizedBox(
                        width: context.dynamicWidth(0.8),
                        child: SizedBox(
                          width: context.dynamicWidth(0.5),
                          child: TextField(
                            controller: noteController,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nhập ghi chú"),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(event.isIncome == false ? "Tiền chi" : "Tiền thu"),
                      SizedBox(width: context.lowValue),
                      SizedBox(
                        width: context.dynamicWidth(0.8),
                        child: TextField(
                          inputFormatters: [
                            NumberFormatter(),
                          ],
                          keyboardType: TextInputType.number,
                          controller: moneyController,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              suffixIcon: eventSnapshot.data!.images!.isEmpty
                                  ? IconButton(
                                      onPressed: () async {
                                        final pickerFile =
                                            await picker.pickImage(
                                                source: ImageSource.gallery);
                                        if (pickerFile != null) {
                                          selectedFile = File(pickerFile.path);
                                          final data =
                                              await extractFile(selectedFile!);
                                          moneyController.text =
                                              formatMoney(data);
                                          imageUrl = await calendarBloc
                                              .uploadNoteImage(
                                                  modalBottomSheetContext,
                                                  File(pickerFile.path));
                                          event.images!.add(EventImages(
                                              id: 1, imageUrl: imageUrl));
                                          calendarBloc.sinkEvent.add(event);
                                        }
                                      },
                                      icon: Icon(Icons.upload_sharp))
                                  : IconButton(
                                      onPressed: () async {
                                        bool result = await eventImage(
                                            modalBottomSheetContext,
                                            event.images![0].imageUrl!);
                                        if (result) {
                                          event.images = [];
                                          calendarBloc.sinkEvent.add(event);
                                        }
                                        log("Result: $event");
                                      },
                                      icon: Icon(Icons.image_outlined),
                                    ),
                              border: InputBorder.none,
                              suffix: Text("₫"),
                              hintText: "0"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Danh mục",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            calendarBloc.getAllLabel(context);
                          },
                          icon: Icon(Icons.refresh))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  StreamBuilder<int>(
                    stream: calendarBloc.streamSelectedLabel,
                    initialData: selectedLabel,
                    builder: (context, selectedLabelSnapshot) {
                      return StreamBuilder<Map<String, List<LabelModel>>?>(
                        stream: calendarBloc.streamAllLabels,
                        builder: (context, allLabelsSnapshot) {
                          if (allLabelsSnapshot.data == null) {
                            calendarBloc.getAllLabel(context);
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return SizedBox(
                              height: context.dynamicHeight(0.35),
                              child: SingleChildScrollView(
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    ...(event.isIncome == false)
                                        ? allLabelsSnapshot.data!['expense']!
                                            .map(
                                            (label) {
                                              return GestureDetector(
                                                onTap: () {
                                                  selectedLabel = label.id!;
                                                  calendarBloc.sinkSelectedLabel
                                                      .add(selectedLabel);
                                                },
                                                child: appIcon(
                                                  modalBottomSheetContext,
                                                  label.name!,
                                                  label.iconName!,
                                                  label.color!,
                                                  isSelected:
                                                      selectedLabelSnapshot
                                                              .data ==
                                                          label.id,
                                                ),
                                              );
                                            },
                                          ).toList()
                                        : allLabelsSnapshot.data!['income']!
                                            .map(
                                            (label) {
                                              return GestureDetector(
                                                onTap: () {
                                                  selectedLabel = label.id!;
                                                  calendarBloc.sinkSelectedLabel
                                                      .add(selectedLabel);
                                                },
                                                child: appIcon(
                                                  modalBottomSheetContext,
                                                  label.name!,
                                                  label.iconName!,
                                                  label.color!,
                                                  isSelected:
                                                      selectedLabelSnapshot
                                                              .data ==
                                                          label.id,
                                                ),
                                              );
                                            },
                                          ).toList(),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget appIcon(BuildContext context, String text, String iconName, String color,
    {required bool isSelected}) {
  return Container(
    width: context.dynamicWidth(0.3),
    height: 100,
    decoration: BoxDecoration(
      border: Border.all(
        color: isSelected ? Colors.red : Colors.grey[400]!,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          IconConstants.instance.getIcon(iconName),
          width: 40,
          height: 40,
          color: Color(int.parse(color)),
        ),
        SizedBox(
          height: context.lowValue,
        ),
        Text(text),
      ],
    ),
  );
}
