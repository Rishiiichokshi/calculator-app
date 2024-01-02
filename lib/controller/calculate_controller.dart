import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:math_expressions/math_expressions.dart';

import '../utils/string_utils.dart';

class CalculateController extends GetxController {
  var userInput = "";
  var userOutput = "0";
  double lastResult = 0.0;
  int equalButtonClickCount = 0;
  ScrollController inputScrollController = ScrollController();
  final NumberFormat numberFormat = NumberFormat.decimalPattern();

  /// Declare a flag to track if a dot is present in the current number
  bool dotAllowed = true;

  void initialiseInputAndOutput(var input, var output) {
    userInput = input;
    userOutput = output;
    update();
  }

  String formatNumber(double number) {
    // final digitsThreshold = 13; // Threshold set to 13 digits
    //
    // if (number.abs().toString().length > digitsThreshold) {
    //   final formatted = number.toStringAsExponential();
    //   return formatted;
    // } else {
    //   return numberFormat.format(number);
    // }
    const threshold = 99999999999999; // Set the threshold to your desired value
    if (number.abs() >= threshold) {
      final formatted = number.toStringAsExponential();
      final parts = formatted.split('e');
      final doublePart = double.parse(parts[0]).toStringAsFixed(7);
      final exponentPart = parts[1].padLeft(2, '0');
      return '$doublePart e$exponentPart';
    } else {
      return numberFormat.format(number);
    }
    // final formatted = number.toStringAsExponential();
    // final parts = formatted.split('e');
    // final doublePart = double.parse(parts[0]).toStringAsFixed(7);
    // final exponentPart = parts[1].padLeft(2, '0');
    // return '$doublePart e$exponentPart';
  }

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputFC = userInput;
    userInputFC = userInputFC.replaceAll("x", "*");
    Parser p = Parser();
    Expression exp = p.parse(userInputFC);
    ContextModel ctx = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, ctx);

    try {
      double eval = exp.evaluate(EvaluationType.REAL, ctx) as double;
      if (eval.isFinite) {
        // Append the last operation to the input string only on the second click
        if (equalButtonClickCount > 0) {
          RegExpMatch? lastOperationMatch =
              RegExp(r'([+\-x/]+)(\d+(?:\.\d+)?)$').firstMatch(userInput);
          if (lastOperationMatch != null) {
            String? lastOperator = lastOperationMatch.group(1) ?? '';
            String? lastOperand = lastOperationMatch.group(2) ?? '';
            userInput += lastOperator + lastOperand;
            evaluateLiveOutput();
          }
        } else {
          evaluateLiveOutput();
        }
        // Update the last evaluated result
        lastResult = eval;
        print('userInput====$userInput');
        equalButtonClickCount++;
      } else {
        userOutput = 'Error';
        logs('Error: Result is not a finite number');
      }
    } catch (e) {
      userOutput = 'Error';
      logs('Error: $e');
    }

    // try {
    //   double eval = exp.evaluate(EvaluationType.REAL, ctx) as double;
    //   if (eval.isFinite) {
    //     RegExpMatch? lastOperationMatch =
    //         RegExp(r'([+\-x/]+)(\d+(?:\.\d+)?)$').firstMatch(userInput);
    //     if (lastOperationMatch != null) {
    //       String? lastOperator = lastOperationMatch.group(1) ?? '';
    //       String? lastOperand = lastOperationMatch.group(2) ?? '';
    //       // print('eval.toString()--${eval.toString()}');
    //       userInput += lastOperator + lastOperand;
    //       evaluateLiveOutput();
    //     }
    //
    //     print('userInput====$userInput');
    //     // userInput = formatNumber(eval);
    //     // userOutput = formatNumber(eval);
    //   } else {
    //     userOutput = 'Error';
    //     logs('Error: Result is not a finite number');
    //   }
    // } catch (e) {
    //   // logs('frd');
    //   userOutput = 'Error';
    //   logs('Error: $e');
    // }

    // if (eval % 1 == 0) {
    //   // If the result is an integer, convert it to an integer and then to a string
    //   userOutput = eval.toInt().toString();
    //   userInput = eval.toInt().toString();
    // } else {
    //   // If it's not an integer, keep it as a double with 2 decimal places
    //   userOutput = eval.toString();
    //   userInput = eval.toInt().toString();
    // }
    update();
  }

  /// Clear Button Pressed Func
  clearInputAndOutput() {
    userInput = "";
    userOutput = "0";
    equalButtonClickCount = 0;
    dotAllowed = true;
    update();
  }

  /// Delete Button Pressed Func
  deleteBtnAction() {
    print('userInput==>$userInput ==>${userInput.length}');
    if (userInput.isNotEmpty) {
      userInput = userInput.substring(0, userInput.length - 1);
      evaluateLiveOutput();
      update();
    } else {
      userOutput = "0";
      update();
    }
  }

  /// on Number Button Tapped
  onBtnTapped(List<String> buttons, int index) {
    /// % button
    if (buttons[index] == '%') {
      percentageButtonPressed();
    }

    /// 00 button & 0 Button
    else if (buttons[index] == "00" || buttons[index] == "0") {
      // If "00" button is pressed, handle it separately
      if (userInput == "0") {
        // If the current input is "0," don't allow further input
        return;
      } else if (userInput.isEmpty) {
        // If there is no input, show only one "0"
        userInput = "0";
      } else {
        userInput += buttons[index];
      }
    }

    ///remove.00
    else if (userInput.endsWith('.00')) {
      // If userInput ends with ".00", remove the ".00" before adding the new digit
      userInput = userInput.substring(0, userInput.length - 3);
      userInput += buttons[index];
    }

    /// . button
    else if (buttons[index] == '.') {
      if (userInput.isEmpty) {
        // If there is no input yet, start with '0.'
        userInput += '0.';
        dotAllowed = false;
      } else {
        final parts = userInput.split(RegExp(r'[+\-x/]'));
        final lastPart = parts.last;
        if (lastPart.isEmpty) {
          // If the last part is empty, add '0.' followed by the dot
          userInput += '0.';
        } else if (!lastPart.contains('.')) {
          // Only add a dot if the last part is not empty and doesn't already contain a dot
          userInput += '.';
        }
        dotAllowed = false;
      }
    }

    // /// . button
    // else if (buttons[index] == '.') {
    //   if (userInput.isEmpty ||
    //       userInput.endsWith('.') ||
    //       !isDigit(userInput[userInput.length - 1])) {
    //     // If there is no input yet, start with '0.'
    //     userInput += '0.';
    //   } else {
    //     final parts = userInput.split(RegExp(r'[+\-*/]'));
    //     final lastPart = parts.last;
    //     if (!lastPart.contains('.')) {
    //       // Only add a dot if the last part doesn't already contain a dot
    //       userInput += '.';
    //     }
    //   }
    // }

    ///this will add isOperator one time only
    else if (isOperator(buttons[index])) {
      // Handle operator button press
      if (userInput.isNotEmpty &&
          !isOperator(userInput[userInput.length - 1])) {
        // Only add the operator if the current input doesn't end with an operator
        userInput += buttons[index];
        // Allow a dot in the next number
        dotAllowed = true;
      } else if (userInput.isNotEmpty &&
          isOperator(userInput[userInput.length - 1])) {
        // Replace the last operator if it's different
        userInput =
            userInput.substring(0, userInput.length - 1) + buttons[index];
      }
    }

    ///other
    else {
      userInput += buttons[index];

      try {
        Parser p = Parser();
        Expression exp = p.parse(userInput);
        ContextModel ctx = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, ctx);
        // userOutput = eval.toString();
      } catch (e) {
        // userOutput = 'Error';
        logs(e.toString());
      }
    }
    /*inputScrollController.jumpTo(
      inputScrollController.position.maxScrollExtent + 20,

      // duration: const Duration(milliseconds: 500),
      // curve: Curves.easeInOut,
    ); */
    inputScrollController.animateTo(
      inputScrollController.position.maxScrollExtent + 20,
      duration: const Duration(milliseconds: 10),
      curve: Curves.ease,
    );
    // evaluateLiveOutput();
    update();
  }

  bool isOperator(String str) {
    return ['%', '/', 'x', '-', '.', '+'].contains(str);
  }

  /// Update userOutput based on the current userInput.
  void evaluateLiveOutput() {
    String userInputFC = userInput.replaceAll("x", "*");

    if (userInputFC.isNotEmpty && userInputFC.endsWith('.')) {
      // If userInput ends with a dot and there is no more input, remove the dot
      userInputFC = userInputFC.substring(0, userInputFC.length - 1);
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(userInputFC);
      ContextModel ctx = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, ctx);
      if (eval.isFinite) {
        userOutput = formatNumber(eval);
      } else {
        userOutput = 'Error';
        logs('Error: Result is not a finite number');
      }
      // if (eval % 1 == 0) {
      //   // If the result is an integer, convert it to an integer and then to a string
      //   userOutput = eval.toInt().toString();
      // } else {
      //   // If it's not an integer, keep it as a double with 2 decimal places
      //   userOutput = eval.toString();
      // }
      logs('===LiveOutput: $userOutput');
    } catch (e) {
      logs('===Error: $e');
    }
    update();
  }

  /// Percentage Button Pressed Func
  percentageButtonPressed() {
    if (userInput.isNotEmpty) {
      try {
        Parser p = Parser();
        Expression exp = p.parse(userInput);
        ContextModel ctx = ContextModel();
        double eval = exp.evaluate(EvaluationType.REAL, ctx);
        double percentage = eval / 100;
        userOutput = percentage.toString();
        userInput = percentage.toString();
        update();
      } catch (e) {
        userOutput = 'Error';
        update();
      }
    } else {
      userOutput = "0.00";
      update();
    }
  }

  bool isDigit(String char) {
    return RegExp(r'\d').hasMatch(char);
  }
}
