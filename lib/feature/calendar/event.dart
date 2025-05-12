class Event {
  final String title;
  final String category;
  final double money;
  final DateTime date;
  Event(this.category, this.money, this.date, this.title);
  @override
  String toString() => title;
}

List<Event> exampleEvents = [
  // Event("Y tế", 100000, DateTime.parse('2025-04-13 22:59:03'), "Thuốc ho"),
  Event("Ăn uống", 50000, DateTime.parse('2025-04-01 12:30:00'), "Bữa trưa"),
  Event("Mua sắm", 200000, DateTime.parse('2025-04-02 15:00:00'), "Áo mới"),
  Event(
      "Giải trí", 150000, DateTime.parse('2025-04-03 19:00:00'), "Vé xem phim"),
  Event("Y tế", 300000, DateTime.parse('2025-04-04 09:00:00'), "Khám sức khỏe"),
  Event("Di chuyển", 20000, DateTime.parse('2025-04-05 07:30:00'), "Xe buýt"),
  Event("Ăn uống", 70000, DateTime.parse('2025-04-06 18:00:00'), "Bữa tối"),
  Event("Mua sắm", 500000, DateTime.parse('2025-04-07 14:00:00'),
      "Giày thể thao"),
  Event(
      "Giải trí", 80000, DateTime.parse('2025-04-08 20:00:00'), "Game online"),
  Event("Y tế", 120000, DateTime.parse('2025-04-09 10:00:00'), "Thuốc cảm"),
  Event("Di chuyển", 50000, DateTime.parse('2025-04-10 08:00:00'), "Grab"),
  Event("Ăn uống", 30000, DateTime.parse('2025-04-11 13:00:00'), "Cà phê"),
  Event("Mua sắm", 250000, DateTime.parse('2025-04-12 16:00:00'), "Quần jeans"),
  Event("Giải trí", 200000, DateTime.parse('2025-04-14 18:30:00'), "Concert"),
  Event("Y tế", 400000, DateTime.parse('2025-04-15 11:00:00'), "Nha sĩ"),
  Event("Di chuyển", 30000, DateTime.parse('2025-04-16 09:00:00'), "Tàu điện"),
  Event("Ăn uống", 60000, DateTime.parse('2025-04-16 19:00:00'), "Bữa tối BBQ"),
  Event("Ăn uống", 60000, DateTime.parse('2025-04-17 19:00:00'), "Bữa tối BBQ"),
  Event("Mua sắm", 100000, DateTime.parse('2025-04-18 15:00:00'), "Sách"),
  Event("Giải trí", 120000, DateTime.parse('2025-04-19 21:00:00'), "Bowling"),
  Event("Y tế", 150000, DateTime.parse('2025-04-20 08:00:00'), "Vitamin"),
  Event("Di chuyển", 40000, DateTime.parse('2025-04-21 07:00:00'), "Taxi"),
  Event("Ăn uống", 45000, DateTime.parse('2025-04-22 12:00:00'), "Bữa trưa"),
  Event("Mua sắm", 300000, DateTime.parse('2025-04-23 14:00:00'), "Tai nghe"),
  Event("Giải trí", 90000, DateTime.parse('2025-04-24 20:00:00'), "Karaoke"),
  Event("Y tế", 200000, DateTime.parse('2025-04-25 10:00:00'), "Kiểm tra mắt"),
  Event("Di chuyển", 25000, DateTime.parse('2025-04-26 08:30:00'), "Xe buýt"),
  Event("Ăn uống", 80000, DateTime.parse('2025-04-27 18:00:00'),
      "Bữa tối nhà hàng"),
  Event("Mua sắm", 150000, DateTime.parse('2025-04-28 13:00:00'), "Ba lô"),
  Event("Giải trí", 100000, DateTime.parse('2025-04-29 19:00:00'),
      "Công viên giải trí"),
  Event("Y tế", 250000, DateTime.parse('2025-04-30 09:00:00'), "Thuốc dị ứng"),
  Event("Y tế", 120000, DateTime.parse('2025-04-09 10:00:00'), "Thuốc cảm"),
  Event("Di chuyển", 50000, DateTime.parse('2025-04-10 08:00:00'), "Grab"),
  Event("Ăn uống", 30000, DateTime.parse('2025-04-11 13:00:00'), "Cà phê"),
  Event("Mua sắm", 250000, DateTime.parse('2025-04-12 16:00:00'), "Quần jeans"),
  Event("Giải trí", 200000, DateTime.parse('2025-04-14 18:30:00'), "Concert"),
  Event("Y tế", 400000, DateTime.parse('2025-04-15 11:00:00'), "Nha sĩ"),
  Event("Di chuyển", 30000, DateTime.parse('2025-04-16 09:00:00'), "Tàu điện"),
  Event("Ăn uống", 60000, DateTime.parse('2025-04-17 19:00:00'), "Bữa tối BBQ"),
  Event("Mua sắm", 100000, DateTime.parse('2025-04-18 15:00:00'), "Sách"),
  Event("Giải trí", 120000, DateTime.parse('2025-04-19 21:00:00'), "Bowling"),
  Event("Y tế", 150000, DateTime.parse('2025-04-20 08:00:00'), "Vitamin"),
  Event("Di chuyển", 40000, DateTime.parse('2025-04-21 07:00:00'), "Taxi"),
  Event("Ăn uống", 45000, DateTime.parse('2025-04-22 12:00:00'), "Bữa trưa"),
  Event("Mua sắm", 300000, DateTime.parse('2025-04-23 14:00:00'), "Tai nghe"),
  Event("Giải trí", 90000, DateTime.parse('2025-04-24 20:00:00'), "Karaoke"),
  Event("Y tế", 200000, DateTime.parse('2025-04-25 10:00:00'), "Kiểm tra mắt"),
  Event("Di chuyển", 25000, DateTime.parse('2025-04-26 08:30:00'), "Xe buýt"),
  Event("Ăn uống", 80000, DateTime.parse('2025-04-27 18:00:00'),
      "Bữa tối nhà hàng"),
  Event("Mua sắm", 150000, DateTime.parse('2025-04-28 13:00:00'), "Ba lô"),
  Event("Giải trí", 100000, DateTime.parse('2025-04-29 19:00:00'),
      "Công viên giải trí"),
  Event("Y tế", 250000, DateTime.parse('2025-04-30 09:00:00'), "Thuốc dị ứng"),
  Event("Y tế", 250000, DateTime.parse('2025-04-30 09:00:00'), "Thuốc dị ứng"),
  Event("Y tế", 250000, DateTime.parse('2025-04-30 09:00:00'), "Thuốc dị ứng"),
  Event("Y tế", 250000, DateTime.parse('2025-04-30 09:00:00'), "Thuốc dị ứng"),
];
