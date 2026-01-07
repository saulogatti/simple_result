part of 'result_cubit.dart';

@immutable
sealed class ResultState {}

final class ResultInitial extends ResultState {}
final class ResultSuccess<S, E> extends ResultState {
  final Success<S, E> value;
  ResultSuccess(this.value);
}
final class ResultError<S, E> extends ResultState {
  final Failure<S, E> value;
  ResultError(this.value);
}