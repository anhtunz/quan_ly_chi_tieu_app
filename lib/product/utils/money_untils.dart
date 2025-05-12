class MoneyUntils {
  MoneyUntils._init();
  static MoneyUntils? _instance;
  static MoneyUntils get instance => _instance ??= MoneyUntils._init();

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
}
