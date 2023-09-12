import 'dart:developer';

import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:math_expressions/math_expressions.dart';

class ScientificController extends GetxController {
  var userInput = "";
  var userOutput = "0";
  var isNegative = false;
  int cursorPosition = 0;
  final buttonText = "Rad".obs;

  /// Declare a flag to track if a dot is present in the current number
  bool dotAllowed = true;

  // Method to toggle the button text.
  toggleButtonText() {
    if (buttonText.value == "Rad") {
      buttonText.value = "Deg";
    } else {
      buttonText.value = "Rad";
    }
  }

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputFC = userInput;

    log('====$userInput');
    log('====userInputFC===$userInputFC');

    ///  y√x
    // Handle the "y√x" expression by capturing both inputs and inserting them
    final ySqrtXRegExp = RegExp(r'(\d+)√(\d+)');
    final matches = ySqrtXRegExp.allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString(); // Convert to non-null string
      final y = match.group(1); // Captured y
      final x = match.group(2); // Captured x
      final result = "($x)^(1/$y)";
      userInputFC = userInputFC.replaceFirst(fullMatch, result);
    }

    userInputFC = userInputFC
        .replaceAll("x", "*")
        .replaceAll("/", "/")
        .replaceAll("-", "-")
        .replaceAll("+", "+")
        .replaceAll("x²", "^2")
        .replaceAll("x³", "^3")
        .replaceAll("EE", "*10^")
        .replaceAll("xʸ", "^")
        .replaceAll("2√x", "sqrt")
        .replaceAll("∛x", "pow($userInput, 1/3)") // Cube root calculation
        .replaceAll("10ˣ", "pow(10,")
        .replaceAll('eˣ', 'exp')
        .replaceAll("+/-", "-")
        .replaceAll("1/x", "1/")
        .replaceAll('X!', '!')
        .replaceAll('e', '${math.e}')
        .replaceAll('π', '${math.pi}');

    if (userInputFC.contains("e^")) {
      // Extract the portion after "e^" and calculate the result
      String inputAfterExponent = userInputFC.split("e^")[1];
      double? input = double.tryParse(inputAfterExponent);
      if (input != null) {
        double result = math.exp(input);
        userOutput = result.toString();
      } else {
        userOutput = 'Error';
      }
    }

    // Handle the "log₁₀" operation
    if (userInputFC.contains("log₁₀")) {
      final logMatches = RegExp(r'log₁₀\(([^)]+)\)').allMatches(userInputFC);
      for (var match in logMatches) {
        final fullMatch = match.group(0).toString();
        final innerValue = match.group(1);
        double? input = double.tryParse(innerValue!);
        if (input != null && input > 0) {
          double result = math.log(input) / math.log(10);
          userInputFC = userInputFC.replaceFirst(fullMatch, result.toString());
        } else {
          userOutput = "Invalid input";
          update();
          return;
        }
      }
    }

    // Handle the "In" operation
    if (userInputFC.contains("In(")) {
      final inMatches = RegExp(r'In\(([^)]+)\)').allMatches(userInputFC);
      for (var match in inMatches) {
        final fullMatch = match.group(0).toString();
        final innerValue = match.group(1);
        double? input = double.tryParse(innerValue!);
        if (input != null && input > 0) {
          double result = math.log(input);
          userInputFC = userInputFC.replaceFirst(fullMatch, result.toString());
        } else {
          userOutput = "Invalid input";
          update();
          return;
        }
      }
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(userInputFC);
      ContextModel ctx = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, ctx);

      if (eval % 1 == 0) {
        // If the result is an integer, convert it to an integer and then to a string
        userOutput = eval.toInt().toString();
        userInput = eval.toInt().toString();
      } else {
        // If it's not an integer, keep it as a double with 2 decimal places
        userOutput = eval.toString();
      }
      // userOutput = eval.toString();
      // userInput = eval.toString();
      print('===ParcerUserOutput: $userOutput');
      print('===ParceruserInputFC: $userInputFC');
    } catch (e) {
      userOutput = 'Error';
    }
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
  void onBtnTapped(List<String> buttons, int index) {
    /// x² button
    if (buttons[index] == 'x²') {
      userInput += "^2";
    }

    /// x³ button
    else if (buttons[index] == 'x³') {
      userInput += "^3";
    }

    /// xʸ button
    else if (buttons[index] == 'xʸ') {
      userInput += "^";
    }

    /// 10ˣ button
    else if (buttons[index] == '10ˣ') {
      if (userInput.isNotEmpty) {
        userInput = "10^$userInput";
      } else {
        userOutput = "0";
      }
    }

    /// "log₁₀" button
    else if (buttons[index] == 'log₁₀') {
      if (userInput.isNotEmpty) {
        double? input = double.tryParse(userInput);
        if (input != null && input > 0) {
          double result =
              math.log(input) / math.log(10); // Calculate the base-10 logarithm
          userInput = "log₁₀($userInput)";
          userOutput = result.toString();
        } else {
          userOutput = "Invalid input";
        }
      } else {
        userOutput = "Not a Number";
      }
    }

    /// eˣ button
    else if (buttons[index] == 'eˣ') {
      // if (userInput.isNotEmpty) {
      double? input = double.tryParse(userInput);
      if (input != null) {
        double result = math.exp(input);
        userInput = "e^$userInput";
        // userOutput = '0';
      } else {
        userInput = 'e^';
        // userOutput = "Not a Number";
      }
      // } else {
      //   userOutput = "0";
      // }
    }

    /// 2√x button
    else if (buttons[index] == '2√x') {
      if (userInput.isNotEmpty) {
        userInput = "sqrt($userInput)";
      } else {
        userOutput = "0";
      }
    }

    /// ∛x button
    else if (buttons[index] == '∛x') {
      userInput += "^(1/3)"; // Add cube root symbol
    }

    /// y√x button
    else if (buttons[index] == 'y√x') {
      userInput += "√"; // Add y√x symbol
    }

    /// In button
    else if (buttons[index] == 'In') {
      if (userInput.isNotEmpty) {
        double? input = double.tryParse(userInput);
        if (input != null && input > 0) {
          double result = math.log(input);
          userInput = "In($userInput)";
          userOutput = result.toString();
        } else {
          userOutput = "Invalid input";
        }
      } else {
        userOutput = "Not a Number";
      }
    }

    /// +/- button
    else if (buttons[index] == '+/-') {
      if (userInput.isNotEmpty) {
        if (isNegative) {
          userInput = userInput.substring(1); // Remove the minus sign
        } else {
          userInput = "-$userInput"; // Add the minus sign
        }
        isNegative = !isNegative; // Toggle the state
      } else {
        userOutput = "0";
      }
    }

    /// 1/x button
    else if (buttons[index] == '1/x') {
      if (userInput.isNotEmpty) {
        userInput = "1/$userInput";
      } else {
        userOutput = 'Not a Number';
      }
    }

    /// X! button
    else if (buttons[index] == 'X!') {
      userInput += "!";
    }

    /// π button
    else if (buttons[index] == 'π') {
      if (userInput.isNotEmpty) {
        final lastChar = userInput[userInput.length - 1];
        if (lastChar == '*' ||
            lastChar == '/' ||
            lastChar == '+' ||
            lastChar == '-') {
          // If the last character is an operator, simply add "π" without multiplication
          userInput += 'π';
        } else {
          // Otherwise, add the multiplication operator before "π"
          userInput += '*π';
        }
      } else {
        // If the input is empty, print the value of π
        userOutput = math.pi.toString();
      }
    }

    /// e button
    else if (buttons[index] == 'e') {
      if (userInput.isNotEmpty) {
        final lastChar = userInput[userInput.length - 1];
        if (lastChar == '*' ||
            lastChar == '/' ||
            lastChar == '+' ||
            lastChar == '-') {
          // If the last character is an operator, simply add "e" without multiplication
          userInput += 'e';
        } else {
          // Otherwise, add the multiplication operator before "e"
          userInput += '*e';
        }
      } else {
        // If the input is empty, print the value of 'e'
        userOutput = math.e.toString();
      }
    }

    /// % button
    else if (buttons[index] == '%') {
      percentButtonPressed();
    }

    /// EE button
    else if (buttons[index] == 'EE') {
      if (userInput.isNotEmpty) {
        userInput += ' EE ';
        // evaluateEEExpression();
      } else {
        userOutput = 'Not a Number';
      }
    }

    /// sin button
    else if (buttons[index] == 'sin') {
      sinButtonPressed();
    }

    /// cos button
    else if (buttons[index] == 'cos') {
      cosButtonPressed();
    }

    /// tan button
    else if (buttons[index] == 'tan') {
      tanButtonPressed();
    }

    /// . button
    else if (buttons[index] == '.') {
      if (dotAllowed) {
        if (userInput.isEmpty) {
          userInput = '0.';
        } else if (RegExp(r'\d$').hasMatch(userInput) &&
            //this will not able to add . if there is already i mean if value is already double
            !userInput.contains('.')) {
          userInput += '.';
        }
        // Set the dotAllowed flag to false to prevent additional dots
        dotAllowed = false;
      }
    }

    /// 00 button
    else if (buttons[index] == "0") {
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

    /// other  buttons
    else {
      userInput += buttons[index];
    }

    evaluateLiveOutput();
    update();
  }

  /// Update userOutput based on the current userInput.
  void evaluateLiveOutput() {
    String userInputFC =
        userInput.replaceAll("x", "*").replaceAll('π', '${math.pi}');
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

  /// Add this function to your ScientificController class
  void percentButtonPressed() {
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
      userOutput = "0";
      update();
    }
  }

  bool isOperator(String str) {
    return ['%', '/', 'x', '-', '.', '+'].contains(str);
  }

  void updateCursorPosition(int position) {
    cursorPosition = position;
    // You can use this cursor position to manipulate your userInput string
  }

  void sinButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-*/]')) + 1
        : 0;

    // Check if there's a number before sin
    final isNumberBeforeSin = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before sin, insert "*sin("; otherwise, insert "sin(".
    if (isNumberBeforeSin) {
      userInput = userInput.substring(0, startIndex) +
          "${userInput.substring(startIndex)}*sin(";
    } else {
      userInput = userInput + "sin(";
    }

    // Update the cursor position to be inside the "sin()" function.
    int newCursorPosition = startIndex +
        (isNumberBeforeSin ? 5 : 4); // 5 is the length of "*sin()".
    updateCursorPosition(newCursorPosition);

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  void cosButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-*/]')) + 1
        : 0;

    // Check if there's a number before cos
    final isNumberBeforeCos = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before cos, insert "*cos("; otherwise, insert "cos(".
    if (isNumberBeforeCos) {
      userInput = userInput.substring(0, startIndex) +
          "${userInput.substring(startIndex)}*cos(";
    } else {
      userInput = userInput + "cos(";
    }

    // Update the cursor position to be inside the "cos()" function.
    int newCursorPosition = startIndex +
        (isNumberBeforeCos ? 5 : 4); // 5 is the length of "*cos()".
    updateCursorPosition(newCursorPosition);

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  void tanButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-*/]')) + 1
        : 0;

    // Check if there's a number before tan
    final isNumberBeforeTan = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before tan, insert "*tan("; otherwise, insert "tan(".
    if (isNumberBeforeTan) {
      userInput = userInput.substring(0, startIndex) +
          "${userInput.substring(startIndex)}*tan(";
    } else {
      userInput = userInput + "tan(";
    }

    // Update the cursor position to be inside the "tan()" function.
    int newCursorPosition = startIndex +
        (isNumberBeforeTan ? 5 : 4); // 5 is the length of "*tan()".
    updateCursorPosition(newCursorPosition);

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }
}
