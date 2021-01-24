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

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dividerTheme: DividerThemeData(
            space: 0,
            thickness: 1,
          ),
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
  List<String> list = [
    'I am a bear',
    'I am a cat',
    'I am a dog',
    'I am a bird',
    'Something incredibly long to see what happens if the text needs to wrap around to the next line.',
    'I am an Eagle',
  ];

  // This function transforms the text shown in the textview
  // when the textfield is not in focus
  String _transformFunction(String str) {
    return str.toUpperCase();
  }

  // This function updates the text used in the textfield
  void _updateText(int index, String str) {
    setState(() {
      list[index] = str;
    });
  }

  void _deleteItem(int index){
    setState(() {
      if(list[index] != null){
        list.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.separated(
          itemBuilder: (context, index) {
            return TransformerTextField(
              index: index,
              text: list[index],
              onUpdate: _updateText,
              onTransform: _transformFunction,
              onDelete: _deleteItem,
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: list.length,
        ),
      ),
    );
  }
}
