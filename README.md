# template repository Clean Architecture Flutter with Bloc

lib/
 ├── app/
 │    ├── di/
 │    │     └── injector.dart
 │    ├── routes/
 │    │     └── app_routes.dart
 │    └── app.dart
 │
 ├── core/
 │    ├── errors/
 │    │     ├── failures.dart
 │    │     └── exceptions.dart
 │    ├── usecases/
 │    │     └── usecase.dart
 │    └── utils/
 │          └── result.dart
 │
 ├── features/
 │    └── example/
 │         ├── domain/
 │         │     ├── entities/example_entity.dart
 │         │     ├── repositories/example_repository.dart
 │         │     └── usecases/get_example.dart
 │         │
 │         ├── data/
 │         │     ├── models/example_model.dart
 │         │     ├── datasources/example_remote_datasource.dart
 │         │     └── repositories/example_repository_impl.dart
 │         │
 │         └── presentation/
 │               ├── bloc/example_bloc.dart
 │               ├── pages/example_page.dart
 │               └── widgets/example_widget.dart
 │
 └── main.dart

