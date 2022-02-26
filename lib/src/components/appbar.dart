import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppbarComponent extends StatelessWidget {
  const AppbarComponent({
    Key? key,
    this.goBack = false,
    this.onExecutePressed,
  }) : super(key: key);

  final bool goBack;
  final void Function()? onExecutePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: MediaQuery.of(context).viewPadding.top + 45,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewPadding.top,
              left: 10,
              right: 10,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              color: Color(0xff1f2428),
            ),
            child: Row(
              children: goBack
                  ? [
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ]
                  : [
                      const Text(
                        "MiniJSEditor",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.play,
                          color: Colors.white,
                        ),
                        onPressed: onExecutePressed,
                      ),
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.cog,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/config');
                        },
                      ),
                    ],
            ),
          ),
        )
      ],
    );
  }
}
