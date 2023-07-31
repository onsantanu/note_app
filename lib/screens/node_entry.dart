import 'package:flutter/material.dart';

class NoteEntry extends StatefulWidget {
  final _textFieldController;

  NoteEntry(this._textFieldController);

  @override
  _NoteEntry createState() => _NoteEntry();
}

class _NoteEntry extends State<NoteEntry> with WidgetsBindingObserver {
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    if (bottomInset <= 0.0) {
      _textFieldFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        controller: widget._textFieldController,
        focusNode: _textFieldFocusNode,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: null,
        style: const TextStyle(
          fontSize: 19,
          height: 1.5,
        ),
      ),
    );
  }
}
