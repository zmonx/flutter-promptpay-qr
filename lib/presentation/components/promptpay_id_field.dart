import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_colors.dart';
import 'app_constant.dart';

class PromptPayIdField extends StatelessWidget {
  final void Function(String) onChanged;
  const PromptPayIdField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 18,
        color: AppColors.text,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ),
      decoration: InputDecoration(
        labelText: l10n.promptpayIdLabel,
        labelStyle: const TextStyle(
          color: AppColors.hint,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstant.radius16),
          borderSide: const BorderSide(color: AppColors.text, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstant.radius16),
          borderSide: const BorderSide(color: AppColors.text, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstant.radius24),
          borderSide: const BorderSide(color: AppColors.accent, width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstant.padding16,
          vertical: AppConstant.padding16,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Icon(
            Icons.account_balance_wallet,
            color: AppColors.accent,
            size: 24,
          ),
        ),
        hintText: l10n.promptpayIdHint,
        hintStyle: const TextStyle(color: AppColors.hint, fontSize: 15),
      ),
      keyboardType: TextInputType.number,
      cursorColor: AppColors.accent,
    );
  }
}
