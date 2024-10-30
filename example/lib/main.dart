import 'package:edge_vision/edge_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/boundaries/logic/bloc/edges_bloc.dart';
import 'src/boundaries/ui/view/edges_sandbox_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            create: (BuildContext context) => EdgesBloc(
              edgeVision: const EdgeVision(),
            ),
          ),
        ],
        child: const EdgesSandboxView(),
      ),
    );
  }
}
