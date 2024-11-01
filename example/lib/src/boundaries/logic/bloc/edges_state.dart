import 'package:autoequal/autoequal.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:equatable/equatable.dart';

import '../model/image_result.dart';
import '../model/test_image.dart';

part 'edges_state.g.dart';

@autoequal
@CopyWith()
class EdgesState extends Equatable {
  const EdgesState({
    required this.images,
    required this.imagesList,
    required this.testImages,
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
        testImages: {},
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

  final Map<String, TestImage> testImages;

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

  Map<String, String> get success {
    final Map<String, String> results = {
      'Total': '',
    };
    final Map<String, int> success = {};
    final Map<String, int> total = {};

    for (final TestImage testImage in testImages.values) {
      final String code = testImage.code;
      total[code] = (total[code] ?? 0) + 1;
      if (images[testImage.fullPath]?.edges?.corners.isNotEmpty ?? false) {
        success[code] = (success[code] ?? 0) + 1;
      }
    }

    for (final TestImage testImage in testImages.values) {
      final String code = testImage.code;
      results[code] = [success[code] ?? 0, total[code] ?? '♾️'].join('/');
    }

    final int totalSuccess = success.values.fold(0, (int sum, int it) => sum + it);
    final int totalOverall = total.values.fold(0, (int sum, int it) => sum + it);
    final double percent = (totalSuccess / totalOverall * 1000).toInt() / 10;

    results['Total'] = '$totalSuccess/$totalOverall | $percent%';

    return results;
  }

  @override
  List<Object?> get props => _$props;
}
