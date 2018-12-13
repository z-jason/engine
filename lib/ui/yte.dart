// TODO(kaikaiz): Copyright.

part of dart.ui;

/// See https://groups.google.com/forum/#!topic/flutter-dev/H0mcfMOMcjY for why NativeFieldWrapperClass2 is required.
class YteUnifiedResolver extends NativeFieldWrapperClass2 {
  YteUnifiedResolver._() {
    _constructor();
  }

  static final YteUnifiedResolver _singleton = YteUnifiedResolver._();

  static Uint8List resolve(Uint8List templateConfig, Uint8List model, Uint8List hostProperties) =>
      _singleton._resolve(templateConfig, model, hostProperties);

  // ======= Below are C++ natives =======

  Uint8List _resolve(Uint8List templateConfig, Uint8List model, Uint8List hostProperties) native 'YteUnifiedResolver_resolve';

  void _constructor() native 'YteUnifiedResolver_constructor';
}

/// See https://groups.google.com/forum/#!topic/flutter-dev/H0mcfMOMcjY for why NativeFieldWrapperClass2 is required.
class YteEkoProcessor extends NativeFieldWrapperClass2 {
  // The transform bytes will be copied and retained in C++.
  YteEkoProcessor(Uint8List transform) {
    _constructor(transform);
  }

  // ======= Below are C++ natives =======

  Uint8List process(Uint8List input) native 'YteEkoProcessor_process';

  void _constructor(Uint8List transform) native 'YteEkoProcessor_constructor';
}

