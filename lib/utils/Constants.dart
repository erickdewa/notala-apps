import 'package:intl/intl.dart';

class Constants {
  static const String VERSION = '1.0.0';

  static const String dataFinance = 'NOTALA_DATA_FINANCE';
  static const String totalFinance = 'NOTALA_TOTAL_FINANCE';
  static const String totalDebitFinance = 'NOTALA_TOTAL_DEBIT_FINANCE';
  static const String totalCreditFinance = 'NOTALA_TOTAL_CREDIT_FINANCE';
  static const String categoryFinance = 'NOTALA_CATEGORY';
  static const String fullnameFinance = 'NOTALA_FULL_NAME';
  static const String callnameFinance = 'NOTALA_CALL_NAME';
  static const String genderFinance = 'NOTALA_GENDER';
}

String formatRupiah(int value) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
  return formatter.format(value);
}