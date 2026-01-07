// ignore_for_file: avoid_types_as_parameter_names

class NoParams {}

abstract class UseCase<Type, Params> {
  Future<Type?> call(Params params);
}
