part of 'example_bloc.dart';

abstract class ExampleState {}

class ExampleInitial extends ExampleState {}

class ExampleLoading extends ExampleState {}

class ExampleLoaded extends ExampleState {
  final ExampleEntity entity;
  ExampleLoaded(this.entity);
}

class ExampleError extends ExampleState {
  final String message;
  ExampleError(this.message);
}
