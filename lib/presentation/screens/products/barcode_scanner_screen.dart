import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';

/// شاشة مسح الباركود — تُفتح من add_product_screen وتعيد الـ barcode string.
///
/// الاستخدام:
/// ```dart
/// final code = await context.push<String>('/barcode-scanner');
/// if (code != null) _barcodeController.text = code;
/// ```
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  MobileScannerController? _controller;
  bool _detected = false;
  bool _torchOn = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_detected) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    _detected = true;
    _controller?.stop();
    Navigator.of(context).pop(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('مسح الباركود',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              await _controller?.toggleTorch();
              setState(() => _torchOn = !_torchOn);
            },
            icon: Icon(
              _torchOn ? Icons.flash_off_rounded : Icons.flash_on_rounded,
              color: _torchOn ? AppColors.gold : Colors.white,
            ),
            tooltip: 'الضوء',
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ── camera feed ──
          MobileScanner(
            controller: _controller!,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.camera_alt_outlined,
                        color: Colors.white54, size: 48),
                    const SizedBox(height: AppSizes.md),
                    Text(
                      _cameraErrorMessage(error),
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          // ── viewfinder overlay ──
          IgnorePointer(
            child: CustomPaint(
              size: Size.infinite,
              painter: _ViewfinderPainter(),
            ),
          ),

          // ── hint text ──
          Positioned(
            bottom: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.lg, vertical: AppSizes.sm),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppSizes.radiusFull),
              ),
              child: const Text(
                'وجّه الكاميرا نحو الباركود',
                style: TextStyle(color: Colors.white, fontSize: AppSizes.textSm),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _cameraErrorMessage(MobileScannerException error) {
    switch (error.errorCode) {
      case MobileScannerErrorCode.permissionDenied:
        return 'تعذر الوصول للكاميرا\nالرجاء السماح للتطبيق بالوصول إليها من الإعدادات';
      default:
        return 'تعذر تشغيل الكاميرا';
    }
  }
}

/// يرسم إطار المسح فوق الكاميرا
class _ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rectSize = w * 0.65;
    final left = (w - rectSize) / 2;
    final top = (h - rectSize) / 2;
    final rect = Rect.fromLTWH(left, top, rectSize, rectSize);

    // Darken outside viewfinder
    final dimPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, w, h))
      ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, dimPaint);

    // Corner brackets
    const cornerLen = 24.0;
    const strokeW = 3.0;
    final bracketPaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = strokeW
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // top-right (RTL: visually top-start)
    canvas.drawLine(Offset(left, top), Offset(left + cornerLen, top), bracketPaint);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLen), bracketPaint);
    // top-left
    canvas.drawLine(Offset(left + rectSize, top), Offset(left + rectSize - cornerLen, top), bracketPaint);
    canvas.drawLine(Offset(left + rectSize, top), Offset(left + rectSize, top + cornerLen), bracketPaint);
    // bottom-right
    canvas.drawLine(Offset(left, top + rectSize), Offset(left + cornerLen, top + rectSize), bracketPaint);
    canvas.drawLine(Offset(left, top + rectSize), Offset(left, top + rectSize - cornerLen), bracketPaint);
    // bottom-left
    canvas.drawLine(Offset(left + rectSize, top + rectSize), Offset(left + rectSize - cornerLen, top + rectSize), bracketPaint);
    canvas.drawLine(Offset(left + rectSize, top + rectSize), Offset(left + rectSize, top + rectSize - cornerLen), bracketPaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
