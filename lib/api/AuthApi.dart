import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:notala_apps/model/ResponseModel.dart';
import 'package:notala_apps/utils/Constants.dart';

Future<ResponseModel> apiAuthRefresh() async {
  var prefs = await SharedPreferences.getInstance();
  var bearerToken = prefs.getString('bearer_token');
  
  var url = baseUrl(url: 'api/v1/auth/refresh');

  final response = await http.get(url, headers: {
    'Authorization': 'Bearer $bearerToken',
    'APK-VERSION': Constants.VERSION,
  });

  var res = json.decode(response.body);
  res['code'] = response.statusCode;

  return ResponseModel.fromJson(res);
}

Future<ResponseModel> apiAuthCheck() async {
  var prefs = await SharedPreferences.getInstance();
  var bearerToken = prefs.getString('bearer_token');
  
  var url = baseUrl(url: 'api/v1/auth/check');

  final response = await http.post(url, headers: {
    'Authorization': 'Bearer $bearerToken',
    'APK-VERSION': Constants.VERSION,
  });

  var res = json.decode(response.body);
  res['code'] = response.statusCode;

  print(res);
  return ResponseModel.fromJson(res);
}

Future<ResponseModel> apiAuthLogin({required String username, required String password, int? rememberMe}) async {
  var prefs = await SharedPreferences.getInstance();
  var bearerToken = prefs.getString('bearer_token');
  
  var url = baseUrl(url: 'api/v1/auth/login');

  final response = await http.post(url, headers: {
    'Authorization': 'Bearer $bearerToken',
    'APK-VERSION': Constants.VERSION,
  }, body: {
    'username': username,
    'password': password,
    'remember_me': (rememberMe ?? 0).toString(),
  });

  var res = json.decode(response.body);
  res['code'] = response.statusCode;

  return ResponseModel.fromJson(res);
}

void apiAuthLogout() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setBool("is_auth", false);
  prefs.setString("user", jsonEncode({}));
  prefs.setString("bearer_token", '');
}
