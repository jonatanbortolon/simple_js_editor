import 'dart:ffi';
import 'package:flutter/services.dart';
import 'package:flutter_jscore/flutter_jscore.dart';
import 'package:js_editor/src/utils/format_duration.dart';

class JsRuntime {
  JsRuntime();

  final List<String> _logs = [];

  final JSContext _jsRuntime = JSContext.createInGroup();

  static Pointer flutterPrintLog(
    Pointer ctx,
    Pointer function,
    Pointer thisObject,
    int argumentCount,
    Pointer<Pointer> arguments,
    Pointer<Pointer> exception,
  ) {
    if (_printLogFunc != null) {
      _printLogFunc!(
        ctx,
        function,
        thisObject,
        argumentCount,
        arguments,
        exception,
      );
    }

    return nullptr;
  }

  static Pointer flutterPrintError(
    Pointer ctx,
    Pointer function,
    Pointer thisObject,
    int argumentCount,
    Pointer<Pointer> arguments,
    Pointer<Pointer> exception,
  ) {
    if (_printErrorFunc != null) {
      _printErrorFunc!(
        ctx,
        function,
        thisObject,
        argumentCount,
        arguments,
        exception,
      );
    }

    return nullptr;
  }

  static Pointer flutterPrintWarn(
    Pointer ctx,
    Pointer function,
    Pointer thisObject,
    int argumentCount,
    Pointer<Pointer> arguments,
    Pointer<Pointer> exception,
  ) {
    if (_printWarnFunc != null) {
      _printWarnFunc!(
        ctx,
        function,
        thisObject,
        argumentCount,
        arguments,
        exception,
      );
    }

    return nullptr;
  }

  static JSObjectCallAsFunctionCallbackDart? _printLogFunc;
  Pointer _printLog(
    Pointer ctx,
    Pointer function,
    Pointer thisObject,
    int argumentCount,
    Pointer<Pointer> arguments,
    Pointer<Pointer> exception,
  ) {
    if (argumentCount > 0) {
      _logs.add(
        "[${DateTime.now()}] Log: ${JSValue(_jsRuntime, arguments[0]).string}",
      );
    }

    return nullptr;
  }

  static JSObjectCallAsFunctionCallbackDart? _printErrorFunc;
  Pointer _printError(
    Pointer ctx,
    Pointer function,
    Pointer thisObject,
    int argumentCount,
    Pointer<Pointer> arguments,
    Pointer<Pointer> exception,
  ) {
    if (argumentCount > 0) {
      _logs.add(
        "[${DateTime.now()}] Error: ${JSValue(_jsRuntime, arguments[0]).string}",
      );
    }

    return nullptr;
  }

  static JSObjectCallAsFunctionCallbackDart? _printWarnFunc;
  Pointer _printWarn(
    Pointer ctx,
    Pointer function,
    Pointer thisObject,
    int argumentCount,
    Pointer<Pointer> arguments,
    Pointer<Pointer> exception,
  ) {
    if (argumentCount > 0) {
      _logs.add(
        "[${DateTime.now()}] Warn: ${JSValue(_jsRuntime, arguments[0]).string}",
      );
    }

    return nullptr;
  }

  Future<List<String>> execute(code) async {
    _logs.clear();

    _printLogFunc = _printLog;
    _printErrorFunc = _printError;
    _printWarnFunc = _printWarn;

    var consoleClass = JSClass.create(
      JSClassDefinition(
        version: 0,
        attributes: JSClassAttributes.kJSClassAttributeNone,
        className: 'console',
        staticFunctions: [
          JSStaticFunction(
            name: 'log',
            callAsFunction: Pointer.fromFunction(flutterPrintLog),
            attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
          ),
          JSStaticFunction(
            name: 'error',
            callAsFunction: Pointer.fromFunction(flutterPrintError),
            attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
          ),
          JSStaticFunction(
            name: 'warn',
            callAsFunction: Pointer.fromFunction(flutterPrintWarn),
            attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
          ),
        ],
      ),
    );

    var consoleObject = JSObject.make(_jsRuntime, consoleClass);

    _jsRuntime.globalObject.setProperty('console', consoleObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);

    final starttime = DateTime.now();

    try {
      _jsRuntime.evaluate(code);
    } on PlatformException catch (e) {
      _logs.add("[${DateTime.now()}] Error: ${e.details}.");
    }

    final endtime = DateTime.now();
    final duration = endtime.difference(starttime).inMilliseconds;

    _logs.add(
      "[${DateTime.now()}] Finished in ${FormatDuration.format(duration)}.",
    );

    return _logs;
  }
}
