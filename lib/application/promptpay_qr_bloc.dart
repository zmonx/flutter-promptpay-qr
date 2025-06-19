import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/promptpay.dart';
import 'promptpay_qr_event.dart';
import 'promptpay_qr_state.dart';

class PromptPayQrBloc extends Bloc<PromptPayQrEvent, PromptPayQrState> {
  final GeneratePromptPayQrUseCase _useCase;
  PromptPayQrBloc(this._useCase) : super(const PromptPayQrState()) {
    on<SetId>((event, emit) {
      emit(state.copyWith(id: event.id, error: null, action: null));
    });
    on<SetAmount>((event, emit) {
      emit(state.copyWith(amount: event.amount, error: null, action: null));
    });
    on<GenerateQr>((event, emit) {
      if (state.id.trim().isEmpty) {
        emit(
          state.copyWith(
            qrData: null,
            error: 'PromptPay ID is required',
            action: null,
          ),
        );
        return;
      }
      double? amount = double.tryParse(state.amount.trim());
      if (state.amount.trim().isEmpty) amount = null;
      final qr = _useCase(
        PromptPayRequest(id: state.id.trim(), amount: amount),
      );
      emit(
        state.copyWith(qrData: qr, error: null, action: ShowQrModalAction(qr)),
      );
    });
    on<CheckSlip>((event, emit) async {
      emit(
        state.copyWith(
          action: ShowDialogAction(isPromptPay: false, slipText: ''),
        ),
      );
    });
    on<ShowQrModal>((event, emit) {
      emit(state.copyWith(action: ShowQrModalAction(event.qrData)));
    });
    on<NavigateToSlipScan>((event, emit) {
      emit(state.copyWith(action: NavigateToSlipScanAction()));
    });
  }
}
