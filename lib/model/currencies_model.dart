import 'dart:convert';

Map<dynamic, dynamic> allCurrenciesFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) => MapEntry<dynamic, dynamic>(k, v));

String allCurrenciesToJson(Map<dynamic, dynamic> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<dynamic, dynamic>(k, v)));

// import 'dart:convert';
//
// Map<String, String> allCurrenciesFromJson(String str) =>
//     Map.from(json.decode(str)).map((k, v) => MapEntry<String, String>(k, v));
//
// String allCurrenciesToJson(Map<String, String> data) =>
//     json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));
