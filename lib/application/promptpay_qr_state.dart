import 'package:equatable/equatable.dart';

// Add a sealed class for UI actions (side effects)
abstract class PromptPayQrAction extends Equatable {
  const PromptPayQrAction();
  @override
  List<Object?> get props => [];
}

class ShowDialogAction extends PromptPayQrAction {
  final bool isPromptPay;
  final String slipText;
  const ShowDialogAction({required this.isPromptPay, required this.slipText});
  @override
  List<Object?> get props => [isPromptPay, slipText];
}

class ShowQrModalAction extends PromptPayQrAction {
  final String qrData;
  const ShowQrModalAction(this.qrData);
  @override
  List<Object?> get props => [qrData];
}

class NavigateToSlipScanAction extends PromptPayQrAction {}

class PromptPayQrState extends Equatable {
  final String id;
  final String amount;
  final String? qrData;
  final String? error;
  final PromptPayQrAction? action;
  const PromptPayQrState({
    this.id = '',
    this.amount = '',
    this.qrData,
    this.error,
    this.action,
  });

  PromptPayQrState copyWith({
    String? id,
    String? amount,
    String? qrData,
    String? error,
    PromptPayQrAction? action,
  }) {
    return PromptPayQrState(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      qrData: qrData,
      error: error,
      action: action,
    );
  }

  @override
  List<Object?> get props => [id, amount, qrData, error, action];
}
