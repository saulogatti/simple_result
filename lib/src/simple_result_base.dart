final class Failure<S, F> extends Result<S, F> {
  final F error;
  const Failure(this.error);
}

/// Uma implementação leve do padrão Result para Clean Architecture.
/// Usa sealed classes do Dart 3 para garantir tratamento exaustivo.
sealed class Result<S, F> {
  const Result();

  /// Cria um resultado de Falha
  factory Result.failure(F failure) = Failure<S, F>;

  /// Cria um resultado de Sucesso
  factory Result.success(S value) = Success<S, F>;

  /// Retorna o erro ou null se for sucesso
  F? get failureOrNull => isFailure ? (this as Failure<S, F>).error : null;

  /// Retorna o valor de sucesso ou null se for falha
  S? get getOrNull => isSuccess ? (this as Success<S, F>).value : null;

  /// Verifica se é falha
  bool get isFailure => this is Failure<S, F>;

  /// Verifica se é sucesso
  bool get isSuccess => this is Success<S, F>;

  /// O método mágico: obriga a tratar os dois casos.
  /// Ideal para usar nos Widgets/Blocs.
  T fold<T>(T Function(S value) onSuccess, T Function(F error) onFailure) {
    return switch (this) {
      Success(value: final v) => onSuccess(v),
      Failure(error: final e) => onFailure(e),
    };
  }

  /// Alias semântico para [fold], mantido por legibilidade e familiaridade
  /// com APIs de pattern matching (por exemplo, `when` em outras linguagens).
  /// Útil especialmente em Widgets/Blocs; em código novo, prefira usar [fold].
  T when<T>(T Function(S value) onSuccess, T Function(F error) onFailure) =>
      fold(onSuccess, onFailure);

  /// Utilitário estático para envolver chamadas perigosas (try-catch)
  static Future<Result<T, Exception>> guard<T>(
    Future<T> Function() block,
  ) async {
    try {
      return Result.success(await block());
    } on Exception catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(Exception(e.toString()));
    }
  }
}

final class Success<S, F> extends Result<S, F> {
  final S value;
  const Success(this.value);
}

extension ResultExtension<S, F> on Result<S, F> {
  /// Flat maps a [Result] to a new [Result] with a different success type.
  Result<R, F> flatMap<R>(Result<R, F> Function(S value) mapper) {
    return fold((value) => mapper(value), (error) => Result.failure(error));
  }

  /// Flat maps a [Result] to a new [Result] with a different error type.
  Result<S, R> flatMapError<R>(Result<S, R> Function(F error) mapper) {
    return fold((value) => Result.success(value), (error) => mapper(error));
  }

  /// Maps a [Result] to a new [Result] with a different success type.
  Result<R, F> map<R>(R Function(S value) mapper) {
    return fold(
      (value) => Result.success(mapper(value)),
      (error) => Result.failure(error),
    );
  }

  /// Maps a [Result] to a new [Result] with a different error type.
  Result<S, R> mapError<R>(R Function(F error) mapper) {
    return fold(
      (value) => Result.success(value),
      (error) => Result.failure(mapper(error)),
    );
  }

  /// Executes a side effect function if the result is a failure.
  Result<S, F> onFailure(void Function(F error) effect) {
    if (this case Failure(error: final e)) {
      effect(e);
    }
    return this;
  }

  /// Executes a side effect function if the result is a success.
  Result<S, F> onSuccess(void Function(S value) effect) {
    if (this case Success(value: final v)) {
      effect(v);
    }
    return this;
  }
}
