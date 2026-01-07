import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/example_bloc.dart';

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Example")),
      body: BlocBuilder<ExampleBloc, ExampleState>(
        builder: (BuildContext context, ExampleState state) {
          if (state is ExampleLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ExampleLoaded) {
            return Center(child: Text("Nome: ${state.entity.name}"));
          }

          if (state is ExampleError) {
            return Center(child: Text(state.message));
          }

          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<ExampleBloc>().add(LoadExampleEvent());
              },
              child: Text("Carregar"),
            ),
          );
        },
      ),
    );
  }
}
