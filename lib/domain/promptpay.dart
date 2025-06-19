// Domain: Entity and Use Case for PromptPay

class PromptPayRequest {
  final String id;
  final double? amount;
  const PromptPayRequest({required this.id, this.amount});
}

class GeneratePromptPayQrUseCase {
  String call(PromptPayRequest request) {
    String normalizeId(String id) {
      if (RegExp(r'^0\d{9}').hasMatch(id)) {
        return '0066${id.substring(1)}';
      }
      return id;
    }

    String tag(String id, String value) {
      final length = value.length.toString().padLeft(2, '0');
      return '$id$length$value';
    }

    String idField =
        tag('00', 'A000000677010111') + tag('01', normalizeId(request.id));
    String payload =
        [
          tag('00', '01'),
          tag('01', request.amount != null ? '12' : '11'),
          tag('29', idField),
          tag('58', 'TH'),
          tag('53', '764'),
          if (request.amount != null)
            tag('54', request.amount!.toStringAsFixed(2)),
        ].join();
    String withCrc = payload + '6304';
    final crc = _crc16(withCrc);
    return withCrc + crc;
  }

  String _crc16(String input) {
    final bytes = input.codeUnits;
    int crc = 0xFFFF;
    for (final b in bytes) {
      crc ^= (b << 8);
      for (int i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ 0x1021;
        } else {
          crc <<= 1;
        }
      }
      crc &= 0xFFFF;
    }
    return crc.toRadixString(16).toUpperCase().padLeft(4, '0');
  }
}
