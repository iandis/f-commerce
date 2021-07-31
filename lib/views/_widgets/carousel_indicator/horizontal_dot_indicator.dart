import 'package:flutter/material.dart';

/// by Iandi Santulus (https://github.com/iandis)
class HorizontalDotIndicator extends StatelessWidget {
  /// dots for showing indicator typically on top of `PageView`
  HorizontalDotIndicator({
    required this.dotCount,
    required this.activeDotColor,
    this.initIndex,
    this.inactiveDotColor,
    this.dotSize,
    this.dotSpacing,
  });

  /// dots needed to create indicator.
  /// set this according to how many pages you have.
  final int dotCount;

  /// initial index of your page.
  /// defaults to `0`.
  final int? initIndex;

  /// color of the dot when active,
  /// i.e. switched from one page to another.
  final Color activeDotColor;

  /// color of the dot when inactive.
  /// defaults to `Colors.grey`
  final Color? inactiveDotColor;

  /// size of the dot (height x width).
  /// defaults to `10`
  final double? dotSize;

  /// space between dots.
  /// defaults to `dotSize / 2`
  final double? dotSpacing;

  /// --- default values ---

  /// create ValueNotifier instance for controlling the active dot
  late final ValueNotifier<int> _index = ValueNotifier<int>(initIndex ?? 0);

  /// default value for dot size is 10
  late final double _dotSize = dotSize ?? 10.0;

  /// default value for dot spaces is 5
  late final double _dotSpacing = dotSpacing ?? _dotSize / 2;

  /// default color for inactive is Grey
  late final Color _inactiveDotColor = inactiveDotColor ?? Colors.grey;

  /// generate list of dots and spaces between
  late final List<Widget> _dots = List<Widget>.generate(
    // length
    dotCount * 2 - 1,

    // generate dots
    (i) => i % 2 == 0 ? _inactiveDot : SizedBox(width: _dotSpacing),

    // set growable to false
    growable: false,
  );

  /// create a widget for inactive dots
  late final _inactiveDot = Container(
    width: _dotSize,
    height: _dotSize,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: _inactiveDotColor,
      border: Border.all(
        color: Colors.transparent,
        width: 0,
        style: BorderStyle.none,
      ),
      borderRadius: BorderRadius.circular(_dotSize / 2),
    ),
  );

  /// create a widget for the active dot
  late final _activeDot = Container(
    width: _dotSize,
    height: _dotSize,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: activeDotColor,
      borderRadius: BorderRadius.circular(_dotSize / 2),
    ),
  );

  // ignore: use_setters_to_change_properties
  /// use this to move the dot according to [index].
  /// index must start from 0.
  void moveDot(int index) {
    _index.value = index;
  }

  /// must call this when not needed to prevent memory leak.
  void dispose() {
    _index.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      /// number of dots * size of dots  +  number of spaces ( which is number of dots -1) * size of dot spaces
      width: (dotCount * _dotSize) + ((dotCount - 1) * _dotSpacing),
      height: _dotSize,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _dots,
          ),
          ValueListenableBuilder<int>(
            valueListenable: _index,
            builder: (_, value, __) => Align(
              alignment: FractionalOffset(value / (dotCount - 1), 0.0),
              child: _activeDot,
            ),
          ),
        ],
      ),
    );
  }
}
