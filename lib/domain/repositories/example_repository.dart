import 'package:simple_result/domain/entities/example_entity.dart';

abstract class ExampleRepository {
  Future<ExampleEntity?> getExample();
}
