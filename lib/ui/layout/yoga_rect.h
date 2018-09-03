// TODO(kaikaiz): Copyright.

#ifndef FLUTTER_LIB_UI_LAYOUT_YOGA_RECT_H_
#define FLUTTER_LIB_UI_LAYOUT_YOGA_RECT_H_

#include "third_party/dart/runtime/include/dart_api.h"
#include "third_party/tonic/converter/dart_converter.h"

namespace blink {

struct YogaRect {
  float left;
  float top;
  float width;
  float height;

  YogaRect(float l, float t, float w, float h) : left(l), top(t), width(w), height(h) {}
};

}  // namespace blink

namespace tonic {

template <>
struct DartConverter<blink::YogaRect> {
  static void SetReturnValue(Dart_NativeArguments args, const blink::YogaRect &val);
  static Dart_Handle ToDart(const blink::YogaRect &val);
};

template <>
struct DartListFactory<blink::YogaRect> {
  static Dart_Handle NewList(intptr_t length);
};

}  // namespace tonic

#endif  // FLUTTER_LIB_UI_LAYOUT_YOGA_RECT_H_
