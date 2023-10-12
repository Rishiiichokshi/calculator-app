class AppUrl {
  // static const String currencyFetchKey = '779685828f954ffaa01339fbf3bb47e5';
  static const String currencyFetchKey = '880f252acd24aa6ac71b2ece57796b51';

  // static const String baseUrl = 'https://openexchangerates.org/api/';
  static const String baseUrl = 'http://data.fixer.io/api/';
  // static const String currenciesUrl =
  //     '${baseUrl}currencies.json?app_id=$currencyFetchKey';
  static const String ratesUrl =
      '${baseUrl}latest?access_key=$currencyFetchKey';
  // static const String ratesUrl =
  //     '${baseUrl}latest.json?base=USD&app_id=$currencyFetchKey';
}
