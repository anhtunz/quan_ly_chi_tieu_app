import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_chi_tieu/feature/home/model/label_model.dart';
import 'package:quan_ly_chi_tieu/product/constants/enums/app_route_enums.dart';
import 'package:quan_ly_chi_tieu/product/constants/icon/icon_constants.dart';
import 'package:quan_ly_chi_tieu/product/shared/shared_toast_notification.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../product/extension/context_extension.dart';
import '../../../product/base/bloc/base_bloc.dart';
import '../../../product/services/api_services.dart';
import '../../../product/utils/datetime_utils.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeBloc homeBloc;
  bool isVN = true;
  bool isLight = true;
  APIServices apiServices = APIServices();
  TextEditingController datePickerController = TextEditingController(
      text: DateTimeUtils.instance.formatDateToDayMonthYear(DateTime.now()));
  TextEditingController noteController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  File? selectedFile;
  final picker = ImagePicker();
  // List<String> icons = [];
  // Map<String, List<LabelModel>> selectedLabel = {};
  bool isMoneySpent = true;
  LabelModel? selectedLabel;
  String imageUrl = "";
  @override
  void initState() {
    super.initState();
    homeBloc = BlocProvider.of(context);
    // homeBloc.getAllLabel(context);
  }

  // void initialCheck() async {
  //   String language = await apiServices.checkLanguage();
  //   String theme = await apiServices.checkTheme();
  //   if (language == LanguageConstants.VIETNAM) {
  //     isVN = true;
  //   } else {
  //     isVN = false;
  //   }
  //   if (theme == AppThemes.LIGHT.name) {
  //     isLight = true;
  //   } else if (theme == AppThemes.DARK.name) {
  //     isLight = false;
  //   } else {
  //     isLight = true;
  //   }
  //   mainBloc.sinkIsVNIcon.add(isVN);
  //   mainBloc.sinkThemeMode.add(isLight);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: ToggleSwitch(
          animate: true,
          animationDuration: 200,
          curve: Curves.bounceInOut,
          minWidth: 90.0,
          initialLabelIndex: 0,
          // cornerRadius: 20.0,
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey[400],
          inactiveFgColor: Colors.white,
          totalSwitches: 2,
          labels: ['Tiền chi', 'Tiền thu'],
          // icons: [Icons.add, Icons.play_arrow],
          activeBgColors: [
            [Colors.green],
            [Colors.green]
          ],
          onToggle: (index) {
            if (index == 1) {
              isMoneySpent = false;
            } else {
              isMoneySpent = true;
            }
            homeBloc.sinkIsMoneySpend.add(isMoneySpent);
          },
        ),
      ),
      body: StreamBuilder<bool>(
        initialData: isMoneySpent,
        stream: homeBloc.streamIsMoneySpend,
        builder: (context, isMoneySpendSnapshot) {
          return StreamBuilder<String>(
            stream: homeBloc.streamNoteImageUrl,
            initialData: imageUrl,
            builder: (context, imageUrlSnapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                      handleClickButton(true);
                                    },
                                    icon: Icon(Icons.chevron_left)),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    handleClickButton(false);
                                  },
                                  icon: Icon(Icons.chevron_right),
                                ),
                              ),
                            ),
                          )
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
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(isMoneySpendSnapshot.data == true
                              ? "Tiền chi"
                              : "Tiền thu"),
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
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      pickImage();
                                    },
                                    icon: Icon(Icons.upload_sharp),
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
                      if (imageUrlSnapshot.data != "")
                        TextButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              useSafeArea: true,
                              builder: (bottonSheetContext) {
                                return Scaffold(
                                  appBar: AppBar(
                                    leading: null,
                                    actions: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(bottonSheetContext);
                                        },
                                        icon: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  body: Image.file(
                                    selectedFile!,
                                    height: bottonSheetContext.height,
                                    width: bottonSheetContext.width,
                                  ),
                                );
                              },
                            );
                          },
                          child: Text("Xem ảnh"),
                        ),
                      Divider(),
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
                                homeBloc.getAllLabel(context);
                              },
                              icon: Icon(Icons.refresh))
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      StreamBuilder<Map<String, List<LabelModel>>?>(
                        stream: homeBloc.streamAllLabels,
                        builder: (context, allLabelsSnapshot) {
                          if (allLabelsSnapshot.data == null) {
                            homeBloc.getAllLabel(context);
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
                                    ...(isMoneySpendSnapshot.data == true)
                                        ? allLabelsSnapshot.data!['expense']!
                                            .map((label) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedLabel =
                                                      label; // Cập nhật appIcon được chọn
                                                });
                                              },
                                              child: appIcon(
                                                label.name!,
                                                label.iconName!,
                                                label.color!,
                                                isSelected: selectedLabel ==
                                                    label, // Kiểm tra xem có được chọn không
                                              ),
                                            );
                                          }).toList()
                                        : allLabelsSnapshot.data!['income']!
                                            .map((label) {
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedLabel =
                                                      label; // Cập nhật appIcon được chọn
                                                });
                                              },
                                              child: appIcon(
                                                label.name!,
                                                label.iconName!,
                                                label.color!,
                                                isSelected:
                                                    selectedLabel == label,
                                              ),
                                            );
                                          }).toList(),
                                    // Thêm nút chỉnh sửa vào cuối danh sách
                                    GestureDetector(
                                      onTap: () {
                                        context.pushNamed(
                                          AppRoutes.LABEL_MANAGER.name,
                                          extra: isMoneySpent ? 0 : 1,
                                        );

                                        Future.delayed(
                                          const Duration(seconds: 1),
                                          () =>
                                              homeBloc.sinkAllLabels.add(null),
                                        );
                                      },
                                      child: Container(
                                        width: context.dynamicWidth(0.3),
                                        height: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blueAccent),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Chỉnh sửa",
                                                  style: context
                                                      .responsiveBodySmallWithBold,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MaterialButton(
                        onPressed: () {
                          String date =
                              convertToIso8601(datePickerController.text);
                          String note = noteController.text;
                          String money = moneyController.text.replaceAll(
                              RegExp(r'[,.]'),
                              ''); // Loại bỏ dấu phẩy và dấu chấm
                          log("IsmoneySoent: $isMoneySpent");
                          log("LableId: ${selectedLabel?.name ?? "Chưa có"}");
                          log("ImageUrl: ${imageUrlSnapshot.data}");
                          if (date == "" ||
                              note == "" ||
                              money == "" ||
                              selectedLabel == null) {
                            toastService.showWarningToast(
                              context: context,
                              title: "Thông báo",
                              message: "Hãy nhập đủ các trường",
                            );
                          } else {
                            // Kiểm tra xem money có phải là số hợp lệ
                            int? parsedMoney = int.tryParse(money);
                            if (parsedMoney == null) {
                              toastService.showWarningToast(
                                context: context,
                                title: "Thông báo",
                                message: "Số tiền không hợp lệ",
                              );
                            } else {
                              homeBloc.createNewNote(
                                context,
                                note,
                                parsedMoney, // Sử dụng số đã parse
                                selectedLabel!.id!,
                                date,
                                imageUrlSnapshot.data!,
                                !isMoneySpent,
                              );
                              noteController.clear();
                              moneyController.clear();
                              homeBloc.sinkNoteImageUrl.add("");
                            }
                          }
                        },
                        minWidth: double.infinity,
                        height: 50,
                        color: context.theme.colorScheme.primaryContainer,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          isMoneySpendSnapshot.data == true
                              ? "Thêm khoản chi"
                              : "Thêm khoản thu",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
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
  }

  void handleClickButton(bool isPrevious) {
    String text = datePickerController.text;
    DateTime getDate = DateTimeUtils.instance.convertFromStringToDateTime(text);
    // print("Value: $getDate");
    DateTime value = getDate;
    if (isPrevious) {
      value = getDate.subtract(Duration(days: 1));
    } else {
      value = getDate.add(Duration(days: 1));
    }
    datePickerController.value = TextEditingValue(
        text: DateTimeUtils.instance.formatDateToDayMonthYear(value));
  }

  String convertToIso8601(String input) {
    // Định dạng chuỗi đầu vào: "25/04/2025 (Thứ Sáu)"
    final dateFormat = DateFormat("dd/MM/yyyy '('EEEE')'", 'vi_VN');

    try {
      // Phân tích chuỗi thành DateTime
      DateTime dateTime = dateFormat.parse(input);

      // Chuyển thành định dạng ISO 8601
      // Vì không có thông tin giờ, đặt mặc định là 00:00:00 UTC
      DateTime utcDateTime = DateTime.utc(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        0, // Giờ
        0, // Phút
        0, // Giây
      );

      // Trả về chuỗi ISO 8601
      return utcDateTime.toIso8601String();
    } catch (e) {
      return 'Lỗi: Không thể phân tích chuỗi ngày giờ';
    }
  }

  Widget appIcon(String text, String iconName, String color,
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

  void pickImage() async {
    final pickerFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickerFile != null) {
      // ignore: use_build_context_synchronously
      selectedFile = File(pickerFile.path);
      final data = await extractFile(selectedFile!);
      moneyController.text = formatMoney(data);
      imageUrl = await homeBloc.uploadNoteImage(context, File(pickerFile.path));
      homeBloc.sinkNoteImageUrl.add(imageUrl);
    }
  }

  Future<String> extractFile(File file) async {
    final textRecornized = TextRecognizer(script: TextRecognitionScript.latin);
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecornized.processImage(inputImage);
    setState(() {});
    String text = recognizedText.text;
    log("Text: $text");
    return extractAmountFromText(text) ?? "0";
  }

  String? extractAmountFromText(String text) {
    final regex = RegExp(r'(\d{1,3}(?:,\d{3})*)\s*VND');
    final match = regex.firstMatch(text);

    if (match != null) {
      String amountStr = match.group(1)!.replaceAll(',', '');
      return amountStr;
    }

    return null;
  }

  String formatMoney(String money) {
    int moneyParse = int.parse(money);
    String formattedMoney = moneyParse.abs().toString();

    // Không cần format nếu dưới 4 chữ số
    if (formattedMoney.length < 4) {
      return formattedMoney;
    }

    String result = '';
    for (int i = formattedMoney.length - 1, count = 0; i >= 0; i--) {
      result = formattedMoney[i] + result;
      count++;
      if (count % 3 == 0 && i > 0) {
        result = '.$result';
      }
    }

    return result;
  }
}

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Chỉ giữ các chữ số từ giá trị mới
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Định dạng số với dấu phẩy
    final formatter = NumberFormat.decimalPattern('vi_VN');
    String formatted = formatter.format(int.parse(newText));

    // Tính vị trí con trỏ mới
    int cursorOffset = newValue.selection.baseOffset +
        (formatted.length - newValue.text.length);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(
          offset: cursorOffset.clamp(0, formatted.length)),
    );
  }
}
