import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'app_colors.dart';
import 'app_constant.dart';

class AmountField extends StatelessWidget {
  final void Function(String) onChanged;
  const AmountField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 18,
        color: AppColors.text,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: l10n.amountLabel,
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
        prefixIcon: const Icon(
          Icons.attach_money,
          color: AppColors.accent,
          size: 24,
        ),
        prefixText: '฿ ',
        prefixStyle: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        hintText: l10n.amountHint,
        hintStyle: const TextStyle(color: AppColors.hint, fontSize: 15),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      cursorColor: AppColors.accent,
      autofillHints: const [AutofillHints.transactionAmount],
    );
  }
}
