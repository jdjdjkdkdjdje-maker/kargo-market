/// Forma maydonlarini tekshirish (barcha xabarlar o'zbek tilida).
class Validators {
  Validators._();

  static String? requiredName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Ismingizni kiriting';
    if (v.length < 2) return 'Ism kamida 2 ta harfdan iborat bo\'lishi kerak';
    return null;
  }

  static String? requiredPhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Telefon raqamingizni kiriting';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return 'Telefon raqam noto\'g\'ri kiritildi';
    return null;
  }

  static String? requiredAddress(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Manzilni kiriting';
    if (v.length < 5) return 'Manzil to\'liq kiritilmadi';
    return null;
  }

  static String? requiredText(String? value, String message) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return message;
    return null;
  }

  static String? positiveNumber(String? value, String message) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return message;
    final n = int.tryParse(v);
    if (n == null) return 'Faqat son kiriting';
    if (n <= 0) return 'Qiymat 0 dan katta bo\'lishi kerak';
    return null;
  }

  static String? rating(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Reytingni kiriting';
    final n = double.tryParse(v.replaceAll(',', '.'));
    if (n == null) return 'Faqat son kiriting';
    if (n < 0 || n > 5) return 'Reyting 0–5 oralig\'ida bo\'lishi kerak';
    return null;
  }
}
