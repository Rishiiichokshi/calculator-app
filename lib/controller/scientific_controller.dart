import 'dart:developer';

import 'package:get/get.dart';
import 'dart:math' as math;

import 'package:math_expressions/math_expressions.dart';

class ScientificController extends GetxController {
  var userInput = "";
  var userOutput = "";
  var constantInserted = false;

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputFC = userInput;

    log('====$userInput');
    log('====userInputFC===$userInputFC');

    userInputFC = userInputFC
            .replaceAll("x", "*")
            .replaceAll("x²", "^2")
            .replaceAll("x³", "^3")
            .replaceAll("x^y", "^")
            .replaceAll(
              'X!',
              '!',
            )
            .replaceAll(
              'e',
              '${math.e}',
            )
        // .replaceAll(
        //   'π',
        //   '3.1415926535897932',
        // )
        ;

    // Check if a constant has been inserted, and if so, skip further replacements
    if (!constantInserted) {
      userInputFC = userInputFC
          .replaceAll(
            'e',
            '${math.e}',
          )
          .replaceAll(
            'π',
            '3.1415926535897932',
          );
    }

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
    userOutput = "";
    constantInserted = false;
    update();
  }

  /// Delete Button Pressed Func
  deleteBtnAction() {
    if (!constantInserted) {
      userInput = userInput.substring(0, userInput.length - 1);
    }
    update();
  }

  /// on Number Button Tapped
  void onBtnTapped(List<String> buttons, int index) {
    if (buttons[index] == 'x²') {
      userInput += "^2";
    } else if (buttons[index] == 'x³') {
      userInput += "^3";
    } else if (buttons[index] == 'x^y') {
      userInput += "^";
    } else if (buttons[index] == 'X!') {
      userInput += "!";
    } else if (buttons[index] == 'π') {
      userInput = '${math.pi}';
      constantInserted = true;
    } else if (buttons[index] == 'e') {
      userInput = '${math.e}';
      constantInserted = true;
    } else {
      userInput += buttons[index];
    }
    update();
  }
}
