import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guess My Number',
      home: const MyHomePage(title: 'Guess My Number'),
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.black45),
            foregroundColor: MaterialStateProperty.all(Colors.white),
          )
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum ComparisonResult { smallerThan, equal, greaterThan }
enum ButtonStatus { guess, reset }

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  int randomNumber = Random().nextInt(99) + 1;
  int? valueAttempt;
  ComparisonResult? result;
  String? errorText;

  ComparisonResult _getResult(int value, int randomNumber) {
    if (value > randomNumber) {
      return ComparisonResult.greaterThan;
    }
    if (value == randomNumber) {
      return ComparisonResult.equal;
    }
    return ComparisonResult.smallerThan;
  }

  String _getResultMessage(ComparisonResult result) {
    switch (result) {
      case ComparisonResult.smallerThan:
        return 'Try higher';
      case ComparisonResult.equal:
        return 'You guessed right.';
      case ComparisonResult.greaterThan:
      default:
        return 'Try lower';
    }
  }

  _resetInput() {
    controller.clear();
  }

  _setErrorText(String? text) {
    setState(() {
      errorText = text;
    });
  }

  bool _validateInput(String inputValue) {
    if (inputValue == '') {
      _setErrorText('Please enter a value');
      return false;
    }

    final value = int.tryParse(inputValue);
    if (value == null) {
      _setErrorText('Please enter a valid number');
      return false;
    }
    if (value < 1 || value > 100) {
      _setErrorText('Please enter a number between 1 and 100');
      return false;
    }

    _setErrorText(null);
    return true;
  }

  _showDialog(BuildContext context, int correctNumber) {
    const String tryAgainText = 'Try again!';
    const String okText = 'OK';

    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('You guessed right!'),
              content: Text('It was $correctNumber'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, tryAgainText);
                    _resetGame();
                  },
                  child: const Text(tryAgainText),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, okText),
                  child: const Text(okText),
                ),
              ],
            ));
  }

  _guessNumber(BuildContext context) {
    setState(() {
      String inputValue = controller.value.text;
      if (_validateInput(inputValue)) {
        int attempt = int.parse(inputValue);
        valueAttempt = attempt;
        result = _getResult(attempt, randomNumber);

        if (result == ComparisonResult.equal) {
          _showDialog(context, randomNumber);
        }

        _resetInput();
      }
    });
  }

  _generateNewRandomNumber() {
    setState(() {
      randomNumber = Random().nextInt(99) + 1;
    });
  }

  _resetGame() {
    setState(() {
      valueAttempt = null;
      result = null;
    });
    _resetInput();
    _generateNewRandomNumber();
  }

  @override
  Widget build(BuildContext context) {
    final bool correctGuess = result == ComparisonResult.equal;
    final ButtonStatus buttonStatus =
        correctGuess ? ButtonStatus.reset : ButtonStatus.guess;
    final String buttonText =
        buttonStatus == ButtonStatus.reset ? 'Reset' : 'Guess';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: const EdgeInsetsDirectional.only(top: 16.0, bottom: 8.0),
              child: const Text(
                'I\'m thinking of a number between 1 and 100.',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 8.0, bottom: 16.0),
              child: const Text(
                'It\'s your turn to guess my number!',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            if (valueAttempt != null && result != null)
              Container(
                margin: const EdgeInsetsDirectional.only(top: 4.0, bottom: 8.0),
                child: Text(
                  'You tried $valueAttempt\n' + _getResultMessage(result!),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 8.0, bottom: 4.0),
              child: Card(
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsetsDirectional.only(
                              top: 4.0, bottom: 4.0),
                          child: Text(
                            'Try a number!',
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          margin:
                              const EdgeInsetsDirectional.only(bottom: 16.0),
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              errorText: errorText,
                            ),
                            focusNode: focusNode,
                            enabled: !correctGuess,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ElevatedButton(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(buttonText),
                            ),
                            onPressed: () {
                              setState(() {
                                if (buttonStatus == ButtonStatus.guess) {
                                  _guessNumber(context);
                                  FocusScope.of(context)
                                      .requestFocus(focusNode);
                                  return;
                                }
                                _resetGame();
                              });
                            }),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
