# هيكل مشروع تطبيق حساب — Flutter

## البنية الكاملة للمجلدات

```
hisab/
├── lib/
│   ├── main.dart                     # نقطة الدخول الرئيسية
│   │
│   ├── core/                         # الأساسيات المشتركة
│   │   ├── constants/
│   │   │   ├── app_colors.dart       # الألوان
│   │   │   ├── app_strings.dart      # النصوص العربية
│   │   │   └── app_sizes.dart        # المقاسات والهوامش
│   │   ├── theme/
│   │   │   └── app_theme.dart        # ثيم التطبيق الكامل
│   │   ├── utils/
│   │   │   ├── currency_formatter.dart  # تنسيق الريال اليمني
│   │   │   ├── date_formatter.dart      # تنسيق التواريخ
│   │   │   └── validators.dart          # التحقق من المدخلات
│   │   └── errors/
│   │       └── failures.dart         # أنواع الأخطاء
│   │
│   ├── data/                         # طبقة البيانات
│   │   ├── local/
│   │   │   ├── database/
│   │   │   │   └── app_database.dart    # إعداد SQLite (drift)
│   │   │   └── daos/
│   │   │       ├── transaction_dao.dart # عمليات المعاملات
│   │   │       ├── product_dao.dart     # عمليات المنتجات
│   │   │       ├── customer_dao.dart    # عمليات الزبائن
│   │   │       └── report_dao.dart      # عمليات التقارير
│   │   ├── remote/
│   │   │   ├── api_client.dart          # الاتصال بالسيرفر
│   │   │   └── sync_service.dart        # خدمة المزامنة
│   │   └── models/
│   │       ├── transaction_model.dart
│   │       ├── product_model.dart
│   │       ├── customer_model.dart
│   │       └── report_model.dart
│   │
│   ├── domain/                       # قواعد العمل
│   │   ├── entities/
│   │   │   ├── transaction.dart
│   │   │   ├── product.dart
│   │   │   ├── customer.dart
│   │   │   └── report.dart
│   │   ├── repositories/
│   │   │   ├── transaction_repository.dart
│   │   │   ├── product_repository.dart
│   │   │   └── customer_repository.dart
│   │   └── usecases/
│   │       ├── add_sale.dart
│   │       ├── add_expense.dart
│   │       ├── get_daily_report.dart
│   │       └── calculate_credit_score.dart
│   │
│   ├── presentation/                 # الواجهات
│   │   ├── screens/
│   │   │   ├── auth/
│   │   │   │   ├── splash_screen.dart
│   │   │   │   ├── login_screen.dart      # دخول برقم الهاتف
│   │   │   │   └── otp_screen.dart        # رمز التحقق
│   │   │   ├── dashboard/
│   │   │   │   └── dashboard_screen.dart  # لوحة التحكم
│   │   │   ├── transactions/
│   │   │   │   ├── add_sale_screen.dart   # إضافة بيع
│   │   │   │   ├── add_expense_screen.dart # إضافة مصروف
│   │   │   │   └── transactions_list_screen.dart
│   │   │   ├── products/
│   │   │   │   ├── products_screen.dart
│   │   │   │   └── add_product_screen.dart
│   │   │   ├── customers/
│   │   │   │   ├── customers_screen.dart  # دفتر الديون
│   │   │   │   └── customer_detail_screen.dart
│   │   │   ├── reports/
│   │   │   │   └── reports_screen.dart    # التقارير
│   │   │   └── credit/
│   │   │       └── credit_screen.dart     # السجل الائتماني
│   │   ├── widgets/
│   │   │   ├── common/
│   │   │   │   ├── app_button.dart        # زر موحد
│   │   │   │   ├── app_text_field.dart    # حقل نص موحد
│   │   │   │   ├── loading_widget.dart
│   │   │   │   └── empty_state_widget.dart
│   │   │   ├── dashboard/
│   │   │   │   ├── stat_card.dart         # بطاقة الإحصائية
│   │   │   │   └── recent_transactions.dart
│   │   │   └── charts/
│   │   │       ├── bar_chart_widget.dart
│   │   │       └── pie_chart_widget.dart
│   │   └── providers/                # إدارة الحالة (Riverpod)
│   │       ├── auth_provider.dart
│   │       ├── transaction_provider.dart
│   │       ├── product_provider.dart
│   │       ├── customer_provider.dart
│   │       └── report_provider.dart
│   │
│   └── app.dart                      # إعداد التطبيق والـ Router
│
├── assets/
│   ├── images/
│   │   └── logo.png
│   ├── icons/
│   └── fonts/
│
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
│
├── pubspec.yaml                      # التبعيات
└── README.md
```

## المكتبات الأساسية (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # إدارة الحالة
  flutter_riverpod: ^2.4.0

  # قاعدة البيانات المحلية
  drift: ^2.14.0
  sqlite3_flutter_libs: ^0.5.0

  # الـ Backend والـ API
  dio: ^5.3.0

  # التوجيه بين الشاشات
  go_router: ^12.0.0

  # الرسوم البيانية
  fl_chart: ^0.65.0

  # مسح الباركود
  mobile_scanner: ^3.5.0

  # تصدير PDF
  pdf: ^3.10.0
  printing: ^5.11.0

  # إشعارات محلية
  flutter_local_notifications: ^16.0.0

  # تنسيق التواريخ
  intl: ^0.18.0

  # حفظ البيانات البسيطة
  shared_preferences: ^2.2.0

  # فتح واتساب للتذكيرات
  url_launcher: ^6.2.0

  # الأيقونات
  flutter_svg: ^2.0.0
```

## معمارية Clean Architecture — شرح مبسط

```
[الشاشة] → [Provider] → [UseCase] → [Repository] → [DAO/API]
   ↑                                                      ↓
   └──────────────── البيانات ←──────────────────────────┘
```

- **presentation/** → ما يراه المستخدم
- **domain/** → قواعد العمل (لا تتغير)
- **data/** → كيف تُحفظ البيانات وتُجلب
