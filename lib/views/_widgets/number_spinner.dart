import 'package:flutter/material.dart';

import '/core/constants/app_theme.dart';

typedef MSP<T> = MaterialStateProperty<T>;

class NumberSpinner extends StatefulWidget {
  final int value;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final int lowerLimit;
  final int? upperLimit;
  final bool isScalingValue;

  const NumberSpinner({
    required this.value,
    this.lowerLimit = 0,
    this.upperLimit,
    this.onIncrement,
    this.onDecrement,
    this.isScalingValue = false,
  });

  @override
  _NumberSpinnerState createState() => _NumberSpinnerState();
}

class _NumberSpinnerState extends State<NumberSpinner> {

  double get _screenWidth => MediaQuery.of(context).size.width;

  Widget get _decrementButton {
    final minusText = Text(
      '-',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: ((_screenWidth / 3) / 100) * 7.5,
      ),
    );

    final buttonForegroundColor = MSP.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey;
      }
      return Colors.black;
    });

    final buttonShape = MSP.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular((_screenWidth / 100) * 1.5),
      ),
    );

    final buttonStyle = ButtonStyle(
      padding: MSP.all(const EdgeInsets.all(1)),
      overlayColor: MSP.all(Colors.grey[200]),
      foregroundColor: buttonForegroundColor,
      shape: buttonShape,
    );

    final button = OutlinedButton(
      onPressed: widget.value > widget.lowerLimit ? widget.onDecrement : null,
      style: buttonStyle,
      child: minusText,
    );

    return Expanded(
      child: SizedBox(
        width:(_screenWidth / 100) * 6,
        height:(_screenWidth / 100) * 4.5,
        child: button,
      ),
    );
  }

  Widget get _valueText {
    final String text;

    if (widget.isScalingValue) {
      text = '${widget.value}x'; //ex: 1x, 2x, 3x, ...
    } else {
      text = widget.value.toString(); //ex: 1, 2, 3, ...
    }

    return Expanded(
      flex: 2,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget get _incerementButton {
    final VoidCallback? buttonOnPressed =
        (widget.upperLimit != null && widget.value == widget.upperLimit!) ? null : widget.onIncrement;

    final plusText = Text(
      '+',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: ((_screenWidth / 3) / 100) * 7.5,
      ),
    );

    final buttonOverlayColor = MSP.all(AppTheme.secondaryColor);

    final buttonBackgroundColor = MSP.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return AppTheme.secondaryColor;
      }
      return AppTheme.primaryColor;
    });

    final buttonShape = MSP.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular((_screenWidth / 100) *1.5),
      ),
    );

    final buttonStyle = ButtonStyle(
      padding: MSP.all(const EdgeInsets.all(1)),
      overlayColor: buttonOverlayColor,
      foregroundColor: MSP.all(Colors.white),
      backgroundColor: buttonBackgroundColor,
      shape: buttonShape,
    );

    final button = OutlinedButton(
      onPressed: buttonOnPressed,
      style: buttonStyle,
      child: plusText,
    );

    return Expanded(
      child: SizedBox(
        width:(_screenWidth / 100) * 6,
        height:(_screenWidth / 100) * 4.5,
        child: button,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _decrementButton,
        _valueText,
        _incerementButton,
      ],
    );
  }
}
