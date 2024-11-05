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
        final bool settingsSelected = state.selectedSettings != null;

        return ListView(
          children: [
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
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
            BlocBuilder<EdgesBloc, EdgesState>(
              builder: (BuildContext context, EdgesState state) {
                final int settingsAmount = state.settings.length;
                final int? settingsIndex = state.settingsIndex;

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ...List.generate(
                      settingsAmount,
                      (int index) => ToggleButton(
                        title: 'Settings [$index]',
                        isOn: settingsIndex == index,
                        onPressed: () async => bloc.chooseSettingsAsActive(index),
                      ),
                    ),
                    TextButton(
                      onPressed: bloc.addNewSettings,
                      child: Text('Add'),
                    ),
                    TextButton(
                      onPressed: bloc.removeSelectedSettings,
                      child: Text('Remove'),
                    ),
                  ],
                );
              },
            ),
            if (settingsSelected) ...[
              const SizedBox(height: 16),
              SimpleSlider(
                title: 'Grayscale Level',
                value: state.selectedSettings!.grayscaleLevel,
                onChanged: (double value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(grayscaleLevel: value)),
                min: 0.0,
                max: 8.0,
                divisions: 8 ~/ 0.05,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Grayscale Amount',
                value: state.selectedSettings!.grayscaleAmount,
                onChanged: (int value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(grayscaleAmount: value)),
                min: 0,
                max: 10,
                divisions: 10,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Sobel Level',
                value: state.selectedSettings!.sobelLevel,
                onChanged: (double value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(sobelLevel: value)),
                min: 0.0,
                max: 2.0,
                divisions: 2 ~/ 0.05,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Sobel Amount',
                value: state.selectedSettings!.sobelAmount,
                onChanged: (int value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(sobelAmount: value)),
                min: 0,
                max: 10,
                divisions: 10,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Black / White Threshold',
                value: state.selectedSettings!.blackWhiteThreshold,
                onChanged: (int value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(blackWhiteThreshold: value)),
                min: 0,
                max: 255,
                divisions: 255,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Search Matrix Size',
                value: state.selectedSettings!.searchMatrixSize,
                onChanged: (int value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(searchMatrixSize: value)),
                min: 1,
                max: 5,
                divisions: 4,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Object Size Threshold',
                value: state.selectedSettings!.minObjectSize,
                onChanged: (int value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(minObjectSize: value)),
                min: 1,
                max: 80,
                divisions: 79 ~/ 2,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Direction Angle Level',
                value: state.selectedSettings!.directionAngleLevel,
                onChanged: (double value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(directionAngleLevel: value)),
                min: 0.0,
                max: 6.0,
                divisions: 6 ~/ 0.25,
              ),
              SimpleSlider(
                title: 'Symmetric Angle Threshold',
                value: state.selectedSettings!.symmetricAngleThreshold,
                onChanged: (double value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(symmetricAngleThreshold: value)),
                min: 0.0,
                max: 10.0,
                divisions: 10 ~/ 0.25,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Skew Threshold',
                value: state.selectedSettings!.skewnessThreshold,
                onChanged: (double value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(skewnessThreshold: value)),
                min: 0.0,
                max: 0.5,
                divisions: 0.5 ~/ 0.05,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Area Threshold',
                value: state.selectedSettings!.areaThreshold,
                onChanged: (double value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(areaThreshold: value)),
                min: 0.0,
                max: 1.0,
                divisions: 1 ~/ 0.05,
              ),
              const SizedBox(height: 8),
              SimpleSlider(
                title: 'Blur Radius',
                value: state.selectedSettings!.blurRadius,
                onChanged: (int value) async => bloc.applySettings((EdgeVisionSettings settings) => settings.copyWith(blurRadius: value)),
                min: 0,
                max: 5,
                divisions: 5,
              ),
            ],
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
