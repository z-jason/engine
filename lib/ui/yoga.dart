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
  // TODO(kaikaiz): add assertions/clamps for double.
  const YogaValue(this.value, [this.unit = YogaUnit.point]);
  const YogaValue.percent(double value) : this(value, YogaUnit.percent);

  final double value;
  final YogaUnit unit;

  // This is YGValueAuto.
  static final YogaValue auto = const YogaValue(0.0, YogaUnit.auto);

  // This is YGValueUndefined. Not to be used - just for a comment.
  static final YogaValue undefined = const YogaValue(0.0, YogaUnit.undefined);

  void _encode(List<int> intList, List<double> doubleList) {
    doubleList.add(value);
    intList.add(unit.index);
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    YogaValue typedOther = other;
    return typedOther.value == value && typedOther.unit == unit;
  }

  @override
  int get hashCode => hashValues(value, unit);

  @override
  String toString() {
    if (unit == YogaUnit.point)
      return 'YogaValue.point(${value.toStringAsFixed(1)})';
    if (unit == YogaUnit.percent)
      return 'YogaValue.percent(${value.toStringAsFixed(1)})';
    return 'YogaValue(${value.toStringAsFixed(1)}, $unit)';
  }
}

/// TODO(kaikaiz): there is no resolving logic - we simply pass it to Yoga.
class YogaEdgeInsets {
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

  final YogaValue left;
  final YogaValue top;
  final YogaValue right;
  final YogaValue bottom;
  final YogaValue start;
  final YogaValue end;
  final YogaValue horizontal;
  final YogaValue vertical;
  final YogaValue all;

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

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    YogaEdgeInsets typedOther = other;
    return typedOther.left == left &&
        typedOther.top == top &&
        typedOther.right == right &&
        typedOther.bottom == bottom &&
        typedOther.start == start &&
        typedOther.end == end &&
        typedOther.horizontal == horizontal &&
        typedOther.vertical == vertical &&
        typedOther.all == all;
  }

  @override
  int get hashCode => hashValues(
      left, top, right, bottom, start, end, horizontal, vertical, all);

  @override
  String toString() {
    String val = '';
    if (left != null) val += 'left: $left,';
    if (top != null) val += 'top: $top,';
    if (right != null) val += 'right: $right,';
    if (bottom != null) val += 'bottom: $bottom,';
    if (start != null) val += 'start: $start,';
    if (end != null) val += 'end: $end,';
    if (horizontal != null) val += 'horizontal: $horizontal,';
    if (vertical != null) val += 'vertical: $vertical,';
    if (all != null) val += 'all: $all,';
    return 'YogaEdgeInsets($val)';
  }
}

class YogaStyle {
  // TODO(kaikaiz): find way to map double.nan to YGFloatOptional.
  // TODO(kaikaiz): add assertions for double.
  // The comments are the default values in C++ side. Some fields have different default values for convenience, such as flexGrow and flexShrink.
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
    this.flexGrow = 0.0, // double.nan
    this.flexShrink = 1.0, // double.nan
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

  final YogaDirection direction;
  final YogaFlexDirection flexDirection;
  final YogaJustify justifyContent;
  final YogaAlign alignContent;
  final YogaAlign alignItems;
  final YogaAlign alignSelf;
  final YogaPositionType positionType;
  final YogaWrap flexWrap;
  final YogaOverflow overflow;
  final YogaDisplay display;
  final double flex;
  final double flexGrow;
  final double flexShrink;
  final YogaValue flexBasis;
  final YogaEdgeInsets margin;
  final YogaEdgeInsets position;
  final YogaEdgeInsets padding;
  final YogaEdgeInsets border;
  final YogaValue width;
  final YogaValue height;
  final YogaValue minWidth;
  final YogaValue minHeight;
  final YogaValue maxWidth;
  final YogaValue maxHeight;
  final double aspectRatio;

  // Encoding should match those in C++.
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

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    YogaStyle typedOther = other;
    return typedOther.direction == direction &&
        typedOther.flexDirection == flexDirection &&
        typedOther.justifyContent == justifyContent &&
        typedOther.alignContent == alignContent &&
        typedOther.alignItems == alignItems &&
        typedOther.alignSelf == alignSelf &&
        typedOther.positionType == positionType &&
        typedOther.flexWrap == flexWrap &&
        typedOther.overflow == overflow &&
        typedOther.display == display &&
        typedOther.flex == flex &&
        typedOther.flexGrow == flexGrow &&
        typedOther.flexShrink == flexShrink &&
        typedOther.flexBasis == flexBasis &&
        typedOther.margin == margin &&
        typedOther.position == position &&
        typedOther.padding == padding &&
        typedOther.border == border &&
        typedOther.width == width &&
        typedOther.height == height &&
        typedOther.minWidth == minWidth &&
        typedOther.minHeight == minHeight &&
        typedOther.maxWidth == maxWidth &&
        typedOther.maxHeight == maxHeight &&
        typedOther.aspectRatio == aspectRatio;
  }

  // TODO(kaikaiz): https://github.com/flutter/flutter/issues/1356
  // @override
  // int get hashCode => hashValues(direction, flexDirection, justifyContent, alignContent, alignItems, alignSelf, positionType, flexWrap, overflow, display, flex, flexGrow, flexShrink, flexBasis, margin, position, padding, border, width, height, minWidth, minHeight, maxWidth, maxHeight, aspectRatio);

  @override
  String toString() {
    String val = '';
    if (direction != null) val += 'direction: $direction,';
    if (flexDirection != null) val += 'flexDirection: $flexDirection,';
    if (justifyContent != null) val += 'justifyContent: $justifyContent,';
    if (alignContent != null) val += 'alignContent: $alignContent,';
    if (alignItems != null) val += 'alignItems: $alignItems,';
    if (alignSelf != null) val += 'alignSelf: $alignSelf,';
    if (positionType != null) val += 'positionType: $positionType,';
    if (flexWrap != null) val += 'flexWrap: $flexWrap,';
    if (overflow != null) val += 'overflow: $overflow,';
    if (display != null) val += 'display: $display,';
    if (flex != null) val += 'flex: ${flex.toStringAsFixed(1)},';
    if (flexGrow != null) val += 'flexGrow: ${flexGrow.toStringAsFixed(1)},';
    if (flexShrink != null) val += 'flexShrink: ${flexShrink.toStringAsFixed(1)},';
    if (flexBasis != null) val += 'flexBasis: $flexBasis,';
    if (margin != null) val += 'margin: $margin,';
    if (position != null) val += 'position: $position,';
    if (padding != null) val += 'padding: $padding,';
    if (border != null) val += 'border: $border,';
    if (width != null) val += 'width: $width,';
    if (height != null) val += 'height: $height,';
    if (minWidth != null) val += 'minWidth: $minWidth,';
    if (minHeight != null) val += 'minHeight: $minHeight,';
    if (maxWidth != null) val += 'maxWidth: $maxWidth,';
    if (maxHeight != null) val += 'maxHeight: $maxHeight,';
    if (aspectRatio != null) val += 'aspectRatio: ${aspectRatio.toStringAsFixed(1)},';
    return 'YogaStyle($val)';
  }
}

class YogaRect {
  // Created by engine, not available externally.
  @pragma('vm:entry-point')
  const YogaRect._(this.left, this.top, this.width, this.height);

  final double left;
  final double top;
  final double width;
  final double height;

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

/// The closure takes four params: width, isWidthLoose, height, isHeightLoose. And it returns the width/height as a list.
typedef YogaLayoutClosure = Float64List Function(double, bool, double, bool);

/// See https://groups.google.com/forum/#!topic/flutter-dev/H0mcfMOMcjY for why NativeFieldWrapperClass2 is required.
class YogaNode extends NativeFieldWrapperClass2 {
  YogaNode(YogaStyle style) {
    List<int> intList = [];
    List<double> doubleList = [];
    style._encode(intList, doubleList);
    _constructor(Int32List.fromList(intList), Float64List.fromList(doubleList));
    _nodeId = _retrieveNodeId();
    _children = [];
  }

  int _nodeId;
  List<YogaNode> _children;

  void insertChild(YogaNode child, {YogaNode before}) {
    if (before != null) {
      int index = _children.indexOf(before);
      _insertChild(child._nodeId, index);
      _children.insert(index, child);
    } else {
      _insertChild(child._nodeId, _children.length);
      _children.add(child);
    }
  }

  // TODO(kaikaiz): not sure about how double.infinity is translated into C native double.
  // This value is defined inside Yoga C++ impl.
  double _clamp(double x) => x.isFinite ? x : 10e20;

  YogaRect calculateLayout({
    double width = double.infinity,
    double height = double.infinity,
    YogaDirection direction = YogaDirection.ltr,
  }) =>
      _calculateLayout(_clamp(width), _clamp(height), direction.index);

  // ======= Below are C++ natives =======

  // Only valid after calling calculateLayout on the root node.
  YogaRect get rect native 'YogaNode_rect';

  // It is the user's responsbility to pass a null/meaningful value to
  // remove/add the closure before/after inserting/removing children.
  //
  // The C++ YogaNode is responsible for retaining and freeing the closure.
  void attachLayoutClosure(YogaLayoutClosure closure)
      native 'YogaNode_attachLayoutClosure';

  void _constructor(Int32List intList, Float64List doubleList)
      native 'YogaNode_constructor';

  // Should only be called once inside the constructor. Won't change during the lifetime of the object.
  int _retrieveNodeId() native 'YogaNode_nodeId';

  void _insertChild(int childNodeId, int index) native 'YogaNode_insertChild';

  YogaRect _calculateLayout(double width, double height, int direction)
      native 'YogaNode_calculateLayout';

  // TODO(kaikaiz): below is only for debug.

  void printStyle() native 'YogaNode_printStyle';

  void printLayout() native 'YogaNode_printLayout';
}
