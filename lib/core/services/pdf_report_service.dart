import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../domain/entities/report.dart';
import '../utils/currency_formatter.dart';
import '../utils/date_formatter.dart';

/// يولّد تقرير PDF بالعربية (اتجاه RTL) لبيانات المبيعات/المصاريف.
///
/// يستخدم PdfGoogleFonts من مكتبة printing لجلب خط عربي (Noto Sans Arabic)
/// وقت التشغيل، فما نحتاج نضيف ملفات خطوط للمشروع أو حزمة جديدة.
class PdfReportService {
  PdfReportService._();

  static const _brandBlue = PdfColor.fromInt(0xFF3B82F6);
  static const _gold = PdfColor.fromInt(0xFFEAB308);
  static const _success = PdfColor.fromInt(0xFF22C55E);
  static const _danger = PdfColor.fromInt(0xFFEF4444);
  static const _textDark = PdfColor.fromInt(0xFF0F172A);
  static const _textGray = PdfColor.fromInt(0xFF64748B);
  static const _borderGray = PdfColor.fromInt(0xFFE2E8F0);

  /// يبني ملف PDF لتقرير اليوم + بيانات آخر 7 أيام، ويعيد البايتات جاهزة للطباعة/المشاركة.
  static Future<Uint8List> buildReportPdf({
    required Report today,
    required List<Report> weekReports,
  }) async {
    final regularFont = await PdfGoogleFonts.notoSansArabicRegular();
    final boldFont = await PdfGoogleFonts.notoSansArabicBold();

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.all(28),
        header: (context) => _buildHeader(today, boldFont, regularFont),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'صفحة ${context.pageNumber} من ${context.pagesCount}',
            style: pw.TextStyle(font: regularFont, fontSize: 9, color: _textGray),
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 16),
          _buildSummaryCards(today, boldFont, regularFont),
          pw.SizedBox(height: 20),
          if (today.topProducts.isNotEmpty) ...[
            _sectionTitle('المنتجات الأكثر مبيعاً اليوم', boldFont),
            pw.SizedBox(height: 8),
            _buildTopProductsTable(today.topProducts, boldFont, regularFont),
            pw.SizedBox(height: 20),
          ],
          _sectionTitle('أداء آخر 7 أيام', boldFont),
          pw.SizedBox(height: 8),
          _buildWeekTable(weekReports, boldFont, regularFont),
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _buildHeader(
      Report today, pw.Font boldFont, pw.Font regularFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      margin: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _borderGray, width: 1)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text('تقرير حساب',
                  style: pw.TextStyle(
                      font: boldFont, fontSize: 20, color: _brandBlue)),
              pw.SizedBox(height: 2),
              pw.Text(DateFormatter.formatFull(DateTime.now()),
                  style: pw.TextStyle(
                      font: regularFont, fontSize: 10, color: _textGray)),
            ],
          ),
          pw.Container(
            width: 40,
            height: 40,
            decoration: pw.BoxDecoration(
              color: _brandBlue,
              borderRadius: pw.BorderRadius.circular(10),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text('ح',
                style: pw.TextStyle(
                    font: boldFont, fontSize: 20, color: _gold)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _sectionTitle(String text, pw.Font boldFont) {
    return pw.Text(text,
        style: pw.TextStyle(font: boldFont, fontSize: 14, color: _textDark));
  }

  static pw.Widget _buildSummaryCards(
      Report today, pw.Font boldFont, pw.Font regularFont) {
    return pw.Row(
      children: [
        _summaryCard('الإيراد', today.revenue, _success, boldFont, regularFont),
        pw.SizedBox(width: 10),
        _summaryCard('المصاريف', today.expenses, _danger, boldFont, regularFont),
        pw.SizedBox(width: 10),
        _summaryCard(
            'الربح',
            today.profit,
            today.isProfitable ? _success : _danger,
            boldFont,
            regularFont),
      ],
    );
  }

  static pw.Widget _summaryCard(String label, double amount, PdfColor color,
      pw.Font boldFont, pw.Font regularFont) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromInt(0xFFF8FAFC),
          borderRadius: pw.BorderRadius.circular(8),
          border: pw.Border.all(color: _borderGray, width: 0.6),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(label,
                style: pw.TextStyle(
                    font: regularFont, fontSize: 9, color: _textGray)),
            pw.SizedBox(height: 4),
            pw.Text(CurrencyFormatter.format(amount),
                style: pw.TextStyle(font: boldFont, fontSize: 13, color: color)),
          ],
        ),
      ),
    );
  }

  static pw.Widget _buildTopProductsTable(
      List<ProductSales> products, pw.Font boldFont, pw.Font regularFont) {
    return pw.TableHelper.fromTextArray(
      headers: ['الإيراد', 'الكمية المباعة', 'المنتج'],
      data: products
          .map((p) => [
                CurrencyFormatter.format(p.totalRevenue),
                p.quantitySold.toString(),
                p.productName,
              ])
          .toList(),
      headerStyle: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: _brandBlue),
      cellStyle: pw.TextStyle(font: regularFont, fontSize: 9.5, color: _textDark),
      cellAlignment: pw.Alignment.centerRight,
      headerAlignment: pw.Alignment.centerRight,
      border: pw.TableBorder.all(color: _borderGray, width: 0.5),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    );
  }

  static pw.Widget _buildWeekTable(
      List<Report> reports, pw.Font boldFont, pw.Font regularFont) {
    return pw.TableHelper.fromTextArray(
      headers: ['الربح', 'المصاريف', 'الإيراد', 'التاريخ'],
      data: reports
          .map((r) => [
                (r.isProfitable ? '+' : '') +
                    CurrencyFormatter.formatNumberOnly(r.profit),
                CurrencyFormatter.formatNumberOnly(r.expenses),
                CurrencyFormatter.formatNumberOnly(r.revenue),
                DateFormatter.formatShort(r.startDate),
              ])
          .toList(),
      headerStyle: pw.TextStyle(font: boldFont, fontSize: 10, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: _brandBlue),
      cellStyle: pw.TextStyle(font: regularFont, fontSize: 9.5, color: _textDark),
      cellAlignment: pw.Alignment.centerRight,
      headerAlignment: pw.Alignment.centerRight,
      border: pw.TableBorder.all(color: _borderGray, width: 0.5),
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      oddRowDecoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xFFF8FAFC)),
    );
  }

  /// يفتح حوار الطباعة/المشاركة الأصلي للنظام (يعمل على Android وWeb).
  static Future<void> shareReport({
    required Report today,
    required List<Report> weekReports,
  }) async {
    final bytes = await buildReportPdf(today: today, weekReports: weekReports);
    await Printing.sharePdf(
      bytes: bytes,
      filename: 'hisab_report_${DateFormatter.formatShort(DateTime.now()).replaceAll('/', '-')}.pdf',
    );
  }
}
