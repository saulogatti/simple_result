# Simple Result

[![Pub Version](https://img.shields.io/pub/v/simple_result)](https://pub.dev/packages/simple_result)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Uma implementação leve e type-safe do padrão Result para Dart, perfeita para Clean Architecture e aplicações Flutter.

## 🎯 Características

- ✅ **Type-Safe**: Usa sealed classes do Dart 3 para garantir tratamento exaustivo de casos
- ⚡ **Leve**: Sem dependências externas, implementação minimalista
- 🎨 **Pattern Matching**: Suporte completo para switch expressions do Dart 3
- 🛡️ **Guard**: Utilitário para envolver operações assíncronas com tratamento automático de erros
- 🏗️ **Clean Architecture**: Ideal para camada de domínio e casos de uso
- 📱 **Flutter Ready**: Perfeito para uso com BLoC, Cubit ou qualquer gerenciador de estado

## 📦 Instalação

Adicione ao seu `pubspec.yaml`:

```yaml
dependencies:
  simple_result: ^1.0.0
```

## 🚀 Uso Básico

### Criando Results

```dart
import 'package:simple_result/simple_result.dart';

// Sucesso
final success = Result<int, String>.success(42);

// Falha
final failure = Result<int, String>.failure('Erro ao processar');
```

### Verificando o Tipo

```dart
if (result.isSuccess) {
  print('Operação bem-sucedida!');
}

if (result.isFailure) {
  print('Algo deu errado');
}
```

### Extraindo Valores

```dart
// Retorna o valor ou null
final value = result.getOrNull;

// Retorna o erro ou null
final error = result.failureOrNull;
```

### Fold - O Método Mágico

O método `fold` é a maneira mais elegante de lidar com Results. Ele força você a tratar ambos os casos:

```dart
final message = result.fold(
  (value) => 'Sucesso: $value',
  (error) => 'Erro: $error',
);
```

### Pattern Matching

```dart
final message = switch (result) {
  Success(value: final v) => 'Valor recebido: $v',
  Failure(error: final e) => 'Falha: $e',
};
```

## 💡 Exemplos Práticos

### Caso de Uso com Repositório

```dart
class UserRepository {
  Future<Result<User, String>> getUserById(int id) async {
    try {
      final user = await api.fetchUser(id);
      return Result.success(user);
    } catch (e) {
      return Result.failure('Erro ao buscar usuário: $e');
    }
  }
}
```

### Usando Result.guard

O método `guard` simplifica o tratamento de exceções:

```dart
Future<Result<User, Exception>> getUser(int id) {
  return Result.guard(() async {
    final response = await http.get('/users/$id');
    return User.fromJson(response.data);
  });
}
```

### Em um BLoC/Cubit (Flutter)

```dart
class UserCubit extends Cubit<UserState> {
  final UserRepository repository;

  Future<void> loadUser(int id) async {
    emit(UserLoading());
    
    final result = await repository.getUserById(id);
    
    result.fold(
      (user) => emit(UserLoaded(user)),
      (error) => emit(UserError(error)),
    );
  }
}
```

### Em Widgets Flutter

```dart
Widget build(BuildContext context) {
  return result.fold(
    (user) => UserProfile(user: user),
    (error) => ErrorWidget(message: error),
  );
}
```

### Validação de Entrada

```dart
Result<Email, String> validateEmail(String input) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  
  if (emailRegex.hasMatch(input)) {
    return Result.success(Email(input));
  } else {
    return Result.failure('Email inválido');
  }
}
```

### Composição de Results

```dart
Future<Result<Order, String>> createOrder() async {
  final userResult = await getUser();
  final productResult = await getProduct();
  
  return userResult.fold(
    (user) => productResult.fold(
      (product) => Result.success(Order(user, product)),
      (error) => Result.failure('Erro no produto: $error'),
    ),
    (error) => Result.failure('Erro no usuário: $error'),
  );
}
```

## 🎓 API Completa

### Construtores

- `Result.success(S value)`: Cria uma instância de `Success`.
- `Result.failure(F error)`: Cria uma instância de `Failure`.

### Classes (Sealed)

- `Success<S, F>`: Representa um resultado positivo contendo um valor do tipo `S`.
- `Failure<S, F>`: Representa um resultado negativo contendo um erro do tipo `F`.

### Propriedades

- `isSuccess: bool`: Retorna `true` se o resultado for `Success`.
- `isFailure: bool`: Retorna `true` se o resultado for `Failure`.
- `getOrNull: S?` - Retorna o valor ou null
- `failureOrNull: F?` - Retorna o erro ou null

### Métodos

- `fold<T>(onSuccess, onFailure)` - Transforma o result em outro tipo, tratando ambos os casos
- `Result.guard<T>(Future<T> Function() block)` - Envolve operações assíncronas com tratamento de exceções

## 🏆 Vantagens

1. **Segurança de Tipos**: O compilador garante que você trate todos os casos
2. **Código Limpo**: Elimina try-catch aninhados e códigos de erro confusos
3. **Testável**: Facilita testes unitários sem mocks complexos
4. **Explícito**: Deixa claro quando uma função pode falhar
5. **Funcional**: Permite composição e transformação de resultados

## 🧪 Testes

A biblioteca é rigorosamente testada para garantir confiabilidade. Para rodar a suíte de testes:

```bash
# Se estiver usando apenas Dart
dart test

# Se estiver em um projeto Flutter
flutter test
```

## 📚 Inspiração

Este padrão é inspirado em implementações similares encontradas em:
- Rust (`Result<T, E>`)
- Kotlin (`Result`)
- Swift (`Result<Success, Failure>`)
- Scala (`Either`)

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests.

## 📄 Licença

Este projeto está sob a licença MIT.
