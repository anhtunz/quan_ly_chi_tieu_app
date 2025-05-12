import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._init();
  static DateTimeUtils? _instance;
  static DateTimeUtils get instance => _instance ??= DateTimeUtils._init();

  String formatDateTimeToString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd\'T\'00:00:00\'Z\'').format(dateTime);
  }

  String convertCurrentMillisToDateTimeString(int time) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch((time) * 1000);
    return DateFormat('HH:mm:ss dd-MM-yyyy').format(dateTime);
  }

  String formatDateToDayMonthYear(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy (EEEE)', 'vi');
    return formatter.format(date);
  }

  DateTime convertFromStringToDateTime(String formatDateToDayMonthYear) {
    String cleaned = formatDateToDayMonthYear.split(' ').first;
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.parse(cleaned);
  }

  String formatDateToMonth(DateTime date) {
    final month = date.month;
    final year = date.year;
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);

    return '$month/$year (${firstDay.day}/${firstDay.month}-${lastDay.day}/${lastDay.month})';
  }

  DateTime parseDateFromFormattedMonth(String formattedString) {
    final regex =
        RegExp(r'^(\d{1,2})/(\d{4}) \(\d{1,2}/\d{1,2}-\d{1,2}/\d{1,2}\)$');
    final match = regex.firstMatch(formattedString);

    if (match != null) {
      final month = int.parse(match.group(1)!);
      final year = int.parse(match.group(2)!);
      return DateTime(year, month, 1);
    } else {
      throw FormatException('Chuỗi không đúng định dạng: $formattedString');
    }
  }

  DateTime parseDateFromFormattedYear(String formattedString) {
    final regex = RegExp(r'^(\d{4}) \((\d{1,2})/(\d{1,2})-\d{1,2}/\d{1,2}\)$');
    final match = regex.firstMatch(formattedString);

    if (match != null) {
      final year = int.parse(match.group(1)!);
      final startDay = int.parse(match.group(2)!);
      final startMonth = int.parse(match.group(3)!);
      return DateTime(year, startMonth, startDay);
    } else {
      throw FormatException('Chuỗi không đúng định dạng: $formattedString');
    }
  }



  DateTime addYears(DateTime date, int years) {
    int newYear = date.year + years;
    int maxDaysInMonth = _daysInMonth(newYear, date.month);

    // Nếu ngày hiện tại là 29/2 và năm mới không phải năm nhuận, đặt ngày thành 28/2
    int newDay = date.day;
    if (date.month == 2 && date.day == 29 && !isLeapYear(newYear)) {
      newDay = 28;
    } else if (date.day > maxDaysInMonth) {
      newDay = maxDaysInMonth; // Đặt thành ngày cuối tháng nếu vượt quá
    }

    return DateTime(newYear, date.month, newDay);
  }

  DateTime addMonths(DateTime date, int months) {
    int newYear = date.year + (date.month + months - 1) ~/ 12;
    int newMonth = (date.month + months - 1) % 12 + 1;
    int maxDaysInNewMonth = _daysInMonth(newYear, newMonth);

    // Giữ ngày hiện tại nếu nhỏ hơn hoặc bằng số ngày tối đa của tháng mới,
    // nếu không, đặt thành ngày cuối tháng
    int newDay = date.day > maxDaysInNewMonth ? maxDaysInNewMonth : date.day;

    return DateTime(newYear, newMonth, newDay);
  }

// Hàm phụ để tính số ngày tối đa trong tháng, xử lý năm nhuận
  int _daysInMonth(int year, int month) {
    if (month == 2) {
      return isLeapYear(year) ? 29 : 28;
    }
    return [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31][month];
  }

// Kiểm tra năm nhuận
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
