import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/boundaries/logic/bloc/edges_bloc.dart';
import 'src/boundaries/ui/view/edges_sandbox_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final EdgesBloc edgesBloc = EdgesBloc();
  await edgesBloc.init();

  runApp(
    MyApp(
      bloc: edgesBloc,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    required this.bloc,
    super.key,
  });

  final EdgesBloc bloc;

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
          BlocProvider.value(value: bloc),
        ],
        child: const EdgesSandboxView(),
      ),
    );
  }
}
