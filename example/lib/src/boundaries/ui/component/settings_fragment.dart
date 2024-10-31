import 'package:edge_vision/edge_vision.dart';
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
        return ListView(
          children: [
            const SizedBox(height: 16),
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
                ToggleButton(
                  title: 'Cloud',
                  isOn: state.dotsCloudOn,
                  onPressed: bloc.toggleDotsCloud,
                ),
                ToggleButton(
                  title: 'Painter',
                  isOn: state.painterOn,
                  onPressed: bloc.togglePainter,
                ),
                ToggleButton(
                  title: 'Dark Settings',
                  isOn: state.darkSettingsOn,
                  onPressed: bloc.toggleDarkSettings,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SimpleSlider(
              title: 'Opacity',
              value: state.opacity,
              onChanged: (double value) async => bloc.updateOpacity(value),
              min: 0.0,
              max: 1.0,
              divisions: 1 ~/ 0.05,
            ),
            const SizedBox(height: 16),
            SimpleSlider(
              title: 'Grayscale Amount',
              value: state.settings.grayscaleAmount,
              onChanged: (double value) async => bloc.applySettings((Settings settings) => settings.copyWith(grayscaleAmount: value)),
              min: 1.0,
              max: 8.0,
              divisions: 7 ~/ 0.05,
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Sobel Amount',
              value: state.settings.sobelAmount,
              onChanged: (double value) async => bloc.applySettings((Settings settings) => settings.copyWith(sobelAmount: value)),
              min: 0.5,
              max: 2.0,
              divisions: 1.5 ~/ 0.05,
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Black / White Threshold',
              value: state.settings.blackWhiteThreshold,
              onChanged: (int value) async => bloc.applySettings((Settings settings) => settings.copyWith(blackWhiteThreshold: value)),
              min: 1,
              max: 254,
              divisions: 253,
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Search Matrix Size',
              value: state.settings.searchMatrixSize,
              onChanged: (int value) async => bloc.applySettings((Settings settings) => settings.copyWith(searchMatrixSize: value)),
              min: 1,
              max: 12,
              divisions: 11,
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Object Size Threshold',
              value: state.settings.minObjectSize,
              onChanged: (int value) async => bloc.applySettings((Settings settings) => settings.copyWith(minObjectSize: value)),
              min: 1,
              max: 150,
              divisions: 150 ~/ 2,
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Distortion Angle Threshold',
              value: state.settings.distortionAngleThreshold,
              onChanged: (double value) async => bloc.applySettings((Settings settings) => settings.copyWith(distortionAngleThreshold: value)),
              min: 0.0,
              max: 15.0,
              divisions: 15 ~/ 0.1,
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Skew Threshold',
              value: state.settings.skewnessThreshold,
              onChanged: (double value) async => bloc.applySettings((Settings settings) => settings.copyWith(skewnessThreshold: value)),
              min: 0.0,
              max: 0.5,
              divisions: 0.5 ~/ 0.025,
            ),
            const SizedBox(height: 8),
            SimpleSlider(
              title: 'Blur Radius',
              value: state.settings.blurRadius,
              onChanged: (int value) async => bloc.applySettings((Settings settings) => settings.copyWith(blurRadius: value)),
              min: 0,
              max: 10,
              divisions: 10,
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
