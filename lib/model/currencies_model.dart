import 'dart:convert';

Map<dynamic, dynamic> allCurrenciesFromJson(String str) =>
    Map.from(json.decode(str)).map((k, v) => MapEntry<dynamic, dynamic>(k, v));

String allCurrenciesToJson(Map<dynamic, dynamic> data) =>
    json.encode(Map.from(data).map((k, v) => MapEntry<dynamic, dynamic>(k, v)));
