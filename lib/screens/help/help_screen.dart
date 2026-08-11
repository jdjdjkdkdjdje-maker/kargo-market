import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Yordam sahifasi — ko'p so'raladigan savollar (o'zbek tilida).
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const _faqs = [
    (
      'Internet kerakmi?',
      'Yo\'q! Xarid — 100% oflayn ilova. Barcha ma\'lumotlar telefoningizning '
          'ichki xotirasida saqlanadi va internet butunlay o\'chirilgan holatda ham '
          'ilova to\'liq ishlaydi.'
    ),
    (
      'Buyurtma qanday yaratiladi?',
      'Mahsulotni savatchaga qo\'shing, "Buyurtma berish" tugmasini bosing, '
          'ism, telefon raqam va manzilni kiriting hamda buyurtmani tasdiqlang. '
          'Buyurtma telefoningizda saqlanadi.'
    ),
    (
      'To\'lov qanday amalga oshiriladi?',
      'To\'lov usuli sifatida "Naqd pul" yoki "Karta orqali"ni tanlashingiz mumkin. '
          'Bu demo ilova bo\'lgani uchun haqiqiy to\'lov amalga oshirilmaydi.'
    ),
    (
      'Ma\'lumotlarim qayerda saqlanadi?',
      'Barcha ma\'lumotlar (savatcha, buyurtmalar, sevimlilar, profil) Hive lokal '
          'bazasida, ya\'ni telefoningizning o\'zida saqlanadi. Hech narsa internetga '
          'yuborilmaydi.'
    ),
    (
      'Buyurtma holati qanday o\'zgaradi?',
      'Server bo\'lmagani uchun holatlar avtomatik o\'zgarmaydi. Buyurtma sahifasidagi '
          '"Demo: holatni yangilash" tugmasi orqali holatni qo\'lda ko\'chirishingiz mumkin.'
    ),
    (
      'Mahsulotlarni qanday boshqarish mumkin?',
      'Profil sahifasining pastki qismidagi versiya matnini (Xarid v1.0.0) uzoq '
          'bosib turing — yashirin "Mahsulotlarni boshqarish" bo\'limi ochiladi. '
          'U yerda mahsulot qo\'shish, tahrirlash va o\'chirish mumkin.'
    ),
    (
      'Xarid qilishda nima qilmaslik kerak?',
      'Ilova to\'liq oflayn bo\'lgani uchun internetdan foydalanish shart emas. '
          'Agar telefonda internet yoqilgan bo\'lsa ham, ilova hech qanday '
          'serverga murojaat qilmaydi.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Yordam')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.cloud_off_rounded, color: AppColors.primary, size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Internet kerak emas — ilova oflayn rejimda ishlamoqda',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ko\'p so\'raladigan savollar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF12241C) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                for (var i = 0; i < _faqs.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  _FaqTile(question: _faqs[i].$1, answer: _faqs[i].$2),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      shape: const Border(),
      collapsedShape: const Border(),
      title: Text(
        question,
        style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700),
      ),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          answer,
          style: TextStyle(
            fontSize: 13.5,
            height: 1.5,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : const Color(0xFF3D4F46),
          ),
        ),
      ],
    );
  }
}
