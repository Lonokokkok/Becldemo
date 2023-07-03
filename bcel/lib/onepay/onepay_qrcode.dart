
class OnepayQRC {
  /// @param value
  /// @return {string}
  String pad(int value) {
    return value >= 9 ? value.toString() : '0' + value.toString();
  }

  /// @param arr
  /// @return {string}
  String buildqrcode(arr) {
    var res = '';
    for (var i = 0; i < arr.length; i++) {
      String _key = '${arr[i]['k']}';
      String _value = '${arr[i]['v']}';
      int _value_length = _value.length;
      res = res + pad(int.parse(_key)) + pad(_value_length) + _value;
    }

    return res;
  }

  /// @param mcid
  /// @param transactionId
  /// @param terminalId
  /// @param amount
  /// @return {string}
  String generateonepayQR(mcid, transactionId, terminalId, amount, invoiceId,description ) {
    const mcc = '5734'; //category code for merchant
    const ccy = 418;
    const country = 'LA';
    const province = 'VTE';
     description = description;
    var stage33 = [
      {"k": 0, "v": 'BCEL'},
      {"k": 1, "v": 'ONEPAY'},
      {"k": 2, "v": mcid}
    ];
    var stage62 = [
      {"k": 1, "v": invoiceId},
      {"k": 5, "v": transactionId},
      {"k": 7, "v": terminalId},
      {"k": 8, "v": description}
    ];
    var allStage = [
      {"k": 0, "v": '01'},
      {"k": 1, "v": '11'},
      {"k": 33, "v": buildqrcode(stage33)},
      {"k": 52, "v": mcc},
      {"k": 53, "v": ccy},
      {"k": 54, "v": amount},
      {"k": 58, "v": country},
      {"k": 60, "v": province},
      {"k": 62, "v": buildqrcode(stage62)}
    ];
   
    return buildqrcode(allStage);
  }
}
