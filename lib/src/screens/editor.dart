import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:js_editor/src/components/appbar.dart';
import 'package:js_editor/src/components/editor_field.dart';
import 'package:js_editor/src/components/toolbar.dart';
import 'package:js_editor/src/utils/js_runtime.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  @override
  _EditorScreenState createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final _editorKey = GlobalKey();
  final JsRuntime _jsRuntime = JsRuntime();
  final _terminalScrollController = ScrollController();
  final List<String> _terminalLogs = ['Welcome to terminal! Happy coding.'];
  bool _terminalShow = false;
  int _line = 1;
  int _col = 1;
  String _code = "";
  List<int?> _gutter = [1];

  _toggleTerminal() {
    setState(() {
      _terminalShow = !_terminalShow;
    });
  }

  _executeCode() async {
    final List<String> logs = await _jsRuntime.execute(_code);

    setState(() {
      _terminalLogs.addAll(logs);
    });
  }

  _scrollTerminalBottom() {
    if (_terminalScrollController.hasClients) {
      _terminalScrollController
          .jumpTo(_terminalScrollController.position.maxScrollExtent);
    }
  }

  _editorFieldChange(int line, int col, String code) {
    final double editorWidth = _editorKey.currentContext!.size!.width;

    final splitted = _code.split("\n");
    final List<int?> splittedHandler = [];

    int lastIndex = 0;

    print(editorWidth);
    print(splitted[0].length);

    for (var i = 0; i < splitted.length; i++) {
      splittedHandler.add(lastIndex + 1);

      if (editorWidth / splitted[i].length < 11) {
        splittedHandler.add(null);
      }

      lastIndex++;
    }

    print(splittedHandler);

    setState(
      () {
        _line = line;
        _col = col;
        _code = code;

        _gutter = splittedHandler;
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _terminalScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      _scrollTerminalBottom();
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: const Color(0xff1f2428),
        ),
        child: Column(
          children: [
            AppbarComponent(
              onExecutePressed: _executeCode,
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: 40,
                          padding: const EdgeInsets.all(0),
                          decoration: const BoxDecoration(
                            color: Color(0xff24292e),
                            border: Border(
                              right: BorderSide(
                                color: Colors.white12,
                                width: 1,
                              ),
                            ),
                          ),
                          child: ListView(
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _gutter
                                    .map(
                                      (index) => Text(
                                        index != null ? "$index" : "",
                                        style: TextStyle(
                                          color: index != null
                                              ? (_line == index
                                                  ? Colors.white
                                                  : Colors.white12)
                                              : Colors.white,
                                          height: 1.71,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: EditorFieldComponent(
                      key: _editorKey,
                      onChange: _editorFieldChange,
                    ),
                  ),
                ],
              ),
            ),
            ToolbarComponent(
              line: _line,
              col: _col,
              onTerminalToggle: _toggleTerminal,
            ),
            if (_terminalShow)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Color(0xff1f2428),
                      ),
                      child: ListView(
                        padding: const EdgeInsets.all(5),
                        controller: _terminalScrollController,
                        children: _terminalLogs
                            .map(
                              (line) => Text(
                                line,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Int {}
