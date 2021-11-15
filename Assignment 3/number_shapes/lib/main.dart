import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Number Shapes';

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class GeometricalNumber {
  GeometricalNumber(this.initialNumber) {
    isSquare = checkSquare(initialNumber);
    isTriangular = checkTriangular(initialNumber);
  }

  int initialNumber;
  bool? isSquare;
  bool? isTriangular;

  bool checkSquare(int number) {
    return sqrt(number) == int.parse(sqrt(number).toStringAsFixed(0));
  }

  bool checkTriangular(int number) {
    return checkSquare(int.parse((8 * number + 1).toString()));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();
  String? errorText;

  void _resetInput() {
    controller.clear();
  }

  void _setErrorText(String? text) {
    setState(() {
      errorText = text;
    });
  }

  void _validateInput(String inputValue) {
    if (inputValue == '') {
      _setErrorText('Please enter a value');
      return;
    }

    final int? value = int.tryParse(inputValue);
    if (value == null) {
      _setErrorText('Please enter a valid number');
      return;
    }
    if (value < 0) {
      _setErrorText('Please enter a positive number');
      return;
    }

    _setErrorText(null);
  }

  void _showDialog(BuildContext context, int number, String message, Function onClose) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text('$number'),
              content: Text(message),
            )).whenComplete(() {
      onClose();
    });
  }

  void _checkNumber(BuildContext context) {
    final String inputValue = controller.value.text;
    if (inputValue == '') {
      return;
    }

    final int number = int.parse(inputValue);
    String message = '';

    final GeometricalNumber geometricalNumber = GeometricalNumber(number);

    if (geometricalNumber.isSquare! && geometricalNumber.isTriangular!) {
      message = 'Number $number is both SQUARE and TRIANGULAR.';
    } else if (geometricalNumber.isSquare!) {
      message = 'Number $number is SQUARE.';
    } else if (geometricalNumber.isTriangular!) {
      message = 'Number $number is TRIANGULAR.';
    } else {
      message = 'Number $number is neither SQUARE or TRIANGULAR.';
    }

    _showDialog(context, number, message, _resetInput);
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = errorText != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: AlignmentDirectional.topStart,
              margin: const EdgeInsetsDirectional.only(bottom: 8.0),
              child: const Text(
                'Please input a number to see if it is square or triangular.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                errorText: errorText,
              ),
              onChanged: (String value) {
                _validateInput(value);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isButtonDisabled
            ? null
            : () {
                _checkNumber(context);
              },
        backgroundColor: isButtonDisabled ? Colors.grey[400] : null,
        child: const Icon(Icons.check),
      ),
    );
  }
}
