import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_constant.dart';
import 'app_colors.dart';

class GenerateButton extends StatelessWidget {
  final VoidCallback onPressed;
  const GenerateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 8,
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstant.radius16),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstant.padding32,
            vertical: AppConstant.padding16,
          ),

          shadowColor: AppColors.accent.withOpacity(0.25),
        ),
        child: Text(
          l10n.generateButton,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: AppColors.background,
          ),
        ),
      ),
    );
  }
}
