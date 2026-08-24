# ملاحظات اختيار مزود OTP

## Twilio Verify

توضح وثائق Twilio Verify أن واجهة التحقق تدعم إرسال OTP عبر SMS وWhatsApp، وأن التحقق يتم بإنشاء verification ثم فحصه عبر Verify API. عند استعمال WhatsApp يلزم إنشاء أو استعمال Verify Service وإرسال `Channel=whatsapp`، ثم فحص الرمز كما في باقي القنوات. كما تتطلب قناة WhatsApp Sender مرتبطاً بحساب WhatsApp Business، وتفيد الوثائق بأن استخدام Sender مملوك للعلامة مطلوب منذ 1 مارس 2024. [1]

توضح وثيقة قابلية التسليم أن Verify يتبع دعم Twilio Messaging بحسب البلد، وأن إعدادات Geo Permissions في حساب Verify قد تمنع الإرسال وتظهر الخطأ 60605؛ لذلك يجب فتح اليمن صراحة في بيئة التجريب قبل الإطلاق. [2]

تعرض إرشادات اليمن أن البلد يستخدم رمز الاتصال `+967` وأن SMS ثنائي الاتجاه مدعوم، مع ضرورة مراجعة الالتزامات المحلية والتأكد من صلاحية الرقم قبل الإرسال. [3]

## WhatsApp Cloud API

توضح وثائق Meta أن OTP عبر WhatsApp يجب أن يستخدم Authentication Template. يمكن أن يحمل القالب زر نسخ رمز أو تعبئة تلقائية، وتذكر أن قالب المصادقة يمكن أن يتضمن تحذير أمني ومدة انتهاء. تتطلب أزرار one-tap تغييرات Android إضافية، بينما يوفر زر copy code مساراً أبسط. [4]

## القرار التشغيلي المبدئي

يُنفذ Twilio Verify كخيار أول في الخلفية لأنه يوحد بدء التحقق وفحصه وتبديل القناة عبر متغير إعداد، مع تشغيل SMS أولاً في التجريب. لا يُفعّل WhatsApp قبل ربط WhatsApp Business Sender مع العلامة والتحقق من نجاح التسليم الفعلي لأرقام يمنية. الاحتفاظ بواجهة `OtpProvider` يسمح بإضافة مزود محلي مرخص لاحقاً دون تعديل منطق الجلسات.

## المراجع

[1] https://www.twilio.com/docs/verify/whatsapp
[2] https://www.twilio.com/docs/verify/verify-countries-and-regions-deliverability
[3] https://www.twilio.com/en-us/guidelines/ye/sms
[4] https://developers.facebook.com/documentation/business-messaging/whatsapp/templates/authentication-templates/authentication-templates
