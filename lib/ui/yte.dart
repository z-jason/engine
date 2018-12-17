// TODO(kaikaiz): Copyright.

part of dart.ui;

class YteResult {
  YteResult._(ByteData raw)
      : errorCode = raw.getUint8(0) + (raw.getUint8(1) << 8),
        content = raw.buffer.asUint8List(2);
  final int errorCode;
  final Uint8List content;
  bool get ok => errorCode == 0;
  String get errorMessage => ok ? null : '$errorCode: ' + String.fromCharCodes(content);
}

/// See https://groups.google.com/forum/#!topic/flutter-dev/H0mcfMOMcjY for why NativeFieldWrapperClass2 is required.
class YteUnifiedResolver extends NativeFieldWrapperClass2 {
  YteUnifiedResolver._() {
    _constructor();
  }

  static final YteUnifiedResolver _singleton = YteUnifiedResolver._();

  static YteResult resolve(Uint8List templateConfig, Uint8List model, Uint8List hostProperties) =>
      YteResult._(_singleton._resolve(templateConfig, model, hostProperties));

  // ======= Below are C++ natives =======

  ByteData _resolve(Uint8List templateConfig, Uint8List model, Uint8List hostProperties) native 'YteUnifiedResolver_resolve';

  void _constructor() native 'YteUnifiedResolver_constructor';
}

/// See https://groups.google.com/forum/#!topic/flutter-dev/H0mcfMOMcjY for why NativeFieldWrapperClass2 is required.
class YteEkoProcessor extends NativeFieldWrapperClass2 {
  // The transform bytes will be copied and retained in C++.
  YteEkoProcessor(Uint8List transform) {
    _constructor(transform);
  }

  YteResult process(Uint8List input) => YteResult._(_process(input));

  // ======= Below are C++ natives =======

  ByteData _process(Uint8List input) native 'YteEkoProcessor_process';

  void _constructor(Uint8List transform) native 'YteEkoProcessor_constructor';
}
