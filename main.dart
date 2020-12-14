import 'package:flutter/material.dart';
import 'package:transformer_textfield/transformer_textfield.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Gesture detector used to unfocus textfields when tapped outside
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Transformer textfield demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This string is used to give the textfield an initial value
  String text = 'I am a bear';

  // This function transforms the text shown in the textview
  // when the textfield is not in focus
  String _transformFunction(String str) {
    return str.toUpperCase();
  }

  // This function updates the text used in the textfield
  void _updateText(String str){
    setState(() {
      text = str;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TransformerTextField(
              text: text,
              transformFunction: _transformFunction,
              updateFunction: _updateText,
            ),
          ],
        ),
      ),
    );
  }
}
