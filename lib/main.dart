import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:js_editor/src/screens/config.dart';
import 'package:js_editor/src/screens/editor.dart';
import 'package:flutter_jscore/binding/jsc_ffi.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  JscFfi.lib = Platform.isIOS || Platform.isMacOS
      ? DynamicLibrary.open('JavaScriptCore.framework/JavaScriptCore')
      : Platform.isWindows
          ? DynamicLibrary.open('JavaScriptCore.dll')
          : Platform.isLinux
              ? DynamicLibrary.open('libjavascriptcoregtk-4.0.so.18')
              : DynamicLibrary.open('libjsc.so');

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Javascript Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => const EditorScreen(),
        "/config": (context) => const ConfigScreen(),
      },
    );
  }
}
