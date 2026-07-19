# تقرير تسليم — مشروع Hisab (حساب)

**آخر تحديث:** 19 يوليو 2026
**الريبو:** https://github.com/usingn50/hisab-app
**آخر Commit محلياً:** `654f662` — لم يُرفع بعد لـ GitHub (يحتاج توكن، انظر "خطوات فورية" أدناه)

> هذا الملف مكتوب ليقرأه نموذج AI آخر أو جلسة دردشة جديدة ويكمل العمل مباشرة
> بدون إعادة تحليل المشروع من الصفر. كل مسار مذكور هنا **مطابق فعلياً**
> لبنية الريبو (تم التحقق منه بالكود مباشرة، وليس تلخيصاً تقريبياً).

---

## 1. خطوات فورية قبل أي شيء

1. **رفع آخر commit لـ GitHub** — الكود جاهز محلياً بمجلد العمل لكن غير مرفوع.
   يحتاج GitHub Personal Access Token من المستخدم لتنفيذ `git push`.
2. **تحذير أمني متكرر:** المستخدم أرسل أكثر من توكن GitHub مباشرة داخل
   محادثات سابقة (شكل `ghp_...` و`github_pat_...`). كل توكن استُخدم وحُذف
   فوراً من إعدادات git المحلية بعد الاستخدام، لكنه يبقى **مكشوفاً في
   سجل المحادثة**. ذكّر المستخدم دائماً بإلغاء أي توكن قديم وعمل واحد جديد،
   ولا تعيد استخدام توكن من محادثة سابقة إن أمكن تجنّب ذلك.
3. **لا يوجد Flutter/Dart SDK في بيئة sandbox** (لا يوجد وصول لـ pub.dev).
   لا يمكن تشغيل `flutter pub get` أو `build_runner` أو `flutter analyze`
   من هنا. كل التحقق تم يدوياً (توازن أقواس/أقواس معقوفة + قراءة كود
   دقيقة)، وليس تشغيلاً فعلياً. **أول شيء يفعله المستخدم عند سحب الكود:
   تشغيل build_runner والتأكد من عدم وجود أخطاء compile حقيقية.**

---

## 2. ما تم إنجازه (بالترتيب الزمني)

### أ. ملفات drift المولّدة (`.g.dart`)
- **المشكلة الأصلية:** لم تكن موجودة إطلاقاً في الريبو (وهذا طبيعي —
  `*.g.dart` مستبعدة عمداً في `.gitignore`، معيار قياسي لمشاريع drift).
- **الحل المؤقت:** كتبتها يدوياً (لأن لا يوجد SDK هنا لتشغيل build_runner):
  - `lib/data/local/database/app_database.g.dart`
  - `lib/data/local/daos/{customer,product,transaction}_dao.g.dart`
- **⚠️ مهم:** هذه نسخة "جسر مؤقت" وليست الناتج الرسمي لـ `drift_dev`.
  أول ما يتوفر Flutter SDK محلياً، شغّل:
  ```bash
  flutter pub get
  dart run build_runner build --delete-conflicting-outputs
  ```
  هذا سيستبدل ملفاتي بالنسخة الرسمية تلقائياً. تحققت من تطابق الأنواع
  (`Customer`, `Product`, `Transaction`, `*Companion`) مع كل من
  `data/repositories/*_impl.dart` — يجب أن تعمل بدون تعديل إضافي.

### ب. تصميم شاشة تسجيل الدخول (`login_screen.dart`)
- إعادة تصميم كاملة: خلفية متحركة بتوهجات (أخضر/ذهبي وقتها)، حركة دخول
  (fade+slide)، بطاقة إدخال هاتف مرتفعة مع تأثير توهج عند التركيز،
  شريط ثقة أسفل الشاشة. **لا تغيير بمنطق OTP/validation.**

### ج. هوية الألوان — تحول من أخضر إلى أزرق/ذهبي
- المستخدم اختار أيقونة تطبيق بتصميم ذهبي/أزرق (بدل الأخضر/الذهبي الأصلي
  بالـ SRS). القرار: **primary يتغيّر لأزرق، لكن success يبقى أخضر منفصل
  تماماً** — لأن الأخضر/الأحمر للربح/الخسارة له دلالة مالية عالمية يجب ألا
  تتأثر بلون العلامة التجارية.
- `lib/core/constants/app_colors.dart`:
  - `primary: #3B82F6` (كان `#22C55E`)
  - `success: #22C55E` (منفصل الآن، غير مرتبط بـ primary)
  - `successLight: #86EFAC` (جديد — لمقاييس تدرّج تحتاج أخضر بغض النظر عن العلامة)
  - `info: #06B6D4` (غُيّر ليبتعد عن primary الجديد ويتجنب تصادم الألوان)
- صححت مكانين كانا يستخدمان `primary` بالخطأ لدلالة مالية (كانا سيتحولان
  للأزرق بالخطأ):
  - `reports_screen.dart` — لون أعمدة الربح/الخسارة بالمخطط
  - `credit_screen.dart` — الفئة الثانية بتدرّج مقياس السجل الائتماني
- **⚠️ لم يُنفَّذ بعد:** الأيقونة الفعلية (ملفات png/svg للأندرويد/iOS)
  لم تُنشأ كملفات حقيقية بعد — فقط تقرر اتجاه اللون. المستخدم يحتاج يرفع
  أو نصمم نسخة مبسّطة (بدون نص، رمز واحد فقط) صالحة لحجم أيقونة صغير.

### د. تصدير PDF (`core/services/pdf_report_service.dart`)
- تقرير PDF عربي RTL كامل: ملخص اليوم (إيراد/مصاريف/ربح) + جدول آخر 7
  أيام + أفضل المنتجات مبيعاً. يستخدم `PdfGoogleFonts.notoSansArabic*`
  من مكتبة `printing` (موجودة بالـ pubspec أصلاً، بدون حزم إضافية).
- موصول بزر PDF في `reports_screen.dart` عبر `Printing.sharePdf` (يفتح
  حوار المشاركة/الطباعة الأصلي — يعمل على Android وWeb).
- **⚠️ يحتاج اختبار حقيقي على جهاز** — لم يُختبر التشغيل الفعلي (لا يوجد
  محاكي/جهاز بهذه البيئة). تأكد أن `PdfGoogleFonts` تنجح بجلب الخط عبر
  الشبكة أول مرة (تحتاج إنترنت أول استخدام، تُخزَّن محلياً بعدها).

### هـ. نظام جلسة حقيقي (Session Management)
- **المشكلة الأصلية:** `const _currentUserId = 'local-user';` مكرر بـ9
  ملفات، بدون أي منطق تسجيل دخول فعلي.
- **الحل:**
  - `lib/core/services/session_service.dart` — يحفظ/يقرأ الجلسة عبر
    `shared_preferences` (رقم الهاتف نفسه = userId مؤقتاً، إلى حين ربط
    Backend حقيقي بمعرّف من السيرفر — القرار موثّق بالكود بالتفصيل).
  - `currentUserIdProvider` (`StateProvider<String?>`) في
    `presentation/providers/injection.dart`.
  - `main.dart` يقرأ الجلسة المحفوظة **قبل** `runApp` ويمررها كـ
    `overrides` لـ `ProviderScope`.
  - `otp_screen.dart` يحفظ الجلسة فعلياً بعد "التحقق" الناجح (حالياً
    محاكاة بـ `Future.delayed`، ليست مكالمة API حقيقية — انظر القسم 3).
  - `splash_screen.dart` يقرأ الجلسة عبر `SessionService` بدل الوصول
    المباشر لـ `SharedPreferences`.
  - استبدلت `'local-user'`/`_currentUserId` الثابتة في 9 ملفات
    (`dashboard_screen`, `credit_screen`, `products_screen`,
    `customers_screen`, `add_sale_screen`, `add_expense_screen`,
    `add_customer_screen`, `add_product_screen`, `reports_screen`)
    بقراءة تفاعلية من `currentUserIdProvider` (مع fallback آمن
    `?? 'local-user'` لو الجلسة لم تُحمّل بعد لأي سبب).

### و. تسجيل الخروج (Logout Flow)
- ملف جديد `lib/presentation/screens/settings/settings_screen.dart`:
  بطاقة حساب (تعرض رقم الهاتف الحالي) + زر تسجيل خروج بحوار تأكيد.
  عند التأكيد: `SessionService.clearSession()` + تصفير
  `currentUserIdProvider` + `context.go('/login')`.
  **بيانات المعاملات/المنتجات/الزبائن تبقى محفوظة بقاعدة البيانات
  المحلية** (تسجيل الخروج لا يحذفها — الدخول بنفس الرقم لاحقاً يرجّعها).
- مسار `/settings` أُضيف بـ `app.dart`.
- نقطة الدخول: أيقونة إعدادات ⚙️ بجانب أيقونة الإشعارات بأعلى `dashboard_screen.dart`.
- أضفت النصوص اللازمة بـ `app_strings.dart` (`settings`, `logout`,
  `logoutConfirmTitle`, `logoutConfirmMessage`, `cancel`, `appVersion`).

---

## 3. المتبقي (بترتيب الأولوية المقترح)

| # | المهمة | الموقع | ملاحظة |
|---|---|---|---|
| 1 | ربط Backend حقيقي لإرسال/التحقق من OTP | `login_screen.dart:75`, `otp_screen.dart:65,81` | حالياً محاكاة بـ `Future.delayed`. `data/remote/api_client.dart` موجود كهيكل جاهز لكن غير مفعّل فعلياً. لا يوجد سيرفر Node.js بهذا الريبو أصلاً (مذكور بالـ SRS كمكوّن منفصل) |
| 2 | توليد `share_token` ومشاركة السجل الائتماني | `credit_screen.dart:161` | TODO صريح بالكود، الميزة مذكورة بالـ SRS كأهم ميزة تفاضلية (الموردون يثقون بالسجل) |
| 3 | تفعيل ماسح الباركود فعلياً | `add_product_screen.dart:46` | حالياً SnackBar وهمي فقط ("سيتم فتح الكاميرا"). حزمة `mobile_scanner` موجودة بالـ pubspec لكن غير مستخدمة فعلياً بالكود |
| 4 | إنشاء ملفات الأيقونة الفعلية (png/adaptive icon) | assets جديدة + `pubspec.yaml` | تقرر لون الأيقونة (ذهبي/أزرق، رمز مبسّط بدون نص) لكن لم تُنشأ ملفات png حقيقية بعد. يفضّل حزمة `flutter_launcher_icons` (غير مضافة بعد بالـ pubspec) |
| 5 | تشغيل build_runner فعلياً واستبدال ملفات `.g.dart` اليدوية | كل المشروع | ملفاتي حالياً "جسر مؤقت" غير مضمون 100% مطابق للناتج الرسمي |
| 6 | اختبار PDF على جهاز حقيقي | `pdf_report_service.dart` | لم يُختبر التشغيل الفعلي إطلاقاً بهذه البيئة |
| 7 | (اختياري مستقبلاً) upsert فعلي لجدول `users` بقاعدة drift عند تسجيل الدخول | لا يوجد `UserDao` حالياً | حالياً الجلسة تُدار بـ `SharedPreferences` فقط بدون أي تفاعل مع جدول `users` بقاعدة drift (الجدول موجود بالسكيمة لكن غير مستخدم من أي DAO). مفيد لاحقاً عند إضافة مزامنة سيرفر حقيقية |

---

## 4. قرارات معمارية مهمة يجب معرفتها (لتجنّب التراجع عنها بالخطأ)

- **`success` منفصل عمداً عن `primary`** بألوان التطبيق — لا تدمجهما مرة
  أخرى حتى لو غيّرنا لون العلامة التجارية لاحقاً. الأخضر/الأحمر دائماً
  = ربح/خسارة، بغض النظر عن هوية العلامة.
- **`userId` = رقم الهاتف حالياً** (وليس UUID منفصل) — قرار مقصود
  ومبسّط ريثما يُربط Backend حقيقي يُصدر معرّفات خاصة به. أي كود جديد
  يفترض `userId` يجب أن يتعامل معه كسلسلة نصية عامة، وليس تنسيق UUID.
- **تسجيل الخروج لا يمسح بيانات قاعدة drift المحلية** — فقط الجلسة
  (SharedPreferences). هذا مقصود: نفس رقم الهاتف يرجّع نفس البيانات.

---

## 5. بنية المشروع (مرجع سريع)

```
lib/
├── core/
│   ├── constants/        (app_colors, app_sizes, app_strings)
│   ├── services/         (session_service.dart, pdf_report_service.dart)  ← جديد
│   ├── theme/
│   └── utils/            (currency/date formatters, validators)
├── data/
│   ├── local/
│   │   ├── database/     (app_database.dart + .g.dart يدوي)
│   │   └── daos/         (customer/product/transaction + .g.dart يدوي)
│   ├── remote/           (api_client.dart, sync_service.dart — غير مفعّلين فعلياً)
│   └── repositories/     (impl لكل من customer/product/transaction)
├── domain/
│   ├── entities/, repositories/, usecases/
├── presentation/
│   ├── providers/injection.dart   (كل Riverpod providers، بما فيها currentUserIdProvider)
│   ├── screens/
│   │   ├── auth/          (splash, login, otp)
│   │   ├── dashboard/
│   │   ├── transactions/  (add_sale, add_expense)
│   │   ├── products/, customers/, credit/, reports/
│   │   └── settings/      ← جديد (logout)
│   └── widgets/
├── app.dart               (GoRouter + MaterialApp.router)
└── main.dart               (bootstrap + تحميل الجلسة قبل runApp)
```

---

## 6. كيف تبدأ الجلسة القادمة

1. اسحب آخر commit من GitHub (بعد التأكد من رفعه — راجع القسم 1).
2. اقرأ هذا الملف كاملاً قبل أي تعديل.
3. إذا الأولوية "ربط Backend حقيقي" — ابدأ بفحص `data/remote/api_client.dart`
   و`data/remote/sync_service.dart` لمعرفة ما هو جاهز فعلاً مقابل هيكل فارغ.
4. لا تدمج `success` و`primary` مرة أخرى (راجع القسم 4).
5. أي عمل جديد على `.g.dart` — تأكد أولاً إذا المستخدم شغّل build_runner
   فعلياً عنده (لو نعم، ملفاتي اليدوية تصير غير ذات صلة ويمكن تجاهلها).
