import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'app_colors.dart';
import 'app_constant.dart';

class QrDisplay extends StatelessWidget {
  final String qrData;
  const QrDisplay({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstant.radius24),
        side: BorderSide(color: AppColors.divider, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstant.padding16),
        child: Column(
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: AppConstant.qrSize,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: AppConstant.padding16),
            SelectableText(
              qrData,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.hint,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
