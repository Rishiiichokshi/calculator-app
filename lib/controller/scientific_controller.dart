import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:math_expressions/math_expressions.dart';

class ScientificController extends GetxController {
  var userInput = "";
  var userOutput = "";

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputFC = userInput;
    userInputFC = userInputFC
        .replaceAll("x²", "^2")
        .replaceAll("x", "*")
        .replaceAll(
          'X!',
          '!',
        )
        .replaceAll(
          'e',
          '${math.e}',
        );
    try {
      Parser p = Parser();
      Expression exp = p.parse(userInputFC);
      ContextModel ctx = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, ctx);

      userOutput = eval.toString();
      print('userOutput: $userOutput');
    } catch (e) {
      // Handle the exception and provide a user-friendly error message.
      userOutput = 'Error';
    }
    update();
  }

  /// Clear Button Pressed Func
  clearInputAndOutput() {
    userInput = "";
    userOutput = "";
    update();
  }

  /// Delete Button Pressed Func
  deleteBtnAction() {
    userInput = userInput.substring(0, userInput.length - 1);
    update();
  }

  /// on Number Button Tapped
  void onBtnTapped(List<String> buttons, int index) {
    if (buttons[index] == 'x²') {
      userInput += "²";
    } else if (buttons[index] == 'X!') {
      userInput += "!";
    } else if (buttons[index] == 'π') {
      userInput = '${math.pi}';
    } else if (buttons[index] == 'e') {
      userInput = '${math.e}';
    } else {
      userInput += buttons[index];
    }
    update();
  }
}
