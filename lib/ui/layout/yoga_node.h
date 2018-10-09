// TODO(kaikaiz): Copyright.

#ifndef FLUTTER_LIB_UI_LAYOUT_YOGA_NODE_H_
#define FLUTTER_LIB_UI_LAYOUT_YOGA_NODE_H_

#include "flutter/lib/ui/dart_wrapper.h"
#include "flutter/lib/ui/layout/yoga_rect.h"
#include "flutter/third_party/yoga/src/Yoga.h"
#include "third_party/tonic/typed_data/float64_list.h"
#include "third_party/tonic/typed_data/int32_list.h"

namespace tonic {
class DartLibraryNatives;
}  // namespace tonic

namespace blink {

class YogaNode : public RefCountedDartWrappable<YogaNode> {
  DEFINE_WRAPPERTYPEINFO();
  FML_FRIEND_MAKE_REF_COUNTED(YogaNode);

 public:
  static fml::RefPtr<YogaNode> Create(const tonic::Int32List &intList, const tonic::Float64List &doubleList);

  ~YogaNode() override;

  intptr_t nodeId() {
    return reinterpret_cast<intptr_t>(m_node);
  }

  YogaRect rect() {
    return YogaRect(YGNodeLayoutGetLeft(m_node), YGNodeLayoutGetTop(m_node), YGNodeLayoutGetWidth(m_node), YGNodeLayoutGetHeight(m_node));
  }

  void addChild(intptr_t childNodeId) {
    YGNodeInsertChild(m_node, reinterpret_cast<YGNodeRef>(childNodeId), YGNodeGetChildCount(m_node));
  }

  void calculateLayout(double width, double height, int direction) {
    YGNodeCalculateLayout(m_node, width, height, (YGDirection)direction);
  }

  void setTextLayoutClosure(Dart_Handle textLayoutClosure) {
    Dart_PersistentHandle oldHandle = static_cast<Dart_PersistentHandle>(YGNodeGetContext(m_node));
    if (oldHandle != nullptr) {
      Dart_DeletePersistentHandle(oldHandle);
    }
    if (Dart_IsNull(textLayoutClosure)) {
      YGNodeSetContext(m_node, nullptr);
      YGNodeSetMeasureFunc(m_node, nullptr);
    } else {
      // Balanced here, or in the destructor.
      YGNodeSetContext(m_node, Dart_NewPersistentHandle(textLayoutClosure));
      YGNodeSetMeasureFunc(m_node, MeasureFunc);
    }
  }

  // TODO(kaikaiz): only for debug.

  void printStyle() {
    YGNodePrint(m_node, (YGPrintOptions)(YGPrintOptionsChildren | YGPrintOptionsStyle));
  }
  void printLayout() {
    YGNodePrint(m_node, (YGPrintOptions)(YGPrintOptionsChildren | YGPrintOptionsLayout));
  }

  static YGSize MeasureFunc(YGNodeRef node,
                            float width,
                            YGMeasureMode widthMode,
                            float height,
                            YGMeasureMode heightMode);

  static void RegisterNatives(tonic::DartLibraryNatives *natives);

 private:
  YGNodeRef m_node;
  explicit YogaNode(const tonic::Int32List &intList, const tonic::Float64List &doubleList);
};

}  // namespace blink

#endif  // FLUTTER_LIB_UI_LAYOUT_YOGA_NODE_H_
