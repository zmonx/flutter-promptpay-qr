import 'package:equatable/equatable.dart';

abstract class PromptPayQrEvent extends Equatable {
  const PromptPayQrEvent();
  @override
  List<Object?> get props => [];
}

class SetId extends PromptPayQrEvent {
  final String id;
  const SetId(this.id);
  @override
  List<Object?> get props => [id];
}

class SetAmount extends PromptPayQrEvent {
  final String amount;
  const SetAmount(this.amount);
  @override
  List<Object?> get props => [amount];
}

class GenerateQr extends PromptPayQrEvent {}

class CheckSlip extends PromptPayQrEvent {}

class ShowQrModal extends PromptPayQrEvent {
  final String qrData;
  const ShowQrModal(this.qrData);
  @override
  List<Object?> get props => [qrData];
}

class NavigateToSlipScan extends PromptPayQrEvent {}
