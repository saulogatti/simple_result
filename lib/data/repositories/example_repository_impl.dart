import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/example_entity.dart';
import '../../domain/repositories/example_repository.dart';
import '../datasources/example_remote_datasource.dart';

class ExampleRepositoryImpl implements ExampleRepository {
  final ExampleRemoteDataSource datasource;

  ExampleRepositoryImpl(this.datasource);

  @override
  Future<ExampleEntity> getExample() async {
    try {
      return await datasource.fetchExample();
    } catch (e) {
      throw ServerException("Erro ao buscar exemplo");
    }
  }
}
