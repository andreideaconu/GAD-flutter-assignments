import 'package:flutter/material.dart';
import 'package:forex/forex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Convertor',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Currency Convertor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();

  double? valueToBeFormatted;
  String? convertedValue;
  String? errorText;
  Map<String, num>? quotes;

  void initializeForex() async {
    quotes = await Forex.fx(
        quoteProvider: QuoteProvider.ecb, base: 'RON', quotes: <String>['EUR']);
  }

  double? _convertValue(String value) {
    return double.tryParse(value);
  }

  _performConversion(double value) {
    double exchangeValue = double.parse(quotes!.values.first.toString());

    setState(() {
      convertedValue =
          (valueToBeFormatted! * exchangeValue).toStringAsFixed(2) + ' RON';
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool shouldConvertButtonBeEnabled =
        valueToBeFormatted != null && errorText == '';
    final bool showImage = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (showImage) const Image(image: AssetImage('assets/Money.jpg')),
              Container(
                  margin: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 16.0, 16.0, 8.0),
                  child: TextField(
                      controller: controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: 'Enter the amount in EUR',
                        errorText: errorText,
                        suffix: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.clear();
                          },
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          convertedValue = null;
                          valueToBeFormatted = _convertValue(value);

                          if (value == '') {
                            errorText = '';

                            return;
                          }

                          if (valueToBeFormatted == null) {
                            errorText = 'Please enter a numeric value';

                            return;
                          }

                          if (valueToBeFormatted! < 0) {
                            errorText = 'Please enter a positive number';

                            return;
                          }

                          if (errorText != '') {
                            errorText = '';
                          }
                        });
                      })),
              ElevatedButton(
                child: const Text('Convert!'),
                onPressed: shouldConvertButtonBeEnabled
                    ? () {
                        _performConversion(valueToBeFormatted!);
                      }
                    : null,
              ),
              if (convertedValue != null)
                Text(
                  convertedValue!,
                  style: Theme.of(context).textTheme.headline4,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
