import 'dart:convert';
import 'package:banking_testapp/config/baseURL.dart';
import 'package:http/http.dart' as http;

class Withdraw {
  String amount;
  Map? data;
  int? statusCode;
  Withdraw({required this.amount});
  Future<void> newWithDraw() async {
    baseURL instance = baseURL();
    await instance.rootURL();
    var body = {"amount": amount};
    var url = Uri.parse('${instance.url}api/withdraw/new');
    var response = await http.post(url, headers: {"Accept": "*"}, body: body);
    data = jsonDecode(response.body);
    statusCode = response.statusCode;
  }
}
