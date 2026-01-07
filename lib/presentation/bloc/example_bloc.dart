import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_result/core/usecases/usecase.dart';

import '../../domain/entities/example_entity.dart';
import '../../domain/usecases/get_example.dart';

part 'example_event.dart';
part 'example_state.dart';

class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  final GetExample getExample;

  ExampleBloc(this.getExample) : super(ExampleInitial()) {
    on<LoadExampleEvent>((
      LoadExampleEvent event,
      Emitter<ExampleState> emit,
    ) async {
      emit(ExampleLoading());

      try {
        final ExampleEntity? result = await getExample(NoParams());
        emit(ExampleLoaded(result!));
      } catch (e) {
        emit(ExampleError("Erro ao carregar"));
      }
    });
  }
}
