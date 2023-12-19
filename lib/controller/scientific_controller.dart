import 'dart:math';
import 'package:decimal/decimal.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';
import '../utils/string_utils.dart';

class ScientificController extends GetxController {
  var userInput = "";
  var userOutput = "0";
  var isNegative = false;
  int cursorPosition = 0;
  RxString buttonText = "Rad".obs;
  double memoryValue = 0;
  double lastResult = 0.0;
  int equalButtonClickCount = 0;
  final NumberFormat numberFormat = NumberFormat.decimalPattern();

  /// Declare a flag to track if a dot is present in the current number
  bool dotAllowed = true;

  //2nd button toggle
  RxBool isToggleOn = false.obs;

  //2nd button toggle
  void toggleButton() {
    isToggleOn.value = !isToggleOn.value;
    update(); // Notify the UI to update after the toggle
  }

  ///Rat to Deg Button change
  void changeButtonText() {
    buttonText.value = (buttonText.value == "Rad") ? "Deg" : "Rad";
  }

  String formatNumber(double number) {
    const threshold = 99999999999999; // Set the threshold to your desired value
    if (number.abs() >= threshold) {
      print('-------formatted Number If condition');
      final formatted = number.toStringAsExponential();
      final parts = formatted.split('e');
      final doublePart = num.parse(parts[0]).toStringAsFixed(7);
      final exponentPart = parts[1].padLeft(2, '0');
      return '$doublePart e$exponentPart';
    } else {
      print('-------formatted Number Else condition');
      print('Formatted: ${numberFormat.format(number)}');
      return numberFormat.format(number);
    }
  }

  /// Equal Button Pressed Func
  equalPressed() {
    String userInputWithoutCommas = userInput.replaceAll(',', '');
    String userInputFC = userInputWithoutCommas;

    logs('====$userInput');
    logs('====userInputFC===$userInputFC');

    //eˣ
    userInputFC = calculateExponential(userInputFC);

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
        .replaceAll("∛x", "pow($userInput, 1/3)")
        .replaceAll("10ˣ", "pow(10,")
        .replaceAll("2ˣ", "pow(2,")
        .replaceAll('eˣ', 'exp')
        .replaceAll("+/-", "-")
        .replaceAll("1/x", "1/")
        .replaceAll('X!', '!')
        .replaceAll('e', '${math.e}')
        .replaceAll('π', '${math.pi}');

    if (userInputFC.contains("acos")) {
      userInputFC = calculateArccosine(userInputFC);
    }
    if (userInputFC.contains("asin")) {
      userInputFC = calculateArcsine(userInputFC);
    }
    if (userInputFC.contains("atan")) {
      userInputFC = calculateInverseTangent(userInputFC);
    }
    if (userInputFC.contains("sin")) {
      userInputFC = calculateSine(userInputFC);
    }
    if (userInputFC.contains("cos")) {
      userInputFC = calculateCosine(userInputFC);
    }
    if (userInputFC.contains("tan")) {
      userInputFC = calculateTangent(userInputFC);
    }
    if (userInputFC.contains("asinh")) {
      userInputFC = calculateInverseSinh(userInputFC);
    }
    if (userInputFC.contains("acosh")) {
      userInputFC = calculateArcCoshRadian(userInputFC);
    }
    if (userInputFC.contains("atanh")) {
      userInputFC = calculateArcTanhRadian(userInputFC);
    }
    if (userInputFC.contains("^")) {
      userInputFC = handleXPowYExpression(userInputFC);
    }

    //sinh
    userInputFC = calculateSinh(userInputFC);
    //cosh
    userInputFC = calculateCosh(userInputFC);
    //tanh
    userInputFC = calculateTanh(userInputFC);
    // log₁₀
    userInputFC = calculateLogBase10(userInputFC);
    // log₂
    userInputFC = calculateLogBase2(userInputFC);
    //ln
    userInputFC = calculateNaturalLog(userInputFC);
    //y√x
    userInputFC = handleYSqrtXExpression(userInputFC);
    //yˣ
    userInputFC = handleYPowerXExpression(userInputFC);
    //xy
    // userInputFC = handleXPowerYExpression(userInputFC);
    //logᵧ
    userInputFC = handleYLogXExpression(userInputFC);

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
      // print('----parseFormattedNumber----${parseFormattedNumber(userInput)}');
      logs('===Equal press Error ==Error: $e');
      userOutput = 'Error';
    }

    // try {
    //   Parser p = Parser();
    //   Expression exp = p.parse(userInputFC);
    //   ContextModel ctx = ContextModel();
    //   // double eval = exp.evaluate(EvaluationType.REAL, ctx);
    //
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
    //     // userInput = formatNumber(eval);
    //     ///
    //     // userOutput = formatNumber(eval);
    //     // print('----parseFormattedNumber----${parseFormattedNumber(userInput)}');
    //   } else {
    //     userOutput = 'Error';
    //     // print('----parseFormattedNumber----${parseFormattedNumber(userInput)}');
    //     logs('Error: Result is not a finite number');
    //   }
    //
    //   // if (eval % 1 == 0) {
    //   //   // If the result is an integer, convert it to an integer and then to a string
    //   //   userOutput = eval.toInt().toString();
    //   //   userInput = eval.toInt().toString();
    //   // } else {
    //   //   // If it's not an integer, keep it as a double with 2 decimal places
    //   //   userOutput = eval.toString();
    //   //   userInput = eval.toString();
    //   // }
    //   // userOutput = eval.toString();
    //   // userInput = eval.toString();
    //   logs('===ParcerUserOutput: $userOutput');
    //   logs('===ParceruserInputFC: $userInputFC');
    // }

    cursorPosition = userInput.length;
    update();
  }

  bool isDigit(String char) {
    return RegExp(r'\d').hasMatch(char);
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
    evaluateLiveOutput();
    update();
  }

  /// on Number Button Tapped
  void onBtnTapped(List<String> buttons, int index) {
    if (RegExp(r'sin\(\d').hasMatch(userInput)) {
      return;
    }
    if (RegExp(r'cos\(\d').hasMatch(userInput)) {
      return;
    }
    if (RegExp(r'tan\(\d').hasMatch(userInput)) {
      return;
    }
    if (RegExp(r'sinh\(\d').hasMatch(userInput)) {
      return;
    }
    if (RegExp(r'cosh\(\d').hasMatch(userInput)) {
      return;
    }
    if (RegExp(r'tanh\(\d').hasMatch(userInput)) {
      return;
    }
    if (RegExp(r'asin\(\d').hasMatch(userInput)) {
      return;
    }
    if (RegExp(r'acos\(\d').hasMatch(userInput)) {
      return;
    }
    if (RegExp(r'atan\(\d').hasMatch(userInput)) {
      return;
    }

    print('buttons[index]==>${buttons[index]}');

    /// x² button
    if (buttons[index] == 'x²') {
      if (userInput.isEmpty) {
        userOutput = '0';
      } else {
        String sanitizedInput = userInput.replaceAll(',', '');
        try {
          Decimal baseNumber = Decimal.parse(sanitizedInput);
          Decimal squareResult = baseNumber * baseNumber;
          userInput = formatNumber(squareResult.toDouble());
          print('X2 ---userInput--$userInput');

          userOutput = formatNumber(squareResult.toDouble());
          print('---userOutput--$userOutput');
        } catch (e) {
          userOutput = 'Not a Number';
          logs('Error: $e');
        }
      }
    }

    /// x³ button
    // else if (buttons[index] == 'x³') {
    //   if (userInput.isEmpty) {
    //     userOutput = '0';
    //   } else {
    //     // userInput += "^3";
    //     double baseNumber = double.parse(userInput);
    //
    //     // Calculate the square
    //     double squareResult = baseNumber * baseNumber * baseNumber;
    //
    //     // Update userInput and userOutput
    //     userInput = formatNumber(squareResult);
    //     userOutput = formatNumber(squareResult);
    //   }
    // }
    else if (buttons[index] == 'x³') {
      if (userInput.isEmpty) {
        userOutput = '0';
      } else {
        String sanitizedInput = userInput.replaceAll(',', '');
        try {
          Decimal baseNumber = Decimal.parse(sanitizedInput);
          Decimal cubeResult = baseNumber * baseNumber * baseNumber;
          userInput = formatNumber(cubeResult.toDouble());
          userOutput = formatNumber(cubeResult.toDouble());
        } catch (e) {
          userOutput = 'Not a Number';
          logs('Error: $e');
        }
      }
    }

    /// xʸ button
    else if (buttons[index] == 'xʸ') {
      if (userInput.isEmpty) {
        userOutput = '0';
      } else {
        try {
          if (userInput.endsWith('^')) {
            // Do nothing or handle as per your requirement
          } else {
            userInput += '^';
            print('---userInput--$userInput');
            print('---userOutput--$userOutput');
          }
          // userOutput += "^";
          // userOutput = '$userInput';
        } catch (e) {
          userOutput = 'Not a Number';
          logs('Error: $e');
        }
      }
    }

    /// mc button
    else if (buttons[index] == 'mc') {
      clearMemory();
      logs('mc button-----$memoryValue');
    }

    /// m+ button
    else if (buttons[index] == 'm+') {
      onMPlusButtonPressed(double.parse(userOutput));
      logs('m+ button-----$memoryValue');
    }

    /// m- button
    else if (buttons[index] == 'm-') {
      onMMinusButtonPressed(double.parse(userOutput));
      logs('m- button-----$memoryValue');
    }

    /// mr button
    else if (buttons[index] == 'mr') {
      onMRButtonPressed();
      logs('mr button-----$memoryValue');
    }

    /// 10ˣ button or 2ˣ button
    else if (buttons[index] == '10ˣ' || buttons[index] == '2ˣ') {
      //2ˣ button
      if (isToggleOn.value) {
        if (userInput.isNotEmpty) {
          // userInput = "2^$userInput";
          num base = 2; // The base for 2ˣ
          num exponent =
              (double.tryParse(userInput.replaceAll(',', '')) ?? 0.0);
          num result = math.pow(base, exponent);
          //.00 remove regex
          userInput = result.toString().replaceAll(RegExp(r'\.0$'), '');
          userOutput = userInput;
        } else {
          userOutput = "0";
        }
      }
      // 10ˣ button
      else {
        if (userInput.isNotEmpty) {
          double base = 10; // The base for 10ˣ
          double exponent =
              (double.tryParse(userInput.replaceAll(',', '')) ?? 0.0);
          double result = math.pow(base, exponent) as double;
          userInput = formatNumber(result);
          userOutput = userInput;
        } else {
          userOutput = "0";
        }
      }
    }

    /// "log₁₀" button or log₂ button
    else if (buttons[index] == 'log₁₀' || buttons[index] == 'log₂') {
      // log₂  button
      if (isToggleOn.value) {
        if (userInput.isNotEmpty) {
          double? input = double.tryParse(userInput);
          if (input != null && input > 0) {
            double result = math.log(input) / math.log(2);
            userInput = "log₂($userInput)";
            userOutput = result.toStringAsFixed(10);
          } else {
            userOutput = "Invalid input";
          }
        } else {
          userOutput = "Not a Number";
        }
      }
      // log₁₀ button
      else {
        if (userInput.isNotEmpty) {
          double? input = double.tryParse(userInput);
          if (input != null && input > 0) {
            double result = math.log(input) /
                math.log(10); // Calculate the base-10 logarithm
            userInput = "log₁₀($userInput)";
            userOutput = result.toString();
          } else {
            userOutput = "Invalid input";
          }
        } else {
          userOutput = "Not a Number";
        }
      }
    }

    /// eˣ button or yˣ button
    else if (buttons[index] == 'eˣ' || buttons[index] == 'yˣ') {
      // yˣ button
      if (isToggleOn.value) {
        if (userInput.isEmpty) {
          userOutput = '0';
        } else {
          userInput += "^";
        }
      }
      //eˣ button
      else {
        if (userInput.isEmpty) {
          userOutput = '0';
        } else {
          userInput = "e^$userInput";
          calculateExponential(userInput);
          logs('====eˣ output====$userOutput');
        }
      }
    }

    /// In button or logᵧ
    else if (buttons[index] == 'In' || buttons[index] == 'logᵧ') {
      // logᵧ button
      if (isToggleOn.value) {
        if (userInput.isEmpty) {
          userOutput = '0';
        } else {
          userInput += 'log';
        }
      }
      // In button
      else {
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
    }

    /// sin button or  sin⁻¹ button
    else if (buttons[index] == 'sin' || buttons[index] == 'sin⁻¹') {
      if (isToggleOn.value) {
        // if (userInput.isEmpty) {
        //   userInput += "asin(";
        // } else {
        //   // Handle the case when there is user input
        //   userInput += "*asin(";
        // }
        asinButtonPressed();
      } else {
        sinButtonPressed();
      }
    }

    /// cos button or cos⁻¹ button
    else if (buttons[index] == 'cos' || buttons[index] == 'cos⁻¹') {
      if (isToggleOn.value) {
        // if (userInput.isEmpty) {
        //   userInput += "acos(";
        // } else {
        //   // Handle the case when there is user input
        //   userInput += "*acos(";
        // }
        acosButtonPressed();
      } else {
        cosButtonPressed();
      }
    }

    /// tan button or tan⁻¹ button
    else if (buttons[index] == 'tan' || buttons[index] == 'tan⁻¹') {
      if (isToggleOn.value) {
        // if (userInput.isEmpty) {
        //   userInput += "atan(";
        // } else {
        //   // Handle the case when there is user input
        //   userInput += "*atan(";
        // }
        atanButtonPressed();
      } else {
        tanButtonPressed();
      }
    }

    /// sinh button or sinh⁻¹ button
    else if (buttons[index] == 'sinh' || buttons[index] == 'sinh⁻¹') {
      if (isToggleOn.value) {
        // if (userInput.isEmpty) {
        //   userInput += "asinh(";
        // } else {
        //   // Handle the case when there is user input
        //   userInput += "*asinh(";
        // }
        asinhButtonPressed();
      } else {
        sinhButtonPressed();
      }
    }

    /// cosh button or cosh⁻¹ button
    else if (buttons[index] == 'cosh' || buttons[index] == 'cosh⁻¹') {
      if (isToggleOn.value) {
        // if (userInput.isEmpty) {
        //   userInput += "acosh(";
        // } else {
        //   // Handle the case when there is user input
        //   userInput += "*acosh(";
        // }
        acoshButtonPressed();
      } else {
        coshButtonPressed();
      }
    }

    /// tanh button or tanh⁻¹ button
    else if (buttons[index] == 'tanh' || buttons[index] == 'tanh⁻¹') {
      if (isToggleOn.value) {
        // if (userInput.isEmpty) {
        //   userInput += "atanh(";
        // } else {
        //   // Handle the case when there is user input
        //   userInput += "*atanh(";
        // }
        atanhButtonPressed();
      } else {
        tanhButtonPressed();
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
      if (userInput.isNotEmpty) {
        userInput += "^(1/3)"; // Add cube root symbol
      } else {
        userOutput = "0";
      }
    }

    /// y√x button
    else if (buttons[index] == 'y√x') {
      if (userInput.isNotEmpty) {
        userInput += "√"; // Add y√x symbol
      } else {
        userOutput = "0";
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
      if (userInput.isNotEmpty) {
        userInput += "!";
      } else {
        userOutput = '0';
      }
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
        // If the input is empty, display the value of π
        userOutput = math.pi.toString();
        userInput = math.pi.toString();
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
        // If the input is empty, display the value of 'e'
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

    /// Rand button
    else if (buttons[index] == 'Rand') {
      randButtonPressed();
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
      print('ELSE ---------');
      userInput += buttons[index];
      // lastCharIsOperator = isOperator(buttons[index]);
    }

    evaluateLiveOutput();
    update();
  }

  bool isOperator(String str) {
    return ['%', '/', 'x', '-', '.', '+'].contains(str);
  }

  void updateCursorPosition(int position) {
    cursorPosition = position;
    // You can use this cursor position to manipulate your userInput string
  }

  /// Update userOutput based on the current userInput.
  void evaluateLiveOutput() {
    String userInputWithoutCommas = userInput.replaceAll(',', '');
    // String userInputFC = userInputWithoutCommas;
    String userInputFC = userInputWithoutCommas
        .replaceAll("x", "*")
        .replaceAll('π', '${math.pi}')
        .replaceAll("EE", "*10^")
        .replaceAll('e', '${math.e}');

    if (userInputFC.contains("acos")) {
      userInputFC = calculateArccosine(userInputFC);
    }
    if (userInputFC.contains("atan")) {
      userInputFC = calculateInverseTangent(userInputFC);
    }
    if (userInputFC.contains("asin")) {
      userInputFC = calculateArcsine(userInputFC);
    }
    if (userInputFC.contains("sin")) {
      userInputFC = calculateSine(userInputFC);
    }
    if (userInputFC.contains("cos")) {
      userInputFC = calculateCosine(userInputFC);
    }
    if (userInputFC.contains("tan")) {
      userInputFC = calculateTangent(userInputFC);
    }
    if (userInputFC.contains("asinh")) {
      userInputFC = calculateInverseSinh(userInputFC);
    }
    if (userInputFC.contains("acosh")) {
      userInputFC = calculateArcCoshRadian(userInputFC);
    }
    if (userInputFC.contains("atanh")) {
      userInputFC = calculateArcTanhRadian(userInputFC);
    }

    if (userInputFC.contains("^")) {
      userInputFC = handleXPowYExpression(userInputFC);
    }

    userInputFC = calculateSinh(userInputFC);
    userInputFC = calculateCosh(userInputFC);
    userInputFC = calculateTanh(userInputFC);
    userInputFC = calculateExponential(userInputFC);
    userInputFC = calculateLogBase10(userInputFC);
    userInputFC = calculateLogBase2(userInputFC);
    userInputFC = calculateNaturalLog(userInputFC);
    userInputFC = handleYSqrtXExpression(userInputFC);
    userInputFC = handleYPowerXExpression(userInputFC);
    // userInputFC = handleXPowerYExpression(userInputFC);
    userInputFC = handleYLogXExpression(userInputFC);

    if (userInputFC.isNotEmpty && userInputFC.endsWith('.')) {
      // If userInput ends with a dot and there is no more input, remove the dot
      userInputFC = userInputFC.substring(0, userInputFC.length - 1);
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(userInputFC);
      ContextModel ctx = ContextModel();
      // double eval = exp.evaluate(EvaluationType.REAL, ctx);

      double eval = exp.evaluate(EvaluationType.REAL, ctx) as double;
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
      logs('===evalute live output ==Error: $e');
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

  ///calculate e^ and return the result as a string
  String calculateExponential(String userInputFC) {
    if (userInputFC.contains("e^")) {
      // Extract the portion after "e^" and calculate the result
      String inputAfterExponent = userInputFC.split("e^")[1];
      double? input = double.tryParse(inputAfterExponent);
      if (input != null) {
        double result = math.exp(input);
        userOutput = result.toString();
        return result.toString();
      } else {
        return 'Error';
      }
    }
    return userInputFC;
  }

  ///calculate log10 and replace it in the input string
  String calculateLogBase10(String userInputFC) {
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
        return userInputFC;
      }
    }
    return userInputFC;
  }

  ///calculate log2 and replace it in the input string
  String calculateLogBase2(String userInputFC) {
    final logMatches = RegExp(r'log₂\(([^)]+)\)').allMatches(userInputFC);
    for (var match in logMatches) {
      final fullMatch = match.group(0).toString();
      final innerValue = match.group(1);
      double? input = double.tryParse(innerValue!);
      if (input != null && input > 0) {
        double result = math.log(input) / math.log(2);
        userInputFC = userInputFC.replaceFirst(fullMatch, result.toString());
      } else {
        userOutput = "Invalid input";
        update();
        return userInputFC;
      }
    }
    return userInputFC;
  }

  ///calculate In and replace it in the input string
  String calculateNaturalLog(String userInputFC) {
    final lnMatches = RegExp(r'ln\(([^)]+)\)').allMatches(userInputFC);
    for (var match in lnMatches) {
      final fullMatch = match.group(0).toString();
      final innerValue = match.group(1);
      double? input = double.tryParse(innerValue!);
      if (input != null && input > 0) {
        double result = math.log(input);
        userInputFC = userInputFC.replaceFirst(fullMatch, result.toString());
      } else {
        userOutput = "Invalid input";
        update();
        return userInputFC;
      }
    }
    return userInputFC;
  }

  ///Rand button operation Manage
  void randButtonPressed() {
    // Generate a random number between 0 and 1
    final random = Random();
    final randomNumber = random.nextDouble();

    // Update both user input and output with the random number
    userInput = randomNumber.toString();
    userOutput = randomNumber.toString();

    // Call update() to notify the UI to refresh
    update();
  }

  //sin
  // ///manage click of sin button --how input will display--manage conditions
  // void sinButtonPressed() {
  //   // Find the beginning of the current number or operator.
  //   final startIndex = userInput.isNotEmpty
  //       ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
  //       : 0;
  //
  //   // Check if there's a number before sin
  //   final isNumberBeforeSin = startIndex < userInput.length &&
  //       RegExp(r'\d').hasMatch(userInput[startIndex]);
  //
  //   // If there's a number before sin, insert "*sin("; otherwise, insert "sin(".
  //   if (isNumberBeforeSin) {
  //     userInput =
  //         "${userInput.substring(0, startIndex)}${userInput.substring(startIndex)}*sin(";
  //   } else {
  //     userInput = "${userInput}sin(";
  //   }
  //
  //   // Update the cursor position to be inside the "sin()" function.
  //   int newCursorPosition = startIndex +
  //       (isNumberBeforeSin ? 5 : 4); // 5 is the length of "*sin()".
  //   updateCursorPosition(newCursorPosition);
  //
  //   // Evaluate the updated expression.
  //   evaluateLiveOutput();
  // }

  void sinButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before sin
    final isNumberBeforeSin = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before sin, insert "sin("; otherwise, insert "sin(".
    String sinExpression = isNumberBeforeSin ? "sin(" : "sin(";

    // Check if "sin(" is already present in userInput.
    final isSinPresent = userInput.contains("sin(");

    // If "sin(" is not already present, update userInput.
    if (!isSinPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the sin expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$sinExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "sin()" function.
      int newCursorPosition =
          startIndex + sinExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "sin(" is already present, do not allow any additions.
      return;
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  /// calculate sin and convert to either radians or degrees
  String calculateSine(String userInputFC) {
    final matches = RegExp(r'sin\(([^)]+)\)').allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString();
      final innerValue = match.group(1);
      double? input = double.tryParse(innerValue!);
      if (input != null) {
        final isDegMode = buttonText.value == "Deg";
        final resultInRadians =
            isDegMode ? math.sin(input) : math.sin(input * math.pi / 180);
        userInputFC = userInputFC.replaceFirst(
            fullMatch, resultInRadians.toStringAsFixed(7));
      } else {
        userOutput = 'Error';
        update();
        return userInputFC;
      }
    }
    return userInputFC;
  }

  ///sin-1
  void asinButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before asin
    final isNumberBeforeAsin = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before asin, insert "*asin("; otherwise, insert "asin(".
    String asinExpression = isNumberBeforeAsin ? "asin(" : "asin(";

    // Check if "asin(" is already present in userInput.
    final isAsinPresent = userInput.contains("asin(");

    // If "asin(" is not already present, update userInput.
    if (!isAsinPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the asin expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$asinExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "asin()" function.
      int newCursorPosition =
          startIndex + asinExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "asin(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + asinExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  ///cos-1
  void acosButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before acos
    final isNumberBeforeAcos = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before acos, insert "*acos("; otherwise, insert "acos(".
    String acosExpression = isNumberBeforeAcos ? "acos(" : "acos(";

    // Check if "acos(" is already present in userInput.
    final isAcosPresent = userInput.contains("acos(");

    // If "acos(" is not already present, update userInput.
    if (!isAcosPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the acos expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$acosExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "acos()" function.
      int newCursorPosition =
          startIndex + acosExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "acos(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + acosExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  ///tan-1
  void atanButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before atan
    final isNumberBeforeAtan = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before atan, insert "*atan("; otherwise, insert "atan(".
    String atanExpression = isNumberBeforeAtan ? "atan(" : "atan(";

    // Check if "atan(" is already present in userInput.
    final isAtanPresent = userInput.contains("atan(");

    // If "atan(" is not already present, update userInput.
    if (!isAtanPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the atan expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$atanExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "atan()" function.
      int newCursorPosition =
          startIndex + atanExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "atan(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + atanExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  //cos
  // ///manage click of cos button --how input will display--manage conditions
  // void cosButtonPressed() {
  //   // Find the beginning of the current number or operator.
  //   final startIndex = userInput.isNotEmpty
  //       ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
  //       : 0;
  //
  //   // Check if there's a number before cos
  //   final isNumberBeforeCos = startIndex < userInput.length &&
  //       RegExp(r'\d').hasMatch(userInput[startIndex]);
  //
  //   // If there's a number before cos, insert "*cos("; otherwise, insert "cos(".
  //   if (isNumberBeforeCos) {
  //     userInput =
  //         "${userInput.substring(0, startIndex)}${userInput.substring(startIndex)}*cos(";
  //   } else {
  //     userInput = "${userInput}cos(";
  //   }
  //
  //   // Update the cursor position to be inside the "cos()" function.
  //   int newCursorPosition = startIndex +
  //       (isNumberBeforeCos ? 5 : 4); // 5 is the length of "*cos()".
  //   updateCursorPosition(newCursorPosition);
  //
  //   // Evaluate the updated expression.
  //   evaluateLiveOutput();
  // }
  void cosButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before cos
    final isNumberBeforeCos = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before cos, insert "cos("; otherwise, insert "cos(".
    String cosExpression = isNumberBeforeCos ? "cos(" : "cos(";

    // Check if "cos(" is already present in userInput.
    final isCosPresent = userInput.contains("cos(");

    // If "cos(" is not already present, update userInput.
    if (!isCosPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the cos expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$cosExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "cos()" function.
      int newCursorPosition =
          startIndex + cosExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "cos(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + cosExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  ///calculate cos and convert to either radians or degrees
  String calculateCosine(String userInputFC) {
    final matches = RegExp(r'cos\(([^)]+)\)').allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString();
      final innerValue = match.group(1);
      double? input = double.tryParse(innerValue!);
      if (input != null) {
        final isDegMode = buttonText.value == "Deg";
        final resultInRadians =
            isDegMode ? math.cos(input) : math.cos(input * math.pi / 180);
        userInputFC =
            userInputFC.replaceFirst(fullMatch, resultInRadians.toString());
      } else {
        userOutput = 'Error';
        update();
        return userInputFC;
      }
    }
    return userInputFC;
  }

  //tan
  ///manage click of tan button --how input will display--manage conditions
  void tanButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before tan
    final isNumberBeforeTan = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before tan, insert "tan("; otherwise, insert "tan(".
    String tanExpression = isNumberBeforeTan ? "tan(" : "tan(";

    // Check if "tan(" is already present in userInput.
    final isTanPresent = userInput.contains("tan(");

    // If "tan(" is not already present, update userInput.
    if (!isTanPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the tan expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$tanExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "tan()" function.
      int newCursorPosition =
          startIndex + tanExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "tan(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + tanExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  ///calculate tan and convert to either radians or degrees
  String calculateTangent(String userInputFC) {
    final matches = RegExp(r'tan\(([^)]+)\)').allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString();
      final innerValue = match.group(1);
      double? input = double.tryParse(innerValue!);
      if (input != null) {
        final isDegMode = buttonText.value == "Deg";
        final resultInRadians =
            isDegMode ? math.tan(input) : math.tan(input * math.pi / 180);
        userInputFC =
            userInputFC.replaceFirst(fullMatch, resultInRadians.toString());
      } else {
        userOutput = 'Error';
        update();
        return userInputFC;
      }
    }
    return userInputFC;
  }

  ///sinh-1
  void asinhButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before asinh
    final isNumberBeforeAsinh = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before asinh, insert "*asinh("; otherwise, insert "asinh(".
    String asinhExpression = isNumberBeforeAsinh ? "asinh(" : "asinh(";

    // Check if "asinh(" is already present in userInput.
    final isAsinhPresent = userInput.contains("asinh(");

    // If "asinh(" is not already present, update userInput.
    if (!isAsinhPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the asinh expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$asinhExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "asinh()" function.
      int newCursorPosition =
          startIndex + asinhExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "asinh(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + asinhExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  ///cosh-1
  void acoshButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before acosh
    final isNumberBeforeAcosh = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before acosh, insert "*acosh("; otherwise, insert "acosh(".
    String acoshExpression = isNumberBeforeAcosh ? "acosh(" : "acosh(";

    // Check if "acosh(" is already present in userInput.
    final isAcoshPresent = userInput.contains("acosh(");

    // If "acosh(" is not already present, update userInput.
    if (!isAcoshPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the acosh expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$acoshExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "acosh()" function.
      int newCursorPosition =
          startIndex + acoshExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "acosh(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + acoshExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  ///tanh-1
  void atanhButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before atanh
    final isNumberBeforeAtanh = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before atanh, insert "*atanh("; otherwise, insert "atanh(".
    String atanhExpression = isNumberBeforeAtanh ? "atanh(" : "atanh(";

    // Check if "atanh(" is already present in userInput.
    final isAtanhPresent = userInput.contains("atanh(");

    // If "atanh(" is not already present, update userInput.
    if (!isAtanhPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the atanh expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$atanhExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "atanh()" function.
      int newCursorPosition =
          startIndex + atanhExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "atanh(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + atanhExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  //sinh
  ///manage click of sinh button --how input will display--manage conditions
  void sinhButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before sinh
    final isNumberBeforeSinh = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before sinh, insert "sinh("; otherwise, insert "sinh(".
    String sinhExpression = isNumberBeforeSinh ? "sinh(" : "sinh(";

    // Check if "sinh(" is already present in userInput.
    final isSinhPresent = userInput.contains("sinh(");

    // If "sinh(" is not already present, update userInput.
    if (!isSinhPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the sinh expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$sinhExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "sinh()" function.
      int newCursorPosition =
          startIndex + sinhExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "sinh(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + sinhExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  ///calculate sinh and replace it in the input string
  String calculateSinh(String userInputFC) {
    userInputFC = userInputFC.replaceAllMapped(
      RegExp(r'sinh\(([^)]+)\)'),
      (match) {
        final innerValue = match.group(1);
        double? input = double.tryParse(innerValue!);
        if (input != null) {
          double result = (math.exp(input) - math.exp(-input)) / 2;
          return result.toString();
        } else {
          return 'Error';
        }
      },
    );
    return userInputFC;
  }

  //cosh
  ///manage click of cosh button --how input will display--manage conditions
  void coshButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before cosh
    final isNumberBeforeCosh = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before cosh, insert "cosh("; otherwise, insert "cosh(".
    String coshExpression = isNumberBeforeCosh ? "cosh(" : "cosh(";

    // Check if "cosh(" is already present in userInput.
    final isCoshPresent = userInput.contains("cosh(");

    // If "cosh(" is not already present, update userInput.
    if (!isCoshPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the cosh expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$coshExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "cosh()" function.
      int newCursorPosition =
          startIndex + coshExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "cosh(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + coshExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  /// calculate cosh and replace it in the input string
  String calculateCosh(String userInputFC) {
    userInputFC = userInputFC.replaceAllMapped(
      RegExp(r'cosh\(([^)]+)\)'),
      (match) {
        final innerValue = match.group(1);
        double? input = double.tryParse(innerValue!);
        if (input != null) {
          double result = (math.exp(input) + math.exp(-input)) / 2;
          return result.toString();
        } else {
          return 'Error';
        }
      },
    );
    return userInputFC;
  }

  //tanh
  ///manage click of tanh button --how input will display--manage conditions
  void tanhButtonPressed() {
    // Find the beginning of the current number or operator.
    final startIndex = userInput.isNotEmpty
        ? userInput.lastIndexOf(RegExp(r'[+\-x/]')) + 1
        : 0;

    // Check if there's a number before tanh
    final isNumberBeforeTanh = startIndex < userInput.length &&
        RegExp(r'\d').hasMatch(userInput[startIndex]);

    // If there's a number before tanh, insert "tanh("; otherwise, insert "tanh(".
    String tanhExpression = isNumberBeforeTanh ? "tanh(" : "tanh(";

    // Check if "tanh(" is already present in userInput.
    final isTanhPresent = userInput.contains("tanh(");

    // If "tanh(" is not already present, update userInput.
    if (!isTanhPresent) {
      // Find the end of the current number.
      final endIndex = userInput.indexOf(RegExp(r'[+\-x/]'), startIndex + 1);
      final endOfString = endIndex == -1 ? userInput.length : endIndex;

      // Extract the current number.
      final currentNumber = userInput.substring(startIndex, endOfString);

      // Insert the tanh expression with parentheses around the current number.
      userInput = userInput.replaceRange(
        startIndex,
        endOfString,
        '$tanhExpression$currentNumber)',
      );

      // Update the cursor position to be inside the "tanh()" function.
      int newCursorPosition =
          startIndex + tanhExpression.length + currentNumber.length + 1;
      updateCursorPosition(newCursorPosition);
    } else {
      // If "tanh(" is already present, simply update the cursor position.
      updateCursorPosition(startIndex + tanhExpression.length);
    }

    // Evaluate the updated expression.
    evaluateLiveOutput();
  }

  ///calculate tanh and replace it in the input string
  String calculateTanh(String userInputFC) {
    userInputFC = userInputFC.replaceAllMapped(
      RegExp(r'tanh\(([^)]+)\)'),
      (match) {
        final innerValue = match.group(1);
        double? input = double.tryParse(innerValue!);
        if (input != null) {
          double result = (math.exp(2 * input) - 1) / (math.exp(2 * input) + 1);
          return result.toString();
        } else {
          return 'Error';
        }
      },
    );
    return userInputFC;
  }

  //2nd page buttons

  /// tanh⁻¹ in radians and replace it in the input string
  String calculateArcTanhRadian(String userInputFC) {
    final atanhRegExp = RegExp(r'atanh\(([^)]+)\)');
    final matches = atanhRegExp.allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString(); // Convert to non-null string
      final argument = match.group(1); // Captured argument
      try {
        final argValue = double.parse(argument!);
        if (argValue < -1.0 || argValue > 1.0) {
          throw Exception('Invalid Input');
        }
        final resultInRadians = 0.5 * math.log((1 + argValue) / (1 - argValue));
        userInputFC =
            userInputFC.replaceFirst(fullMatch, resultInRadians.toString());
      } catch (e) {
        // Handle the case where the argument is not a valid number or out of range
        userInputFC = userInputFC.replaceFirst(fullMatch, 'Invalid Input');
      }
    }
    return userInputFC;
  }

  /// tan⁻¹ convert to either radians or degrees
  String calculateInverseTangent(String userInputFC) {
    final atanRegExp = RegExp(r'atan\(([^)]+)\)');
    final matches = atanRegExp.allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString(); // Convert to non-null string
      final argument = match.group(1); // Captured argument
      try {
        final argValue = double.parse(argument!);
        final resultInRadians = atan(argValue);
        final result = (buttonText.value == "Rad")
            ? ((resultInRadians * 180) / pi).toString()
            : resultInRadians.toString();
        userInputFC = userInputFC.replaceFirst(fullMatch, result);
      } catch (e) {
        // Handle the case where the argument is not a valid number
        userInputFC = userInputFC.replaceFirst(fullMatch, 'Invalid Input');
      }
    }
    return userInputFC;
  }

  /// sin⁻¹ and convert to either radians or degrees
  String calculateArcsine(String userInputFC) {
    final asinRegExp = RegExp(r'asin\(([^)]+)\)');
    final matches = asinRegExp.allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString(); // Convert to non-null string
      final argument = match.group(1); // Captured argument
      try {
        final argValue = double.parse(argument!);
        final resultInRadians = asin(argValue);
        final result = (buttonText.value == "Rad")
            ? ((resultInRadians * 180) / pi).toString()
            : resultInRadians.toString();
        userInputFC = userInputFC.replaceFirst(fullMatch, result);
      } catch (e) {
        // Handle the case where the argument is not a valid number
        userInputFC = userInputFC.replaceFirst(fullMatch, 'Invalid Input');
      }
    }
    return userInputFC;
  }

  /// sinh⁻¹and replace it in the input string
  String calculateInverseSinh(String userInputFC) {
    final asinhRegExp = RegExp(r'asinh\(([^)]+)\)');
    final matches = asinhRegExp.allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString(); // Convert to non-null string
      final argument = match.group(1); // Captured argument
      try {
        final argValue = double.parse(argument!);
        final resultInRadians =
            math.log(argValue + math.sqrt(argValue * argValue + 1));
        userInputFC =
            userInputFC.replaceFirst(fullMatch, resultInRadians.toString());
      } catch (e) {
        // Handle the case where the argument is not a valid number
        userInputFC = userInputFC.replaceFirst(fullMatch, 'Invalid Input');
      }
    }
    return userInputFC;
  }

  /// cos⁻¹ and convert to either radians or degrees
  String calculateArccosine(String userInputFC) {
    final acosRegExp = RegExp(r'acos\(([^)]+)\)');
    final matches = acosRegExp.allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString(); // Convert to non-null string
      final argument = match.group(1); // Captured argument
      try {
        final argValue = double.parse(argument!);
        final resultInRadians = acos(argValue);
        final result = (buttonText.value == "Rad")
            ? ((resultInRadians * 180) / pi).toString()
            : resultInRadians.toString();
        userInputFC = userInputFC.replaceFirst(fullMatch, result);
      } catch (e) {
        // Handle the case where the argument is not a valid number
        userInputFC = userInputFC.replaceFirst(fullMatch, 'Invalid Input');
      }
    }
    return userInputFC;
  }

  /// cosh⁻¹ in radians and replace it in the input string
  String calculateArcCoshRadian(String userInputFC) {
    final acoshRegExp = RegExp(r'acosh\(([^)]+)\)');
    final matches = acoshRegExp.allMatches(userInputFC);
    for (var match in matches) {
      final fullMatch = match.group(0).toString(); // Convert to non-null string
      final argument = match.group(1); // Captured argument
      try {
        final argValue = double.parse(argument!);
        if (argValue < 1.0) {
          throw Exception('Invalid Input');
        }
        final resultInRadians =
            math.log(argValue + math.sqrt(argValue * argValue - 1));
        userInputFC =
            userInputFC.replaceFirst(fullMatch, resultInRadians.toString());
      } catch (e) {
        // Handle the case where the argument is not a valid number or out of range
        userInputFC = userInputFC.replaceFirst(fullMatch, 'Invalid Input');
      }
    }
    return userInputFC;
  }

  /// y√x function handle
  String handleYSqrtXExpression(String input) {
    final ySqrtXRegExp = RegExp(r'(\d+)√(\d+)');
    final matches = ySqrtXRegExp.allMatches(input);
    String result = input; // Initialize the result with the original input

    for (var match in matches) {
      final fullMatch = match.group(0).toString(); // Convert to non-null string
      final y = match.group(1); // Captured y
      final x = match.group(2); // Captured x
      final expressionResult = "($y)^(1/$x)";
      result = result.replaceFirst(fullMatch, expressionResult);
    }

    return result;
  }

  /// yˣ function handle
  String handleYPowerXExpression(String input) {
    final yPowerXRegExp =
        RegExp(r'(\d+)\^(\d+)'); // Updated pattern to include ^
    String result = input;

    final matches = yPowerXRegExp.allMatches(input);
    for (var match in matches) {
      final fullMatch = match.group(0).toString();
      final yStr = match.group(1);
      final xStr = match.group(2);

      if (yStr != null && xStr != null) {
        final y = double.parse(yStr);
        final x = double.parse(xStr);
        final expressionResult = (pow(x, y)).toString(); // Calculate "y^x"
        result = result.replaceFirst(fullMatch, expressionResult);
      }
    }

    return result;
  }

  /// xʸ function handle
  /// Function to handle xʸ expression
  String handleXPowYExpression(String expression) {
    List<String> parts = expression.split('^');
    if (parts.length == 2) {
      double base = double.tryParse(parts[0]) ?? 0.0;
      double exponent = double.tryParse(parts[1]) ?? 0.0;

      // Calculate the result of xʸ
      num result = math.pow(base, exponent);

      // Update expression with the result
      expression = result.toString();
    }
    return expression;
  }

  ///logᵧ function handle
  String handleYLogXExpression(String input) {
    final yLogXRegExp =
        RegExp(r'(\d+)log(\d+)'); // Define the pattern for "ylogx"
    String result = input;

    final matches = yLogXRegExp.allMatches(input);
    for (var match in matches) {
      final fullMatch = match.group(0).toString();
      final yStr = match.group(1);
      final xStr = match.group(2);

      if (yStr != null && xStr != null) {
        final y = double.parse(yStr);
        final x = double.parse(xStr);

        // Calculate "second input log base first input"
        final expressionResult = (math.log(y) / math.log(x)).toString();

        result = result.replaceFirst(fullMatch, expressionResult);
        logs("Full Match: $fullMatch");
        logs("y: $y, x: $x");
        logs("Expression Result: $expressionResult");
      }
    }

    return result;
  }

  /// clear memory (MC)
  void clearMemory() {
    memoryValue = 0;
    update(); // Notify the UI to update
  }

  // Function to add result to memory (M+)
  void addToMemory(double result) {
    memoryValue += result;
    update(); // Notify the UI to update
  }

  // Function to subtract result from memory (M-)
  void subtractFromMemory(double result) {
    memoryValue -= result;
    update(); // Notify the UI to update
  }

  // Function to recall value from memory (MR)
  double recallMemory() {
    return memoryValue;
  }

  /// M+ button
  void onMPlusButtonPressed(double result) {
    addToMemory(result);
  }

  ///  M- button
  void onMMinusButtonPressed(double result) {
    subtractFromMemory(result);
  }

  /// MR button
  void onMRButtonPressed() {
    // Get the value from memory
    double valueFromMemory = recallMemory();

    // Use the valueFromMemory in your calculations or update the display
    // For example, you can set it as the user input or display it in the output
    userInput = valueFromMemory.toString();
    userOutput = valueFromMemory.toString();
  }
}
