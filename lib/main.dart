import 'package:flutter/material.dart';
import 'package:simple_result/presentation/bloc/example_bloc.dart';
import 'package:simple_result/presentation/pages/example_page.dart';
import 'app/di/injector.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<ExampleBloc>(
        create: (_) => di.sl<ExampleBloc>(),
        child: ExamplePage(),
      ),
    );
  }
}
