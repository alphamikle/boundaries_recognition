import 'package:autoequal/autoequal.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:equatable/equatable.dart';

import '../model/image_result.dart';

part 'edges_state.g.dart';

@autoequal
@CopyWith()
class EdgesState extends Equatable {
  const EdgesState({
    required this.images,
    required this.imagesList,
    required this.lightSettings,
    required this.darkSettings,
    required this.maxImageSize,
    required this.threads,
    required this.darkSettingsOn,
    required this.grayScaleOn,
    required this.blurOn,
    required this.resizeOn,
    required this.sobelOn,
    required this.bwOn,
    required this.dotsCloudOn,
    required this.painterOn,
    required this.processing,
    required this.opacity,
  });

  factory EdgesState.initial() => const EdgesState(
        images: {},
        imagesList: [],
        lightSettings: Settings.light(),
        darkSettings: Settings.dark(),
        maxImageSize: 400,
        threads: 1,
        darkSettingsOn: false,
        grayScaleOn: true,
        blurOn: true,
        resizeOn: false,
        sobelOn: true,
        bwOn: true,
        dotsCloudOn: false,
        painterOn: true,
        processing: false,
        opacity: 0.35,
      );

  final Map<String, ImageResult> images;

  final List<ImageResult> imagesList;

  final Settings lightSettings;

  final Settings darkSettings;

  final int maxImageSize;

  final int threads;

  final bool darkSettingsOn;

  final bool grayScaleOn;

  final bool blurOn;

  final bool resizeOn;

  final bool sobelOn;

  final bool bwOn;

  final bool dotsCloudOn;

  final bool painterOn;

  final bool processing;

  final double opacity;

  Settings get settings => darkSettingsOn ? darkSettings : lightSettings;

  @override
  List<Object?> get props => _$props;
}
