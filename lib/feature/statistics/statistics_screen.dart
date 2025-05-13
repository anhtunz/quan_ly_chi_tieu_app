import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/statistics/bar_chart.dart';
import 'package:quan_ly_chi_tieu/feature/statistics/pie_chart.dart';
import 'package:quan_ly_chi_tieu/feature/statistics/statistics_bloc.dart';
import 'package:quan_ly_chi_tieu/product/base/bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/product/utils/money_untils.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../product/constants/icon/icon_constants.dart';
import '../../product/extension/context_extension.dart';
import '../../product/utils/datetime_utils.dart';
import '../calendar/model/event_model.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late StatisticsBloc statisticsBloc;
  DateTime forcusDate = DateTime.now();
  TextEditingController datePickerController = TextEditingController(
      text: DateTimeUtils.instance.formatDateToMonth(DateTime.now()));
  TextEditingController spentMoneyController =
      TextEditingController(text: '312321');
  TextEditingController incomeMoneyController =
      TextEditingController(text: '312321');
  TextEditingController totalMoneyController =
      TextEditingController(text: '312321');
  bool initialIsCalendarForMonth = true;
  bool isScreenLoading = false;
  bool isIncome = false;
  @override
  void initState() {
    super.initState();
    statisticsBloc = BlocProvider.of(context);
  }

  void handleClickButton(bool isPrevious, bool isInMonth) {
    String text = datePickerController.text;
    DateTime? getDate;
    if (initialIsCalendarForMonth) {
      getDate = DateTimeUtils.instance.parseDateFromFormattedMonth(text);
    } else {
      getDate = DateTimeUtils.instance.parseDateFromFormattedYear(text);
    }
    DateTime value = getDate;
    if (isPrevious) {
      if (isInMonth) {
        value = DateTimeUtils.instance.addMonths(getDate, -1);
      } else {
        value = DateTimeUtils.instance.addYears(getDate, -1);
      }
    } else {
      if (isInMonth) {
        value = DateTimeUtils.instance.addMonths(getDate, 1);
      } else {
        value = DateTimeUtils.instance.addYears(getDate, 1);
      }
    }
    statisticsBloc.getAllNotes(
        context, value.month, value.year, false, initialIsCalendarForMonth);
    datePickerController.value = TextEditingValue(
        text: initialIsCalendarForMonth
            ? DateTimeUtils.instance.formatDateToMonth(value)
            : "${value.year} (01/1-31/12)");
    clearData();
  }

  void clearData() {
    statisticsBloc.eventModal.add(null);
    spentMoneyController.clear();
    incomeMoneyController.clear();
    totalMoneyController.clear();
  }

  List<Widget> monthsDataInYear(List<MonthInYearData> datas) {
    List<MonthInYearData> lastData = [];
    for (var month in datas) {
      if ((month.totalIncome ?? 0) != 0 || (month.totalOutcome ?? 0) != 0) {
        lastData.add(month);
      }
    }

    return lastData.map((data) {
      int monthNumber = data.month ?? 0;
      int income = data.totalIncome ?? 0;
      int outcome = data.totalOutcome ?? 0;
      int net = income - outcome;

      return Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: ListTile(
          title: Row(
            children: [
              Text(
                'Tháng ${MoneyUntils.instance.formatMoney(monthNumber)} ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "(${MoneyUntils.instance.formatMoney(net)})",
                style: TextStyle(
                    color: net < 0 ? Colors.red : Colors.blue,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          subtitle: Row(
            children: [
              Text('Thu nhập: '),
              Text(
                MoneyUntils.instance.formatMoney(income),
                style: TextStyle(color: Colors.blue),
              ),
              Text(" - Chi tiêu: "),
              Text(
                MoneyUntils.instance.formatMoney(outcome),
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      );
    }).toList();
  }

  List<Widget> listData(Map<String, List<Events>> events) {
    List<Widget> lala = [];
    events.forEach((keyData, value) {
      lala.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: ListTile(
            onTap: () {
              // eventChanged(context, event, calendarBloc, toastService, events,
              //     _focusedDay);
            },
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  keyData,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "${MoneyUntils.instance.formatMoney(value.first.money!.toInt())}₫",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: value.first.isIncome! ? Colors.blue : Colors.black,
                  ),
                )
              ],
            ),
            leading: Image.asset(
              IconConstants.instance.getIcon(value.first.icon!),
              width: 25,
              height: 25,
              color: Color(
                int.parse(value.first.color!),
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ),
      );
    });
    return lala;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: statisticsBloc.streaIsCalendarForMonth,
      initialData: initialIsCalendarForMonth,
      builder: (context, isMonthSnaphot) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: ToggleSwitch(
              animate: true,
              animationDuration: 200,
              curve: Curves.bounceInOut,
              minWidth: 120.0,
              initialLabelIndex: isMonthSnaphot.data! ? 0 : 1,
              // cornerRadius: 20.0,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey[400],
              inactiveFgColor: Colors.white,
              totalSwitches: 2,
              labels: ['Hàng tháng', 'Hàng năm'],
              activeBgColors: [
                [Colors.green],
                [Colors.green]
              ],
              onToggle: (index) {
                if (index == 1) {
                  initialIsCalendarForMonth = false;
                  datePickerController.text = "${forcusDate.year} (01/1-31/12)";
                  statisticsBloc.getAllNotes(
                      context, forcusDate.month, forcusDate.year, false, false);
                } else {
                  initialIsCalendarForMonth = true;
                  datePickerController.text =
                      DateTimeUtils.instance.formatDateToMonth(forcusDate);
                  statisticsBloc.getAllNotes(
                      context, forcusDate.month, forcusDate.year, false, true);
                }
                statisticsBloc.sinkIsCalendarForMonth
                    .add(initialIsCalendarForMonth);
              },
            ),
          ),
          body: StreamBuilder<EventModel?>(
            stream: statisticsBloc.streamEventModal,
            builder: (context, eventModelSnapshot) {
              return StreamBuilder<YearlyDataModel?>(
                stream: statisticsBloc.streamYearEvents,
                builder: (context, yearEventSnapshot) {
                  return StreamBuilder<Map<String, List<Events>>>(
                    stream: statisticsBloc.streamEvents,
                    builder: (context, eventsSnapshot) {
                      if (eventModelSnapshot.data == null &&
                          eventsSnapshot.data == null &&
                          yearEventSnapshot.data == null) {
                        statisticsBloc.getAllNotes(context, forcusDate.month,
                            forcusDate.year, false, isMonthSnaphot.data!);
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        int outcomeMoney = 0;
                        int incomeMoney = 0;
                        int totalMoney = 0;
                        if (isMonthSnaphot.data == true) {
                          outcomeMoney =
                              eventModelSnapshot.data?.totalOutcome ?? 0;
                          incomeMoney =
                              eventModelSnapshot.data?.totalIncome ?? 0;
                          totalMoney = incomeMoney - outcomeMoney;
                        } else {
                          outcomeMoney =
                              yearEventSnapshot.data?.totalOutcome ?? 0;
                          incomeMoney =
                              yearEventSnapshot.data?.totalIncome ?? 0;
                          totalMoney = incomeMoney - outcomeMoney;
                        }
                        spentMoneyController.text =
                            "-${MoneyUntils.instance.formatMoney(outcomeMoney)}";
                        incomeMoneyController.text =
                            "+${MoneyUntils.instance.formatMoney(incomeMoney)}";
                        totalMoneyController.text =
                            MoneyUntils.instance.formatMoney(totalMoney);
                        return StreamBuilder<Object>(
                          stream: statisticsBloc.streamIsScreenLoading,
                          builder: (context, isScreenLoadingSnapshot) {
                            if (isScreenLoadingSnapshot.data == true) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Padding(
                                padding: context.paddingLow,
                                child: SafeArea(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              isMonthSnaphot.data!
                                                  ? "Tháng"
                                                  : " Năm",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: context.lowValue),
                                            SizedBox(
                                              width: context.dynamicWidth(0.8),
                                              child: TextField(
                                                controller:
                                                    datePickerController,
                                                readOnly: true,
                                                textAlign: TextAlign.center,
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 19),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  prefixIcon: IconButton(
                                                      onPressed: () {
                                                        handleClickButton(
                                                            true,
                                                            isMonthSnaphot
                                                                .data!);
                                                      },
                                                      icon: Icon(
                                                          Icons.chevron_left)),
                                                  suffixIcon: IconButton(
                                                    onPressed: () {
                                                      handleClickButton(false,
                                                          isMonthSnaphot.data!);
                                                    },
                                                    icon: Icon(
                                                        Icons.chevron_right),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: context.dynamicWidth(0.45),
                                              child: TextField(
                                                readOnly: true,
                                                controller:
                                                    spentMoneyController,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                  fontSize: 19,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                decoration: InputDecoration(
                                                  prefixStyle: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  prefixText: "Chi tiêu",
                                                  suffixText: "₫",
                                                  suffixStyle: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: context.dynamicWidth(0.45),
                                              child: TextField(
                                                readOnly: true,
                                                controller:
                                                    incomeMoneyController,
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                  fontSize: 19,
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                decoration: InputDecoration(
                                                  prefixStyle: TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  prefixText: "Thu nhập",
                                                  suffixText: "₫",
                                                  suffixStyle: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: context.lowValue),
                                        SizedBox(
                                          width: context.dynamicWidth(0.92),
                                          child: TextField(
                                            readOnly: true,
                                            controller: totalMoneyController,
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              fontSize: 19,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            decoration: InputDecoration(
                                              prefixStyle: TextStyle(
                                                fontSize: 14,
                                              ),
                                              prefixText: "Thu chi",
                                              suffixText: "₫",
                                              suffixStyle: TextStyle(
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: context.lowValue),
                                        if (isMonthSnaphot.data == true)
                                          StreamBuilder<bool>(
                                              stream:
                                                  statisticsBloc.streaIsIncome,
                                              initialData: isIncome,
                                              builder:
                                                  (context, isIncomeSnapshot) {
                                                return DefaultTabController(
                                                  initialIndex:
                                                      isIncomeSnapshot.data!
                                                          ? 1
                                                          : 0,
                                                  length: 2,
                                                  child: TabBar(
                                                    tabs: [
                                                      Tab(
                                                        text: "Chi tiêu",
                                                      ),
                                                      Tab(
                                                        text: "Thu nhập",
                                                      ),
                                                    ],
                                                    onTap: (index) {
                                                      if (index == 0) {
                                                        isIncome = false;
                                                        statisticsBloc
                                                            .getAllNotes(
                                                                context,
                                                                forcusDate
                                                                    .month,
                                                                forcusDate.year,
                                                                false,
                                                                isMonthSnaphot
                                                                    .data!);
                                                      } else if (index == 1) {
                                                        isIncome = true;
                                                        statisticsBloc
                                                            .getAllNotes(
                                                                context,
                                                                forcusDate
                                                                    .month,
                                                                forcusDate.year,
                                                                true,
                                                                isMonthSnaphot
                                                                    .data!);
                                                      }
                                                      statisticsBloc
                                                          .sinkIsIncome
                                                          .add(isIncome);
                                                    },
                                                  ),
                                                );
                                              }),
                                        SizedBox(
                                          height: context.mediumValue,
                                        ),
                                        StreamBuilder<bool>(
                                          stream: statisticsBloc
                                              .streamIsPieChartLoading,
                                          // initialData: false,
                                          builder: (context,
                                              isPieChartLoadingSnapshot) {
                                            if (isPieChartLoadingSnapshot
                                                    .data ==
                                                true) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return SizedBox(
                                                height: 250,
                                                child: isMonthSnaphot.data! ==
                                                        true
                                                    ? PieChartComponent(
                                                        events: eventsSnapshot
                                                            .data!)
                                                    : BarChartComponent(
                                                        monthsData:
                                                            yearEventSnapshot
                                                                .data!
                                                                .monthData!,
                                                      ),
                                              );
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: context.lowValue,
                                        ),
                                        Divider(),
                                        if (isMonthSnaphot.data == true)
                                          SizedBox(
                                            height: context.dynamicHeight(0.15),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: listData(
                                                    eventsSnapshot.data ?? {}),
                                              ),
                                            ),
                                          ),
                                        if (isMonthSnaphot.data == false)
                                          SizedBox(
                                            height: context.dynamicHeight(0.2),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: monthsDataInYear(
                                                    yearEventSnapshot
                                                            .data!.monthData ??
                                                        []),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
