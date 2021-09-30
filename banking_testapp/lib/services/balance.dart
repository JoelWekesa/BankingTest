import 'dart:convert';
import 'package:banking_testapp/config/baseURL.dart';
import 'package:http/http.dart' as http;

class Balance {
  Map? data;
  int? statusCode;
  Balance();
  Future<void> getBalance() async {
    baseURL instance = baseURL();
    await instance.rootURL();

    var url = Uri.parse('${instance.url}api/balance');
    var response = await http.get(url, headers: {"Accept": "*"});
    data = jsonDecode(response.body);
    statusCode = response.statusCode;
  }
}
