import 'package:get_it/get_it.dart';
import 'package:simple_result/data/datasources/example_remote_datasource.dart';
import 'package:simple_result/data/repositories/example_repository_impl.dart';
import 'package:simple_result/domain/usecases/get_example.dart';
import 'package:simple_result/presentation/bloc/example_bloc.dart';

 

final GetIt sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<ExampleRemoteDataSource>(
      () => ExampleRemoteDataSourceImpl());

  sl.registerLazySingleton(
      () => ExampleRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetExample(sl()));

  sl.registerFactory(() => ExampleBloc(sl()));
}
