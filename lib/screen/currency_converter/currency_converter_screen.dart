import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/theme_controller.dart';
import '../../app_services/api_services.dart';
import '../../model/rates_model.dart';
import '../../utils/colors.dart';
import '../../utils/string_utils.dart';
import '../calculator/scientific_calculator.dart';
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      // Navigate to the ScientificCalculator screen in landscape mode
      return const ScientificCalculator();
    } else {
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
                size: 5.w,
                Icons.arrow_back,
                color: themeController.isDark ? Colors.white : Colors.black,
              )),
          centerTitle: true,
          backgroundColor: themeController.isDark
              ? DarkColors.currencyScaffoldBgColor
              : LightColors.scaffoldBgColor,
          title: Text(
            StringUtils.currencyConvertor,
            style: TextStyle(
                fontSize: 5.w,
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
                                fontSize: 10.sp,
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
}
