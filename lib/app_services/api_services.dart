import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/rates_model.dart';
import 'app_url.dart';

RatesModel ratesModelFromJson(String str) =>
    RatesModel.fromJson(json.decode(str));

String ratesModelToJson(RatesModel data) => json.encode(data.toJson());

Map<dynamic, dynamic> allCurrenciesFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) => MapEntry<dynamic, dynamic>(k, v));

String allCurrenciesToJson(Map<dynamic, dynamic> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<dynamic, dynamic>(k, v)));

Future<RatesModel> fetchRates() async {
  try {
    final response = await http.get(Uri.parse(AppUrl.ratesUrl));
    if (response.statusCode == 200) {
      final ratesModel = ratesModelFromJson(response.body);
      // print('----Rates Model----${response.body}');
      return ratesModel;
    } else {
      throw Exception('Failed to fetch rates');
    }
  } catch (e) {
    throw Exception('Failed to fetch rates: $e');
  }
}

Future<Map<dynamic, dynamic>> fetchCurrencies() async {
  try {
    final response = await http.get(Uri.parse(AppUrl.ratesUrl));
    if (response.statusCode == 200) {
      final allCurrencies = allCurrenciesFromJson(response.body);
      return allCurrencies;
    } else {
      throw Exception('Failed to fetch currencies');
    }
  } catch (e) {
    throw Exception('Failed to fetch currencies: $e');
  }
}

// import 'package:http/http.dart' as http;
//
// import '../model/currencies_model.dart';
// import '../model/rates_model.dart';
// import 'app_url.dart';
//
// Future<RatesModel> fetchRates() async {
//   var response = await http.get(Uri.parse(AppUrl.ratesUrl));
//   final ratesModel = ratesModelFromJson(response.body);
//   return ratesModel;
// }
//
// Future<Map> fetchCurrencies() async {
//   var response = await http.get(Uri.parse(AppUrl.currenciesUrl));
//   final allCurrencies = allCurrenciesFromJson(response.body);
//   return allCurrencies;
// }
