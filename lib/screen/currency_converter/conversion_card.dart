import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:search_choices/search_choices.dart';

import '../../controller/theme_controller.dart';
import '../../utils/colors.dart';
import '../../utils/string_utils.dart';

class TestConversionCard extends StatefulWidget {
  final Map rates;
  final Map currencies;
  final Key scaffoldKey;
  final Function(String) onCurrencySelected;

  const TestConversionCard({
    super.key,
    required this.rates,
    required this.currencies,
    required this.scaffoldKey,
    required this.onCurrencySelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TestConversionCardState createState() => _TestConversionCardState();
}

class ConversionData {
  TextEditingController amountController = TextEditingController();
  String dropdownValue = StringUtils.usd;
  String conversion = '';
  double convertedAmount = 0.0;
  bool isSelected = false;
}

class _TestConversionCardState extends State<TestConversionCard> {
  List<ConversionData> conversionDataList = [];
  ConversionData data = ConversionData();
  bool isLoading = false;
  String defaultCurrency = StringUtils.usd;
  int selectedIndex = 0;
  bool isConvert = false;
  var themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();
    // Load data from SharedPreferences
    loadDataFromSharedPreferences();
    saveDataToSharedPreferences();
    if (conversionDataList.isEmpty) {
      // If empty, add a default ConversionData
      conversionDataList.add(ConversionData());
    }
    // Set up listeners
    for (var data in conversionDataList) {
      data.amountController.addListener(() {
        updateConversionData(data);
      });
    }
    if (conversionDataList.isEmpty) {
      // If list is empty, set default values
      conversionDataList[0].dropdownValue = defaultCurrency;
      conversionDataList[0].amountController.text = '1';
    }
  }

  Future<void> saveDataToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataList = [];

    for (var data in conversionDataList) {
      // Convert ConversionData to a JSON string
      String dataJson = dataToJson(data);
      dataList.add(dataJson);
    }

    // Save the list of JSON strings to shared preferences
    prefs.setStringList('conversionDataList', dataList);
    // print('=============dataList $dataList');
  }

  Future<void> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dataList = prefs.getStringList('conversionDataList');

    if (dataList != null) {
      // Convert the list of JSON strings back to ConversionData objects
      conversionDataList = dataList.map((jsonString) {
        return jsonToData(jsonString);
      }).toList();
      setState(() {});
    }

    // Other initialization logic
  }

// Convert a JSON string to ConversionData
  ConversionData jsonToData(String jsonString) {
    // Implement the conversion logic based on your data structure
    // For example, you can use the `dart:convert` library
    // Here is a simplified example assuming `ConversionData` has simple properties
    Map<String, dynamic> dataMap = jsonDecode(jsonString);
    ConversionData data = ConversionData();
    data.amountController.text = dataMap['amountController'];
    data.dropdownValue = dataMap['dropdownValue'];
    // Set other properties as needed
    return data;
  }

// Convert ConversionData to a JSON string
  String dataToJson(ConversionData data) {
    // Implement the conversion logic based on your data structure
    // For example, you can use the `dart:convert` library
    // Here is a simplified example assuming `ConversionData` has simple properties
    Map<String, dynamic> dataMap = {
      'amountController': data.amountController.text,
      'dropdownValue': data.dropdownValue,
      // Add other properties as needed
    };
    return jsonEncode(dataMap);
  }

  ///updating rates as per entered data
  void updateConversionData(ConversionData updatedData) {
    if (isConvert) {
      for (var data in conversionDataList) {
        if (data != updatedData) {
          String conversionResult = Utils.convert(
            widget.rates,
            updatedData.amountController.text,
            updatedData.dropdownValue,
            data.dropdownValue,
          );
          double? convertedAmount = double.tryParse(conversionResult);
          if (convertedAmount != null) {
            data.amountController.text = conversionResult;
            data.convertedAmount = convertedAmount;
          } else {
            // Handle the case where the conversionResult is not a valid double
          }
        }
      }
    }

    setState(() {});
  }

  ///adding new container on press of add currency
  void addConversionData() {
    setState(() {
      ConversionData newData = ConversionData();
      newData.amountController.addListener(() {
        if (isConvert) {
          updateConversionData(newData);
        }
      });
      newData.dropdownValue = defaultCurrency;
      if (selectedIndex >= 0 && selectedIndex < conversionDataList.length) {
        newData.amountController.text =
            conversionDataList[selectedIndex].amountController.text;
      }
      conversionDataList.add(newData);
      saveDataToSharedPreferences();
    });
  }

  ///working code of bottomsheet
  // Future<void> _showCurrencyOptions(BuildContext context) async {
  //   await showModalBottomSheet<void>(
  //     context: context,
  //     backgroundColor: themeController.isDark
  //         ? DarkColors.btnBgColor
  //         : LightColors.sheetBgColor,
  //     builder: (BuildContext context) {
  //       return ListView(
  //         children: widget.currencies.keys.map((value) {
  //           bool isSelected = conversionDataList.any(
  //             (data) => data.dropdownValue == value,
  //           );
  //
  //           // Check if the currency is the default currency (USD)
  //           bool isDefaultCurrency = value == defaultCurrency;
  //
  //           return ListTile(
  //             title: Row(
  //               children: [
  //                 SizedBox(
  //                   width: 79.w,
  //                   child: Text(
  //                     '$value - ${widget.currencies[value]}',
  //                     overflow: TextOverflow.ellipsis,
  //                     maxLines: 1,
  //                     style: TextStyle(
  //                       color: themeController.isDark
  //                           ? CommonColors.white
  //                           : CommonColors.black,
  //                     ),
  //                   ),
  //                 ),
  //                 if (isSelected)
  //                   IconButton(
  //                     icon: Icon(
  //                       Icons.check,
  //                       color: themeController.isDark
  //                           ? CommonColors.white
  //                           : CommonColors.black,
  //                     ),
  //                     onPressed: () {
  //                       setState(() {
  //                         if (!isDefaultCurrency) {
  //                           conversionDataList.removeWhere(
  //                             (data) => data.dropdownValue == value,
  //                           );
  //                         }
  //                       });
  //                     },
  //                   ),
  //               ],
  //             ),
  //             onTap: () {
  //               setState(() {
  //                 if (!isSelected) {
  //                   ConversionData newData = ConversionData();
  //                   newData.amountController.addListener(() {
  //                     if (isConvert) {
  //                       updateConversionData(newData);
  //                     }
  //                   });
  //
  //                   newData.dropdownValue = value;
  //
  //                   // Calculate the conversion when adding a new currency
  //                   String conversionResult = Utils.convert(
  //                     widget.rates,
  //                     conversionDataList[selectedIndex].amountController.text,
  //                     conversionDataList[selectedIndex].dropdownValue,
  //                     newData.dropdownValue,
  //                   );
  //
  //                   double? convertedAmount = double.tryParse(conversionResult);
  //
  //                   if (convertedAmount != null) {
  //                     newData.amountController.text = conversionResult;
  //                     newData.convertedAmount = convertedAmount;
  //                   } else {
  //                     // Handle the case where the conversionResult is not a valid double
  //                   }
  //
  //                   conversionDataList.add(newData);
  //                 } else {
  //                   // If the currency is already selected, remove it
  //                   if (!isDefaultCurrency) {
  //                     conversionDataList.removeWhere(
  //                       (data) => data.dropdownValue == value,
  //                     );
  //                   } else if (isDefaultCurrency) {
  //                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //                       content: Text(
  //                         'You Can\'t remove default currency!!',
  //                         style: TextStyle(color: Colors.white),
  //                       ),
  //                       backgroundColor: Colors.black54,
  //                     ));
  //                   }
  //                 }
  //               });
  //               Navigator.pop(context); // Close the bottom sheet
  //             },
  //           );
  //         }).toList(),
  //       );
  //     },
  //   );
  // }

  ///search
  Future<void> _showCurrencyOptions(BuildContext context) async {
    // Create a TextEditingController for the search field
    TextEditingController searchController = TextEditingController();

    // Initialize a list to store filtered currencies
    List<dynamic> filteredCurrencies = List.from(widget.rates.keys);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: themeController.isDark
          ? DarkColors.bottomSheetColor
          : LightColors.sheetBgColor,
      builder: (BuildContext context) {
        return StatefulBuilder(
          key: scaffoldKey,
          builder: (BuildContext context, StateSetter setState1) {
            void handleClearSearch() {
              searchController.clear();
              filteredCurrencies = List.from(widget.rates.keys);
              setState1(() {});
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: LightColors.leftOperatorColor,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontFamily: 'Poppins',
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black),
                    controller: searchController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp("^[ ]"))
                    ],
                    decoration: InputDecoration(
                      hintText: StringUtils.searchCurrency,
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: themeController.isDark
                                  ? LightColors.leftOperatorColor
                                  : LightColors.leftOperatorColor)),
                      hintStyle: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'Poppins',
                          color: themeController.isDark
                              ? Colors.grey
                              : Colors.grey),
                      suffixIcon: IconButton(
                          onPressed: () {
                            handleClearSearch();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          icon: Icon(
                            size: 14.sp,
                            Icons.close,
                            color: themeController.isDark
                                ? Colors.grey
                                : Colors.grey,
                          )),
                      prefixIcon: Icon(
                        size: 14.sp,
                        Icons.search,
                        color:
                            themeController.isDark ? Colors.grey : Colors.grey,
                      ),
                    ),
                    onChanged: (value) {
                      setState1(() {
                        // Update the filteredCurrencies list based on user input
                        filteredCurrencies = widget.rates.keys
                            .where((currency) => currency
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: filteredCurrencies.map((value) {
                      bool isSelected = conversionDataList.any(
                        (data) => data.dropdownValue == value,
                      );

                      bool isDefaultCurrency = value == defaultCurrency;

                      return ListTile(
                        title: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.w),
                              child: Text(
                                '$value '
                                // '- ${widget.currencies[value]}'
                                ,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  color: themeController.isDark
                                      ? CommonColors.white
                                      : CommonColors.black,
                                ),
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              IconButton(
                                icon: Icon(
                                  Icons.check,
                                  size: 15.sp,
                                  color: themeController.isDark
                                      ? CommonColors.white
                                      : CommonColors.black,
                                ),
                                onPressed: () {
                                  setState1(() {
                                    if (!isDefaultCurrency) {
                                      conversionDataList.removeWhere(
                                        (data) => data.dropdownValue == value,
                                      );
                                      widget.onCurrencySelected(value);
                                    }
                                  });
                                },
                              ),
                          ],
                        ),
                        onTap: () {
                          setState1(() {
                            if (!isSelected) {
                              ConversionData newData = ConversionData();
                              newData.amountController.addListener(() {
                                if (isConvert) {
                                  updateConversionData(newData);
                                }
                              });

                              newData.dropdownValue = value;

                              String conversionResult = Utils.convert(
                                widget.rates,
                                conversionDataList[selectedIndex]
                                    .amountController
                                    .text,
                                conversionDataList[selectedIndex].dropdownValue,
                                newData.dropdownValue,
                              );

                              double? convertedAmount =
                                  double.tryParse(conversionResult);

                              if (convertedAmount != null) {
                                newData.amountController.text =
                                    conversionResult.toString();
                                newData.convertedAmount = convertedAmount;
                              }

                              conversionDataList.add(newData);
                              widget.onCurrencySelected(value);
                            } else {
                              if (!isDefaultCurrency) {
                                conversionDataList.removeWhere(
                                  (data) => data.dropdownValue == value,
                                );
                                widget.onCurrencySelected(value);
                              } else if (isDefaultCurrency) {
                                Get.snackbar(
                                  StringUtils.warning,
                                  snackStyle: SnackStyle.FLOATING,
                                  StringUtils.youCantRemoveDefaultCurrency,
                                  snackPosition: SnackPosition.BOTTOM,
                                  dismissDirection: DismissDirection.startToEnd,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black54,
                                  titleText: Text(
                                    StringUtils.warning,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  messageText: Text(
                                    StringUtils.youCantRemoveDefaultCurrency,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  icon: Icon(
                                    size: 12.sp,
                                    Icons.add_alert,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void selectConverter(ConversionData data) {
    for (var converter in conversionDataList) {
      converter.isSelected = false;
    }
    data.isSelected = true;
    setState(() {});
  }

  ///delete container
  void _deleteConversionData(int index) {
    setState(() {
      if (index != 0) {
        conversionDataList.removeAt(index);
      }
    });
  }

  ///dialog of delete container
  void showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            StringUtils.deleteCurrencyConverter,
            style: TextStyle(fontSize: 12.sp),
          ),
          content: Text(
            StringUtils.areYouSureYouWantToDeleteCurrencyConverter,
            style: TextStyle(fontSize: 12.sp),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                StringUtils.no,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            TextButton(
              onPressed: () {
                if (index != 0) {
                  _deleteConversionData(index);
                } else {
                  Get.snackbar(
                    StringUtils.warning,
                    StringUtils.youCantDeleteDefaultUsdConverter,
                    snackPosition: SnackPosition.BOTTOM,
                    dismissDirection: DismissDirection.startToEnd,
                    colorText: Colors.white,
                    isDismissible: true,
                    titleText: Text(
                      StringUtils.warning,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    messageText: Text(
                      StringUtils.youCantRemoveDefaultCurrency,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Colors.black54,
                    icon: Icon(
                      Icons.add_alert,
                      size: 12.sp,
                      color: Colors.white,
                    ),
                  );
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                StringUtils.yes,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    saveDataToSharedPreferences();
    for (var data in conversionDataList) {
      data.amountController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();
    return SingleChildScrollView(
      // physics: ,
      child: Padding(
        padding: EdgeInsets.all(7.w),
        child: Column(
          children: [
            SizedBox(
              // height: 69.h,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: conversionDataList.length,
                itemBuilder: (context, index) {
                  ConversionData data = conversionDataList[index];
                  return Column(
                    children: [
                      Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const StretchMotion(),
                          children: [
                            // A SlidableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (context) {
                                showDeleteConfirmationDialog(context, index);
                              },
                              borderRadius: BorderRadius.circular(4.w),
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: StringUtils.delete,
                            ),
                          ],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            selectConverter(data);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(2.5.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.w),
                                  color: themeController.isDark
                                      ? DarkColors.bottomSheetColor
                                      : Colors.white,
                                  border: Border.all(
                                    color: data.isSelected
                                        ? LightColors.leftOperatorColor
                                        : Colors.grey,
                                    width: data.isSelected ? 0.6.w : 0.2.w,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ///without search dropdown

                                    Expanded(
                                      flex: 7,
                                      child: SearchChoices.single(
                                        items: widget.rates.keys
                                            .toList()
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 4.w),
                                              child: Text(
                                                '$value '
                                                // '- ${widget.currencies[value]}'
                                                ,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: themeController
                                                            .isDark
                                                        ? LightColors
                                                            .leftOperatorColor
                                                        : LightColors
                                                            .leftOperatorColor,
                                                    fontSize: 12.sp),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        value: data.dropdownValue,
                                        hint: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: DropdownMenuItem(
                                            child: Text(
                                              StringUtils.selectCurrency,
                                              style: const TextStyle(
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                        ),
                                        menuBackgroundColor:
                                            themeController.isDark
                                                ? DarkColors.bottomSheetColor
                                                : CommonColors.white,

                                        // searchHint: "Select Currency",
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            if (index == 0) {
                                              Get.snackbar(
                                                StringUtils.warning,
                                                StringUtils
                                                    .youCantRemoveDefaultCurrency,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                dismissDirection:
                                                    DismissDirection.endToStart,
                                                titleText: Text(
                                                  StringUtils.warning,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                messageText: Text(
                                                  StringUtils
                                                      .youCantRemoveDefaultCurrency,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                colorText: Colors.white,
                                                backgroundColor: Colors.black54,
                                                icon: Icon(
                                                  Icons.add_alert,
                                                  size: 15.sp,
                                                  color: Colors.white,
                                                ),
                                              );
                                            } else {
                                              // Allow changing currency for subsequent containers
                                              data.dropdownValue = newValue!;
                                              if (isConvert) {
                                                updateConversionData(data);
                                              }
                                            }
                                          });
                                        },
                                        isExpanded: true,

                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Poppins',
                                            color: themeController.isDark
                                                ? CommonColors.white
                                                : CommonColors.black),
                                        // doneButton: Text('Done'),
                                        searchInputDecoration: InputDecoration(
                                          icon: Icon(
                                            Icons.search,
                                            size: 20.sp,
                                            color:
                                                LightColors.leftOperatorColor,
                                          ),
                                          focusedBorder:
                                              const UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: LightColors
                                                  .leftOperatorColor, // Set your desired focused border color here
                                              width: 1.0,
                                            ),
                                          ),
                                        ),
                                        fieldDecoration: BoxDecoration(
                                          color: themeController.isDark
                                              ? DarkColors.bottomSheetColor
                                              : CommonColors.white,
                                        ),
                                        displayClearIcon: false,
                                        iconDisabledColor: Colors.grey,
                                        iconEnabledColor: Colors.grey,

                                        selectedValueWidgetFn: (selectedValue) {
                                          return DropdownMenuItem(
                                            // value: value,
                                            child: Text(
                                              '$selectedValue ',
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                color: themeController.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Expanded(
                                      flex: 2,
                                      child: TextFormField(
                                        cursorColor: themeController.isDark
                                            ? LightColors.leftOperatorColor
                                            : LightColors.leftOperatorColor,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontFamily: 'Poppins',
                                            color: themeController.isDark
                                                ? CommonColors.white
                                                : CommonColors.black),
                                        onChanged: (value) {},
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^\d+\.?\d*')),
                                        ],
                                        controller: data.amountController,
                                        enableInteractiveSelection: false,
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                            decimal: true, signed: true),
                                        decoration: InputDecoration(
                                          hintText: StringUtils.egHundred,
                                          hintStyle: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: Colors.grey,
                                              fontSize: 12.sp),
                                          border: InputBorder.none,
                                        ),
                                        onTap: () {
                                          data.amountController.clear();
                                          selectConverter(data);
                                        },
                                        onEditingComplete: () {
                                          isConvert = true;
                                          // Handle "Done" button press here
                                          // You can call your updateConversionData method here
                                          updateConversionData(data);
                                          isConvert = false;
                                          FocusScope.of(context).unfocus();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 1.w),
                                    data.isSelected
                                        ? Icon(Icons.calculate,
                                            size: 15.sp,
                                            color: themeController.isDark
                                                ? LightColors.leftOperatorColor
                                                : LightColors.leftOperatorColor)
                                        : Icon(
                                            Icons.more_vert,
                                            size: 15.sp,
                                            color: Colors
                                                .grey, // Show 3-dot icon when not selected
                                          ),
                                  ],
                                ),
                              ),
                              // SizedBox(height: 2.h),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 4.w),

            /// add currency option
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async {
                  saveDataToSharedPreferences();
                  await _showCurrencyOptions(context);
                },
                child: Container(
                  width: 45.w,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      color: LightColors.leftOperatorColor,
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 15.sp,
                        color: themeController.isDark
                            ? CommonColors.white
                            : CommonColors.white,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        StringUtils.addCurrency,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            color: themeController.isDark
                                ? CommonColors.white
                                : CommonColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.w),
          ],
        ),
      ),
    );
  }
}

class Utils {
  static String convert(
      Map<dynamic, dynamic> rates, String amount, String from, String to) {
    try {
      double result = double.parse(amount) *
          (rates[to] as double) /
          (rates[from] as double);
      String formattedResult = result.toStringAsFixed(2);
      if (formattedResult.endsWith('.00')) {
        formattedResult =
            formattedResult.substring(0, formattedResult.length - 3);
      }

      return formattedResult;
    } catch (e) {
      return StringUtils.invalidInput;
    }
  }
}
