/// Pul, sana va foizlarni o'zbekcha formatlash uchun yordamchi funksiyalar.
class Formatters {
  Formatters._();

  /// 2499000 -> "2 499 000 so'm"
  static String money(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final remaining = s.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buf.write(' ');
    }
    return "$buf so'm";
  }

  /// 2499000 -> "2 499 000"
  static String plainNumber(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final remaining = s.length - i - 1;
      if (remaining > 0 && remaining % 3 == 0) buf.write(' ');
    }
    return buf.toString();
  }

  /// 20 -> "20%"
  static String percent(int value) => '$value%';

  /// Chegirma foizini hisoblash.
  static int discountPercent(int price, int oldPrice) {
    if (oldPrice <= price || oldPrice <= 0) return 0;
    return ((oldPrice - price) / oldPrice * 100).round();
  }

  /// Sana: "11-avgust, 2026"
  static String date(DateTime d) {
    const months = [
      'yanvar', 'fevral', 'mart', 'aprel', 'may', 'iyun',
      'iyul', 'avgust', 'sentabr', 'oktabr', 'noyabr', 'dekabr',
    ];
    return '${d.day}-${months[d.month - 1]}, ${d.year}';
  }

  /// Sana va vaqt: "11-avgust, 2026 14:30"
  static String dateTime(DateTime d) {
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${date(d)} $hh:$mm';
  }

  /// Qisqa sana: "11.08.2026"
  static String shortDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd.$mm.${d.year}';
  }
}
