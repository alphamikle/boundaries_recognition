import 'package:autoequal/autoequal.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'test_image.g.dart';

@autoequal
@CopyWith()
class TestImage extends Equatable {
  const TestImage({
    required this.index,
    required this.size,
    required this.card,
    required this.background,
    required this.fullPath,
  });

  final int index;
  final String size;
  final String card;
  final String background;
  final String fullPath;

  String get code => '$background.$card';

  @override
  List<Object?> get props => _$props;
}
