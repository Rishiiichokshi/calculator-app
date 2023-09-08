import 'dart:developer';

import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:math_expressions/math_expressions.dart';

class ScientificController extends GetxController {
  var userInput = "";
  var userOutput = "0";
  // var constantInserted = false;
  var isNegative = false;

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
        .replaceAll("x²", "^2")
        .replaceAll("x³", "^3")
        .replaceAll("xʸ", "^")
        .replaceAll("2√x", "sqrt")
        // .replaceAll("y√x", "^(1/")
        .replaceAll("∛x", "pow($userInput, 1/3)") // Cube root calculation
        .replaceAll("10ˣ", "pow(10,")
        .replaceAll('eˣ', 'exp')
        .replaceAll("+/-", "-")
        .replaceAll("1/x", "1/")
        .replaceAll('X!', '!')
        .replaceAll('e', '${math.e}')
        .replaceAll('π', '3.1415926535897932');

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

    // Check if a constant has been inserted, and if so, skip further replacements
    // if (!constantInserted) {
    //   userInputFC = userInputFC
    //       .replaceAll(
    //         'e',
    //         '${math.e}',
    //       )
    //       .replaceAll(
    //         'π',
    //         '3.1415926535897932',
    //       );
    // }

    try {
      Parser p = Parser();
      Expression exp = p.parse(userInputFC);
      ContextModel ctx = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, ctx);

      userOutput = eval.toString();
      userInputFC = eval.toString();
      print('===ParcerUserOutput: $userOutput');
      print('===ParceruserInputFC: $userInputFC');
    } catch (e) {
      // Handle the exception and provide a user-friendly error message.
      userOutput = 'Error';
    }
    update();
  }

  /// Clear Button Pressed Func
  clearInputAndOutput() {
    userInput = "";
    userOutput = "0";
    // constantInserted = false;
    update();
  }

  /// Delete Button Pressed Func
  deleteBtnAction() {
    // if (!constantInserted) {
    userInput = userInput.substring(0, userInput.length - 1);
    // }
    update();
  }

  /// on Number Button Tapped
  void onBtnTapped(List<String> buttons, int index) {
    ///if there is already in input In then this cant able to edit user input
    if (userInput.contains("In")) {
      return;
    }

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

    /// eˣ button
    else if (buttons[index] == 'eˣ') {
      if (userInput.isNotEmpty) {
        double? input = double.tryParse(userInput);
        if (input != null) {
          double result = math.exp(input);
          userInput = "e^$userInput";
          userOutput = '0';
        } else {
          userOutput = "Not a Number";
        }
      } else {
        userOutput = "0";
      }
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
      userInput = 'π';
      // constantInserted = true;
    }

    /// e button
    else if (buttons[index] == 'e') {
      userInput = 'e';
      // constantInserted = true;
    }

    /// other  buttons
    else {
      userInput += buttons[index];
    }
    update();
  }
}
