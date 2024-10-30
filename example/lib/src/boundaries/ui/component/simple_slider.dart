import 'package:flutter/material.dart';

T _zero<T extends num>() => 0 as T;

class SimpleSlider<T extends num> extends StatelessWidget {
  const SimpleSlider({
    required this.title,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.divisions,
    super.key,
  });

  final String title;
  final T value;
  final ValueChanged<T> onChanged;
  final T min;
  final T max;
  final int divisions;

  bool get isInt => T == int;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title),
        const SizedBox(height: 8),
        Slider(
          value: value.toDouble(),
          onChanged: (double value) => onChanged(isInt ? value.toInt() as T : value as T),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: divisions,
          label: value.toStringAsFixed(isInt ? 0 : 2),
        ),
      ],
    );
  }
}
