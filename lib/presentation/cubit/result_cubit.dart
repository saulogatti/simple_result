import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_result/app/di/injector.dart' as di;
import 'package:simple_result/domain/entities/example_entity.dart';
import 'package:simple_result/domain/repositories/example_repository.dart';
import 'package:simple_result/simple_result.dart';

part 'result_state.dart';

class ResultCubit extends Cubit<ResultState> {
  final ExampleRepository repository = di.sl<ExampleRepository>();
  ResultCubit() : super(ResultInitial());
  void getData<S, E>(String key) async {
    final ExampleEntity? data = await repository.getExample();
    if (data != null) {
      _emitSuccess<S, E>(Success<S, E>(data as S));
    } else {
      _emitError<S, E>(Failure<S, E>('Data not found for key: $data' as E));
    }
  }

  void _emitError<S, E>(Failure<S, E> error) {
    emit(ResultError<S, E>(error));
  }

  void _emitSuccess<S, E>(Success<S, E> data) {
    emit(ResultSuccess<S, E>(data));
  }
}
