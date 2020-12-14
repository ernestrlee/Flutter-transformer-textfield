import 'package:flutter/material.dart';

class TransformerTextField extends StatefulWidget {
  final String text;
  final Function transformFunction;
  final Function updateFunction;

  TransformerTextField(
      {this.text, this.transformFunction, this.updateFunction});

  @override
  _TransformerTextFieldState createState() => _TransformerTextFieldState();
}

class _TransformerTextFieldState extends State<TransformerTextField> {
  bool isEnabled = false;
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _controller.addListener(updateText);
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasPrimaryFocus) {
      setState(() {
        // Toggle to texfield view
        isEnabled = true;
        // Populate the texfield with the text
        _controller.text = widget.text;
      });
    } else {
      setState(() {
        // Update the original text value
        widget.updateFunction(_controller.text);
        // Toggle to the text view
        isEnabled = false;
      });
    }
  }

  void updateText() {
    widget.updateFunction(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      alignment: Alignment.centerLeft,
      constraints: BoxConstraints(
        minHeight: 50.0,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: isEnabled == true
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                focusNode: _focusNode,
                controller: _controller,
                autofocus: isEnabled == true ? true : false,
              ),
            )
          : GestureDetector(
              onTap: () {
                setState(() {
                  isEnabled = true;
                  _focusNode.requestFocus();
                });
              },
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.transformFunction(widget.text)),
                ),
              ),
            ),
    );
  }
}
