import 'package:flutter/material.dart';

class EditorFieldComponent extends StatefulWidget {
  const EditorFieldComponent(
      {Key? key, this.initialCode, required this.onChange})
      : super(key: key);

  final String? initialCode;
  final void Function(int, int, String) onChange;

  @override
  State<EditorFieldComponent> createState() => _EditorFieldComponentState();
}

class _EditorFieldComponentState extends State<EditorFieldComponent> {
  late TextEditingController _editorController;

  _listener() {
    final List<String> arr = _editorController.text.split("\n");

    int lineHandler = 1;
    int colHandler = 1;

    for (var i = 0; i < arr.length; i++) {
      final List<String> reducedArr = arr.sublist(0, i + 1);

      final String code =
          reducedArr.reduce((value, element) => value + "_" + element);

      if (code.length >= _editorController.selection.base.offset) {
        lineHandler = i + 1;

        if (reducedArr.length <= 1) {
          colHandler = code.length -
              (code.length - (_editorController.selection.base.offset + 1));
        } else {
          final reducedArrHandler = reducedArr
              .sublist(0, i)
              .reduce((value, element) => value + "_" + element);

          colHandler = _editorController.selection.base.offset -
              reducedArrHandler.length;
        }

        break;
      }
    }

    widget.onChange(lineHandler, colHandler, _editorController.text);
  }

  @override
  void initState() {
    _editorController = TextEditingController(text: widget.initialCode);

    _editorController.addListener(_listener);

    super.initState();
  }

  @override
  void dispose() {
    _editorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _editorController,
      minLines: null,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.only(left: 5),
        border: InputBorder.none,
        filled: true,
        fillColor: Color(0xff24292e),
      ),
      style: const TextStyle(
        color: Colors.white,
      ),
    );
  }
}
