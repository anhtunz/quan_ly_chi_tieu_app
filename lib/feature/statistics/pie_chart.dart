import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../product/utils/money_untils.dart';

import '../calendar/model/event_model.dart';

class PieChartComponent extends StatefulWidget {
  const PieChartComponent({super.key, required this.events});
  final Map<String, List<Events>> events;

  @override
  State<PieChartComponent> createState() => _PieChartComponentState();
}

class _PieChartComponentState extends State<PieChartComponent> {
  OverlayEntry? _overlayEntry;

  List<PieChartSectionData> getAllSection() {
    List<PieChartSectionData> sections = [];
    widget.events.forEach(
      (key, value) {
        sections.add(
          PieChartSectionData(
            titleStyle: TextStyle(
              fontSize: 11,
            ),
            title: key,
            value: value.length.toDouble(),
            radius: 120,
            borderSide: BorderSide(color: Colors.black),
          ),
        );
      },
    );
    return sections;
  }

  void _showTooltip(BuildContext context, int touchedIndex, Offset position) {
    if (touchedIndex < 0 || touchedIndex >= widget.events.length) {
      return;
    }

    _removeTooltip();

    String title = widget.events.keys.elementAt(touchedIndex);
    List<Events> events = widget.events[title]!;
    double totalMoney = events.fold(0, (sum, event) => sum + event.money!);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx - 100,
        top: position.dy - 60,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              // color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    // color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tổng tiền: ${MoneyUntils.instance.formatMoney(totalMoney.toInt())} ₫',
                  style: TextStyle(
                    // color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Thêm tooltip vào Overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle titleStyle = const TextStyle(
    //   color: Colors.white,
    //   fontSize: 20,
    //   fontWeight: FontWeight.bold,
    // );
    if (widget.events.isEmpty) {
      return SizedBox(
        height: 300,
        width: 300,
        child: PieChart(PieChartData(
          sections: [
            PieChartSectionData(
                title: "Chưa có dữ liệu", radius: 120, color: Colors.grey),
          ],
          centerSpaceRadius: 10,
          sectionsSpace: 2,
        )),
      );
    } else {
      final sections = getAllSection();
      return SizedBox(
        height: 300,
        width: 300,
        child: PieChart(
          PieChartData(
            sections: sections,
            centerSpaceRadius: 10,
            sectionsSpace: 2,
            pieTouchData: PieTouchData(
              enabled: true,
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  setState(() {});
                  _removeTooltip();
                  return;
                }

                // Khi nhấn vào section
                final newTouchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
                setState(() {});

                // Lấy vị trí nhấn
                final touchPosition = event.localPosition;
                if (touchPosition != null) {
                  // Chuyển đổi vị trí tương đối sang vị trí toàn cục
                  final renderBox = context.findRenderObject() as RenderBox;
                  final globalPosition = renderBox.localToGlobal(touchPosition);
                  _showTooltip(context, newTouchedIndex, globalPosition);
                }

                log("Index: $newTouchedIndex");
              },
            ),
          ),
        ),
      );
    }
  }
}
