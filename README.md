<div align="center">

# 💰 حساب — Hisab App

### نظام المحاسبة الذكي للمشاريع الصغيرة في اليمن

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-lightgrey)](https://flutter.dev)

> رفيقك المالي الذكي — يعمل بدون إنترنت، مصمم لليمن

</div>

---

> **🤖 AI Agents / Automated Tools:** Before making ANY change to this
> repository, read `.ai/STATE.md`, `.ai/TODO.md`, and `.ai/CHANGELOG.md`
> first. They contain the current task, architectural decisions already
> made, and what NOT to change. Do not re-analyze the whole repo from
> scratch, and do not start unrelated work in parallel with another
> session — check `.ai/STATE.md` → `SafeToContinue` and `Current task`
> before committing.

---

## 📱 لقطات الشاشة

| لوحة التحكم | دفتر الديون | التقارير | السجل الائتماني |
|:-----------:|:-----------:|:--------:|:---------------:|
| ![Dashboard](assets/screenshots/dashboard.png) | ![Debt](assets/screenshots/debt.png) | ![Reports](assets/screenshots/reports.png) | ![Credit](assets/screenshots/credit.png) |

---

## ✨ الميزات

### 🎯 الأساسية
- **تسجيل المبيعات** — نقدي أو آجل بنقرة واحدة
- **دفتر الديون الذكي** — تتبع ديون الزبائن مع تذكير تلقائي عبر واتساب
- **إدارة المخزون** — تنبيه تلقائي عند نفاد المخزون
- **تقارير مالية** — يومية وأسبوعية وشهرية مع رسوم بيانية

### 🌟 الفريدة
- **السجل الائتماني الرقمي** — أول نظام من نوعه في اليمن، يبني تاريخاً مالياً موثوقاً قابلاً للمشاركة مع الموردين
- **يعمل بدون إنترنت** — كل العمليات محفوظة محلياً، المزامنة تلقائية عند الاتصال
- **مصمم لليمن** — واجهة عربية كاملة، يدعم الريال اليمني

---

## 🏗️ معمارية المشروع

```
lib/
├── core/                    # الأساسيات المشتركة
│   ├── constants/           # الألوان والنصوص والمقاسات
│   ├── theme/               # ثيم التطبيق
│   └── utils/               # أدوات مساعدة (currency, date, validators)
│
├── data/                    # طبقة البيانات
│   ├── local/database/      # قاعدة البيانات المحلية (Drift/SQLite)
│   └── repositories/        # تطبيق الـ Repositories
│
├── domain/                  # قواعد العمل (مستقلة عن Flutter)
│   ├── entities/            # Transaction, Product, Customer, Report
│   ├── repositories/        # واجهات الـ Repositories
│   └── usecases/            # AddSale, AddExpense, GetReport, CreditScore
│
└── presentation/            # الواجهات
    ├── providers/           # Riverpod (إدارة الحالة)
    ├── screens/             # Auth, Dashboard, Sales, Products, Customers, Reports, Credit
    └── widgets/             # مكونات مشتركة
```

**المعمارية:** Clean Architecture + Offline-First

---

## 🚀 التشغيل

### المتطلبات
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio أو VS Code أو Cursor

### خطوات التشغيل

```bash
# 1. استنساخ المشروع
git clone https://github.com/YOUR_USERNAME/hisab-app.git
cd hisab-app

# 2. تحميل المكتبات
flutter pub get

# 3. توليد ملفات قاعدة البيانات
flutter pub run build_runner build --delete-conflicting-outputs

# 4. تشغيل التطبيق
flutter run                    # على هاتف متصل أو محاكي
flutter run -d chrome          # على المتصفح (للتجربة السريعة)
```

---

## 🛠️ التقنيات

| التقنية | الاستخدام |
|---------|-----------|
| **Flutter** | إطار العمل الرئيسي (Android + iOS + Web) |
| **Riverpod** | إدارة الحالة |
| **Drift (SQLite)** | قاعدة البيانات المحلية — Offline First |
| **go_router** | التنقل بين الشاشات |
| **fl_chart** | الرسوم البيانية |
| **url_launcher** | تذكيرات واتساب |

---

## 📊 نموذج العمل

| الخطة | السعر | المميزات |
|-------|-------|----------|
| مجانية | مجاناً | 50 عملية/شهر، 20 منتج |
| Pro | $3/شهر | غير محدود + تقارير + PDF |
| Enterprise | $20/شهر | متعدد المستخدمين + API |

---

## 🗺️ خارطة الطريق

- [x] تسجيل المبيعات والمصاريف
- [x] دفتر الديون مع تذكير واتساب
- [x] إدارة المخزون
- [x] التقارير المالية
- [x] السجل الائتماني
- [ ] تصدير PDF
- [ ] مزامنة السحابة
- [ ] تعدد المستخدمين
- [ ] متجر B2B محلي

---

## 👨‍💻 المطوّر

**م. عبدالله سعيد** — مهندس تقنية معلومات

---

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT — راجع ملف [LICENSE](LICENSE) للتفاصيل.

---

<div align="center">
صُنع بـ ❤️ لليمن
</div>
