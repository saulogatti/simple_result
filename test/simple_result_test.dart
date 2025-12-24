import 'package:simple_result/simple_result.dart';
import 'package:test/test.dart';

void main() {
  group('Result.success', () {
    test('deve criar um Success com valor correto', () {
      final result = Result<int, String>.success(42);

      expect(result, isA<Success<int, String>>());
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.getOrNull, equals(42));
      expect(result.failureOrNull, isNull);
    });

    test('deve aceitar valores nulos', () {
      final result = Result<int?, String>.success(null);

      expect(result.isSuccess, isTrue);
      expect(result.getOrNull, isNull);
    });
  });

  group('Result.failure', () {
    test('deve criar um Failure com erro correto', () {
      final result = Result<int, String>.failure('Erro de teste');

      expect(result, isA<Failure<int, String>>());
      expect(result.isFailure, isTrue);
      expect(result.isSuccess, isFalse);
      expect(result.failureOrNull, equals('Erro de teste'));
      expect(result.getOrNull, isNull);
    });

    test('deve aceitar erros nulos', () {
      final result = Result<int, String?>.failure(null);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isNull);
    });
  });

  group('fold', () {
    test('deve executar onSuccess quando for Success', () {
      final result = Result<int, String>.success(10);

      final folded = result.fold(
        (value) => 'Sucesso: $value',
        (error) => 'Erro: $error',
      );

      expect(folded, equals('Sucesso: 10'));
    });

    test('deve executar onFailure quando for Failure', () {
      final result = Result<int, String>.failure('Algo deu errado');

      final folded = result.fold(
        (value) => 'Sucesso: $value',
        (error) => 'Erro: $error',
      );

      expect(folded, equals('Erro: Algo deu errado'));
    });

    test('deve permitir transformação de tipos', () {
      final result = Result<int, String>.success(5);

      final squared = result.fold((value) => value * value, (error) => 0);

      expect(squared, equals(25));
    });

    test('deve retornar valor padrão em caso de falha', () {
      final result = Result<int, String>.failure('Erro');

      final value = result.fold((value) => value, (error) => -1);

      expect(value, equals(-1));
    });
  });

  group('when', () {
    test('deve se comportar exatamente como fold', () {
      final result = Result<int, String>.success(10);

      final value = result.when((v) => v * 2, (e) => 0);

      expect(value, equals(20));
    });
    test('deve executar onFailure quando for Failure', () {
      final result = Result<int, String>.failure('erro');
      final value = result.when((v) => v * 2, (e) => -1);
      expect(value, equals(-1));
    });
  });

  group('getOrNull', () {
    test('deve retornar valor quando Success', () {
      final result = Result<String, Exception>.success('teste');
      expect(result.getOrNull, equals('teste'));
    });

    test('deve retornar null quando Failure', () {
      final result = Result<String, Exception>.failure(Exception('erro'));
      expect(result.getOrNull, isNull);
    });
  });

  group('failureOrNull', () {
    test('deve retornar null quando Success', () {
      final result = Result<String, Exception>.success('teste');
      expect(result.failureOrNull, isNull);
    });

    test('deve retornar erro quando Failure', () {
      final exception = Exception('erro de teste');
      final result = Result<String, Exception>.failure(exception);
      expect(result.failureOrNull, equals(exception));
    });
  });

  group('Result.guard', () {
    test('deve retornar Success quando função não lança exceção', () async {
      final result = await Result.guard(() async => 42);

      expect(result.isSuccess, isTrue);
      expect(result.getOrNull, equals(42));
    });

    test('deve retornar Failure quando função lança Exception', () async {
      final result = await Result.guard(() async {
        throw Exception('Erro esperado');
      });

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<Exception>());
      expect(result.failureOrNull.toString(), contains('Erro esperado'));
    });

    test('deve capturar erros não-Exception e envolver em Exception', () async {
      final result = await Result.guard(() async {
        throw 'String de erro';
      });

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<Exception>());
      expect(result.failureOrNull.toString(), contains('String de erro'));
    });

    test('deve funcionar com operações assíncronas', () async {
      final result = await Result.guard(() async {
        await Future.delayed(Duration(milliseconds: 10));
        return 'resultado assíncrono';
      });

      expect(result.isSuccess, isTrue);
      expect(result.getOrNull, equals('resultado assíncrono'));
    });

    test('deve capturar exceções em operações assíncronas', () async {
      final result = await Result.guard(() async {
        await Future.delayed(Duration(milliseconds: 10));
        throw Exception('Erro assíncrono');
      });

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull, isA<Exception>());
    });
  });

  group('ResultExtension - Operadores Funcionais', () {
    group('map', () {
      test('deve transformar o valor em caso de sucesso', () {
        final result = Result<int, String>.success(10).map((v) => v.toString());
        expect(result.getOrNull, equals('10'));
        expect(result, isA<Success<String, String>>());
      });

      test('deve manter o erro original em caso de falha', () {
        final result = Result<int, String>.failure('erro').map((v) => v * 2);
        expect(result.failureOrNull, equals('erro'));
        expect(result, isA<Failure<int, String>>());
      });
    });

    group('mapError', () {
      test('deve transformar o erro em caso de falha', () {
        final result = Result<int, int>.failure(404).mapError((e) => 'Erro $e');
        expect(result.failureOrNull, equals('Erro 404'));
      });

      test('deve manter o valor original em caso de sucesso', () {
        final result = Result<int, int>.success(200).mapError((e) => 'Erro $e');
        expect(result.getOrNull, equals(200));
      });
    });

    group('flatMap', () {
      test('deve encadear transformações que retornam Result', () {
        final result = Result<int, String>.success(
          10,
        ).flatMap((v) => Result<String, String>.success('Valor: $v'));
        expect(result.getOrNull, equals('Valor: 10'));
      });

      test('deve propagar falha no encadeamento', () {
        final result = Result<int, String>.success(
          10,
        ).flatMap((v) => Result<String, String>.failure('falhou no step 2'));
        expect(result.failureOrNull, equals('falhou no step 2'));
      });

      test('não deve executar mapper se o original for falha', () {
        final result = Result<int, String>.failure(
          'erro inicial',
        ).flatMap((v) => Result.success('não deve ocorrer'));
        expect(result.failureOrNull, equals('erro inicial'));
      });
    });

    group('flatMapError', () {
      test(
        'deve permitir recuperar de um erro ou transformar erro em outro Result',
        () {
          final result = Result<int, String>.failure(
            '404',
          ).flatMapError((e) => Result.failure('Erro formatado: $e'));
          expect(result.failureOrNull, equals('Erro formatado: 404'));
        },
      );
      test('deve permitir recuperar de um erro para um sucesso', () {
        final result = Result<int, String>.failure(
          'erro recuperável',
        ).flatMapError((e) => Result.success(0));
        expect(result.isSuccess, isTrue);
        expect(result.getOrNull, equals(0));
      });
    });
  });

  group('ResultExtension - Efeitos Colaterais', () {
    group('onSuccess', () {
      test('deve executar o callback apenas em caso de sucesso', () {
        int? value;
        final result = Result<int, String>.success(42).onSuccess((v) {
          value = v;
        });

        expect(value, equals(42));
        expect(result, isA<Success<int, String>>());
      });

      test('não deve executar o callback em caso de falha', () {
        bool chamado = false;
        Result<int, String>.failure('erro').onSuccess((_) => chamado = true);
        expect(chamado, isFalse);
      });

      test('deve permitir chamadas encadeadas (fluent API)', () {
        final result = Result<int, String>.success(1);
        final returned = result.onSuccess((_) {});
        expect(returned, same(result));
      });
    });

    group('onFailure', () {
      test('deve executar o callback apenas em caso de falha', () {
        String? error;
        final result = Result<int, String>.failure('ops').onFailure((e) {
          error = e;
        });

        expect(error, equals('ops'));
        expect(result, isA<Failure<int, String>>());
      });

      test('não deve executar o callback em caso de sucesso', () {
        bool chamado = false;
        Result<int, String>.success(10).onFailure((_) => chamado = true);
        expect(chamado, isFalse);
      });

      test('deve permitir chamadas encadeadas (fluent API)', () {
        final result = Result<int, String>.failure('ops');
        final returned = result.onFailure((_) {});
        expect(returned, same(result));
      });
    });

    test('deve permitir encadear onSuccess e onFailure', () {
      String status = '';
      Result<int, String>.success(10)
          .onSuccess((_) => status += 'sucesso')
          .onFailure((_) => status += 'falha');

      expect(status, equals('sucesso'));
    });
  });

  group('Pattern matching com switch', () {
    test('deve funcionar com pattern matching Success', () {
      final result = Result<int, String>.success(100);

      final message = switch (result) {
        Success(value: final v) => 'Valor: $v',
        Failure(error: final e) => 'Erro: $e',
      };

      expect(message, equals('Valor: 100'));
    });

    test('deve funcionar com pattern matching Failure', () {
      final result = Result<int, String>.failure('Falha crítica');

      final message = switch (result) {
        Success(value: final v) => 'Valor: $v',
        Failure(error: final e) => 'Erro: $e',
      };

      expect(message, equals('Erro: Falha crítica'));
    });
  });

  group('Tipos complexos', () {
    test('deve funcionar com tipos customizados', () {
      final result = Result<List<int>, Map<String, dynamic>>.success([1, 2, 3]);

      expect(result.isSuccess, isTrue);
      expect(result.getOrNull, equals([1, 2, 3]));
    });

    test('deve funcionar com classes customizadas', () {
      final user = _User('João', 30);
      final result = Result<_User, String>.success(user);

      expect(result.isSuccess, isTrue);
      expect(result.getOrNull?.name, equals('João'));
      expect(result.getOrNull?.age, equals(30));
    });

    test('deve funcionar com erros customizados', () {
      final error = _CustomError('Erro customizado', 404);
      final result = Result<String, _CustomError>.failure(error);

      expect(result.isFailure, isTrue);
      expect(result.failureOrNull?.message, equals('Erro customizado'));
      expect(result.failureOrNull?.code, equals(404));
    });
  });

  group('Cenários de uso real', () {
    test('simulação de busca de usuário bem-sucedida', () async {
      final result = await _fetchUser(1);

      expect(result.isSuccess, isTrue);

      final userName = result.fold(
        (user) => user.name,
        (error) => 'Usuário não encontrado',
      );

      expect(userName, equals('Usuário 1'));
    });

    test('simulação de busca de usuário com erro', () async {
      final result = await _fetchUser(-1);

      expect(result.isFailure, isTrue);

      final message = result.fold(
        (user) => user.name,
        (error) => 'Erro: $error',
      );

      expect(message, contains('Erro'));
    });
  });
}

// Função simulada para testes de cenário real
Future<Result<_User, String>> _fetchUser(int id) async {
  await Future.delayed(Duration(milliseconds: 10));

  if (id > 0) {
    return Result.success(_User('Usuário $id', 25));
  } else {
    return Result.failure('ID inválido: $id');
  }
}

class _CustomError {
  final String message;
  final int code;

  _CustomError(this.message, this.code);
}

// Classes auxiliares para testes
class _User {
  final String name;
  final int age;

  _User(this.name, this.age);
}
