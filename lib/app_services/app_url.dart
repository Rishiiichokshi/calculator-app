
class AppUrl {
  static const String currencyFetchKey = '779685828f954ffaa01339fbf3bb47e5';

  static const String baseUrl = 'https://openexchangerates.org/api/';
  static const String currenciesUrl =
      '${baseUrl}currencies.json?app_id=$currencyFetchKey';
  static const String ratesUrl =
      '${baseUrl}latest.json?base=USD&app_id=$currencyFetchKey';
}
