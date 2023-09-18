import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculateController extends GetxController {
  var userInput = "";
  var userOutput = "0";

  /// Declare a flag to track if a dot is present in the current number
  bool dotAllowed = true;

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputFC = userInput;
    userInputFC = userInputFC.replaceAll("x", "*");
    Parser p = Parser();
    Expression exp = p.parse(userInputFC);
    ContextModel ctx = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, ctx);

    userOutput = eval.toString();
    userInput = eval.toString();
    update();
  }

  /// Clear Button Pressed Func
  clearInputAndOutput() {
    userInput = "";
    userOutput = "0";
    dotAllowed = true;
    update();
  }

  /// Delete Button Pressed Func
  deleteBtnAction() {
    userInput = userInput.substring(0, userInput.length - 1);
    update();
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

    // /// . button
    // else if (buttons[index] == '.') {
    //   if (dotAllowed) {
    //     if (userInput.isEmpty) {
    //       userInput = '0.';
    //     } else if (RegExp(r'\d$').hasMatch(userInput)) {
    //       userInput += '.';
    //     }
    //     // Set the dotAllowed flag to false to prevent additional dots
    //     dotAllowed = false;
    //   }
    // }
    /// . button
    else if (buttons[index] == '.') {
      if (userInput.isEmpty ||
          userInput.endsWith('.') ||
          !isDigit(userInput[userInput.length - 1])) {
        // If there is no input yet, start with '0.'
        userInput += '0.';
      } else {
        final parts = userInput.split(RegExp(r'[+\-*/]'));
        final lastPart = parts.last;
        if (!lastPart.contains('.')) {
          // Only add a dot if the last part doesn't already contain a dot
          userInput += '.';
        }
      }
    }

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
        userOutput = eval.toString();
      } catch (e) {
        // userOutput = 'Error';
        print(e);
      }
    }
    evaluateLiveOutput();
    update();
  }

  bool isOperator(String str) {
    return ['%', '/', 'x', '-', '.', '+'].contains(str);
  }

  /// Update userOutput based on the current userInput.
  void evaluateLiveOutput() {
    String userInputFC = userInput.replaceAll("x", "*");

    try {
      Parser p = Parser();
      Expression exp = p.parse(userInputFC);
      ContextModel ctx = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, ctx);
      if (eval % 1 == 0) {
        // If the result is an integer, convert it to an integer and then to a string
        userOutput = eval.toInt().toString();
      } else {
        // If it's not an integer, keep it as a double with 2 decimal places
        userOutput = eval.toString();
      }
      print('===LiveOutput: $userOutput');
    } catch (e) {
      print('===Error: $e');
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
