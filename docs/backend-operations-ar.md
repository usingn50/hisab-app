# تشغيل خلفية «حساب»

## الغرض والنطاق

توجد الخلفية في `server/` وتخدم تطبيق Flutter عبر API إصدارها الأول. تعتمد الخدمة على PostgreSQL، وتستخدم ترحيلات SQL مرتبة، وتُنشئ وثيقة OpenAPI في `server/openapi/hisab-v1.json`. تعمل بيئة التطوير محلياً عبر `docker-compose.yml` عندما يتوفر Docker، أو عبر PostgreSQL محلي مضبوط بمتغير `DATABASE_URL`.

> لا تُستخدم قيمة من `.env.example` في بيئة متصلة بالمستخدمين. يجب إنشاء أسرار JWT مستقلة وطويلة لكل بيئة، وتوصيل مزود OTP فعلي قبل فتح التسجيل العام.

| المتغير | وظيفة التشغيل | قاعدة الإنتاج |
|---|---|---|
| `DATABASE_URL` | اتصال PostgreSQL | اتصال مشفر ومخصص للبيئة |
| `JWT_ACCESS_SECRET` | توقيع رمز الوصول | قيمة عشوائية مستقلة لا تدخل المستودع |
| `JWT_REFRESH_SECRET` | فصل أسرار الجلسات طويلة العمر | قيمة عشوائية مختلفة عن access secret |
| `CORS_ORIGIN` | أصل عميل Flutter Web عند الحاجة | نطاقات معتمدة فقط |
| `OTP_PROVIDER` | مزود التحقق | لا تكون `development` في الإنتاج |
| `OTP_DEVELOPMENT_CODE` | رمز محلي فقط | لا يضبط في الإنتاج |

## التشغيل المحلي

```bash
cd server
cp .env.example .env
pnpm install
pnpm db:migrate
pnpm dev
```

تتوفر حالة الخدمة في `GET /health` ووثيقة العقد في `GET /openapi.json`. قبل أي نشر، ينفذ فريق التشغيل الأوامر التالية من جذر المستودع:

```bash
pnpm --dir server test
pnpm --dir server check
pnpm --dir server openapi:validate
flutter analyze
flutter test
```

## بناء الصورة

يُبنى ملف `server/Dockerfile` باستخدام سياق `server/`، ولا ينسخ ملفات البيئة أو الاعتمادات المحلية. تظل الترحيلات خطوة صريحة قبل بدء نسخة جديدة من API:

```bash
cd server
pnpm build
node dist/db/migrate.js
node dist/server.js
```

لا ينفذ أمر النشر الترحيلات بالتوازي عبر عدة نسخ للخادم. تُشغل عملية واحدة للترحيل أولاً، ثم تنشر النسخ الجديدة بعد نجاحها.

## النسخ والاستعادة

ينشئ `server/scripts/backup-postgres.sh` ملف PostgreSQL بصيغة custom وبصمة SHA-256 مرافقة. تحدد وجهة الملفات عبر `BACKUP_DIR`، وتتطلب الأوامر `DATABASE_URL`:

```bash
export DATABASE_URL='postgres://...'
BACKUP_DIR=/secure/backups server/scripts/backup-postgres.sh
```

تتطلب الاستعادة الملف والبصمة وخيار تأكيد صريح، وينفذها المشغل في بيئة معزولة أولاً ثم في الإنتاج بعد التحقق:

```bash
export DATABASE_URL='postgres://...'
server/scripts/restore-postgres.sh /secure/backups/hisab-YYYYMMDDTHHMMSSZ.dump --confirm
```

## قائمة فتح الإصدار التجريبي

| الفحص | شرط القبول |
|---|---|
| قاعدة البيانات | نفذت جميع الترحيلات ويطابق سجل `schema_migrations` الإصدار المتوقع |
| الهوية | مزود OTP فعلي، أسرار منفصلة، وCORS مقيد |
| المزامنة | نجح اختبار Push مكرر وPull من Cursor وBootstrap لجهاز جديد |
| المال والمخزون | نجح اختبار فاتورة نقدية وبيع آجل وسداد، ولا يظهر مخزون سالب |
| المراقبة | فحص `/health` من مراقب خارجي وسجل مركزي للأخطاء |
| الاستعادة | استعيد آخر نسخ احتياطي في قاعدة معزولة بنجاح قبل الإطلاق |

## حدود الحزمة الحالية

الخلفية وOutbox Flutter جاهزان كأساس، لكن ربط جلسة التطبيق الحالية بموفر OTP الإنتاجي وتطبيق تغييرات Pull على جداول Flutter يجب أن يُفعل تدريجياً بعد تثبيت هوية المؤسسة على كل جهاز. لا يُفعّل Cursor على العميل قبل أن تنجح دالة تطبيق التغيير المحلي؛ وإلا قد يتجاوز العميل تغييراً لم يطبّق بعد.
