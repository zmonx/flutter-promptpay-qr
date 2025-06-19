import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../application/promptpay_qr_bloc.dart';
import '../application/promptpay_qr_event.dart';
import '../application/promptpay_qr_state.dart';
import 'components/amount_field.dart';
import 'components/app_constant.dart';
import 'components/app_colors.dart';
import 'components/generate_button.dart';
import 'components/promptpay_id_field.dart';
import 'components/qr_display.dart';
import 'slip_qr_scan_page.dart';

class PromptPayQRPage extends StatelessWidget {
  final Locale? locale;
  final void Function(Locale)? onLocaleChanged;
  const PromptPayQRPage({super.key, this.locale, this.onLocaleChanged});

  Future<void> checkSlip(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    final slipText = recognizedText.text.toLowerCase();
    final isPromptPay =
        slipText.contains('promptpay') || slipText.contains('thai qr payment');
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isPromptPay ? 'Valid PromptPay Slip' : 'Invalid Slip'),
            content: Text(
              isPromptPay
                  ? 'This slip appears to be a real PromptPay slip.'
                  : 'This slip does not appear to be a valid PromptPay slip.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<PromptPayQrBloc, PromptPayQrState>(
      listenWhen:
          (prev, curr) => prev.action != curr.action && curr.action != null,
      listener: (context, state) async {
        final action = state.action;
        if (action is ShowQrModalAction) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder:
                (context) => Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 12,
                    ),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColors.text,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/c/c5/PromptPay-logo.png',
                          height: 32,
                        ),
                        const SizedBox(height: 16),
                        QrDisplay(qrData: action.qrData),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(l10n.close),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          );
        } else if (action is ShowDialogAction) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: Text(
                    action.isPromptPay
                        ? l10n.validSlipTitle
                        : l10n.invalidSlipTitle,
                  ),
                  content: Text(
                    action.isPromptPay ? l10n.validSlip : l10n.invalidSlip,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.close),
                    ),
                  ],
                ),
          );
        } else if (action is NavigateToSlipScanAction) {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => SlipQrScanPage()));
        }
        // After handling, reset action to null
        context.read<PromptPayQrBloc>().add(
          SetId(context.read<PromptPayQrBloc>().state.id),
        ); // Dummy event to clear action
      },
      child: BlocBuilder<PromptPayQrBloc, PromptPayQrState>(
        builder: (context, state) {
          final bloc = context.read<PromptPayQrBloc>();
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const SizedBox(width: 12),
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppColors.text,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.language),
                  tooltip:
                      locale?.languageCode == 'th'
                          ? 'Switch to English'
                          : 'เปลี่ยนเป็นภาษาไทย',
                  onPressed: () {
                    if (onLocaleChanged != null) {
                      onLocaleChanged!(
                        locale?.languageCode == 'th'
                            ? const Locale('en')
                            : const Locale('th'),
                      );
                    }
                  },
                ),
              ],
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.text,
              elevation: 0,
            ),
            body: Container(
              color: AppColors.background,
              child: Column(
                children: [
                  Image.network(
                    "https://miro.medium.com/v2/resize:fit:711/1*nueyBV0RNEpETYMKpsYWhA.png",
                    fit: BoxFit.fitWidth,
                  ),
                  Center(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 32,
                        ),
                        padding: const EdgeInsets.all(AppConstant.padding24),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(
                            AppConstant.radius24,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PromptPayIdField(
                              onChanged: (id) => bloc.add(SetId(id)),
                            ),
                            const SizedBox(height: AppConstant.padding16),
                            AmountField(
                              onChanged:
                                  (amount) => bloc.add(SetAmount(amount)),
                            ),
                            const SizedBox(height: AppConstant.padding24),
                            GenerateButton(
                              onPressed: () {
                                bloc.add(GenerateQr());
                              },
                            ),
                            const SizedBox(height: AppConstant.padding16),
                            if (state.error != null)
                              Text(
                                state.error!,
                                style: const TextStyle(color: AppColors.error),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
