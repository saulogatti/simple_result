# Simple Result - Copilot Instructions

## Project Overview

**simple_result** é uma implementação leve e type-safe do padrão Result para Dart, baseada em sealed classes (Dart 3+). É um package puro sem dependências externas, projetado para Clean Architecture e aplicações Flutter.

## Architecture & Core Concepts

### The Result Type Hierarchy (Sealed Classes)

```
Result<S, F> (sealed)
├── Success<S, F> (final class with value: S)
└── Failure<S, F> (final class with error: F)
```

- **S** = Success type (generic)
- **F** = Failure type (generic - typically `String` or custom error classes)
- Sealed classes garantem pattern matching exaustivo no Dart 3

### Key Files Structure

- `lib/src/simple_result_base.dart` - Core implementation (sealed classes, main methods, extensions)
- `lib/simple_result.dart` - Public API export
- No sub-modules; tudo está em um único arquivo bem organizado

## API Methods & Usage Patterns

### Core Constructors
```dart
Result<int, String>.success(42);      // Cria Success
Result<int, String>.failure("erro");  // Cria Failure
```

### Getters (Non-Destructive Inspection)
- `isSuccess`: bool - verifica se é Success
- `isFailure`: bool - verifica se é Failure
- `getOrNull`: S? - retorna valor ou null
- `failureOrNull`: F? - retorna erro ou null

### Primary Methods

1. **fold<T>()** ⭐ (Método Principal)
   - Força tratamento de ambos os casos
   - Retorna um tipo genérico T
   - Equivalente a switch com ambos os cases
   ```dart
   result.fold(
     (value) => 'Sucesso: $value',
     (error) => 'Erro: $error'
   )
   ```

2. **when<T>()** (Alias semântico para fold)
   - Mesmo comportamento que fold
   - Mantido para familiaridade com outras linguagens
   - Em código novo, prefira fold

3. **guard<T>()** (Static - Async Wrapper)
   - Encapsula operações assíncronas com try-catch automático
   ```dart
   final result = await Result.guard(() => fetchData());
   ```

### Extension Methods (ResultExtension)

- **map<R>()** - Transforma success type mantendo failure
- **mapError<R>()** - Transforma failure type mantendo success
- **flatMap<R>()** - Composição: Result → Result (success)
- **flatMapError<R>()** - Composição: Result → Result (failure)
- **onSuccess()** - Side effect se success (retorna self para chaining)
- **onFailure()** - Side effect se failure (retorna self para chaining)

## Development Patterns

### Pattern Matching (Preferred)
```dart
final msg = switch (result) {
  Success(value: final v) => 'Valor: $v',
  Failure(error: final e) => 'Erro: $e',
};
```

### Type-Safe Error Handling
- Use tipos específicos para F (ex: `Result<User, AppException>`)
- Não use String para erros em código novo (apenas em exemplos)
- Considere sealed classes para hierarquias de erro

### Chaining & Composition
```dart
result
  .map((user) => user.email)
  .flatMap((email) => validateEmail(email))
  .onFailure((error) => log(error))
```

## Testing Approach

- Use `isA<Success<int, String>>()` e `isA<Failure<...>>()` para type checks
- Teste fold com ambos os branches
- Use guard em testes de async/await
- Padrão: 1 test = 1 comportamento (success OU failure)

Exemplo:
```dart
test('deve retornar Success quando API responde', () {
  final result = Result<Data, String>.success(data);
  expect(result.isSuccess, isTrue);
  expect(result.getOrNull, equals(data));
});
```

## Build & Development Commands

```bash
# Run tests
dart test

# Generate documentation
dart doc

# Run linter
dart analyze

# Format code
dart format lib/ test/

# Build (if generating code in future)
dart run build_runner build --delete-conflicting-outputs
```

## Key Conventions

1. **Generics Always Explicit** - Não omita S e F, sejam qual for os tipos
2. **fold() is Canonical** - Prefira fold/when em BLoCs/Widgets sobre múltiplas verificações
3. **No Null Result** - Result nunca é null; use `Result<T?, Exception>` se valor pode ser null
4. **Pure Functional Style** - Evite modificação de estado; use transformações (map, flatMap)
5. **Guard for Async** - Use `Result.guard()` para envolver Future operations

## Integration Points

### With BLoC/State Management
```dart
// No BLoC
final result = await useCase.execute();
final state = result.fold(
  (data) => SuccessState(data),
  (error) => ErrorState(error),
);
emit(state);
```

### With Repositories
```dart
Future<Result<User, NetworkException>> getUser(int id) async {
  return Result.guard(() => _api.fetchUser(id))
    .mapError((e) => NetworkException(e.toString()));
}
```

## New Feature Guidelines

- Keep sealed class hierarchy simple (Success + Failure pattern)
- New methods → add to `ResultExtension`, não à sealed class
- Maintain immutability of Result instances
- Document public APIs with dartdoc comments
- Tests antes do código (TDD recommended)

## Useful Files to Reference

- `test/simple_result_test.dart` - Test patterns and edge cases
- `README.md` - User-facing documentation
