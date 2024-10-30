import 'package:edge_vision/src/edge_vision/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/edges_bloc.dart';
import '../../logic/bloc/edges_state.dart';
import 'simple_slider.dart';
import 'toggle_button.dart';

class SettingsFragment extends StatelessWidget {
  const SettingsFragment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final EdgesBloc bloc = context.read();

    return BlocBuilder<EdgesBloc, EdgesState>(
      buildWhen: (EdgesState p, EdgesState c) => c.copyWith(images: {}) != p.copyWith(images: {}),
      builder: (BuildContext context, EdgesState state) {
        return Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ToggleButton(
                  title: 'Gray',
                  isOn: state.grayScaleOn,
                  onPressed: bloc.toggleGrayscale,
                ),
                ToggleButton(
                  title: 'Blur',
                  isOn: state.blurOn,
                  onPressed: bloc.toggleBlur,
                ),
                ToggleButton(
                  title: 'Resize',
                  isOn: state.resizeOn,
                  onPressed: bloc.toggleResize,
                ),
                ToggleButton(
                  title: 'Sobel',
                  isOn: state.sobelOn,
                  onPressed: bloc.toggleSobel,
                ),
                ToggleButton(
                  title: 'B/W',
                  isOn: state.bwOn,
                  onPressed: bloc.toggleBlackWhite,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Grayscale Amount',
              value: state.settings.grayscaleAmount,
              onChanged: (double value) async => bloc.applySettings((Settings settings) => settings.copyWith(grayscaleAmount: value)),
              min: 0.0,
              max: 8.0,
              divisions: 50 ~/ 8,
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Sobel Amount',
              value: state.settings.sobelAmount,
              onChanged: (double value) async => bloc.applySettings((Settings settings) => settings.copyWith(sobelAmount: value)),
              min: 0.0,
              max: 5.0,
              divisions: 50 ~/ 5,
            ),
          ],
        );
      },
    );
  }
}
