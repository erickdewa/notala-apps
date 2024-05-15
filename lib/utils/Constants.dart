import 'package:intl/intl.dart';

class Constants {
  static const bool IS_PRODUCTION = false;
  static const String VERSION = '1.0.0';
  static const String BASE_URL = (IS_PRODUCTION) ? '192.168.1.16:3000' : '192.168.1.16:3000';
}

Uri baseUrl({String url = '', Map<String, String>? formData}) {
  if(formData != null){
    return Uri.http(Constants.BASE_URL, url, formData);
  } else {
    return Uri.http(Constants.BASE_URL, url);
  }
}

String formatRupiah(int value) {
  final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp. ');
  return formatter.format(value);
}