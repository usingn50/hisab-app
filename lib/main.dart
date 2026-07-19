import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'app.dart';
import 'core/services/session_service.dart';
import 'presentation/providers/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة تنسيق التواريخ العربية
  await initializeDateFormatting('ar');

  // تثبيت اتجاه الشاشة عمودياً فقط — مناسب لتطبيق محاسبة
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // استرجاع جلسة تسجيل الدخول المحفوظة (إن وُجدت) قبل بناء الواجهة
  final savedUserId = await SessionService.getUserId();

  runApp(
    ProviderScope(
      overrides: [
        currentUserIdProvider.overrideWith((ref) => savedUserId),
      ],
      child: const HisabApp(),
    ),
  );
}
