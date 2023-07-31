import 'package:flutter/material.dart';

const c1 = 0xFFFDFFFC, c3 = 0xFF374B4A;

class NoteTitleEntry extends StatefulWidget {
  final _textFieldController;

  NoteTitleEntry(this._textFieldController);

  @override
  _NoteTitleEntry createState() => _NoteTitleEntry();
}

class _NoteTitleEntry extends State<NoteTitleEntry>
    with WidgetsBindingObserver {
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void didChangeMetrics() {
  //   final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
  //   if (bottomInset <= 0.0) {
  //     _textFieldFocusNode.unfocus();
  //   }
  // }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._textFieldController,
      focusNode: _textFieldFocusNode,
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
        counter: null,
        counterText: "",
        hintText: 'Title',
        hintStyle: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
      ),
      maxLength: 31,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        height: 1.5,
        color: Color(c1),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }
}
