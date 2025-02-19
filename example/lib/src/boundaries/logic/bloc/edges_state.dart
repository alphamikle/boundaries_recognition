import 'package:autoequal/autoequal.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:edge_vision/edge_vision.dart';
import 'package:equatable/equatable.dart';

import '../model/image_result.dart';
import '../model/test_image.dart';

part 'edges_state.g.dart';

@autoequal
@CopyWith(copyWithNull: true)
class EdgesState extends Equatable {
  const EdgesState({
    required this.images,
    required this.selectedImages,
    required this.imagesList,
    required this.testImages,
    required this.settings,
    required this.settingsIndex,
    required this.maxImageSize,
    required this.dotsCloudOn,
    required this.painterOn,
    required this.processing,
    required this.opacity,
  });

  factory EdgesState.initial() => const EdgesState(
        images: {},
        selectedImages: {},
        imagesList: [],
        testImages: {},
        settings: [],
        settingsIndex: null,
        maxImageSize: 400,
        dotsCloudOn: false,
        painterOn: true,
        processing: false,
        opacity: 0.35,
      );

  final Map<String, ImageResult> images;

  final Set<String> selectedImages;

  final List<ImageResult> imagesList;

  final Map<String, TestImage> testImages;

  final List<EdgeVisionSettings> settings;

  final int? settingsIndex;

  final int maxImageSize;

  final bool dotsCloudOn;

  final bool painterOn;

  final bool processing;

  final double opacity;

  EdgeVisionSettings? get selectedSettings {
    if (settingsIndex == null || settingsIndex! >= settings.length || settingsIndex! < 0) {
      return null;
    }
    return settings[settingsIndex!];
  }

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
    if (totalOverall > 0) {
      final double percent = (totalSuccess / totalOverall * 1000).toInt() / 10;

      results['Total'] = '$totalSuccess/$totalOverall | $percent%';
    } else {
      results['Total'] = '$totalSuccess/$totalOverall | 0%';
    }

    return results;
  }

  @override
  List<Object?> get props => _$props;
}
