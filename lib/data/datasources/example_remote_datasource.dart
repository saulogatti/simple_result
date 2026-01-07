import '../models/example_model.dart';

abstract class ExampleRemoteDataSource {
  Future<ExampleModel> fetchExample();
}

class ExampleRemoteDataSourceImpl implements ExampleRemoteDataSource {
  @override
  Future<ExampleModel> fetchExample() async {
    await Future<void>.delayed(Duration(milliseconds: 500), () {});

    return ExampleModel(id: 1, name: "Saulo Example");
  }
}
