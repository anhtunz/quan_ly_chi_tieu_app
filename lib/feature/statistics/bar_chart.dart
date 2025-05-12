import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_chi_tieu/product/extension/context_extension.dart';
import 'package:quan_ly_chi_tieu/product/utils/money_untils.dart';

import '../calendar/model/event_model.dart';

class BarChartComponent extends StatefulWidget {
  const BarChartComponent({super.key, required this.monthsData});
  final List<MonthInYearData> monthsData;
  @override
  State<BarChartComponent> createState() => _BarChartComponentState();
}

class _BarChartComponentState extends State<BarChartComponent> {
  bool hasAnyIncomeOrOutcome(List<MonthInYearData> dataList) {
    return dataList.any((item) =>
        (item.totalIncome ?? 0) != 0 || (item.totalOutcome ?? 0) != 0);
  }

  @override
  Widget build(BuildContext context) {
    bool hasAnyIncomeOrOutcome(List<MonthInYearData> dataList) {
      return dataList.any((item) =>
          (item.totalIncome ?? 0) != 0 || (item.totalOutcome ?? 0) != 0);
    }

    bool check = hasAnyIncomeOrOutcome(widget.monthsData);
    if (!check) {
      return SizedBox(
        height: 300,
        width: context.dynamicWidth(0.95),
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(
              border: const Border(
                left: BorderSide(),
                bottom: BorderSide(),
              ),
            ),
            barGroups: List.generate(
              12,
              (index) => BarChartGroupData(x: index + 1),
            ),
            gridData: FlGridData(
              drawVerticalLine: true,
              drawHorizontalLine: true,
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 300,
        width: context.dynamicWidth(0.95),
        child: BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: true, drawVerticalLine: false),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            groupsSpace: 4,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) {
                  // Lấy giá trị x = tháng
                  return Colors.grey[200]!;
                },
                // tooltipBgColor: Colors.grey.shade800,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  final isIncome = rodIndex == 1;
                  final label = isIncome
                      ? 'Thu nhập tháng ${group.x}'
                      : 'Chi tiêu tháng ${group.x}';
                  final value = rod.toY.toStringAsFixed(0);
                  return BarTooltipItem(
                    '$label: ${MoneyUntils.instance.formatMoney(
                      int.parse(value),
                    )}₫',
                    TextStyle(color: isIncome ? Colors.blue : Colors.red),
                  );
                },
              ),
            ),
            barGroups: widget.monthsData.asMap().entries.map((entry) {
              final month = entry.value;
              return BarChartGroupData(
                x: month.month!,
                barRods: [
                  BarChartRodData(
                    toY: month.totalOutcome!.toDouble(),
                    color: Colors.red,
                    width: 10,
                  ),
                  BarChartRodData(
                    toY: month.totalIncome!.toDouble(),
                    color: Colors.blue,
                    width: 10,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    }
  }
}
