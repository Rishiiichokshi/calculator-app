import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/theme_controller.dart';
import '../../utils/colors.dart';

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
  _TestConversionCardState createState() => _TestConversionCardState();
}

class ConversionData {
  TextEditingController amountController = TextEditingController();
  String dropdownValue = 'USD';
  String conversion = '';
  double convertedAmount = 0.0;
  bool isSelected = false;
}

class _TestConversionCardState extends State<TestConversionCard> {
  List<ConversionData> conversionDataList = [];
  ConversionData data = ConversionData();
  bool isLoading = false;
  String defaultCurrency = 'USD';
  int selectedIndex = 0;
  bool isConvert = false;
  var themeController = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();

    conversionDataList.add(ConversionData());
    for (var data in conversionDataList) {
      data.amountController.addListener(() {
        updateConversionData(data);
      });
    }

    conversionDataList[0].dropdownValue = defaultCurrency;
    Future.delayed(Duration.zero, () {
      conversionDataList[0].amountController.text = '1';
      setState(() {});
    });
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
    List<dynamic> filteredCurrencies = List.from(widget.currencies.keys);
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
              // Reset the filteredCurrencies list to show all items
              filteredCurrencies = List.from(widget.currencies.keys);

              setState1(() {}); // Trigger a rebuild of the bottom sheet's UI
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: LightColors.leftOperatorColor,
                    style: TextStyle(
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black),
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Currency',
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: themeController.isDark
                                  ? LightColors.leftOperatorColor
                                  : LightColors.leftOperatorColor)),
                      hintStyle: TextStyle(
                          color: themeController.isDark
                              ? Colors.grey
                              : Colors.grey),
                      suffixIcon: IconButton(
                          onPressed: () {
                            handleClearSearch();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          icon: Icon(
                            Icons.close,
                            color: themeController.isDark
                                ? Colors.grey
                                : Colors.grey,
                          )),
                      prefixIcon: Icon(
                        Icons.search,
                        color:
                            themeController.isDark ? Colors.grey : Colors.grey,
                      ),
                    ),
                    onChanged: (value) {
                      setState1(() {
                        // Update the filteredCurrencies list based on user input
                        filteredCurrencies = widget.currencies.keys
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
                            SizedBox(
                              width: 79.w,
                              child: Text(
                                '$value - ${widget.currencies[value]}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: themeController.isDark
                                      ? CommonColors.white
                                      : CommonColors.black,
                                ),
                              ),
                            ),
                            if (isSelected)
                              IconButton(
                                icon: Icon(
                                  Icons.check,
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
                                  'Warning',
                                  'You Can\'t remove default currency!!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  dismissDirection: DismissDirection.startToEnd,
                                  colorText: Colors.white,
                                  backgroundColor: Colors.black54,
                                  icon: const Icon(
                                    Icons.add_alert,
                                    color: Colors.white,
                                  ),
                                );
                                // ScaffoldMessenger.of(context)
                                //     .showSnackBar(const SnackBar(
                                //   content: Text(
                                //     'You Can\'t remove default currency!!',
                                //     style: TextStyle(color: Colors.white),
                                //   ),
                                //   backgroundColor: Colors.black54,
                                // ));
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
          title: const Text('Delete Currency Converter'),
          content: const Text(
              'Are you sure you want to delete this currency converter?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                if (index != 0) {
                  _deleteConversionData(index);
                } else {
                  Get.snackbar(
                    'Warning',
                    'You can\'t delete the default USD converter!',
                    snackPosition: SnackPosition.BOTTOM,
                    dismissDirection: DismissDirection.startToEnd,
                    colorText: Colors.white,
                    backgroundColor: Colors.black54,
                    icon: const Icon(
                      Icons.add_alert,
                      color: Colors.white,
                    ),
                  );
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //     content: Text(
                  //       'You can\'t delete the default USD converter!',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     backgroundColor: Colors.black54,
                  //   ),
                  // );
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
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
              height: 73.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: conversionDataList.length,
                itemBuilder: (context, index) {
                  ConversionData data = conversionDataList[index];
                  return Slidable(
                    key: const ValueKey(0),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      // dismissible: DismissiblePane(onDismissed: () {}),
                      children: [
                        // A SlidableAction can have an icon and/or a label.
                        SlidableAction(
                          onPressed: (context) {
                            showDeleteConfirmationDialog(context, index);
                          },
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
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
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    // Define the background color for the dropdown menu
                                    canvasColor: themeController.isDark
                                        ? DarkColors.bottomSheetColor
                                        : CommonColors.white,
                                  ),
                                  child: Expanded(
                                    flex: 6,
                                    child: DropdownButton<String>(
                                      borderRadius: BorderRadius.circular(4.w),
                                      menuMaxHeight: 50.h,
                                      value: data.dropdownValue,

                                      icon: Icon(
                                        Icons.arrow_drop_down_rounded,
                                        color: themeController.isDark
                                            ? LightColors.btnBgColor
                                            : CommonColors.black,
                                      ),
                                      isExpanded: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          if (index == 0) {
                                            Get.snackbar(
                                              'Warning',
                                              'You can\'t change the default currency!',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              dismissDirection:
                                                  DismissDirection.endToStart,
                                              colorText: Colors.white,
                                              backgroundColor: Colors.black54,
                                              icon: const Icon(
                                                Icons.add_alert,
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
                                      onTap: () {
                                        selectConverter(data);
                                      },
                                      underline:
                                          Container(), // Removes the default underline

                                      items: widget.currencies.keys
                                          .toList()
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            '$value - ${widget.currencies[value]}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: themeController.isDark
                                                    ? LightColors
                                                        .leftOperatorColor
                                                    : LightColors
                                                        .leftOperatorColor),
                                          ),
                                        );
                                      }).toList(),
                                    ),
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
                                        color: themeController.isDark
                                            ? CommonColors.white
                                            : CommonColors.black),
                                    onChanged: (value) {
                                      // setState(() {});
                                      // value = data.amountController.text;
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d+\.?\d*')),
                                    ],
                                    controller: data.amountController,
                                    enableInteractiveSelection: false,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'eg. 100',
                                      hintStyle: TextStyle(color: Colors.grey),
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
                                        size: 6.4.w,
                                        color: themeController.isDark
                                            ? LightColors.leftOperatorColor
                                            : LightColors.leftOperatorColor)
                                    : Icon(
                                        Icons.more_vert,
                                        size: 6.4.w,
                                        color: Colors
                                            .grey, // Show 3-dot icon when not selected
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),

            /// add currency option
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () async {
                  await _showCurrencyOptions(context);
                },
                child: Container(
                  width: 40.w,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      color: LightColors.leftOperatorColor,
                      borderRadius: BorderRadius.circular(10.w)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: themeController.isDark
                            ? CommonColors.white
                            : CommonColors.white,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Add Currency',
                        style: TextStyle(
                            color: themeController.isDark
                                ? CommonColors.white
                                : CommonColors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.h),
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
      return 'Invalid input';
    }
  }
}
