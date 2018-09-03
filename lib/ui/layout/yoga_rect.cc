// TODO(kaikaiz): Copyright.

#include "flutter/lib/ui/layout/yoga_rect.h"

#include "flutter/fml/logging.h"
#include "third_party/tonic/dart_class_library.h"
#include "third_party/tonic/dart_state.h"
#include "third_party/tonic/logging/dart_error.h"

using namespace blink;

namespace tonic {

namespace {

Dart_Handle GetYogaRectType() {
  DartClassLibrary &class_library = DartState::Current()->class_library();
  Dart_Handle type =
      Dart_HandleFromPersistent(class_library.GetClass("ui", "YogaRect"));
  FML_DCHECK(!LogIfError(type));
  return type;
}

}  // namespace

void DartConverter<YogaRect>::SetReturnValue(Dart_NativeArguments args, const YogaRect &val) {
  Dart_SetReturnValue(args, ToDart(val));
}

Dart_Handle DartConverter<YogaRect>::ToDart(const YogaRect &val) {
  constexpr int argc = 4;
  Dart_Handle argv[argc] = {
      tonic::ToDart(val.left),
      tonic::ToDart(val.top),
      tonic::ToDart(val.width),
      tonic::ToDart(val.height),
  };
  return Dart_New(GetYogaRectType(), tonic::ToDart("_"), argc, argv);
}

Dart_Handle DartListFactory<YogaRect>::NewList(intptr_t length) {
  return Dart_NewListOfType(GetYogaRectType(), length);
}

}  // namespace tonic
