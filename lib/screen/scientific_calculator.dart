import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:math_expressions/math_expressions.dart';

///SCientific

class ScientificCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scientific Calculator'),
      ),
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}

// class Calculator extends StatefulWidget {
//   @override
//   _CalculatorState createState() => CalculatorState();
// }
//
// class _CalculatorState extends State<Calculator> {
//   String _input = '';
//
//   void _onButtonPressed(String text) {
//     setState(() {
//       if (text == '=') {
//         try {
//           Parser p = Parser();
//           Expression exp = p.parse(_input);
//           ContextModel cm = ContextModel();
//           _input = exp.evaluate(EvaluationType.REAL, cm).toString();
//         } catch (e) {
//           _input = 'Error';
//         }
//       } else if (text == 'C') {
//         _input = '';
//       } else {
//         _input += text;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Expanded(
//           child: Container(
//             alignment: Alignment.centerRight,
//             // padding: EdgeInsets.all(16.0),
//             child: Text(
//               _input,
//               style: TextStyle(fontSize: 36.0),
//             ),
//           ),
//         ),
//         Divider(),
//         Expanded(
//           flex: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(2.0),
//             child: GridView.builder(
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 11, crossAxisSpacing: 2, mainAxisSpacing: 2),
//               itemBuilder: (context, index) {
//                 final buttonText = _buttonTexts[index];
//                 return CalculatorButton(
//                   text: buttonText,
//                   onPressed: () => _onButtonPressed(buttonText),
//                 );
//               },
//               itemCount: _buttonTexts.length,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   final List<String> _buttonTexts = [
//     '7',
//     '8',
//     '9',
//     '/',
//     '4',
//     '5',
//     '6',
//     'x',
//     '1',
//     '2',
//     '3',
//     '-',
//     'C',
//     '0',
//     '=',
//     '+',
//     'π',
//     '√',
//     'sin',
//     'cos',
//     'tan',
//   ];
// }
//
// class CalculatorButton extends StatelessWidget {
//   final String text;
//   final Function onPressed;
//
//   CalculatorButton({required this.text, required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () => onPressed(),
//       child: Text(text),
//     );
//   }
// }
