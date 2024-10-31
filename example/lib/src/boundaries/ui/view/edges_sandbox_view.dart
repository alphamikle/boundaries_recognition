import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/colors.dart';
import '../../logic/bloc/edges_bloc.dart';
import '../../logic/bloc/edges_state.dart';
import '../../logic/model/image_result.dart';
import '../component/image_frame.dart';
import '../component/settings_fragment.dart';

class EdgesSandboxView extends StatefulWidget {
  const EdgesSandboxView({
    super.key,
  });

  @override
  State<EdgesSandboxView> createState() => _EdgesSandboxViewState();
}

class _EdgesSandboxViewState extends State<EdgesSandboxView> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  late final EdgesBloc edgesBloc = context.read();
  final int startIndex = 1;
  final int endIndex = 32;

  String get small => true ? '_small' : '';

  Future<void> init() async {
    for (int i = startIndex; i <= endIndex; i++) {
      await edgesBloc.loadImage('cards/small/300x400_$i');
    }
  }

  // Future<void> handleImage(CameraImage cameraImage) async {
  //   await Throttle.run(
  //     'handle_image',
  //     () async {
  //       this.cameraImage = cameraImage.toImage();
  //       orientation = cameraController?.value.deviceOrientation;
  //       await applyFilters();
  //     },
  //   );
  // }
  //
  // Future<void> initCamera() async {
  //   final cameras = await availableCameras();
  //   cameraController = CameraController(cameras[0], ResolutionPreset.low);
  //   await cameraController?.initialize();
  //   await cameraController?.startImageStream(handleImage);
  //   setState(() {});
  // }

  void showNotification({required bool processing}) {
    ScaffoldMessenger.of(key.currentContext!).showSnackBar(
      SnackBar(
        content: Text(processing ? 'Images processing started' : 'Images processing ended'),
      ),
    );
  }

  Future<void> startCamera() async {
    // TODO(alphamikle):
  }

  Widget imageFrameBuilder(BuildContext context, int index) {
    if (index >= edgesBloc.state.imagesList.length) {
      return Container(
        decoration: BoxDecoration(color: context.colors.primary),
      );
    }

    final ImageResult result = edgesBloc.state.imagesList[index];
    return ImageFrame(result: result);
  }

  @override
  void initState() {
    super.initState();
    unawaited(init());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EdgesBloc, EdgesState>(
      listenWhen: (EdgesState p, EdgesState c) => c.processing != p.processing,
      listener: (BuildContext context, EdgesState state) => showNotification(processing: state.processing),
      child: Scaffold(
        key: key,
        endDrawer: Drawer(
          width: max(500, context.query.size.width * (1 / 3)),
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
            child: SettingsFragment(),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(left: 8, top: context.query.padding.top + 8, right: 8, bottom: context.query.padding.bottom + 8),
              sliver: BlocBuilder<EdgesBloc, EdgesState>(
                buildWhen: (EdgesState p, EdgesState c) => c.images != p.images || c.opacity != p.opacity,
                builder: (BuildContext context, EdgesState state) {
                  return SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      childAspectRatio: 3 / 4,
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: imageFrameBuilder,
                    itemCount: state.imagesList.length + 1,
                  );
                },
              ),
            ),
          ],
        ),
        // body: SafeArea(
        //   child: Row(
        //     children: [
        //       const SizedBox(width: 16),
        //       Flexible(
        //         child: BlocBuilder<EdgesBloc, EdgesState>(
        //           buildWhen: (EdgesState p, EdgesState c) => c.images != p.images,
        //           builder: (BuildContext context, EdgesState state) {
        //             return ListView.builder(
        //               itemBuilder: imageFrameBuilder,
        //               itemCount: state.images.length,
        //             );
        //           },
        //         ),
        //       ),
        //       const SizedBox(width: 16),
        //       const Expanded(
        //         child: SettingsFragment(),
        //       ),
        //       const SizedBox(width: 16),
        //     ],
        //   ),
        // ),
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.small(
              onPressed: key.currentState?.openEndDrawer,
              child: Icon(Icons.menu_open_rounded),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              onPressed: startCamera,
              child: Icon(Icons.camera_alt),
            ),
          ],
        ),
      ),
    );
  }
}
