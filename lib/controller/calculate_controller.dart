import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculateController extends GetxController {
  var userInput = "";
  var userOutput = "0";

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputFC = userInput;
    userInputFC = userInputFC.replaceAll("x", "*");
    Parser p = Parser();
    Expression exp = p.parse(userInputFC);
    ContextModel ctx = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, ctx);

    userOutput = eval.toStringAsFixed(2);
    userInput = eval.toStringAsFixed(2);
    update();
  }

  /// Clear Button Pressed Func
  clearInputAndOutput() {
    userInput = "";
    userOutput = "0";
    update();
  }

  /// Delete Button Pressed Func
  deleteBtnAction() {
    userInput = userInput.substring(0, userInput.length - 1);
    update();
  }

  /// on Number Button Tapped
  onBtnTapped(List<String> buttons, int index) {
    if (buttons[index] == '%') {
      percentageButtonPressed();
    }

    /// 00 button
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
    /// || isOperator(userInput[userInput.length - 1]) add this line to use of single dot only
    else if (buttons[index] == '.') {
      if (userInput.isEmpty) {
        userInput += '0.';
      } else if (!userInput.contains('.')) {
        userInput += '.';
      }
    }

    ///this will add isOperator one time only
    else if (isOperator(buttons[index])) {
      // Handle operator button press
      if (userInput.isNotEmpty &&
          !isOperator(userInput[userInput.length - 1])) {
        // Only add the operator if the current input doesn't end with an operator
        userInput += buttons[index];
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
        userOutput = eval.toStringAsFixed(2);
      } catch (e) {
        // userOutput = 'Error';
        print(e);
      }
    }
    update();
  }

  bool isOperator(String str) {
    return ['%', '/', 'x', '-', '.', '+'].contains(str);
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
        userOutput = percentage.toStringAsFixed(2);
        userInput = percentage.toStringAsFixed(2);
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
}
