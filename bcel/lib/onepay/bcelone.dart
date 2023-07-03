import 'package:bcel/onepay/onepay_qrcode.dart';
import 'package:flutter/material.dart';

class BceloneQR{
  final String mcid;
  final String transactionId;
  final String terminalId;
  final num amount;
  final String invoiceId;
  const BceloneQR(
      {Key? key,
      required this.mcid,
      required this.transactionId,
      required this.terminalId,
      required this.amount,
      required this.invoiceId});

  static String bcelQr(
      _mcid, _transactionId, _terminalId, _amount, _invoiceId,description) {
    OnepayQRC _onePayQR = OnepayQRC();
    return _onePayQR.generateonepayQR(
        _mcid, _transactionId, _terminalId, _amount, _invoiceId,description);
  }
}
