import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolbarComponent extends StatelessWidget {
  const ToolbarComponent({
    Key? key,
    required this.line,
    required this.col,
    required this.onTerminalToggle,
  }) : super(key: key);

  final int line;
  final int col;
  final void Function() onTerminalToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              color: Color(0xff24292e),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Ln $line, Col $col",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(flex: 1),
                  InkWell(
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: FaIcon(
                        FontAwesomeIcons.terminal,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                    onTap: onTerminalToggle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
