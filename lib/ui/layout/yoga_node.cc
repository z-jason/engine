// TODO(kaikaiz): Copyright.

#include "flutter/lib/ui/layout/yoga_node.h"

#include "flutter/fml/memory/ref_ptr.h"
#include "third_party/tonic/dart_binding_macros.h"
#include "third_party/tonic/dart_library_natives.h"

namespace blink {

namespace {

// YogaStyle properties

#define STYLE_MASK(name, bit) const int kStyle##name##Mask = 1 << bit

STYLE_MASK(Direction, 0);
STYLE_MASK(FlexDirection, 1);
STYLE_MASK(JustifyContent, 2);
STYLE_MASK(AlignContent, 3);
STYLE_MASK(AlignItems, 4);
STYLE_MASK(AlignSelf, 5);
STYLE_MASK(PositionType, 6);
STYLE_MASK(FlexWrap, 7);
STYLE_MASK(Overflow, 8);
STYLE_MASK(Display, 9);
STYLE_MASK(Flex, 10);
STYLE_MASK(FlexGrow, 11);
STYLE_MASK(FlexShrink, 12);
STYLE_MASK(FlexBasis, 13);
STYLE_MASK(Margin, 14);
STYLE_MASK(Position, 15);
STYLE_MASK(Padding, 16);
STYLE_MASK(Border, 17);
STYLE_MASK(Width, 18);
STYLE_MASK(Height, 19);
STYLE_MASK(MinWidth, 20);
STYLE_MASK(MinHeight, 21);
STYLE_MASK(MaxWidth, 22);
STYLE_MASK(MaxHeight, 23);
STYLE_MASK(AspectRatio, 24);

YGValue DecodeYGValue(tonic::Int32List &intList, tonic::Float64List &doubleList, int *intIndex, int *doubleIndex) {
  return (YGValue){.value = (float)doubleList[(*doubleIndex)++], .unit = (YGUnit)intList[(*intIndex)++]};
}

}  // namespace

static void YogaNode_constructor(Dart_NativeArguments args) {
  DartCallConstructor(&YogaNode::Create, args);
}

IMPLEMENT_WRAPPERTYPEINFO(ui, YogaNode);

#define FOR_EACH_BINDING(V)          \
  V(YogaNode, nodeId)                \
  V(YogaNode, rect)                  \
  V(YogaNode, addChild)              \
  V(YogaNode, calculateLayout)       \
  V(YogaNode, startParagraphBuilder) \
  V(YogaNode, pushTextStyle)         \
  V(YogaNode, popTextStyle)          \
  V(YogaNode, addText)               \
  V(YogaNode, endParagraphBuilder)   \
  V(YogaNode, printStyle)            \
  V(YogaNode, printLayout)

FOR_EACH_BINDING(DART_NATIVE_CALLBACK)

void YogaNode::RegisterNatives(tonic::DartLibraryNatives *natives) {
  natives->Register(
      {{"YogaNode_constructor", YogaNode_constructor, 3, true},
       FOR_EACH_BINDING(DART_REGISTER_NATIVE)});
}

fml::RefPtr<YogaNode> YogaNode::Create(tonic::Int32List &intList, tonic::Float64List &doubleList) {
  return fml::MakeRefCounted<YogaNode>(intList, doubleList);
}

YGSize YogaNode::MeasureFunc(YGNodeRef node, float width, YGMeasureMode widthMode, float height, YGMeasureMode heightMode) {
  Paragraph *paragraph = static_cast<Paragraph *>(YGNodeGetContext(node));
  // TODO(kaikaiz): Yoga won't call this function with both *Exactly* modes. So anyway we'll have to do the layout.
  paragraph->layout(width);
  // TODO(kaikaiz): figure out why we cannot use paragraph->width().
  float actualWidth = widthMode == YGMeasureModeExactly ? width : std::min(width, (float)paragraph->minIntrinsicWidth());
  float actualHeight = heightMode == YGMeasureModeExactly ? height : std::min(height, (float)paragraph->height());
  return (YGSize){.width = actualWidth, .height = actualHeight};
}

// TODO(kaikaiz): those macros are for personal convenience.

#define EXTRACT_ENUM_STYLE(name, type)                       \
  if (mask & kStyle##name##Mask) {                           \
    YGNodeStyleSet##name(m_node, (type)intList[intIndex++]); \
  }

#define EXTRACT_FLOAT_STYLE(name)                                   \
  if (mask & kStyle##name##Mask) {                                  \
    YGNodeStyleSet##name(m_node, (float)doubleList[doubleIndex++]); \
  }

#define EXTRACT_VALUE_STYLE(name)                                    \
  if (mask & kStyle##name##Mask) {                                   \
    YGValue value =                                                  \
        DecodeYGValue(intList, doubleList, &intIndex, &doubleIndex); \
    switch (value.unit) {                                            \
      case YGUnitPoint:                                              \
        YGNodeStyleSet##name(m_node, value.value);                   \
        break;                                                       \
      case YGUnitPercent:                                            \
        YGNodeStyleSet##name##Percent(m_node, value.value);          \
        break;                                                       \
      default:                                                       \
        break;                                                       \
    }                                                                \
  }

#define EXTRACT_VALUE_AUTO_STYLE(name)                               \
  if (mask & kStyle##name##Mask) {                                   \
    YGValue value =                                                  \
        DecodeYGValue(intList, doubleList, &intIndex, &doubleIndex); \
    switch (value.unit) {                                            \
      case YGUnitPoint:                                              \
        YGNodeStyleSet##name(m_node, value.value);                   \
        break;                                                       \
      case YGUnitPercent:                                            \
        YGNodeStyleSet##name##Percent(m_node, value.value);          \
        break;                                                       \
      case YGUnitAuto:                                               \
        YGNodeStyleSet##name##Auto(m_node);                          \
        break;                                                       \
      default:                                                       \
        break;                                                       \
    }                                                                \
  }

#define EXTRACT_EDGE_VALUE_STYLE(name)                                     \
  if (mask & kStyle##name##Mask) {                                         \
    int edgeMask = intList[intIndex++];                                    \
    for (int i = 0; i < YGEdgeCount; ++i) {                                \
      if (edgeMask & (1 << i)) {                                           \
        YGValue value =                                                    \
            DecodeYGValue(intList, doubleList, &intIndex, &doubleIndex);   \
        switch (value.unit) {                                              \
          case YGUnitPoint:                                                \
            YGNodeStyleSet##name(m_node, (YGEdge)i, value.value);          \
            break;                                                         \
          case YGUnitPercent:                                              \
            YGNodeStyleSet##name##Percent(m_node, (YGEdge)i, value.value); \
            break;                                                         \
          default:                                                         \
            break;                                                         \
        }                                                                  \
      }                                                                    \
    }                                                                      \
  }

#define EXTRACT_EDGE_FLOAT_STYLE(name)                                      \
  if (mask & kStyle##name##Mask) {                                          \
    int edgeMask = intList[intIndex++];                                     \
    for (int i = 0; i < YGEdgeCount; ++i) {                                 \
      if (edgeMask & (1 << i)) {                                            \
        YGNodeStyleSet##name(m_node, (YGEdge)i, doubleList[doubleIndex++]); \
      }                                                                     \
    }                                                                       \
  }

#define EXTRACT_EDGE_VALUE_AUTO_STYLE(name)                                \
  if (mask & kStyle##name##Mask) {                                         \
    int edgeMask = intList[intIndex++];                                    \
    for (int i = 0; i < YGEdgeCount; ++i) {                                \
      if (edgeMask & (1 << i)) {                                           \
        YGValue value =                                                    \
            DecodeYGValue(intList, doubleList, &intIndex, &doubleIndex);   \
        switch (value.unit) {                                              \
          case YGUnitPoint:                                                \
            YGNodeStyleSet##name(m_node, (YGEdge)i, value.value);          \
            break;                                                         \
          case YGUnitPercent:                                              \
            YGNodeStyleSet##name##Percent(m_node, (YGEdge)i, value.value); \
            break;                                                         \
          case YGUnitAuto:                                                 \
            YGNodeStyleSet##name##Auto(m_node, (YGEdge)i);                 \
            break;                                                         \
          default:                                                         \
            break;                                                         \
        }                                                                  \
      }                                                                    \
    }                                                                      \
  }

YogaNode::YogaNode(tonic::Int32List &intList, tonic::Float64List &doubleList) {
  m_node = YGNodeNew();

  int mask = intList[0];
  int intIndex = 1;
  int doubleIndex = 0;

  EXTRACT_ENUM_STYLE(Direction, YGDirection);
  EXTRACT_ENUM_STYLE(FlexDirection, YGFlexDirection);
  EXTRACT_ENUM_STYLE(JustifyContent, YGJustify);
  EXTRACT_ENUM_STYLE(AlignContent, YGAlign);
  EXTRACT_ENUM_STYLE(AlignItems, YGAlign);
  EXTRACT_ENUM_STYLE(AlignSelf, YGAlign);
  EXTRACT_ENUM_STYLE(PositionType, YGPositionType);
  EXTRACT_ENUM_STYLE(FlexWrap, YGWrap);
  EXTRACT_ENUM_STYLE(Overflow, YGOverflow);
  EXTRACT_ENUM_STYLE(Display, YGDisplay);
  EXTRACT_FLOAT_STYLE(Flex);
  EXTRACT_FLOAT_STYLE(FlexGrow);
  EXTRACT_FLOAT_STYLE(FlexShrink);
  EXTRACT_VALUE_AUTO_STYLE(FlexBasis);
  EXTRACT_EDGE_VALUE_STYLE(Position);
  EXTRACT_EDGE_VALUE_AUTO_STYLE(Margin);
  EXTRACT_EDGE_VALUE_STYLE(Padding);
  EXTRACT_EDGE_FLOAT_STYLE(Border);
  EXTRACT_VALUE_AUTO_STYLE(Width);
  EXTRACT_VALUE_AUTO_STYLE(Height);
  EXTRACT_VALUE_STYLE(MinWidth);
  EXTRACT_VALUE_STYLE(MinHeight);
  EXTRACT_VALUE_STYLE(MaxWidth);
  EXTRACT_VALUE_STYLE(MaxHeight);
  EXTRACT_FLOAT_STYLE(AspectRatio);
}

// TODO(kaikaiz): free the underlaying YGNodeRef?
YogaNode::~YogaNode() = default;

}  // namespace blink
