import 'dart:async';

import 'package:image/image.dart';

import '../tools/bench.dart';
import '../tools/collection_extensions.dart';
import 'edge_vision.dart';
import 'edge_vision_isolated.dart';
import 'edge_vision_settings.dart';
import 'edges.dart';

class EdgeVisionOrchestrator implements EdgeVision {
  factory EdgeVisionOrchestrator({
    required List<EdgeVisionIsolated> threads,
  }) {
    return EdgeVisionOrchestrator._(
      threads: threads,
      idleThreads: {...List.generate(threads.length, (int index) => index)},
    );
  }

  EdgeVisionOrchestrator._({
    required this.threads,
    required this.idleThreads,
  });

  final List<EdgeVisionIsolated> threads;
  final Set<int> idleThreads;

  int index = 0;

  int get nextIndex {
    final int result = index;
    index++;
    if (index == threads.length) {
      index = 0;
    }
    return result;
  }

  @override
  Future<Edges> findImageEdges({required Image image, bool isImagePrepared = false, OnImagePrepare? onImagePrepare}) async {
    int? threadIndex = idleThreads.randomOrNull();
    if (threadIndex != null) {
      idleThreads.remove(threadIndex);
    }
    threadIndex ??= nextIndex;

    final EdgeVisionIsolated thread = threads[threadIndex];

    try {
      start('Finding edges with thread $threadIndex / ${threads.length}');
      final Edges results = await thread.findImageEdges(image: image, isImagePrepared: isImagePrepared, onImagePrepare: onImagePrepare);
      idleThreads.add(threadIndex);
      stop('Finding edges with thread $threadIndex / ${threads.length}');

      return results;
    } catch (_) {
      idleThreads.add(threadIndex);
      rethrow;
    }
  }

  @override
  Future<void> resetSettings() async {
    await Future.wait(threads.map((EdgeVisionIsolated thread) => thread.resetSettings()));
  }

  @override
  Future<void> updateConfiguration({Set<EdgeVisionSettings>? settings, EdgeProcessingMode? processingMode}) async {
    await Future.wait(threads.map((EdgeVisionIsolated thread) => thread.updateConfiguration(settings: settings, processingMode: processingMode)));
  }

  @override
  Future<void> dispose() async {
    await Future.wait(threads.map((EdgeVisionIsolated thread) => thread.dispose()));
  }
}
