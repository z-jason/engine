// TODO(kaikaiz): Copyright.

part of dart.ui;

/// YGAlign
enum YogaAlign {
  auto,
  flexStart,
  center,
  flexEnd,
  stretch,
  baseline,
  spaceBetween,
  spaceAround,
}

/// YGDirection
enum YogaDirection {
  inherit,
  ltr,
  rtl,
}

/// YGDisplay
enum YogaDisplay {
  flex,
  none,
}

/// YGFlexDirection
enum YogaFlexDirection {
  column,
  columnReverse,
  row,
  rowReverse,
}

/// YGJustify
enum YogaJustify {
  flexStart,
  center,
  flexEnd,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

/// YGOverflow
enum YogaOverflow {
  visible,
  hidden,
  scroll,
}

/// YGPositionType
enum YogaPositionType {
  relative,
  absolute,
}

/// YGUnit
enum YogaUnit {
  undefined,
  point,
  percent,
  auto,
}

/// YGWrap
enum YogaWrap {
  noWrap,
  wrap,
  wrapReverse,
}

class YogaValue {
  final double value;
  final YogaUnit unit;

  // TODO(kaikaiz): add assertions for double
  const YogaValue(this.value, this.unit);
  const YogaValue.point(double value) : this(value, YogaUnit.point);
  const YogaValue.percent(double value) : this(value, YogaUnit.percent);

  // This is YGValueAuto.
  // static final YogaValue auto = const YogaValue(0.0, YogaUnit.auto);

  // This is YGValueUndefined.
  // static final YogaValue undefined = const YogaValue(0.0, YogaUnit.undefined);

  void _encode(List<int> intList, List<double> doubleList) {
    doubleList.add(value);
    intList.add(unit.index);
  }
}

/// TODO(kaikaiz): there is no resolving logic - we simply pass it to Yoga.
class YogaEdgeInsets {
  YogaValue left;
  YogaValue top;
  YogaValue right;
  YogaValue bottom;
  YogaValue start;
  YogaValue end;
  YogaValue horizontal;
  YogaValue vertical;
  YogaValue all;

  YogaEdgeInsets({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.start,
    this.end,
    this.horizontal,
    this.vertical,
    this.all,
  });

  /** static final YogaEdgeInsets undefined = YogaEdgeInsets(
      YogaValue.undefined,
      YogaValue.undefined,
      YogaValue.undefined,
      YogaValue.undefined,
      YogaValue.undefined,
      YogaValue.undefined,
      YogaValue.undefined,
      YogaValue.undefined,
      YogaValue.undefined); */

  // TODO(kaikaiz): override operator==, hashCode and toString.

  void _encode(List<int> intList, List<double> doubleList) {
    int maskIndex = intList.length;
    intList.add(0);
    if (left != null) {
      intList[maskIndex] |= 1 << 0;
      left._encode(intList, doubleList);
    }
    if (top != null) {
      intList[maskIndex] |= 1 << 1;
      top._encode(intList, doubleList);
    }
    if (right != null) {
      intList[maskIndex] |= 1 << 2;
      right._encode(intList, doubleList);
    }
    if (bottom != null) {
      intList[maskIndex] |= 1 << 3;
      bottom._encode(intList, doubleList);
    }
    if (start != null) {
      intList[maskIndex] |= 1 << 4;
      start._encode(intList, doubleList);
    }
    if (end != null) {
      intList[maskIndex] |= 1 << 5;
      end._encode(intList, doubleList);
    }
    if (horizontal != null) {
      intList[maskIndex] |= 1 << 6;
      right._encode(intList, doubleList);
    }
    if (vertical != null) {
      intList[maskIndex] |= 1 << 7;
      bottom._encode(intList, doubleList);
    }
    if (all != null) {
      intList[maskIndex] |= 1 << 8;
      all._encode(intList, doubleList);
    }
  }
}

class YogaStyle {
  YogaDirection direction;
  YogaFlexDirection flexDirection;
  YogaJustify justifyContent;
  YogaAlign alignContent;
  YogaAlign alignItems;
  YogaAlign alignSelf;
  YogaPositionType positionType;
  YogaWrap flexWrap;
  YogaOverflow overflow;
  YogaDisplay display;
  double flex;
  double flexGrow;
  double flexShrink;
  YogaValue flexBasis;
  YogaEdgeInsets margin;
  YogaEdgeInsets position;
  YogaEdgeInsets padding;
  YogaEdgeInsets border;
  YogaValue width;
  YogaValue height;
  YogaValue minWidth;
  YogaValue minHeight;
  YogaValue maxWidth;
  YogaValue maxHeight;
  double aspectRatio;

  // TODO(kaikaiz): find way to map double.nan to YGFloatOptional
  YogaStyle({
    this.direction, // YogaDirection.inherit
    this.flexDirection, // YogaFlexDirection.column
    this.justifyContent, // YogaJustify.flexStart
    this.alignContent, // YogaAlign.flexStart
    this.alignItems, // YogaAlign.stretch
    this.alignSelf, // YogaAlign.auto
    this.positionType, // YogaPositionType.relative
    this.flexWrap, // YogaWrap.noWrap
    this.overflow, // YogaOverflow.visible
    this.display, // YogaDisplay.flex
    this.flex, // double.nan
    this.flexGrow, // double.nan
    this.flexShrink, // double.nan
    this.flexBasis, // YogaValue.auto
    this.margin, // YogaEdgeInsets.undefined
    this.position, // YogaEdgeInsets.undefined
    this.padding, // YogaEdgeInsets.undefined
    this.border, // YogaEdgeInsets.undefined
    this.width, // YogaValue.auto
    this.height, // YogaValue.auto
    this.minWidth, // YogaValue.undefined
    this.minHeight, // YogaValue.undefined
    this.maxWidth, // YogaValue.undefined
    this.maxHeight, // YogaValue.undefined
    this.aspectRatio, // double.nan
  });

  // TODO(kaikaiz): override operator==, hashCode and toString.

  // TODO(kaikaiz): Encoding should match those in C++, and seriously, we should use WhateverBuffers...
  void _encode(List<int> intList, List<double> doubleList) {
    int maskIndex = intList.length;
    intList.add(0);
    if (direction != null) {
      intList[maskIndex] |= 1 << 0;
      intList.add(direction.index);
    }
    if (flexDirection != null) {
      intList[maskIndex] |= 1 << 1;
      intList.add(flexDirection.index);
    }
    if (justifyContent != null) {
      intList[maskIndex] |= 1 << 2;
      intList.add(justifyContent.index);
    }
    if (alignContent != null) {
      intList[maskIndex] |= 1 << 3;
      intList.add(alignContent.index);
    }
    if (alignItems != null) {
      intList[maskIndex] |= 1 << 4;
      intList.add(alignItems.index);
    }
    if (alignSelf != null) {
      intList[maskIndex] |= 1 << 5;
      intList.add(alignSelf.index);
    }
    if (positionType != null) {
      intList[maskIndex] |= 1 << 6;
      intList.add(positionType.index);
    }
    if (flexWrap != null) {
      intList[maskIndex] |= 1 << 7;
      intList.add(flexWrap.index);
    }
    if (overflow != null) {
      intList[maskIndex] |= 1 << 8;
      intList.add(overflow.index);
    }
    if (display != null) {
      intList[maskIndex] |= 1 << 9;
      intList.add(display.index);
    }
    if (flex != null) {
      intList[maskIndex] |= 1 << 10;
      doubleList.add(flex);
    }
    if (flexGrow != null) {
      intList[maskIndex] |= 1 << 11;
      doubleList.add(flexGrow);
    }
    if (flexShrink != null) {
      intList[maskIndex] |= 1 << 12;
      doubleList.add(flexShrink);
    }
    if (flexBasis != null) {
      intList[maskIndex] |= 1 << 13;
      flexBasis._encode(intList, doubleList);
    }
    if (margin != null) {
      intList[maskIndex] |= 1 << 14;
      margin._encode(intList, doubleList);
    }
    if (position != null) {
      intList[maskIndex] |= 1 << 15;
      position._encode(intList, doubleList);
    }
    if (padding != null) {
      intList[maskIndex] |= 1 << 16;
      padding._encode(intList, doubleList);
    }
    if (border != null) {
      intList[maskIndex] |= 1 << 17;
      border._encode(intList, doubleList);
    }
    if (width != null) {
      intList[maskIndex] |= 1 << 18;
      width._encode(intList, doubleList);
    }
    if (height != null) {
      intList[maskIndex] |= 1 << 19;
      height._encode(intList, doubleList);
    }
    if (minWidth != null) {
      intList[maskIndex] |= 1 << 20;
      minWidth._encode(intList, doubleList);
    }
    if (minHeight != null) {
      intList[maskIndex] |= 1 << 21;
      minHeight._encode(intList, doubleList);
    }
    if (maxWidth != null) {
      intList[maskIndex] |= 1 << 22;
      maxWidth._encode(intList, doubleList);
    }
    if (maxHeight != null) {
      intList[maskIndex] |= 1 << 23;
      maxHeight._encode(intList, doubleList);
    }
    if (aspectRatio != null) {
      intList[maskIndex] |= 1 << 24;
      doubleList.add(aspectRatio);
    }
  }
}

class YogaRect {
  final double left;
  final double top;
  final double width;
  final double height;

  // Created by engine, not available externally.
  const YogaRect._(this.left, this.top, this.width, this.height);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    YogaRect typedOther = other;
    return typedOther.left == left &&
        typedOther.top == top &&
        typedOther.width == width &&
        typedOther.height == height;
  }

  @override
  int get hashCode => hashValues(left, top, width, height);

  @override
  String toString() =>
      'YogaRect._(${left.toStringAsFixed(1)}, ${top.toStringAsFixed(1)}, ${width.toStringAsFixed(1)}, ${height.toStringAsFixed(1)})';
}

// The closure takes four params: width, isWidthLoose, height, isHeightLoose. And it returns the width/height as a list.
typedef YogaLayoutClosure = Float64List Function(double, bool, double, bool);

// See https://groups.google.com/forum/#!topic/flutter-dev/H0mcfMOMcjY for why NativeFieldWrapperClass2 is required.
class YogaNode extends NativeFieldWrapperClass2 {
  // TODO(kaikaiz): should be final.
  int _nodeId;
  YogaNode _owner;
  YogaNode get owner => _owner;
  // TODO(kaikaiz): should only expose getChild API.
  final List<YogaNode> children;

  YogaNode(YogaStyle style) : children = List() {
    List<int> intList = List();
    List<double> doubleList = List();
    style._encode(intList, doubleList);
    _constructor(Int32List.fromList(intList), Float64List.fromList(doubleList));
    _nodeId = _retrieveNodeId();
  }

  void _constructor(Int32List intList, Float64List doubleList)
      native 'YogaNode_constructor';

  int _retrieveNodeId() native 'YogaNode_nodeId';

  YogaRect get rect native 'YogaNode_rect';

  void addChild(YogaNode child) {
    children.add(child);
    child._owner = this;
    _addChild(child._nodeId);
  }

  void _addChild(int childNodeId) native 'YogaNode_addChild';

  void calculateLayout(double width, double height, YogaDirection direction) =>
      _calculateLayout(width, height, direction.index);

  void _calculateLayout(double width, double height, int direction)
      native 'YogaNode_calculateLayout';

  // The C++ YogaNode is responsible for retaining and freeing the closure.
  void setLayoutClosure(YogaLayoutClosure closure) native 'YogaNode_setLayoutClosure';

  // TODO(kaikaiz): below is only for debug.

  void printStyle() native 'YogaNode_printStyle';

  void printLayout() native 'YogaNode_printLayout';
}
