# Xarid — 100% oflayn marketplace ilovasi

**Xarid** — bu Android telefoningizning o'zida ishlaydigan, **server va internetsiz** zamonaviy marketplace ilovasi. Barcha ma'lumotlar telefoningizning ichki xotirasida saqlanadi — ilova internet butunlay o'chirilgan holatda ham to'liq ishlaydi.

> ⚡ Internet kerak emas — ilova oflayn rejimda ishlamoqda

---

## 📲 Imkoniyatlar

| Bo'lim | Tavsif |
|---|---|
| 🏠 **Bosh sahifa** | Logotip, qidiruv, kategoriyalar, aksiya bannerlari, mashhur/yangi/chegirmadagi/tavsiya mahsulotlar |
| 🔍 **Qidiruv** | Lokal bazada nom va kategoriya bo'yicha tezkor qidiruv (internet talab qilmaydi) |
| 🗂 **Kategoriyalar** | 15 ta kategoriya, 44 ta demo mahsulot |
| 🛒 **Savatcha** | Qo'shish, o'chirish, miqdorni o'zgartirish, chegirma va yetkazib berish hisobi |
| 📦 **Buyurtmalar** | Lokal buyurtmalar, holatlar: Qabul qilindi → Tayyorlanmoqda → Yetkazilmoqda → Yetkazib berildi / Bekor qilindi |
| 👤 **Profil** | Lokal profil, sevimlilar, sozlamalar, yordam |
| ❤️ **Sevimlilar** | Yurakcha tugmasi bilan saqlanadi |
| 🛠 **Yashirin boshqaruv** | Mahsulot qo'shish, tahrirlash, o'chirish, narx va chegirma o'zgartirish |

## 🗄 Ma'lumotlar saqlash

- **Hive** lokal bazasi — hamma narsa telefon xotirasida
- Savatcha, buyurtmalar, profil, sevimlilar, mahsulot o'zgarishlari va sozlamalar saqlanib qoladi
- Ilova yopilganda va telefon qayta ishga tushirilganda ham ma'lumotlar yo'qolmaydi

## 🛠 Texnologiyalar

- **Flutter** (Dart) — Android APK
- **Riverpod** — state management
- **Hive** — lokal ma'lumotlar bazasi
- Barcha rasmlar loyihaga **lokal asset** sifatida kiritilgan

## 🔧 O'rnatish va qurish

```bash
# 1. Flutter o'rnatilgan bo'lishi kerak
flutter --version

# 2. Dependency larni o'rnatish
flutter pub get

# 3. Debug APK qurish
flutter build apk --debug

# 4. Release APK qurish
flutter build apk --release
```

Tayyor APK fayllar:
- `build/app/outputs/flutter-apk/app-debug.apk`
- `build/app/outputs/flutter-apk/app-release.apk`

APK ni telefonga o'tkazib, `Xarid` ilovasini o'rnating — boshqa hech narsa kerak emas.

## 🗝 Maxfiy bo'lim (Mahsulotlarni boshqarish)

**Profil** sahifasining pastki qismidagi **"Xarid v1.0.0"** matnini **uzoq bosib** turing — yashirin **"Mahsulotlarni boshqarish"** bo'limi ochiladi. U yerda:

- yangi mahsulot qo'shish
- mahsulotni tahrirlash (nom, narx, eski narx, chegirma, kategoriya, rasm, reyting, ombor)
- mahsulotni o'chirish
- rasm tanlash (44 ta tayyor rasm ichidan)

mumkin. Barcha o'zgarishlar lokal bazaga yoziladi.

## 🔐 Xavfsizlik

- Hech qanday API kalitlari, server parollari yoki cloud credential'lar yo'q
- Release APKda INTERNET ruxsati ham yo'q — ilova hech qaerga murojaat qilmaydi
- Barcha ma'lumotlar faqat sizning telefoningizda

## 📁 Loyiha tuzilishi

```
lib/
├── core/          # mavzu, doimiylar, yordamchi funksiyalar
├── models/        # Product, CartItem, Order, ProfileData...
├── database/      # Hive lokal baza
├── services/      # demo ma'lumotlar, xabarlar
├── repositories/  # ma'lumotlar bilan ishlash qatlami
├── providers/     # Riverpod state management
├── routes/        # navigatsiya
├── screens/       # barcha sahifalar
├── widgets/       # qayta ishlatiladigan vidjetlar
└── main.dart
```

## 🧪 Testlar

```bash
flutter test
```

## ⚠️ Eslatma

Bu **demo ilova** — buyurtmalar haqiqiy yetkazib berishsiz, faqat telefon xotirasida yaratiladi. To'lov amalga oshirilmaydi. Holatlar buyurtma sahifasidagi "Demo: holatni yangilash" tugmasi orqali ko'chiriladi.
