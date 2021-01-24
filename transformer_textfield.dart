import 'package:flutter/material.dart';

class TransformerTextField extends StatefulWidget {
  final int index;
  final String text;
  final Function onTransform;
  final Function onUpdate;
  final Function onDelete;

  TransformerTextField(
      {this.index, this.text, this.onTransform, this.onUpdate, this.onDelete});

  @override
  _TransformerTextFieldState createState() => _TransformerTextFieldState();
}

class _TransformerTextFieldState extends State<TransformerTextField> {
  bool isEnabled = false;
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.text;
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
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
        // Start cursor at end of text when tapped on
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
      });
    } else {
      // Update the original text value
      _updateText();
      setState(() {
        // Toggle to the text view
        isEnabled = false;
      });
    }
  }

  void _updateText() {
    widget.onUpdate(widget.index, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isEnabled = true;
          _focusNode.requestFocus();
        });
      },
      child: Container(
        child: isEnabled == true
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  focusNode: _focusNode,
                  controller: _controller,
                  autofocus: true,
                ),
              )
            : Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  widget.onDelete(widget.index);
                },
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                direction: DismissDirection.endToStart,
                child: Center(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    constraints: BoxConstraints(
                      minHeight: 50,
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(widget.onTransform(_controller.text)),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
