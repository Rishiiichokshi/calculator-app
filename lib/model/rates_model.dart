import 'dart:convert';

RatesModel ratesModelFromJson(String str) =>
    RatesModel.fromJson(json.decode(str));

String ratesModelToJson(RatesModel data) => json.encode(data.toJson());

class RatesModel {
  RatesModel({
    required this.success,
    required this.timestamp,
    required this.base,
    required this.date,
    required this.rates,
  });

  bool success;
  int timestamp;
  String base;
  String date;
  Map<String, double> rates;

  factory RatesModel.fromJson(Map<dynamic, dynamic> json) {
    return RatesModel(
      success: json["success"],
      timestamp: json["timestamp"],
      base: json["base"],
      date: json["date"],
      rates: Map<String, dynamic>.from(json["rates"])
          .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
    );
  }

  Map<dynamic, dynamic> toJson() => {
        "success": success,
        "timestamp": timestamp,
        "base": base,
        "date": date,
        "rates":
            Map.from(rates).map((k, v) => MapEntry<dynamic, dynamic>(k, v)),
      };
}

// import 'dart:convert';
//
// RatesModel ratesModelFromJson(String str) =>
//     RatesModel.fromJson(json.decode(str));
//
// String ratesModelToJson(RatesModel data) => json.encode(data.toJson());
//
// class RatesModel {
//   RatesModel({
//     required this.disclaimer,
//     required this.license,
//     required this.timestamp,
//     required this.base,
//     required this.rates,
//   });
//
//   String disclaimer;
//   String license;
//   int timestamp;
//   String base;
//   Map<String, double> rates;
//
//   factory RatesModel.fromJson(Map<String, dynamic> json) => RatesModel(
//     disclaimer: json["disclaimer"],
//     license: json["license"],
//     timestamp: json["timestamp"],
//     base: json["base"],
//     rates: Map.from(json["rates"])
//         .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "disclaimer": disclaimer,
//     "license": license,
//     "timestamp": timestamp,
//     "base": base,
//     "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
//   };
// }
