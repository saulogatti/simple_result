import '../../../../core/usecases/usecase.dart';
import '../entities/example_entity.dart';
import '../repositories/example_repository.dart';

class GetExample implements UseCase<ExampleEntity, NoParams> {
  final ExampleRepository repository;

  GetExample(this.repository);

  @override
  Future<ExampleEntity?> call(NoParams params) {
    return repository.getExample();
  }
}
