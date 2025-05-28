import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/calendar_bloc.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/model/event_model.dart';
import 'package:quan_ly_chi_tieu/feature/calendar/other/event_changed.dart';
import 'package:quan_ly_chi_tieu/product/base/bloc/base_bloc.dart';
import 'package:quan_ly_chi_tieu/product/constants/icon/icon_constants.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';
import 'package:quan_ly_chi_tieu/product/shared/shared_toast_notification.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late CalendarBloc calendarBloc;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? selectedDay;
  final ScrollController _scrollController = ScrollController();
  final Map<DateTime, GlobalKey> _dayKeys = {};
  DateTime _focusedDay = DateTime.now();
  bool _isLoading = false;
  EventModel event = EventModel();

  void getAllNote() async {
    try {
      _isLoading = true;
      calendarBloc.sinkIsLoading.add(_isLoading);
      event = await calendarBloc.getAllNotes(
          context, _focusedDay.month, _focusedDay.year);
      calendarBloc.sinkEvents.add(event);
      _isLoading = false;
      calendarBloc.sinkIsLoading.add(_isLoading);
    } catch (e) {
      _isLoading = false;
      calendarBloc.sinkIsLoading.add(_isLoading);
      // print('Lỗi khi tải sự kiện: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải dữ liệu sự kiện')),
      );
    }
  }

  Map<DateTime, List<Events>> _selectedEvents(EventModel? eventModel) {
    Map<DateTime, List<Events>> eventsMap = {};
    if (eventModel == null || eventModel.events == null) {
      return {};
    }
    for (var event in eventModel.events!) {
      DateTime day =
          DateTime(event.inDate!.year, event.inDate!.month, event.inDate!.day);
      if (eventsMap[day] == null) {
        eventsMap[day] = [];
      }
      eventsMap[day]!.add(event);
    }
    return eventsMap;
  }

  List<Events> _getEventFromDay(DateTime day, EventModel? eventModel) {
    return _selectedEvents(
            eventModel)[DateTime(day.year, day.month, day.day)] ??
        [];
  }

  void _scrollToDay(DateTime day) {
    final key = _dayKeys[DateTime(day.year, day.month, day.day)];
    if (key != null && key.currentContext != null) {
      final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero).dy;
      final scrollPosition = _scrollController.offset + position - 550;
      _scrollController.animateTo(
        scrollPosition,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  String getMonthlyTotal(EventModel? eventModel) {
    double total = 0;
    final eventsInMonth = _selectedEvents(eventModel)
        .entries
        .where((entry) =>
            entry.key.year == _focusedDay.year &&
            entry.key.month == _focusedDay.month)
        .expand((entry) => entry.value)
        .toList();
    for (var event in eventsInMonth) {
      total += event.money!;
    }
    return getMoneyOnDay(eventsInMonth);
  }

  int getMonthlyIncomeTotal(EventModel? eventModel) {
    int incomeTotal = 0;
    final eventsInMonth = _selectedEvents(eventModel)
        .entries
        .where((entry) =>
            entry.key.year == _focusedDay.year &&
            entry.key.month == _focusedDay.month)
        .expand((entry) => entry.value)
        .toList();
    for (var event in eventsInMonth) {
      if (event.isIncome!) {
        incomeTotal += event.money!;
      }
    }
    return incomeTotal;
  }

  int getMonthlySpentTotal(EventModel? eventModel) {
    int spentTotal = 0;
    final eventsInMonth = _selectedEvents(eventModel)
        .entries
        .where((entry) =>
            entry.key.year == _focusedDay.year &&
            entry.key.month == _focusedDay.month)
        .expand((entry) => entry.value)
        .toList();
    for (var event in eventsInMonth) {
      if (!event.isIncome!) {
        spentTotal += event.money!;
      }
    }
    return spentTotal;
  }

  String getMoneyOnDay(List<Events> events) {
    double money = 0;
    for (var event in events) {
      if (event.isIncome!) {
        money -= event.money!;
      } else {
        money += event.money!;
      }
    }

    if (money >= 1000000) {
      double million = money / 1000000;
      String formattedMillion = million
          .toStringAsFixed(million.truncateToDouble() == million ? 0 : 1);
      List<String> parts = formattedMillion.split('.');
      String integerPart = parts[0];
      String? decimalPart = parts.length > 1 ? '.${parts[1]}' : '';
      String formattedInteger = '';
      for (int i = integerPart.length - 1, count = 0; i >= 0; i--) {
        formattedInteger = integerPart[i] + formattedInteger;
        count++;
        if (count % 3 == 0 && i > 0) {
          formattedInteger = ',$formattedInteger';
        }
      }
      return '$formattedInteger$decimalPart Triệu';
    } else {
      String formattedMoney = money.toInt().toString();
      String result = '';
      for (int i = formattedMoney.length - 1, count = 0; i >= 0; i--) {
        result = formattedMoney[i] + result;
        count++;
        if (count % 3 == 0 && i > 0) {
          result = ',$result';
        }
      }
      return result;
    }
  }

  String getMoneyIncomeOnDay(List<Events> events) {
    int incomeMoney = 0;
    for (var event in events) {
      if (event.isIncome!) {
        incomeMoney += event.money!;
      }
    }
    return formatMoney(incomeMoney);
  }

  String getMoneySpentOnDay(List<Events> events) {
    int spentMoney = 0;
    for (var event in events) {
      if (!event.isIncome!) {
        spentMoney += event.money!;
      }
    }
    return formatMoney(spentMoney);
  }

  String getMoneyOnDayNotFormat(List<Events> events) {
    int money = 0;
    for (var event in events) {
      if (event.isIncome!) {
        money += event.money!;
      } else {
        money -= event.money!;
      }
    }
    return formatMoney(money);
  }

  String formatMoney(int money) {
    bool isNegative = money < 0;
    String formattedMoney = money.abs().toString();
    String result = '';

    for (int i = formattedMoney.length - 1, count = 0; i >= 0; i--) {
      result = formattedMoney[i] + result;
      count++;
      if (count % 3 == 0 && i > 0) {
        result = ',$result';
      }
    }

    return isNegative ? '-$result' : result;
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  @override
  void initState() {
    super.initState();
    calendarBloc = BlocProvider.of(context);
    getAllNote();
    // Future.delayed(Duration(seconds: 10), () => {getAllNote()});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: StreamBuilder<bool>(
          stream: calendarBloc.streamIsLoading,
          initialData: _isLoading,
          builder: (context, isLoadingSnapshot) {
            return StreamBuilder<EventModel?>(
              stream: calendarBloc.streamEvents,
              initialData: event,
              builder: (context, eventsSnapshot) {
                if (isLoadingSnapshot.data == true ||
                    eventsSnapshot.data == null) {
                  getAllNote();
                  return Center(child: CircularProgressIndicator());
                } else {
                  return SafeArea(
                    child: Column(
                      children: [
                        TableCalendar<Events>(
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, date, _) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 5.0,
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            outsideBuilder: (context, date, _) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 5.0,
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w200),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            todayBuilder: (context, date, _) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Colors.green[200],
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 5.0,
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            selectedBuilder: (context, date, _) {
                              return Container(
                                margin: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue[200],
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 5.0,
                                      child: Text(
                                        '${date.day}',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            markerBuilder: (context, date, events) {
                              if (events.isNotEmpty) {
                                return Positioned(
                                  left: 5.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: Column(
                                      children: [
                                        getMoneyIncomeOnDay(events) != "0"
                                            ? Text(
                                                truncateText(
                                                    getMoneyIncomeOnDay(events),
                                                    9),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.blue),
                                              )
                                            : SizedBox.shrink(),
                                        Text(
                                          truncateText(
                                              getMoneySpentOnDay(events), 9),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.redAccent),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return null;
                            },
                          ),
                          locale: "vi_VN",
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          calendarFormat: _calendarFormat,
                          eventLoader: (day) =>
                              _getEventFromDay(day, eventsSnapshot.data),
                          headerVisible: true,
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            titleTextStyle: TextStyle(fontSize: 25),
                          ),
                          calendarStyle: CalendarStyle(
                            outsideDecoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            weekendDecoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            todayDecoration: BoxDecoration(
                              color: Colors.purpleAccent,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            defaultDecoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          daysOfWeekVisible: true,
                          pageJumpingEnabled: true,
                          sixWeekMonthsEnforced: false,
                          weekNumbersVisible: false,
                          rowHeight: 60,
                          daysOfWeekHeight: 20,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          dayHitTestBehavior: HitTestBehavior.opaque,
                          availableGestures: AvailableGestures.all,
                          availableCalendarFormats: {
                            CalendarFormat.month: "Month"
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(selectedDay, day);
                          },
                          onDaySelected: (DateTime selected, DateTime focused) {
                            setState(() {
                              selectedDay = selected;
                              _focusedDay = focused;
                              _scrollToDay(selected);
                            });
                          },
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                            getAllNote();
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          color: Colors.green[200],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text("Thu nhập"),
                                  Text(
                                    "${formatMoney(getMonthlyIncomeTotal(eventsSnapshot.data))} ₫",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Chi tiêu"),
                                  Text(
                                    "${formatMoney(getMonthlySpentTotal(eventsSnapshot.data))} ₫",
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Tổng"),
                                  Text(
                                    "${formatMoney(getMonthlyIncomeTotal(eventsSnapshot.data) - getMonthlySpentTotal(eventsSnapshot.data))}₫",
                                    style: TextStyle(
                                      color: getMonthlyIncomeTotal(
                                                  eventsSnapshot.data) >
                                              getMonthlySpentTotal(
                                                  eventsSnapshot.data)
                                          ? Colors.blue
                                          : Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: context.lowValue),
                        Expanded(
                          child: ListView(
                            controller: _scrollController,
                            children: [
                              ..._selectedEvents(eventsSnapshot.data)
                                  .entries
                                  .where((entry) =>
                                      entry.key.year == _focusedDay.year &&
                                      entry.key.month == _focusedDay.month)
                                  .map(
                                (entry) {
                                  final key = GlobalKey();
                                  _dayKeys[entry.key] = key;
                                  return Column(
                                    key: key,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryFixed,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${entry.key.day}/${entry.key.month}/${entry.key.year} ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${getMoneyOnDayNotFormat(entry.value)}₫',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ),
                                      ...entry.value.map(
                                        (event) => ListTile(
                                          onTap: () {
                                            eventChanged(
                                                context,
                                                event,
                                                calendarBloc,
                                                toastService,
                                                _focusedDay);
                                          },
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${event.labelName!} (${event.name})",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                "${formatMoney(event.money!.toInt())}₫",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: event.isIncome!
                                                      ? Colors.blue
                                                      : Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                          leading: Image.asset(
                                            IconConstants.instance
                                                .getIcon(event.icon!),
                                            width: 25,
                                            height: 25,
                                            color: Color(
                                              int.parse(event.color!),
                                            ),
                                          ),
                                          trailing:
                                              Icon(Icons.arrow_forward_ios),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          }),
    );
  }
}
