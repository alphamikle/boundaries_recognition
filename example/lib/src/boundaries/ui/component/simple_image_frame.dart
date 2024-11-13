import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/material.dart';

import '../../logic/model/image_result.dart';
import 'edges_painter.dart';

class SimpleImageFrame extends StatelessWidget {
  const SimpleImageFrame({
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

    return (edges.allPoints.isNotEmpty || edges.corners.isNotEmpty) && result.processedImageWidth != null && result.processedImageHeight != null;
  }

  Widget painter(Color color) {
    return Positioned.fill(
      child: EdgesPainter(
        points: result.edges!.corners,
        width: result.originalImageWidth,
        height: result.originalImageHeight,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final XAxis? xMoveTo = result.edges?.xMoveTo;
    final YAxis? yMoveTo = result.edges?.yMoveTo;

    return Center(
      child: AspectRatio(
        aspectRatio: 6 / 4,
        child: Row(
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
                  Positioned.fill(
                    child: painter(Colors.blue),
                  ),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Image.memory(
                    result.processedImage!,
                    fit: BoxFit.cover,
                  ),
                  Positioned.fill(
                    child: painter(Colors.blue),
                  ),
                  if (xMoveTo != null && yMoveTo != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
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
                            style: const TextStyle(fontSize: 28),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
