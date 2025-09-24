import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInput extends StatefulWidget {
  final int length;
  final void Function(String pin) onCompleted;
  final void Function(String pin)? onChanged;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final double spacing;
  final double pinSize;
  final TextStyle? textStyle;
  final String? errorText;
  final bool autofocus;

  const PinInput({
    Key? key,
    this.length = 4,
    required this.onCompleted,
    this.onChanged,
    this.obscureText = true,
    this.keyboardType = TextInputType.number,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderWidth = 2.0,
    this.borderRadius,
    this.spacing = 16.0,
    this.pinSize = 56.0,
    this.textStyle,
    this.errorText,
    this.autofocus = true,
  }) : super(key: key);

  @override
  State<PinInput> createState() => _PinInputState();

  // Methode zum Zurücksetzen des PIN-Inputs
  static void clear(GlobalKey key) {
    final state = key.currentState as _PinInputState?;
    state?.clear();
  }
}

class _PinInputState extends State<PinInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _pin = '';

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.length, (index) => FocusNode());

    // Autofocus auf das erste Feld
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNodes[0].requestFocus();
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {
      if (value.isNotEmpty) {
        // Nur Ziffern erlauben
        if (RegExp(r'^[0-9]$').hasMatch(value)) {
          _controllers[index].text = value;
          _updatePin();

          // Zum nächsten Feld springen
          if (index < widget.length - 1) {
            _focusNodes[index + 1].requestFocus();
          } else {
            // Letztes Feld erreicht - Fokus entfernen
            _focusNodes[index].unfocus();
          }
        } else {
          // Ungültiges Zeichen - Feld leeren
          _controllers[index].clear();
        }
      } else {
        _updatePin();
      }
    });
  }

  void _onKeyEvent(KeyEvent event, int index) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          // Zum vorherigen Feld springen
          _focusNodes[index - 1].requestFocus();
          _controllers[index - 1].clear();
          _updatePin();
        }
      }
    }
  }

  void _updatePin() {
    _pin = _controllers.map((controller) => controller.text).join();

    // Callback aufrufen
    if (widget.onChanged != null) {
      widget.onChanged!(_pin);
    }

    // Wenn PIN vollständig, onCompleted aufrufen
    if (_pin.length == widget.length) {
      widget.onCompleted(_pin);
    }
  }

  void clear() {
    setState(() {
      for (final controller in _controllers) {
        controller.clear();
      }
      _pin = '';
      _focusNodes[0].requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultFillColor = widget.fillColor ?? colorScheme.surface;
    final defaultBorderColor = widget.borderColor ?? colorScheme.outline;
    final defaultFocusedBorderColor =
        widget.focusedBorderColor ?? colorScheme.primary;
    final defaultBorderRadius =
        widget.borderRadius ?? BorderRadius.circular(12.0);
    final defaultTextStyle =
        widget.textStyle ??
        theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              width: widget.pinSize,
              height: widget.pinSize,
              child: Focus(
                onKeyEvent: (node, event) {
                  _onKeyEvent(event, index);
                  return KeyEventResult.handled;
                },
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboardType: widget.keyboardType,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  obscureText: widget.obscureText,
                  style: defaultTextStyle,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: defaultFillColor,
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: defaultBorderRadius,
                      borderSide: BorderSide(
                        color: defaultBorderColor,
                        width: widget.borderWidth,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: defaultBorderRadius,
                      borderSide: BorderSide(
                        color: defaultBorderColor,
                        width: widget.borderWidth,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: defaultBorderRadius,
                      borderSide: BorderSide(
                        color: defaultFocusedBorderColor,
                        width: widget.borderWidth,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: defaultBorderRadius,
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: widget.borderWidth,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: defaultBorderRadius,
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: widget.borderWidth,
                      ),
                    ),
                  ),
                  onChanged: (value) => _onChanged(value, index),
                ),
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
