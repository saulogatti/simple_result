import '../../domain/entities/example_entity.dart';

class ExampleModel extends ExampleEntity {
  ExampleModel({
    required super.id,
    required super.name,
  });

  factory ExampleModel.fromJson(Map<String, dynamic> json) {
    return ExampleModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
