import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/colors.dart';
import '../../../utils/navigation.dart';
import '../../logic/bloc/edges_bloc.dart';
import '../../logic/bloc/edges_state.dart';
import '../../logic/model/image_result.dart';
import '../component/image_frame.dart';
import '../component/settings_fragment.dart';
import 'camera_view.dart';

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

  Future<void> init() async {
    await edgesBloc.loadImages();
    setState(() {});
  }

  Future<void> startCamera() async {
    final XFile? picture = await context.pushScreen<XFile>((BuildContext context) => CameraView());
    if (picture != null) {
      await edgesBloc.loadImage(picture.path);
    }
  }

  Widget imageFrameBuilder(BuildContext context, int index) {
    if (index >= edgesBloc.state.imagesList.length) {
      return Container(
        decoration: BoxDecoration(color: context.colors.primary),
      );
    }

    final EdgesState state = edgesBloc.state;
    final ImageResult result = state.imagesList[index];
    final bool selected = state.selectedImages.isEmpty || state.selectedImages.contains(result.name);

    return ImageFrame(
      result: result,
      selected: selected,
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      endDrawer: Drawer(
        width: max(min(500, context.query.size.width * 4 / 5), context.query.size.width * (1 / 3)),
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
          child: SettingsFragment(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: 8, top: context.query.padding.top + 8, right: 8, bottom: 8),
            sliver: BlocBuilder<EdgesBloc, EdgesState>(
              builder: (BuildContext context, EdgesState state) {
                final Map<String, String> success = state.success;

                return SliverToBoxAdapter(
                  child: Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      for (final MapEntry(:key, :value) in success.entries)
                        Chip(
                          label: Text(
                            '$key: $value',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: context.query.padding.bottom + 8),
            sliver: BlocBuilder<EdgesBloc, EdgesState>(
              buildWhen: (EdgesState p, EdgesState c) =>
                  c.images != p.images ||
                  c.opacity != p.opacity ||
                  c.dotsCloudOn != p.dotsCloudOn ||
                  c.painterOn != p.painterOn ||
                  c.selectedImages != p.selectedImages,
              builder: (BuildContext context, EdgesState state) {
                return SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 3 / 4,
                    maxCrossAxisExtent: 300,
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
    );
  }
}
