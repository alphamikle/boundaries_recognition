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
    required this.settings,
    required this.maxImageSize,
    required this.threads,
    required this.grayScaleOn,
    required this.blurOn,
    required this.resizeOn,
    required this.sobelOn,
    required this.bwOn,
    required this.dotsCloudOn,
    required this.painterOn,
  });

  factory EdgesState.initial() => const EdgesState(
        images: {},
        settings: Settings(),
        maxImageSize: 400,
        threads: 1,
        grayScaleOn: false,
        blurOn: false,
        resizeOn: false,
        sobelOn: false,
        bwOn: false,
        dotsCloudOn: false,
        painterOn: true,
      );

  final Map<String, ImageResult> images;

  final Settings settings;

  final int maxImageSize;

  final int threads;

  final bool grayScaleOn;

  final bool blurOn;

  final bool resizeOn;

  final bool sobelOn;

  final bool bwOn;

  final bool dotsCloudOn;

  final bool painterOn;

  @override
  List<Object?> get props => _$props;
}
