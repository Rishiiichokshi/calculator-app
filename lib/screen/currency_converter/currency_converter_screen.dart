import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/theme_controller.dart';
import '../../data/network/api_services.dart';
import '../../model/rates_model.dart';
import '../../utils/colors.dart';
import 'conversion_card.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  late Future<RatesModel> ratesModel;
  late Future<Map> currenciesModel;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    ratesModel = fetchRates();
    currenciesModel = fetchCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: themeController.isDark
          ? DarkColors.scaffoldBgColor
          : LightColors.scaffoldBgColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: themeController.isDark
            ? DarkColors.scaffoldBgColor
            : LightColors.scaffoldBgColor,
        leading: Icon(
          Icons.currency_exchange,
          color:
              themeController.isDark ? CommonColors.white : CommonColors.black,
        ),
        title: Text(
          'Currency Convertor',
          style: TextStyle(
              color: themeController.isDark
                  ? CommonColors.white
                  : CommonColors.black),
        ),
      ),
      body: FutureBuilder<RatesModel>(
          future: ratesModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                    // color: themeController.isDark
                    //     ? CommonColors.white
                    //     : CommonColors.black
                    ),
              );
            } else {
              return FutureBuilder<Map>(
                  future: currenciesModel,
                  builder: (context, index) {
                    if (index.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (index.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${index.error}',
                          style: TextStyle(
                              color: themeController.isDark
                                  ? CommonColors.white
                                  : CommonColors.black),
                        ),
                      );
                    } else {
                      return TestConversionCard(
                        rates: snapshot.data!.rates,
                        currencies: index.data!,
                      );
                    }
                  });
            }
          }),
    );
  }
}
