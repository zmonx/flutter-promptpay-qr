import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A simple, clean page for scanning or uploading a Thai slip QR code.
/// Demonstrates camera QR scanning and file-based QR detection with ML Kit OCR.
class SlipQrScanPage extends StatefulWidget {
  const SlipQrScanPage({super.key});

  @override
  State<SlipQrScanPage> createState() => _SlipQrScanPageState();
}

class _SlipQrScanPageState extends State<SlipQrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrResult;
  Map<String, String>? parsedResult;
  bool useCamera = true;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Camera QR scan callback
  void _onQRViewCreated(QRViewController ctrl) {
    controller = ctrl;
    controller?.scannedDataStream.listen((scanData) {
      if (qrResult == null) {
        setState(() {
          qrResult = scanData.code;
          parsedResult = parsePromptPayQr(scanData.code ?? '');
        });
        controller?.pauseCamera();
      }
    });
  }

  // Pick an image and try to extract QR code from slip using OCR
  Future<void> _pickQrImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);
    // Try to find a QR-like string (very basic)
    final qrMatch = RegExp(
      r'[A-Z0-9]{10,}',
    ).firstMatch(recognizedText.text.replaceAll('\n', ''));
    final qrPayload = qrMatch?.group(0);
    setState(() {
      useCamera = false;
      qrResult = qrPayload ?? recognizedText.text;
      parsedResult = parsePromptPayQr(qrPayload ?? recognizedText.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanSlipQR),
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            tooltip: l10n.browseFile,
            onPressed: _pickQrImage,
          ),
        ],
      ),
      body:
          qrResult == null && useCamera
              ? _buildCameraView(context)
              : _buildResult(context, l10n),
    );
  }

  Widget _buildCameraView(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Expanded(
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.greenAccent,
              borderRadius: 16,
              borderLength: 32,
              borderWidth: 8,
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.photo_library),
                label: Text(l10n.browseFile),
                onPressed: _pickQrImage,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.close),
                label: Text(l10n.cancel),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.qrScanResult,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (parsedResult != null && parsedResult!.isNotEmpty)
                  ...parsedResult!.entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text(
                            '${_localizedKey(e.key, l10n)}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Text(e.value)),
                        ],
                      ),
                    ),
                  ),
                if (parsedResult == null || parsedResult!.isEmpty)
                  Text(qrResult ?? '', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n.scanAgain),
                      onPressed: () {
                        setState(() {
                          qrResult = null;
                          parsedResult = null;
                          useCamera = true;
                        });
                        controller?.resumeCamera();
                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.close),
                      label: Text(l10n.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _localizedKey(String key, AppLocalizations l10n) {
    switch (key) {
      case 'Sender ID':
        return l10n.senderId;
      case 'Amount':
        return l10n.amount;
      case 'Date':
        return l10n.date;
      default:
        return key;
    }
  }
}

/// Very basic PromptPay QR parser for demo/learning.
Map<String, String> parsePromptPayQr(String payload) {
  final result = <String, String>{};
  try {
    // Example: parse ID, amount, date from payload
    final idMatch = RegExp(r'01(\d{2})(\d{10,})').firstMatch(payload);
    if (idMatch != null) {
      result['Sender ID'] = idMatch.group(2) ?? '';
    }
    final amountMatch = RegExp(r'540(\d{2})(\d+\.\d{2})').firstMatch(payload);
    if (amountMatch != null) {
      // Add Thai Baht symbol
      result['Amount'] = '฿ ' + (amountMatch.group(2) ?? '');
    }
    final dateMatch = RegExp(r'(20\d{2}[01]\d[0-3]\d)').firstMatch(payload);
    if (dateMatch != null) {
      result['Date'] = dateMatch.group(1) ?? '';
    }
  } catch (_) {}
  return result;
}
