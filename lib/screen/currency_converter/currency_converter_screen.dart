import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    ratesModel = fetchRates();
    currenciesModel = fetchCurrencies();
  }

  // Callback function to handle currency selection
  void handleCurrencySelected(String selectedCurrency) {
    // Perform any necessary state updates here
    // For example, you can update the state and re-fetch data if needed
    setState(() {
      // Update the state as needed
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeController.isDark
          ? DarkColors.currencyScaffoldBgColor
          : LightColors.scaffoldBgColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: themeController.isDark ? Colors.white : Colors.black,
            )),
        backgroundColor: themeController.isDark
            ? DarkColors.currencyScaffoldBgColor
            : LightColors.scaffoldBgColor,
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
              return Center(
                child: CircularProgressIndicator(
                    color: themeController.isDark
                        ? CommonColors.white
                        : DarkColors.bottomSheetColor),
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
                        scaffoldKey: _scaffoldKey,
                        onCurrencySelected: handleCurrencySelected,
                      );
                    }
                  });
            }
          }),
    );
  }
}
