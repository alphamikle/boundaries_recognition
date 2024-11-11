import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/boundaries/logic/bloc/edges_bloc.dart';
import 'src/boundaries/ui/view/edges_sandbox_view.dart';

Future<void> main() async {
  final EdgeVision edgeVision = await EdgeVision.isolated(processingMode: EdgeProcessingMode.allInOne);

  runApp(
    MyApp(edgeVision: edgeVision),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.edgeVision,
    super.key,
  });

  final EdgeVision edgeVision;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edges Sandbox',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => EdgesBloc(edgeVision: edgeVision),
          ),
        ],
        child: const EdgesSandboxView(),
      ),
    );
  }
}
