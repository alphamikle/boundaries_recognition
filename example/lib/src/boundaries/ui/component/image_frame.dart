import 'package:edge_vision/src/edge_vision/edges.dart';
import 'package:flutter/material.dart';

import '../../logic/model/image_result.dart';
import 'edges_painter.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({
    required this.result,
    super.key,
  });

  final ImageResult result;

  bool get hasProcessedImage => result.processedImage != null;

  bool get hasEdges {
    final Edges? edges = result.edges;

    if (edges == null) {
      return false;
    }

    return edges.corners.isNotEmpty && result.processedImageWidth != null && result.processedImageHeight != null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget? painter = hasEdges
        ? Positioned.fill(
            child: EdgesPainter(
              points: result.edges!.corners,
              width: result.processedImageWidth!,
              height: result.processedImageHeight!,
            ),
          )
        : null;

    final XAxis? xMoveTo = result.edges?.xMoveTo;
    final YAxis? yMoveTo = result.edges?.yMoveTo;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              Image.memory(
                result.originalImage,
                fit: BoxFit.cover,
              ),
              if (painter != null) painter,
            ],
          ),
        ),
        const SizedBox(width: 8),
        AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              hasProcessedImage
                  ? Image.memory(
                      result.processedImage!,
                      fit: BoxFit.cover,
                    )
                  : Center(
                      child: SizedBox.square(
                        dimension: 60,
                        child: CircularProgressIndicator(),
                      ),
                    ),
              if (painter != null) painter,
              if (xMoveTo != null && yMoveTo != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        // ⬅️↖️↙️➡️️↗️↘️️⬇️⬆️️⏺️
                        switch ((xMoveTo, yMoveTo)) {
                          (XAxis.left, YAxis.top) => '↖️',
                          (XAxis.left, YAxis.bottom) => '↙️',
                          (XAxis.left, YAxis.center) => '⬅️',
                          (XAxis.right, YAxis.top) => '↗️',
                          (XAxis.right, YAxis.bottom) => '↘️️',
                          (XAxis.right, YAxis.center) => '➡️',
                          (XAxis.center, YAxis.top) => '⬆️',
                          (XAxis.center, YAxis.bottom) => '⬇️',
                          (XAxis.center, YAxis.center) => '⏺️',
                        },
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
