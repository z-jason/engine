// TODO(kaikaiz): Copyright.

#ifndef FLUTTER_LIB_UI_LAYOUT_YOGA_NODE_H_
#define FLUTTER_LIB_UI_LAYOUT_YOGA_NODE_H_

#include <vector>

#include "flutter/lib/ui/dart_wrapper.h"
#include "flutter/lib/ui/layout/yoga_rect.h"
#include "flutter/lib/ui/text/paragraph.h"
#include "flutter/lib/ui/text/paragraph_builder.h"
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
  static fml::RefPtr<YogaNode> Create(tonic::Int32List &intList, tonic::Float64List &doubleList);

  ~YogaNode() override;

  int nodeId() {
    return m_nodeId;
  }

  YogaRect rect() {
    YGNodeRef node = nodes[m_nodeId];
    return YogaRect(YGNodeLayoutGetLeft(node), YGNodeLayoutGetTop(node), YGNodeLayoutGetWidth(node), YGNodeLayoutGetHeight(node));
  }

  void addChild(int childNodeId) {
    YGNodeInsertChild(nodes[m_nodeId], nodes[childNodeId], YGNodeGetChildCount(nodes[m_nodeId]));
  }

  void calculateLayout(double width, double height, int direction);

  std::vector<YogaRect> flattenedLayout();

  // TODO(kaikaiz): for now, exactly as those in paragraph_builder.

  void startParagraphBuilder(tonic::Int32List &encoded,
                             const std::string &fontFamily,
                             double fontSize,
                             double lineHeight,
                             const std::u16string &ellipsis,
                             const std::string &locale) {
    m_paragraphBuilder = ParagraphBuilder::create(encoded, fontFamily, fontSize, lineHeight, ellipsis, locale);
  }
  void pushTextStyle(tonic::Int32List& encoded,
                     const std::string& fontFamily,
                     double fontSize,
                     double letterSpacing,
                     double wordSpacing,
                     double height,
                     const std::string& locale,
                     Dart_Handle background_objects,
                     Dart_Handle background_data,
                     Dart_Handle foreground_objects,
                     Dart_Handle foreground_data) {
    m_paragraphBuilder->pushStyle(encoded,
                                  fontFamily,
                                  fontSize,
                                  letterSpacing,
                                  wordSpacing,
                                  height,
                                  locale,
                                  background_objects,
                                  background_data,
                                  foreground_objects,
                                  foreground_data);
  }
  void popTextStyle() {
    m_paragraphBuilder->pop();
  }
  Dart_Handle addText(const std::u16string &text) {
    return m_paragraphBuilder->addText(text);
  }
  void endParagraphBuilder() {
    // TODO(kaikaiz): memory management. Release the builder?
    m_paragraph = m_paragraphBuilder->build();
    YGNodeSetContext(nodes[m_nodeId], m_paragraph.get());
    YGNodeSetMeasureFunc(nodes[m_nodeId], MeasureFunc);
  }

  // TODO(kaikaiz): only for debug.

  void printStyle() {
    YGNodePrint(nodes[m_nodeId], (YGPrintOptions)(YGPrintOptionsChildren | YGPrintOptionsStyle));
  }
  void printLayout() {
    YGNodePrint(nodes[m_nodeId], (YGPrintOptions)(YGPrintOptionsChildren | YGPrintOptionsLayout));
  }

  static YGSize MeasureFunc(YGNodeRef node,
                            float width,
                            YGMeasureMode widthMode,
                            float height,
                            YGMeasureMode heightMode);

  static void RegisterNatives(tonic::DartLibraryNatives *natives);

 private:
  static std::vector<YGNodeRef> nodes;
  int m_nodeId;

  double m_lastWidth;
  double m_lastHeight;
  int m_lastDirection;

  std::vector<YogaRect> m_flattenedLayout;

  fml::RefPtr<ParagraphBuilder> m_paragraphBuilder;
  fml::RefPtr<Paragraph> m_paragraph;
  explicit YogaNode(tonic::Int32List &intList, tonic::Float64List &doubleList);
};

}  // namespace blink

#endif  // FLUTTER_LIB_UI_LAYOUT_YOGA_NODE_H_
