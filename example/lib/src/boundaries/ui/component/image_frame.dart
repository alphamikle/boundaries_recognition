import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/bloc/edges_bloc.dart';
import '../../logic/bloc/edges_state.dart';
import '../../logic/model/image_result.dart';
import 'edges_painter.dart';

class ImageFrame extends StatelessWidget {
  const ImageFrame({
    required this.result,
    required this.selected,
    super.key,
  });

  final ImageResult result;
  final bool selected;

  bool get hasProcessedImage => result.processedImage != null;

  bool get hasEdges {
    final Edges? edges = result.edges;

    if (edges == null) {
      return false;
    }

    return (edges.allPoints.isNotEmpty || edges.corners.isNotEmpty) && result.processedImageWidth != null && result.processedImageHeight != null;
  }

  @override
  Widget build(BuildContext context) {
    final EdgesState state = context.read<EdgesBloc>().state;

    final Widget? painter = hasEdges && state.painterOn
        ? Positioned.fill(
            child: EdgesPainter(
              points: state.dotsCloudOn ? result.edges!.allPoints : result.edges!.corners,
              width: result.processedImageWidth!,
              height: result.processedImageHeight!,
            ),
          )
        : null;

    final XAxis? xMoveTo = result.edges?.xMoveTo;
    final YAxis? yMoveTo = result.edges?.yMoveTo;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 250),
      opacity: selected ? 1 : 0.5,
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            hasProcessedImage
                ? Image.memory(
                    result.processedImage!,
                  )
                : Center(
                    child: SizedBox.square(
                      dimension: 60,
                      child: CircularProgressIndicator(),
                    ),
                  ),
            AspectRatio(
              aspectRatio: 3 / 4,
              child: Opacity(
                opacity: state.opacity,
                child: Image.memory(
                  result.originalImage,
                ),
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
            Positioned.fill(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () => context.read<EdgesBloc>().toggleImageSelection(result.name),
                ),
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              child: Checkbox(
                value: selected,
                onChanged: (_) => context.read<EdgesBloc>().toggleImageSelection(result.name),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
