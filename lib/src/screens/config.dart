import 'package:flutter/material.dart';
import 'package:js_editor/src/components/appbar.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          color: const Color(0xff1f2428),
        ),
        child: Column(
          children: const [
            AppbarComponent(
              goBack: true,
            ),
          ],
        ),
      ),
    );
  }
}
